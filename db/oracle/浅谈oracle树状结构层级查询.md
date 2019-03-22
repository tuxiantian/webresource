本篇中主要介绍start with...connect by prior 、order by 、sys_connect_by_path。

　　概要：树状结构通常由根节点、父节点、子节点和叶节点组成，简单来说，一张表中存在两个字段，dept_id,par_dept_id,那么通过找到每一条记录的父级id即可形成一个树状结构，也就是par_dept_id（子）=dept_id（父），通俗的说就是这条记录的par_dept_id是另外一条记录也就是父级的dept_id，其树状结构层级查询的基本语法是：

　　SELECT [LEVEL],*

　　FEOM table_name 

　　START WITH 条件1

　　CONNECT BY PRIOR 条件2

　　WHERE 条件3

　　ORDER　BY　排序字段

　　说明：LEVEL---伪列，用于表示树的层次

　　　　　条件1---根节点的限定条件，当然也可以放宽权限，以获得多个根节点，也就是获取多个树

　　　　　条件2---连接条件，目的就是给出父子之间的关系是什么，根据这个关系进行递归查询

　　　　　条件3---过滤条件，对所有返回的记录进行过滤。

　　　　　排序字段---对所有返回记录进行排序

　　对prior说明：要的时候有两种写法：connect by prior dept_id=par_dept_id 或 connect by dept_id=prior par_dept_id，前一种写法表示采用[自上而下](https://www.baidu.com/s?wd=%E8%87%AA%E4%B8%8A%E8%80%8C%E4%B8%8B&tn=24004469_oem_dg&rsv_dl=gh_pl_sl_csd)的搜索方式（先找父节点然后找子节点），后一种写法表示采用[自下而上](https://www.baidu.com/s?wd=%E8%87%AA%E4%B8%8B%E8%80%8C%E4%B8%8A&tn=24004469_oem_dg&rsv_dl=gh_pl_sl_csd)的搜索方式（先找叶子节点然后找父节点）。 

　　树状结构层次化查询需要对树结构的每一个节点进行访问并且不能重复，其访问步骤为：

　　![img](http://images2017.cnblogs.com/blog/1233594/201710/1233594-20171018152532131-1453364015.png)![img](http://images2017.cnblogs.com/blog/1233594/201710/1233594-20171018154210412-1484761238.png)

　　大致意思就是扫描整个树结构的过程即遍历树的过程，其用语言描述就是：

　　步骤一：从根节点开始；

　　步骤二：访问该节点；

　　步骤三：判断该节点有无未被访问的子节点，若有，则转向它最左侧的未被访问的子节，并执行第二步，否则执行第四步； 

　　步骤四：若该节点为根节点，则访问完毕，否则执行第五步； 

　　步骤五：返回到该节点的父节点，并执行第三步骤。 

　　除此之外，sys_connect_by_path函数是和connect  by 一起使用的，在实战中具体带目的具体介绍！

　　实战：最近做项目的组织结构，对于部门的各级层次显示，由于这部分掌握不牢固，用最笨的like模糊查询解决了，虽然功能实现了，但是问题很多，如扩展性不好，稍微改下需求就要进行大改，不满意最后对其进行了优化。在开发中能用数据库解决的就不要用java去解决，这也是我一直保持的想法并坚持着。

　　对于建表语句及其测试数据我放在另外一篇博客中，需要进行测试的可以过去拷贝运行测试验证下！

　　博客地址：[浅谈oracle树状结构层级查询测试数据](http://www.cnblogs.com/angusbao/p/7688212.html)

　　在这张表中有三个字段：dept_id 部门主键id;dept_name  部门名称;dept_code 部门编码；par_dept_id   父级部门id(首级部门为 -1);

1. 当前节点遍历子节点（遍历当前部门下所有子部门包括本身）
```
   select t.dept_id, t.dept_name, t.dept_code, t.par_dept_id, level
from SYS_DEPT t
start with t.dept_id = '40288ac45a3c1e8b015a3c28b4ae01d6'
connect by prior t.dept_id = t.par_dept_id
order by level, t.dept_code
```
   结果：

   dept_id=40288ac45a3c1e8b015a3c28b4ae01d6 是客运部主键，对其下的所有子部门进行遍历，同时用  order by level,dept_code 进行排序 以便达到实际生活中想要的数据；共31条数据，部分数据如图所示：

   ![img](http://images2017.cnblogs.com/blog/1233594/201710/1233594-20171018163524256-478375550.png)

   但是：

   　　有问题啊，如果你想在上面的数据中获取层级在2也就是level=2的所有部门，发现刚开始的时候介绍的语言不起作用？并且会报ORA-00933：sql命令未正确结束，why?

   这个我暂时也没有得到研究出理论知识，但是改变下where level='2'的位置发现才会可以的。错误的和正确的sql我们对比一下，以后会用就行，要是路过的大神知道为什么，还请告知下，万分感谢！

   错误sql:
```
   select t.dept_id, t.dept_name, t.dept_code, t.par_dept_id, level
from SYS_DEPT t 
start with t.dept_id = '40288ac45a3c1e8b015a3c28b4ae01d6'
connect by prior t.dept_id = t.par_dept_id
where level = '2'
order by level, t.dept_code
```
   正确sql:
```
   select t.dept_id, t.dept_name, t.dept_code, t.par_dept_id, level 
from SYS_DEPT t
where level = '2'
start with t.dept_id = '40288ac45a3c1e8b015a3c28b4ae01d6'
connect by prior t.dept_id = t.par_dept_id
order by level, t.dept_code
```
   ![img](http://images2017.cnblogs.com/blog/1233594/201710/1233594-20171018171558693-823248132.png)
   当然了，这个对其他形式的where过滤所有返回记录没有影响的，这个只是一个例外！

2. sys_connect_by_path函数求父节点到子节点路径
   简单介绍下，在oracle中sys_connect_by_path与connect by 一起使用，也就是先要有或建立一棵树，否则无用还会报错。它的主要作用体现在path上即路径，是可以吧一个父节点下的所有节点通过某个字符区分，然后链接在一个列中显示。
   sys_connect_by_path(column,clear),其中column是字符型或能自动转换成字符型的列名，它的主要目的就是将父节点到当前节点的“path”按照指定的模式出现，char可以是单字符也可以是多字符，但不能使用列值中包含的字符，而且这个参数必须是常量，且不允许使用绑定变量，clear不要用逗号。
   文字容易让人疲劳，放图和代码吧！
```
   select sys_connect_by_path(t.dept_name,'-->'),t.dept_id, t.dept_name, t.dept_code, t.par_dept_id, level 
from SYS_DEPT t  
start with t.dept_id = '40288ac45a3c1e8b015a3c28b4ae01d6' 
connect by prior t.dept_id = t.par_dept_id
order by level, t.dept_code
```
  结果：

![img](http://images2017.cnblogs.com/blog/1233594/201710/1233594-20171018173829974-1719216227.png)