---
typora-root-url: ..\..
---

## 联合查询语法内联、左联、右联、全联

MySQL联合查询效率较高，以下例子来说明联合查询（内联、左联、右联、全联）的好处：


T1表结构（用户名,密码）   
| userid（int） | username varchar（20） | password varchar（20） |
| ----------- | -------------------- | -------------------- |
| 1           | jack                 | jackpwd              |
| 2           | owen                 | owenpwd              |


T2表结构（用户名,密码）   
| userid（int） | jifen varchar（20） | dengji varchar（20） |
| ----------- | ----------------- | ------------------ |
| 1           | 20                | 3                  |
| 3           | 50                | 6                  |

### 第一：内联（inner join）

如果想把用户信息、积分、等级都列出来，那么一般会这样写：

select * from T1, T3 where T1.userid = T3.userid
（其实这样的结果等同于select * from T1 inner join T3 on T1.userid=T3.userid ）。

把两个表中都存在userid的行拼成一行（即内联），但后者的效率会比前者高很多，建议用后者（内联）的写法。

SQL语句：
select * from T1 inner join T2 on T1.userid = T2.userid

运行结果   
| T1.userid | username | password | T2.userid | jifen | dengji |
| --------- | -------- | -------- | --------- | ----- | ------ |
| 1         | jack     | jackpwd  | 1         | 20    | 3      |



### 第二：左联（left outer join）

显示左表T1中的所有行，并把右表T2中符合条件加到左表T1中；
右表T2中不符合条件，就不用加入结果表中，并且NULL表示。

SQL语句：
select * from T1 left outer join T2 on T1.userid = T2.userid

运行结果   
| T1.userid | username | password | T2.userid | jifen | dengji |
| --------- | -------- | -------- | --------- | ----- | ------ |
| 1         | jack     | jackpwd  | 1         | 20    | 3      |
| 2         | owen     | owenpwd  | NULL      | NULL  | NULL   |



### 第三：右联（right outer join）

显示右表T2中的所有行，并把左表T1中符合条件加到右表T2中；
左表T1中不符合条件，就不用加入结果表中，并且NULL表示。

SQL语句：
select * from T1 right outer join T2 on T1.userid = T2.userid

运行结果   
| T1.userid | username | password | T2.userid | jifen | dengji |
| --------- | -------- | -------- | --------- | ----- | ------ |
| 1         | jack     | jackpwd  | 1         | 20    | 3      |
| NULL      | NULL     | NULL     | 3         | 50    | 6      |



### 第四：全联（full outer join）

显示左表T1、右表T2两边中的所有行，即把左联结果表 + 右联结果表组合在一起，然后过滤掉重复的。

SQL语句：
select * from T1 full outer join T2 on T1.userid = T2.userid

运行结果   
| T1.userid | username | password | T2.userid | jifen | dengji |
| --------- | -------- | -------- | --------- | ----- | ------ |
| 1         | jack     | jackpwd  | 1         | 20    | 3      |
| 2         | owen     | owenpwd  | NULL      | NULL  | NULL   |
| NULL      | NULL     | NULL     | 3         | 50    | 6      |

总结，关于联合查询，效率的确比较高，4种联合方式如果可以灵活使用，基本上复杂的语句结构也会简单起来。

## 实战中联合查询的书写建议

![TIM截图20181116113913](/images/db/mysql/TIM截图20181116113913.png)

