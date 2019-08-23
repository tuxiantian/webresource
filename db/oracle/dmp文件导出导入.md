```
docker run -d -p 1522:1521 --name yunnan_od sath89/oracle-12c -v /etc/timezone:/etc/timezone \

docker cp od_data.dmp yunnan_od:/

docker exec -it yunnan_od /bin/bash

#这一步要输入密码，密码是oracle
#system/oracle
sqlplus sys as sysdba

create user ocdm identified by ocdm;

grant connect,resource,dba to ocdm;

exit

imp ocdm/ocdm file=od_data.dmp log=/od_data.log full=y

```
# [ORA-28000: the account is locked-的解决办法](https://www.cnblogs.com/jianqiang2010/archive/2011/09/01/2162574.html)

```sql
ALTER USER ocdm ACCOUNT UNLOCK;
```

查看容器的日志

```
docker logs -f yunnan_od
```

```
###### 虚拟机云南docker_oracle 12c xe，ocdm/ocdm

local_12c_yunnan =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.226.135)(PORT = 1522))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = xe)
    )
  )
```

本机导出实战

```
mkdir /dmp
chmod -R 777 /dmp
sqlplus sys as sysdba  
create or replace directory dmp  as '/dmp';
grant read,write on directory dmp to ocdm;

expdp ocdm/ocdm@127.0.0.1:1521/xe directory=dmp dumpfile=ocdm_neimeng.dmp logfile=ocdm_neimeng.log  version=11.2;
```

本地导入实战

```
impdp ocdm/ocdm@127.0.0.1:1521/xe  directory=dmp dumpfile=ocdm_neimeng.dmp log=od_data.log schemas=ocdm
```

导入时ocdm_neimeng.dmp要在dmp目录中，否则会提示找不到文件。

ip:port不能省略，否则会报这个错误

> ORA-12154: TNS:could not resolve the connect identifier specified

**expdp/impdp和exp/imp的区别**

1、exp和imp是客户端工具程序，它们既可以在客户端使用，也可以在服务端使用。

2、expdp和impdp是服务端的工具程序，他们只能在[Oracle](https://www.linuxidc.com/topicnews.aspx?tid=12)服务端使用，不能在客户端使用。

3、imp只适用于exp导出的文件，不适用于expdp导出文件；impdp只适用于expdp导出的文件，而不适用于exp导出文件。

4、对于10g以上的服务器，使用exp通常不能导出0行数据的空表，而此时必须使用expdp导出。

# Oracle导出表（即DMP文件）的两种方法

## 方法一：利用PL/SQL Developer工具导出

菜单栏---->Tools---->Export Tables，如下图，设置相关参数即可：

![](https://img-my.csdn.net/uploads/201205/18/1337329645_5175.jpg)

## 方法二：利用cmd的操作命令导出，详情如下

### 1:配置数据库连接

G:\Oracle\product\10.1.0\Client_1\NETWORK\ADMIN目录下有个tnsname.ora文件，内容如下：

```
CMSTAR =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 172.18.13.200)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = cmstar)
    )
  )
```
其中：CMSTAR为数据库名，HOST为IP地址，所以可以仿效上面的例子手动添加数据录连接。

### 2：用cmd进入命令行

输入：tnsping cmstar
就是测试172.18.13.200是否连接成功

### 3：导入与导出

#### 数据导出

 1 将数据库TEST完全导出,用户名system 密码manager 导出到D:\daochu.dmp中

 ```
   exp system/manager@TEST file=d:\daochu.dmp full=y
 ```

 2 将数据库中system用户与sys用户的表导出
   ```
   exp system/manager@TEST file=d:\daochu.dmp owner=(system,sys)
   ```
 3 将数据库中的表table1 、table2导出
   ```
   exp system/manager@TEST file=d:\daochu.dmp tables=(table1,table2) 
   ```
  将生产库导出一份放在本地调试，分2次导出，一次导出配置数据表，包含配置数据，一次导出业务表，不包含业务数据。整理配置表和业务表时需要查出所有的表，一般使用下面的查询语句。

**查询数据库中有哪些表**

  ```
select table_name from tabs;

select * from dba_all_tables;
select * from user_all_tables;
  ```

4 将数据库中的表table1中的字段filed1以"00"打头的数据导出

   ```
exp system/manager@TEST file=d:\daochu.dmp tables=(table1) query=\" where filed1 like '00%'\"
   ```
 上面是常用的导出，对于压缩我不太在意，用winzip把dmp文件可以很好的压缩。  不过在上面命令后面 加上 compress=y  就可以了 。

#### 数据的导入

 1 将D:\daochu.dmp 中的数据导入 TEST数据库中。
 ```
imp system/manager@TEST  file=d:\daochu.dmp
 ```
上面可能有点问题，因为有的表已经存在，然后它就报错，对该表就不进行导入。   在后面加上 ignore=y 就可以了。
 2 将d:\daochu.dmp中的表table1 导入

 ```
 imp system/manager@TEST  file=d:\daochu.dmp  tables=(table1) 
 ```
注意事项：导出dmp数据时需要有导出表的权限的用户，否则不能导出。 

11g远程导库
```
exp od/Ztesoft123@iom file=/home/oracle/expdata/od_data_20190418.dmp owner=od
```
11g本地导库

 ```
create or replace directory iom_dir as '/home/oracle/iom';

expdp iom/yniombss31108 directory=iom_dir dumpfile=iom_data_20190419.dmp include=table query=\"where rownum < 100001\"

 ```

##### ORA-00959: tablespace 'TBS_OD_ORDER_INST' does not exist

验证表空间是否存在

```
select * from dba_data_files where tablespace_name = 'TBS_OD_ORDER_INST';
```

  查询数据库datafile路径

```
select * from dba_data_files;  
```

 手动创建表空间

```
create tablespace TBS_OD_ORDER_INST   
  logging   
  datafile  '/u01/app/oracle/oradata/xe/users02.dbf'     
  size 32m    
  autoextend on    
  next 32m maxsize 2048m   
  extent management local; 
```

这时候再用imp导入dmp文件就可以成功了。使用exp和imp这组命令进行导入导出的好处是表中的clob类型的字段数据也可以导入成功。

查询数据库表空间

```sql
select a.TABLESPACE_NAME from user_tables a group by a.TABLESPACE_NAME;
```

删除表空间

```
drop tablespace TBS_OCDM4BP_NEIMENG_INST including contents and datafiles;
```

