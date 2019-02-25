业务需求，要将数据在redis中hashmap的形式存下来，及 key:map 
map中的value也是一个map即map2 
map2中的value也是一个map即map3 
共3个map 
即：key：（key2：（key3，（key4，value））） 
但是redis只支持Hashmap<String,String>的存法 
因此在存时将map2和map3转化为String
```
    JedisPool pool=new JedisPool(new JedisPoolConfig(), host, port, timeout);
        Jedis jedis=pool.getResource();
        HashMap<String, String> map=new HashMap<>();
        HashMap<String, String> map2=new HashMap<>();
        HashMap<String, String> map3=new HashMap<>();
        try {
            map3.put("江苏", "无锡");
            map2.put("中国", map3.toString());
            map.put("亚洲",map2.toString());
            jedis.hmset("地球", map);
        } finally {
            pool.returnResource(jedis);
        }
```
通过redis的key地球可以轻松获取redis的value:
```
Map<String, String> hgetAll = jedis.hgetAll("地球");
System.out.println(hgetAll);

{亚洲={中国={江苏=无锡}}}

List<String> list = jedis.hmget("地球", "亚洲");
System.out.println(list);
[{中国={江苏=无锡}}]
```
这时的返回值已经变成一个list，不能再按key、value取值了，但是业务需求是通过江苏获取城市名的话就不太好操作了。 
此时通过list—-json—map可以将值重新转为map
```
JSONObject  jasonObject = JSONObject.fromObject(list.toString());
System.out.println(jasonObject);
```
这样直接写的话会报错
```
Exception in thread "main" net.sf.json.JSONException: A JSONObject text must begin with '{' at character 1 of [{中国={江苏=无锡}}]
```
list不是json格式的，这里我投机取巧了一把，直接将list头尾的 [ 和 ] 截取了
```
String string = list.toString();
String substring = string.substring(1, string.length()-1);
JSONObject  jasonObject = JSONObject.fromObject(substring);
System.out.println(jasonObject);
```
报错：
```
Exception in thread "main" net.sf.json.JSONException: Unquotted string '无锡'
```

百度了一圈，没找到特别好的解决办法。只能在赋值时给 无锡 这个值时加上双引号
```
map3.put("江苏", "\"无锡\"");
```
再次运行输出的值为：
```
{"中国":{"江苏":"无锡"}}
```
转成map
```
Map map = (Map)jasonObject;
System.out.println(map.get("中国"));

{"江苏":"无锡"}
```
```
Object object = map.get("中国");
Map map2 = (Map)object;
System.out.println(map2.get("江苏"));

无锡
```
昨天代码优化后发现了更好的方式 不用map2,map3，直接用JSONObject存更方便
```
HashMap<String, String> map=new HashMap<>();
JSONObject jsonObject=new JSONObject();
JSONObject jsonObject2=new JSONObject();
try {
jsonObject2.put("江苏", "无锡");
jsonObject.put("中国", jsonObject2.toString());
map.put("亚洲",jsonObject.toString());
jedis.hmset("地球", map);
```
这时进行查询时结果直接为json格式
```
List<String> list = jedis.hmget("地球", "亚洲");
System.out.println(list);
```
结果为：{"中国":{"江苏":"无锡"}}
