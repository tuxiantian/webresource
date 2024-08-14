**1 LIMIT语句**

分页查询是最常用的场景之一，但也通常也是最容易出问题的地方。比如对于下面简单的语句，一般 DBA 想到的办法是在 type, name, create_time 字段上加组合索引。这样条件排序都能有效的利用到索引，性能迅速提升。

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpl8HoNCJibsWKFNTDX9OEF4bDrQ6JY1pohRxFrgNl8xiawbr5EcksicdBg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

好吧，可能90%以上的 DBA 解决该问题就到此为止。但当 LIMIT 子句变成 “LIMIT 1000000,10” 时，程序员仍然会抱怨：我只取10条记录为什么还是慢？

要知道数据库也并不知道第1000000条记录从什么地方开始，即使有索引也需要从头计算一次。出现这种性能问题，多数情形下是程序员偷懒了。

在前端数据浏览翻页，或者大数据分批导出等场景下，是可以将上一页的最大值当成参数作为查询条件的。SQL 重新设计如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXp2pbeonsxvgdNz8hCYeBWP7Zlgia9wNFCXt9dkgE3wmyA8djjM4cuWmA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

在新设计下查询时间基本固定，不会随着数据量的增长而发生变化。

**2 隐式转换**

SQL语句中查询变量和字段定义类型不匹配是另一个常见的错误。比如下面的语句：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpXp5PX1qrW2sNYQw8O8KTBxe35F7eOeicRQccyU4MRatoalotRicXVe8w/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

其中字段 bpn 的定义为 varchar(20)，MySQL 的策略是将字符串转换为数字之后再比较。函数作用于表字段，索引失效。

上述情况可能是应用程序框架自动填入的参数，而不是程序员的原意。现在应用框架很多很繁杂，使用方便的同时也小心它可能给自己挖坑。

**3 关联更新、删除**

虽然 MySQL5.6 引入了物化特性，但需要特别注意它目前仅仅针对查询语句的优化。对于更新或删除需要手工重写成 JOIN。

比如下面 UPDATE 语句，MySQL 实际执行的是循环/嵌套子查询（DEPENDENT SUBQUERY)，其执行时间可想而知。

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpcAwibxcLaUEADKq3ec5uxbfkIujy3mSLlkA4fU6SRQVZxcZEhHAdtHw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

执行计划：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpok8sCYby71edCLMiazNrIYXgjMuDCrg8TDfqtHJibFKibNUBriaDdfAj9A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

重写为 JOIN 之后，子查询的选择模式从 DEPENDENT SUBQUERY 变成 DERIVED，执行速度大大加快，从7秒降低到2毫秒

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpKsfUm7nsaq7uIIaF0vOZjTGfKU8NxrgXbGzyjEpibCFXn9DYzkrb00w/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

执行计划简化为：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpianfM9YWcovlrY08VeWnuXY7iaowsX5F8FCalP09ia29aLb8mRiaYYniawg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**4 混合排序**

MySQL 不能利用索引进行混合排序。但在某些场景，还是有机会使用特殊方法提升性能的。

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpuAWZibdpiajsWyPXPwKws8tdS5A93nzwMbmm5lZMgEje0Ig4fsYibBicww/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

执行计划显示为全表扫描：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpkyU5XCibOM4Buia3eNodia7bnEWSOLZ2lhb8fWOjsT8K7khsjVYGdnHbQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

由于 is_reply 只有0和1两种状态，我们按照下面的方法重写后，执行时间从1.58秒降低到2毫秒。

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpvRvzHCkvlibBWOrqsVUjBQ79KVNwGxv3EiaUj4GhoQvgOEeA0s3dtJng/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**5** **EXISTS语句**

MySQL 对待 EXISTS 子句时，仍然采用嵌套子查询的执行方式。如下面的 SQL 语句：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXp6AxFhHeQdrdKKx7lYNEwF6zbKibSPdxUURpuMSE2aCoZVm9P3095GCg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

执行计划为：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpvYIsFTLVjnuCiclicLiaMuw4Uy8WKTaiaLWHzKj7TlRXT0q2GeRSntj30Q/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

去掉 exists 更改为 join，能够避免嵌套子查询，将执行时间从1.93秒降低为1毫秒。

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpOB4HPxzhvt7VdTQPj4JI0A1dGdMs6awt2NZX7UqHJB8LvYWcd3Arsg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

新的执行计划：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpumwajBqicZIm9vLAwGVR00bBlR2fq7IsWHhQRy0x9pdz8tZAPyNQpibg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**6 条件下推**

外部查询条件不能够下推到复杂的视图或子查询的情况有：

- 聚合子查询；
- 含有 LIMIT 的子查询；
- UNION 或 UNION ALL 子查询；
- 输出字段中的子查询；

如下面的语句，从执行计划可以看出其条件作用于聚合子查询之后

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpQP4wkhBFG8IXRpURfxu17vXiaxUQ1wsiclCtzH5JzeRGDvw1NMyJXVRg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpZP5hSEP7cFlNLVjRD7JYUktCQWHc4f6zkLjowRj7zWSQXHwMX8LRYw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

确定从语义上查询条件可以直接下推后，重写如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpq49eBeoAffh7u5mupy0DSzSTqFeS6libprFhXkYNI2p6ibuWPTG4Wmrg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

执行计划变为：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpNuUxkd2y2icDgWCNqS7r1au5o51NkkNDfvgc3p4by0dBMmzjpHWgzJw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**7 提前缩小范围**

先上初始 SQL 语句：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpiapicXampaPKSia7DUwhcS61U18uIpvhdotniabOicy7qkD1DhVFHP4bKibA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

数为90万，时间消耗为12秒。

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXp37V0EAwIlicCFl4wWYNkdRibpH6d8cbU52SIWQ0axWcyZXkLS1N3C3ag/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

由于最后 WHERE 条件以及排序均针对最左主表，因此可以先对 my_order 排序提前缩小数据量再做左连接。SQL 重写后如下，执行时间缩小为1毫秒左右。

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpma6rNrIVyTV87nMdmwiauMKyevwmYEj7tcJJW0HFDcejAPc93fH0N4Q/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

再检查执行计划：子查询物化后（select_type=DERIVED)参与 JOIN。虽然估算行扫描仍然为90万，但是利用了索引以及 LIMIT 子句后，实际执行时间变得很小。

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpQCEaTV3jPkL6bhHQNVDSF3AicjLKwsI3lhI38WCRtNtGx2wG2EeR6Tw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**8** **中间结果集下推**

再来看下面这个已经初步优化过的例子(左连接中的主表优先作用查询条件)：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpldHAicNhSU113BdMx0PzmB006zpAeCIyBLZHZvDSvTj1qia6cCbwOmfg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

那么该语句还存在其它问题吗？不难看出子查询 c 是全表聚合查询，在表数量特别大的情况下会导致整个语句的性能下降。

其实对于子查询 c，左连接最后结果集只关心能和主表 resourceid 能匹配的数据。因此我们可以重写语句如下，执行时间从原来的2秒下降到2毫秒。

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpYzjvTWMSicPtRsic2jZ3lB9oPcfPQjTdhSo4Jic2UWQ9FT3ZemG4OLTDA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

但是子查询 a 在我们的SQL语句中出现了多次。这种写法不仅存在额外的开销，还使得整个语句显的繁杂。使用 WITH 语句再次重写：

![img](https://mmbiz.qpic.cn/mmbiz_png/UtWdDgynLdYgtsE9alsWhXpq0bGJMBXpP7khx3kicVucvATHkMasoJQRrk4ETuzWtzgOPeeJ75x9kXicfz4kMUBQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**9** **总结**

数据库编译器产生执行计划，决定着SQL的实际执行方式。但是编译器只是尽力服务，所有数据库的编译器都不是尽善尽美的。

上述提到的多数场景，在其它数据库中也存在性能问题。了解数据库编译器的特性，才能避规其短处，写出高性能的SQL语句。

程序员在设计数据模型以及编写SQL语句时，要把算法的思想或意识带进来。

编写复杂SQL语句要养成使用 WITH 语句的习惯。简洁且思路清晰的SQL语句也能减小数据库的负担 。