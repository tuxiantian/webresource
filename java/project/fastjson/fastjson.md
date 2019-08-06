jsonpath使用示例

## 字符串和数字类型的处理方式的区别

```java
JSONPath jsonPath = JSONPath.compile("$.prodOrderItems.ordProdInsts[0:][prodInstId=370008142710].accNum");
//language=JSON
String str2="{\n" +
        "  \"prodOrderItems\":[\n" +
        "    {\n" +
        "      \"ordProdInsts\":[\n" +
        "        {\n" +
        "          \"prodInstId\":370008142710,\n" +
        "          \"accNum\":123\n" +
        "          \n" +
        "        }\n" +
        "      ]\n" +
        "    },\n" +
        "    {\n" +
        "      \"ordProdInsts\":[\n" +
        "        {\n" +
        "          \"prodInstId\":370008142711,\n" +
        "          \"accNum\":124\n" +
        "\n" +
        "        }\n" +
        "      ]\n" +
        "    }\n" +
        "  ]\n" +
        "}";
Object eval = jsonPath.eval(JSONObject.parseObject(str2));
System.out.println(eval instanceof JSONArray);
System.out.println(eval);
```

输出结果如下：

true
[123]

由于json数据中prodInstId的属性值是数值类型，所以json表达式的筛选使用的是：`$.prodOrderItems.ordProdInsts[0:][prodInstId=370008142710].accNum`

若是json数据中prodInstId的属性值是字符串，那json表达式的筛选使用：`$.prodOrderItems[0:].ordProdInsts[0:][prodInstId='370008142710'].accNum`

筛选结果是`JSONArray`

## 多条件筛选的写法

```java
String json="{\n" +
                "  \"students\":[\n" +
                "    {\n" +
                "      \"name\":\"Bob\",\n" +
                "      \"gender\":\"male\",\n" +
                "      \"age\":10\n" +
                "    },\n" +
                "    {\n" +
                "      \"name\":\"Bob\",\n" +
                "      \"gender\":\"female\",\n" +
                "      \"age\":11\n" +
                "    }\n" +
                "  ]\n" +
                "}\n"
    ;
JSONPath jsonPath = JSONPath.compile("$.students[0:][name='Bob'][gender='male'].age");
Object result = jsonPath.eval(JSONObject.parseObject(json));
if (result instanceof JSONArray){    
    JSONArray array= (JSONArray) result;    
    Assert.assertEquals(array.get(0),10);
}
```

想从students集合中筛选name='Bob'并且gender='male'的学生，就要这样写`$.students[0:][name='Bob'][gender='male'].age`