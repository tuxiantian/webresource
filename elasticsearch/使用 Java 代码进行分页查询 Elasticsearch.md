使用 Java 代码进行分页查询 Elasticsearch （版本 7 及以上）的示例如下。在这个示例中，我们将使用 Elasticsearch 的官方 Java 客户端，即 High-Level REST Client (Java High-Level REST Client) 来进行分页查询。

### 环境准备

确保你已经安装并运行了 Elasticsearch。你可以从 [Elasticsearch 官网](https://www.elastic.co/cn/downloads/elasticsearch)下载最新版本并进行安装。

添加 Maven 依赖

在你的 Maven 项目的 `pom.xml` 文件中添加 Elasticsearch 客户端的依赖：

```xml
<dependencies>
    <!-- Elasticsearch 高级 REST 客户端依赖 -->
    <dependency>
        <groupId>org.elasticsearch.client</groupId>
        <artifactId>elasticsearch-rest-high-level-client</artifactId>
        <version>7.10.2</version> <!-- 请根据你的 Elasticsearch 版本选择合适的版本 -->
    </dependency>
    <!-- 添加必要的传输客户端依赖 -->
    <dependency>
        <groupId>org.apache.httpcomponents</groupId>
        <artifactId>httpclient</artifactId>
    </dependency>
</dependencies>
```

### Java 代码示例

创建一个 Java 应用程序，通过分页方式从 Elasticsearch 查询数据。示例假设索引名称 `my_index`，查询条件为 `field1:value1`。

```java
import org.apache.http.HttpHost;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.sort.SortOrder;

public class ElasticsearchPaginationExample {
    
    private static final String INDEX_NAME = "my_index";
    private static final String FIELD_NAME = "field1";
    private static final String FIELD_VALUE = "value1";
    private static final int PAGE_SIZE = 10; // 每页大小

    public static void main(String[] args) {
        // 创建 Elasticsearch 客户端
        try (RestHighLevelClient client = new RestHighLevelClient(
                RestClient.builder(new HttpHost("localhost", 9200, "http")))) {

            int pageNumber = 0;
            boolean hasMoreHits = true;

            while (hasMoreHits) {
                // 创建搜索请求
                SearchRequest searchRequest = new SearchRequest(INDEX_NAME);
                SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();

                // 定义查询条件
                sourceBuilder.query(QueryBuilders.termQuery(FIELD_NAME, FIELD_VALUE));
                
                // 设置分页
                sourceBuilder.from(pageNumber * PAGE_SIZE);
                sourceBuilder.size(PAGE_SIZE);
                
                // 可选：设置排序
                sourceBuilder.sort("timestamp", SortOrder.DESC);

                searchRequest.source(sourceBuilder);

                // 执行搜索请求
                SearchResponse searchResponse = client.search(searchRequest, RequestOptions.DEFAULT);

                // 获取查询结果
                searchResponse.getHits().forEach(hit -> {
                    System.out.println(hit.getSourceAsString());
                });

                // 检查是否还有更多数据
                hasMoreHits = searchResponse.getHits().getHits().length > 0;

                // 增加页码
                pageNumber++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### 核心步骤

1. **创建 Elasticsearch 客户端**：
   - 使用 `RestHighLevelClient` 创建 Elasticsearch 客户端，这里以本地运行的 Elasticsearch 实例为例。

2. **定义查询条件**：
   - 使用 `SearchSourceBuilder` 定义查询条件，这里使用 `termQuery` 查询指定字段的值。

3. **设置分页参数**：
   - 通过 `from` 和 `size` 方法设置分页参数。`from` 表示查询结果的起始位置，`size` 表示每页的文档数量。

4. **可选设置排序**：
   - 如果需要，可以使用 `sort` 方法设置排序条件。

5. **执行查询并处理结果**：
   - 使用 `client.search` 方法执行查询请求，并获取 `SearchResponse`。
   - 遍历查询结果，并处理每个文档。

6. **分页逻辑**：
   - 使用一个循环进行分页查询，当一次查询结果为空时，停止循环。

### 注意事项

- 上述示例的分页方式适用于数据量较小的情况，对于大规模数据分页查询，推荐使用 Elasticsearch 的 [Scroll API](https://www.elastic.co/guide/en/elasticsearch/reference/current/paginate-search-results.html#scroll-search-results)。
- Elasticsearch 客户端应该在应用程序生命周期内保持单例避免频繁创建。
- 在生产环境中，建议优化 Elasticsearch 查询性能，如使用合适的索引、查询缓存等。

通过上述步骤，您可以使用 Java 实现分页查询 Elasticsearch，并处理查询结果。希望这个示例能对您有所帮助！

对于大规模数据的分页查询，Elasticsearch 的 Scroll API 是一个高效且实用的选择。它适合处理需要提取大量数据的场景，因为 Scroll API 能够保持搜索上下文，避免在分页过程中因为深度分页导致数据库性能下降的问题。

下面是一个使用 Elasticsearch 高级 REST 客户端（Java High-Level REST Client）进行滚动（scroll）查询的完整示例。

### Java 代码示例

这是一个使用 Scroll API 进行大规模数据分页查询的示例，假设索引名称为 `my_index`。

```java
import org.apache.http.HttpHost;
import org.elasticsearch.action.search.ClearScrollRequest;
import org.elasticsearch.action.search.ClearScrollResponse;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchScrollRequest;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.common.unit.TimeValue;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.Scroll;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.sort.SortOrder;

import java.io.IOException;

public class ElasticsearchScrollAPIDemo {

    private static final String INDEX_NAME = "my_index";
    private static final String SCROLL_TIMEOUT = "1m";  // 滚动时间
    private static final int PAGE_SIZE = 100;  // 每页大小

    public static void main(String[] args) {
        // 创建 Elasticsearch 客户端
        try (RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("localhost", 9200, "http")))) {

            // 初始化滚动上下文
            final Scroll scroll = new Scroll(TimeValue.timeValueMinutes(1L));
            SearchRequest searchRequest = new SearchRequest(INDEX_NAME);
            SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
            sourceBuilder.query(QueryBuilders.matchAllQuery());
            sourceBuilder.size(PAGE_SIZE);
            sourceBuilder.sort("_doc", SortOrder.ASC);  // 以文档顺序排序，性能更好

            searchRequest.scroll(scroll);
            searchRequest.source(sourceBuilder);

            SearchResponse searchResponse = client.search(searchRequest, RequestOptions.DEFAULT);
            String scrollId = searchResponse.getScrollId();

            // 获取初始的搜索命中
            if (searchResponse.getHits().getHits().length == 0) {
                System.out.println("No results found.");
                return;
            } else {
                processSearchHits(searchResponse);
            }

            // 使用 scrollId 循环获取后续数据
            boolean hasMoreHits = true;
            while (hasMoreHits) {
                SearchScrollRequest scrollRequest = new SearchScrollRequest(scrollId);
                scrollRequest.scroll(scroll);

                SearchResponse searchScrollResponse = client.scroll(scrollRequest, RequestOptions.DEFAULT);
                scrollId = searchScrollResponse.getScrollId();

                if (searchScrollResponse.getHits().getHits().length == 0) {
                    hasMoreHits = false;
                } else {
                    processSearchHits(searchScrollResponse);
                }
            }

            // 清理滚动上下文
            ClearScrollRequest clearScrollRequest = new ClearScrollRequest();
            clearScrollRequest.addScrollId(scrollId);
            ClearScrollResponse clearScrollResponse = client.clearScroll(clearScrollRequest, RequestOptions.DEFAULT);
            if (!clearScrollResponse.isSucceeded()) {
                System.out.println("Failed to clear the scroll context.");
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void processSearchHits(SearchResponse searchResponse) {
        searchResponse.getHits().forEach(hit -> {
            System.out.println(hit.getSourceAsString());
        });
    }
}
```

### 核心步骤解析

1. **初始化滚动上下文**：
   ```java
   final Scroll scroll = new Scroll(TimeValue.timeValueMinutes(1L));
   ```

2. **创建搜索请求并设置滚动参数**：
   ```java
   SearchRequest searchRequest = new SearchRequest(INDEX_NAME);
   searchRequest.scroll(scroll);
   
   SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
   sourceBuilder.query(QueryBuilders.matchAllQuery());
   sourceBuilder.size(PAGE_SIZE);
   sourceBuilder.sort("_doc", SortOrder.ASC);  // 以文档顺序排序，性能更好
   
   searchRequest.source(sourceBuilder);
   ```

3. **执行初始搜索请求并获取 scrollId**：
   ```java
   SearchResponse searchResponse = client.search(searchRequest, RequestOptions.DEFAULT);
   String scrollId = searchResponse.getScrollId();
   ```

4. **处理初始搜索命中并循环获取后续数据**：
   ```java
   boolean hasMoreHits = true;
   while (hasMoreHits) {
       SearchScrollRequest scrollRequest = new SearchScrollRequest(scrollId);
       scrollRequest.scroll(scroll);
   
       SearchResponse searchScrollResponse = client.scroll(scrollRequest, RequestOptions.DEFAULT);
       scrollId = searchScrollResponse.getScrollId();
   
       if (searchScrollResponse.getHits().getHits().length == 0) {
           hasMoreHits = false;
       } else {
           processSearchHits(searchScrollResponse);
       }
   }
   ```

5. **清理滚动上下文**：
   ```java
   ClearScrollRequest clearScrollRequest = new ClearScrollRequest();
   clearScrollRequest.addScrollId(scrollId);
   
   ClearScrollResponse clearScrollResponse = client.clearScroll(clearScrollRequest, RequestOptions.DEFAULT);
   if (!clearScrollResponse.isSucceeded()) {
       System.out.println("Failed to clear the scroll context.");
   }
   ```

在使用 Elasticsearch 的 Scroll API 进行大规模分页查询时，清理滚动上下文（scroll context）是一个重要的步骤。下面我们详细解释一下原因：

### 为什么要清理滚动上下文？

1. **资源管理**：

   每次创建一个滚动上下文，Elasticsearch 都需要在集群中维持这个上下文的状态，包括搜索的结果和位置。这需要占用一定的资源，如内存和文件句柄。如果不及时清理，这些资源会一直占用，导致资源泄漏，特别是在大量使用 Scroll API 的情况下，可能会导致集群资源耗尽。

2. **性能影响**：

   未能及时清理滚动上下文可能会导致 Elasticsearch 集群性能下降。当有大量未清理的滚动上下文时，Elasticsearch 需要维护更多的上下文状态，增加了集群的负担，从而影响查询和索引的性能。

3. **滚动上下文过期**：

   即使你不清理滚动上下文，Elasticsearch 也会在滚动上下文的有效期（通常由 `scroll` 参数指定）过后自动清理。但是，主动清理滚动上下文可以更加及时地释放资源。依赖自动过期机制可能导致资源占用的时间过长。

### 总结

使用 Scroll API 进行大规模数据分页查询可以有效避免深度分页带来的性能问题。通过配合滚动上下文（scroll context），Elasticsearch 能够高效地保持查询结果的状态，逐页返回数据。上述示例展示了如何使用 Java 代码实现对大数据集的分页查询，包括初始化滚动上下文、处理搜索命中和清理滚动上下文的全部过程。希望这个示例能对你有所帮助！