在使用 Elasticsearch 进行数据写入时，Java 客户端（RestHighLevelClient）提供了丰富的 API 来进行各种操作。下面是一个完整的 Java 示例，展示如何在 Elasticsearch 中写入数据（即创建或索引文档）。

### 环境准备

首先，确保你已经在 Maven 项目中添加了 Elasticsearch 高级 REST 客户端的依赖。可以在你的 `pom.xml` 文件中添加以下依赖项：

```xml
<dependencies>
    <dependency>
        <groupId>org.elasticsearch.client</groupId>
        <artifactId>elasticsearch-rest-high-level-client</artifactId>
        <version>7.10.2</version> <!-- 确保使用与你的 Elasticsearch 版本匹配的版本 -->
    </dependency>
    <dependency>
        <groupId>org.apache.httpcomponents</groupId>
        <artifactId>httpclient</artifactId>
    </dependency>
</dependencies>
```

### Java 代码示例

下面是一个示例，展示如何使用 Elasticsearch 高级 REST 客户端写入数据到 Elasticsearch 索引。

```java
import org.apache.http.HttpHost;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.common.xcontent.XContentBuilder;
import org.elasticsearch.common.xcontent.XContentFactory;

import java.io.IOException;

public class ElasticsearchWriteDataExample {
    public static void main(String[] args) {
        // 创建 Elasticsearch 客户端
        try (RestHighLevelClient client = new RestHighLevelClient(
                RestClient.builder(new HttpHost("localhost", 9200, "http")))) {
            
            // 创建索引请求，指定索引名称和文档 ID（可选）
            IndexRequest request = new IndexRequest("my_index").id("1");

            // 准备文档内容
            XContentBuilder builder = XContentFactory.jsonBuilder();
            builder.startObject();
            {
                builder.field("user", "john_doe");
                builder.field("postDate", "2023-10-01");
                builder.field("message", "Trying out Elasticsearch");
            }
            builder.endObject();
            request.source(builder);

            // 发送索引请求
            IndexResponse indexResponse = client.index(request, RequestOptions.DEFAULT);
            
            // 输出响应信息
            System.out.println("Index name: " + indexResponse.getIndex());
            System.out.println("Document ID: " + indexResponse.getId());
            System.out.println("Response result: " + indexResponse.getResult());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### 代码详解

1**创建 Elasticsearch 客户端**：

   ```java
RestHighLevelClient client = new RestHighLevelClient(
RestClient.builder(new HttpHost("localhost", 9200, "http")));
   ```

2**创建索引请求**：

   ```java
   IndexRequest request = new IndexRequest("my_index").id("1");
   ```

    这里的 `my_index` 是你要操作的索引名称。
    `id("1")` 指定了文档的 ID。如果没有指定，Elasticsearch 会自动生成一个。

3**准备文档内容**：

   ```java
   XContentBuilder builder = XContentFactory.jsonBuilder();
   builder.startObject();
   {
       builder.field("user", "john_doe");
       builder.field("postDate", "2023-10-01");
       builder.field("message", "Trying out Elasticsearch");
   }
   builder.endObject();
   request.source(builder);
   ```

4**发送索引请求**：

   ```java
   IndexResponse indexResponse = client.index(request, RequestOptions.DEFAULT);
   ```

5**输出响应信息**：

  ```java
   System.out.println("Index name: " + indexResponse.getIndex());
   System.out.println("Document ID: " + indexResponse.getId());
   System.out.println("Response result: " + indexResponse.getResult());
  ```

### 异步写入示例

如果你希望异步写入数据，可以使用如下代码：

```java
import org.apache.http.HttpHost;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.common.xcontent.XContentBuilder;
import org.elasticsearch.common.xcontent.XContentFactory;
import org.elasticsearch.action.ActionListener;

import java.io.IOException;

public class ElasticsearchAsyncWriteExample {
    public static void main(String[] args) {
        try (RestHighLevelClient client = new RestHighLevelClient(
                RestClient.builder(new HttpHost("localhost", 9200, "http")))) {
            
            IndexRequest request = new IndexRequest("my_index").id("2");

            XContentBuilder builder = XContentFactory.jsonBuilder();
            builder.startObject();
            {
                builder.field("user", "jane_doe");
                builder.field("postDate", "2023-10-02");
                builder.field("message", "Learning Elasticsearch");
            }
            builder.endObject();
            request.source(builder);

            client.indexAsync(request, RequestOptions.DEFAULT, new ActionListener<IndexResponse>() {
                @Override
                public void onResponse(IndexResponse indexResponse) {
                    System.out.println("Index name: " + indexResponse.getIndex());
                    System.out.println("Document ID: " + indexResponse.getId());
                    System.out.println("Response result: " + indexResponse.getResult());
                }

                @Override
                public void onFailure(Exception e) {
                    e.printStackTrace();
                }
            });

            // 主线程可以继续做其他事情
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

在这个异步示例中，使用 `client.indexAsync` 方法，可以在处理写入操作的同时继续执行其他任务，而不是等待响应。

### 总结

通过以上示例代码，可以看出如何使用 Elasticsearch 高级 REST 客户端将数据写入到 Elasticsearch 索引中。无论是同步还是异步写入，Elasticsearch 客户端都提供了方便的方法来完成这些操作。确保在项目的 Maven 依赖中包含必要的客户端库，然后根据实际需求进行代码调整和扩展。