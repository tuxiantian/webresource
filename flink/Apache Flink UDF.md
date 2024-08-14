在 Apache Flink 中，UDF（用户自定义函数）允许用户编写自定义逻辑，以便在流处理或批处理作业中使用。Flink 提供了多种类型的 UDF，每种类型都特定于某种处理范例或操作类型。主要的 UDF 类型包括：

### 1. ScalarFunction（标量函数）

**描述**：标量函数用于将输入的一个或多个值转换为单个输出值。这类函数在 SQL 查询中的 `SELECT` 子句中使用，以对列进行转换和计算。

**示例**：
```java
import org.apache.flink.table.functions.ScalarFunction;

public class StringLength extends ScalarFunction {
    public int eval(String str) {
        return str.length();
    }
}
```

**使用**：
```java
tableEnv.createTemporarySystemFunction("strlen", StringLength.class);

// SQL
tableEnv.sqlQuery("SELECT strlen(myColumn) FROM myTable");

// Table API
table.select(call("strlen", $("myColumn")));
```

### 2. TableFunction（表函数）

**描述**：表函数将输入的一个值或多个值转换为一系列（零个或多个）输出记录。它常用于将输入展开成多个输出行。

**示例**：
```java
import org.apache.flink.table.functions.TableFunction;

public class Split extends TableFunction<String> {
    public void eval(String str, String delimiter) {
        for (String s : str.split(delimiter)) {
            collect(s);
        }
    }
}
```

**使用**：
```java
tableEnv.createTemporarySystemFunction("split", Split.class);

// SQL
tableEnv.sqlQuery("SELECT id, s FROM myTable, LATERAL TABLE(split(textColumn, ' ')) AS T(s)");

// Table API
table.joinLateral(call("split", $("textColumn"), " ")).select($("id"), $("s"));
```

### 3. AggregateFunction（聚合函数）

**描述**：聚合函数用于将一系列输入值聚合成一个单一的输出值。常用于求和、取平均值等聚合操作。

**示例**：
```java
import org.apache.flink.table.functions.AggregateFunction;

public class SumAggregateFunction extends AggregateFunction<Long, SumAccumulator> {
    @Override
    public Long getValue(SumAccumulator accumulator) {
        return accumulator.sum;
    }

    @Override
    public SumAccumulator createAccumulator() {
        return new SumAccumulator();
    }

    public void accumulate(SumAccumulator accumulator, Long value) {
        accumulator.sum += value;
    }

    public static class SumAccumulator {
        public long sum = 0;
    }
}
```

**使用**：
```java
tableEnv.createTemporarySystemFunction("sumAggregate", SumAggregateFunction.class);

// SQL
tableEnv.sqlQuery("SELECT sumAggregate(value) FROM myTable");

// Table API
table.groupBy($("groupKey")).select(call("sumAggregate", $("value")).as("sum"));
```

### 4. TableAggregateFunction（表聚合函数）

**描述**：表聚合函数类似于聚合函数，但它可以将一系列输入聚合成多条输出记录。这在执行复杂的聚合操作（例如找出前 N 名等）时特别有用。

**示例**：
```java
import org.apache.flink.table.functions.TableAggregateFunction;

public class Top2 extends TableAggregateFunction<Tuple2<Integer, Integer>, Top2Accumulator> {
    public void accumulate(Top2Accumulator acc, Integer value) {
        if (value > acc.first) {
            acc.second = acc.first;
            acc.first = value;
        } else if (value > acc.second) {
            acc.second = value;
        }
    }

    public void emitValue(Top2Accumulator acc, Collector<Tuple2<Integer, Integer>> out) {
        out.collect(Tuple2.of(acc.first, 1));
        out.collect(Tuple2.of(acc.second, 2));
    }

    @Override
    public Top2Accumulator createAccumulator() {
        return new Top2Accumulator();
    }

    // 累加器定义
    public static class Top2Accumulator {
        public int first = Integer.MIN_VALUE;
        public int second = Integer.MIN_VALUE;
    }
}
```

**使用**：
```java
tableEnv.createTemporarySystemFunction("top2", Top2.class);

// SQL 中目前不可用，通常在 Table API 中使用
table.groupBy($("groupKey"))
     .flatAggregate(call("top2", $("value")))
     .select($("groupKey"), $("f0"), $("f1"));
```

### 5. AsyncFunction（异步函数）

**描述**：异步函数用于在流处理中执行异步操作，例如异步访问外部数据源。它扩展了 `RichAsyncFunction` 类，提供了允许异步结果返回的功能。

**示例**：
```java
import org.apache.flink.streaming.api.functions.async.RichAsyncFunction;
import org.apache.flink.streaming.api.functions.async.ResultFuture;

public class AsyncLookupFunction extends RichAsyncFunction<String, String> {
    @Override
    public void asyncInvoke(String input, ResultFuture<String> resultFuture) {
        // 模拟异步访问
        CompletableFuture.supplyAsync(() -> {
            // 模拟的耗时操作
            return "Result for " + input;
        }).thenAccept(resultFuture::complete);
    }
}
```

**使用**：
```java
DataStream<String> input = env.fromElements("input1", "input2", "input3");
AsyncDataStream.unorderedWait(input, new AsyncLookupFunction(), 1000, TimeUnit.MILLISECONDS)
               .print();
```

### 总结

通过以上 UDF 类型，Apache Flink 提供了强大的扩展功能，使得用户可以在处理数据流和批处理时，编写符合业务需求的自定义逻辑。根据具体的需求选择合适的 UDF 类型，不仅可以显著提高计算效率和代码可读性，还可以灵活地满足各种复杂的数据处理场景。

