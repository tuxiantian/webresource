1，[Oracle](http://lib.csdn.net/base/oracle)没有offet,limit，在[mysql](http://www.jzxue.com/shujuku/mysql/)中我们用它们来控制显示的行数，最多的是[分页](http://www.jzxue.com/tag/%B7%D6%D2%B3/)了。[oracle](http://lib.csdn.net/base/oracle)要分页的话，要换成rownum。

2，oracle建表时，没有auto_increment，所有要想让表的一个字段自增，要自己添加序列，插入时，把序列的值，插入进去。

3，oracle有一个dual表，当[select](http://www.jzxue.com/tag/Select/)后没有表时，加上的。不加会报错的。select 1 这个在[mysql](http://www.jzxue.com/shujuku/mysql/)不会报错的，oracle下会。select 1 from dual这样的话，oracle就不会报错了。

4，对空值的判断，name != ""这样在my[sql](http://www.jzxue.com/shujuku/mssqlserver/)下不会报错的，但是oracle下会报错。在oracle下的要换成name is not null

5，oracle下对单引号，双引号要求的很死，一般不准用双引号，用了会报

> ERROR at line 1:
> ORA-00904: "t": invalid identifier

而[MySQL](http://lib.csdn.net/base/mysql)要求就没有那么严格了，单引号，双引号都可以。

6，oracle有to_number,to_date这样的转换函数，oracle表字段是number型的，如果你$_[POST](http://www.jzxue.com/tag/post/)得到的参数是123456，入库的时候，你还要to_number来强制转换一下，不然后会被当成字符串来处理。而[mysql](http://lib.csdn.net/base/mysql)却不会。

7，group_concat这个函数，oracle是没有的，如果要想用自已写方法。

8，mysql的用户权限管理，是放到mysql自动带的一个[数据库](http://lib.csdn.net/base/mysql)mysql里面的，而oracle是用户权限是根着表空间走的。

9，group by,在下oracle下用group by的话，group by后面的字段必须在select后面出现，不然会报错的，而mysql却不会。

10，mysql存储引擎有好多，常用的mysiam,innodb等，而创建oracle表的时候，不要这样的，好像只有一个存储引擎。

11，oracle字段无法选择位置，alter table add column before|after，这样会报错的，即使你用sql*plus这样的工具，也没法改字段的位置。

12，oracle的表字段类型也没有mysql多，并且有很多不同，例如：mysql的int,float合成了oracle的number型等。

13，oracle查询时from 表名后面 不能加上[as](http://www.jzxue.com/tag/FlashAS/) 不然会报错的，select t.username from test as t而在mysql下是可以的。

14，oracle中是没有substring这个函数的，mysql有的。