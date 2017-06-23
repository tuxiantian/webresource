## 非自增主键的保存更新问题
![](/images/work/question1.png)  
表结构信息如下
```
CREATE TABLE `t_busline_map_data` (
  `line_id` int(10) unsigned NOT NULL COMMENT '线路id',
  `map_data` varchar(20000) DEFAULT NULL COMMENT '地图数据',
  PRIMARY KEY (`line_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='线路地图数据'
```
重写服务类的保存更新方法，根据主键值查询，非空即更新
![](/images/work/solution11.png)  
删除insert元素的useGeneratedKeys和keyProperty属性，将主键改为手动插入
![](/images/work/solution12.png)  