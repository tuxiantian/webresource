jsonpath使用示例

```
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

