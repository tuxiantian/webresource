**一、expdp/impdp和exp/imp的区别**

1、exp和imp是客户端工具程序，它们既可以在客户端使用，也可以在服务端使用。

2、expdp和impdp是服务端的工具程序，他们只能在[Oracle](https://www.linuxidc.com/topicnews.aspx?tid=12)服务端使用，不能在客户端使用。

3、imp只适用于exp导出的文件，不适用于expdp导出文件；impdp只适用于expdp导出的文件，而不适用于exp导出文件。

4、对于10g以上的服务器，使用exp通常不能导出0行数据的空表，而此时必须使用expdp导出。

**二、expdp导出步骤**

（1）创建逻辑目录：

　　　第一步：在服务器上创建真实的目录；（注意：第三步创建逻辑目录的命令不会在OS上创建真正的目录，所以要先在服务器上创建真实的目录。如下图：）

　![img](https://www.linuxidc.com/upload/2017_09/170905205243212.png)

　　　第二步：用sys管理员登录sqlplus；

```
oracle@ypdbtest:/home/oracle/dmp/vechcore>sqlplus

SQL*Plus: Release 11.2.0.4.0 Production on Tue Sep 5 09:20:49 2017

Copyright (c) 1982, 2013, Oracle.  All rights reserved.

Enter user-name: sys as sysdba
Enter password:

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL>
```

　　　第三步：创建逻辑目录；

```
SQL> create directory data_dir as '/home/oracle/dmp/user';

Directory created.
```

　　　第四步：查看管理员目录，检查是否存在；

```
SQL> select * from dba_directories;

OWNER                          DIRECTORY_NAME
------------------------------ ------------------------------
DIRECTORY_PATH
--------------------------------------------------------------------------------
SYS                            DATA_DIR
/home/oracle/dmp/user
```

　　　　第五步：用sys管理员给你的指定用户赋予在该目录的操作权限。

```
SQL> grant read,write on directory data_dir to user;

Grant succeeded.
```

（2）用expdp导出dmp，有五种导出方式：

　　　　第一种：“full=y”，全量导出数据库；

```
expdp user/passwd@orcl dumpfile=expdp.dmp directory=data_dir full=y logfile=expdp.log;
```

　　　　第二种：schemas按用户导出；

```
expdp user/passwd@orcl schemas=user dumpfile=expdp.dmp directory=data_dir logfile=expdp.log;
```

　　　　第三种：按表空间导出；

```
expdp sys/passwd@orcl tablespace=tbs1,tbs2 dumpfile=expdp.dmp directory=data_dir logfile=expdp.log;
```

　　　　第四种：导出表；

```
expdp user/passwd@orcl tables=table1,table2 dumpfile=expdp.dmp directory=data_dir logfile=expdp.log;
```

　　　　第五种：按查询条件导；

```
expdp user/passwd@orcl tables=table1='where number=1234' dumpfile=expdp.dmp directory=data_dir logfile=expdp.log;
```


**三、impdp导入步骤**

（1）如果不是同一台服务器，需要先将上面的dmp文件下载到目标服务器上，具体命令参照：http://www.cnblogs.com/promise-x/p/7452972.html

（2）参照“expdp导出步骤”里的前三步，建立逻辑目录；

（3）用impdp命令导入，对应五种方式：

　　　　第一种：“full=y”，全量导入数据库；

```
impdp user/passwd directory=data_dir dumpfile=expdp.dmp full=y;
```

　　　　第二种：同名用户导入，从用户A导入到用户A；

```
impdp A/passwd schemas=A directory=data_dir dumpfile=expdp.dmp logfile=impdp.log;
```

　　　　第三种：①从A用户中把表table1和table2导入到B用户中；

```
impdp B/passwdtables=A.table1,A.table2 remap_schema=A:B directory=data_dir dumpfile=expdp.dmp logfile=impdp.log;
```

　　　　　　　　②将表空间TBS01、TBS02、TBS03导入到表空间A_TBS，将用户B的数据导入到A，并生成新的oid防止冲突；

```
impdp A/passwdremap_tablespace=TBS01:A_TBS,TBS02:A_TBS,TBS03:A_TBS remap_schema=B:A FULL=Y transform=oid:n 
directory=data_dir dumpfile=expdp.dmp logfile=impdp.log
```

　　　　第四种：导入表空间；

```
impdp sys/passwd tablespaces=tbs1 directory=data_dir dumpfile=expdp.dmp logfile=impdp.log;
```

　　　　第五种：追加数据；

```
impdp sys/passwd directory=data_dir dumpfile=expdp.dmp schemas=system table_exists_action=replace logfile=impdp.log; 
--table_exists_action:导入对象已存在时执行的操作。有效关键字:SKIP,APPEND,REPLACE和TRUNCATE
```

 

**四、expdp关键字与命令**

------

 **（1）关键字　　　　　　　　　  　　说明 (默认)**

------

 ATTACH　　　　　　　　　　　　　　　连接到现有作业, 例如 ATTACH [=作业名]。

 COMPRESSION　　　　  　　　　　　　减小转储文件内容的大小, 其中有效关键字  值为: ALL, (METADATA_ONLY), DATA_ONLY 和 NONE。

 CONTENT　　　　　　　　　 　　　　  指定要卸载的数据, 其中有效关键字  值为: (ALL), DATA_ONLY 和 METADATA_ONLY。

 DATA_OPTIONS　　　　　　  　　　　  数据层标记, 其中唯一有效的值为: 使用CLOB格式的 XML_CLOBS-write XML 数据类型。

 DIRECTORY　　　　　　　　 　　　　　供转储文件和日志文件使用的目录对象，即逻辑目录。

 DUMPFILE　　　　　　　　　　　　　　目标转储文件 (expdp.dmp) 的列表,例如 DUMPFILE=expdp1.dmp, expdp2.dmp。

 ENCRYPTION　　　　　　　　  　　　　加密部分或全部转储文件, 其中有效关键字值为: ALL, DATA_ONLY, METADATA_ONLY,ENCRYPTED_COLUMNS_ONLY 或 NONE。

 ENCRYPTION_ALGORITHM　　　　　　指定应如何完成加密, 其中有效关键字值为: (AES128), AES192 和 AES256。

 ENCRYPTION_MODE　　　　　　　　　`生成加密密钥的方法, 其中有效关键字值为: DUAL, PASSWORD` `和 (TRANSPARENT)。`

 ENCRYPTION_PASSWORD　　　　　　用于创建加密列数据的口令关键字。

 ESTIMATE　　　　　　　　　　　　　　计算作业估计值, 其中有效关键字值为: (BLOCKS) 和 STATISTICS。

 ESTIMATE_ONLY　　　　　　　  　　　 在不执行导出的情况下计算作业估计值。

 EXCLUDE　　　　　　　　　　　　 　　排除特定的对象类型, 例如 EXCLUDE=TABLE:EMP。例：EXCLUDE=[object_type]:[name_clause],[object_type]:[name_clause] 。

 FILESIZE　　　　　　　　　　　　  　　以字节为单位指定每个转储文件的大小。

 FLASHBACK_SCN　　　　　　　　 　　用于将会话快照设置回以前状态的 SCN。 -- 指定导出特定SCN时刻的表数据。

 FLASHBACK_TIME　　　　　　　　　　用于获取最接近指定时间的 SCN 的时间。-- 定导出特定时间点的表数据，注意FLASHBACK_SCN和FLASHBACK_TIME不能同时使用。

 FULL　　　　　　　　　　　　　　  　　导出整个数据库 (N)。　　

 HELP　　　　　　　　　　　　　　 　　显示帮助消息 (N)。

 INCLUDE　　　　　　　　　　　　  　　包括特定的对象类型, 例如 INCLUDE=TABLE_DATA。

 JOB_NAME　　　　　　　　　　　  　　要创建的导出作业的名称。

 LOGFILE　　　　　　　　　　　　  　　日志文件名 (export.log)。

 NETWORK_LINK　　　　　　　　  　　链接到源系统的远程数据库的名称。

 NOLOGFILE　　　　　　　　　　　　　不写入日志文件 (N)。

 PARALLEL　　　　　　　　　　　  　　更改当前作业的活动 worker 的数目。

 PARFILE　　　　　　　　　　　　  　　指定参数文件。

 QUERY　　　　　　　　　　　　　 　　用于导出表的子集的谓词子句。--QUERY = [schema.][table_name:] query_clause。

 REMAP_DATA　　　　　　　　　   　　指定数据转换函数,例如 REMAP_DATA=EMP.EMPNO:REMAPPKG.EMPNO。

 REUSE_DUMPFILES　　　　　　　　　覆盖目标转储文件 (如果文件存在) (N)。

 SAMPLE　　　　　　　　　　　　  　　要导出的数据的百分比。

 SCHEMAS　　　　　　　　　　　  　　要导出的方案的列表 (登录方案)。　　

 STATUS　　　　　　　　　　　　  　　在默认值 (0) 将显示可用时的新状态的情况下,要监视的频率 (以秒计) 作业状态。　　

 TABLES　　　　　　　　　　　　  　　标识要导出的表的列表 - 只有一个方案。--[schema_name.]table_name[:partition_name][,…]

 TABLESPACES　　　　　　　　　 　　标识要导出的表空间的列表。

 TRANSPORTABLE　　　　　　　　　  指定是否可以使用可传输方法, 其中有效关键字值为: ALWAYS, (NEVER)。

 TRANSPORT_FULL_CHECK　　 　　　验证所有表的存储段 (N)。 

 TRANSPORT_TABLESPACES　　　　  要从中卸载元数据的表空间的列表。

 VERSION　　　　　　　　　　　　　　要导出的对象的版本, 其中有效关键字为:(COMPATIBLE), LATEST 或任何有效的数据库版本。

------

**（2）命令　　　　　　　　　　　　说明**

------

 ADD_FILE　　　　　　　　　　　　　向转储文件集中添加转储文件。

 CONTINUE_CLIENT　　　　　　　 　返回到记录模式。如果处于空闲状态, 将重新启动作业。

 EXIT_CLIENT　　　　　　　　　　 　退出客户机会话并使作业处于运行状态。

 FILESIZE　　　　　　　　　　　　 　后续 ADD_FILE 命令的默认文件大小 (字节)。

 HELP　　　　　　　　　　　　　　　总结交互命令。

 KILL_JOB　　　　　　　　　　　　　分离和删除作业。

 PARALLEL　　　　　　　　　　　  　 更改当前作业的活动 worker 的数目。PARALLEL=<worker 的数目>。

 _DUMPFILES　　　　　　　　　　 　 覆盖目标转储文件 (如果文件存在) (N)。

 START_JOB　　　　　　　　　　  　启动/恢复当前作业。

 STATUS　　　　　　　　　　　　  　 在默认值 (0) 将显示可用时的新状态的情况下,要监视的频率 (以秒计) 作业状态。STATUS[=interval]。

 STOP_JOB　　　　　　　　　　　 　 顺序关闭执行的作业并退出客户机。STOP_JOB=IMMEDIATE 将立即关闭数据泵作业。

------

 

**五、impdp关键字与命令**

------

**（1）关键字　　　　　　　　　　　　说明 (默认)**

------

ATTACH　　　　　　　　　　　　　　　连接到现有作业, 例如 ATTACH [=作业名]。

CONTENT　　　　　　　　　 　　　　  指定要卸载的数据, 其中有效关键字  值为: (ALL), DATA_ONLY 和 METADATA_ONLY。

DATA_OPTIONS　　　　　　  　　　　  数据层标记,其中唯一有效的值为:SKIP_CONSTRAINT_ERRORS-约束条件错误不严重。

DIRECTORY　　　　　　　　　　　　　供转储文件,日志文件和sql文件使用的目录对象，即逻辑目录。

DUMPFILE　　　　　　　　　　　　　　要从(expdp.dmp)中导入的转储文件的列表,例如 DUMPFILE=expdp1.dmp, expdp2.dmp。

 ENCRYPTION_PASSWORD　　　　　　用于访问加密列数据的口令关键字。此参数对网络导入作业无效。

 ESTIMATE　　　　　　　　　　　　　　计算作业估计值, 其中有效关键字为:(BLOCKS)和STATISTICS。

 EXCLUDE　　　　　　　　　　　　　　排除特定的对象类型, 例如 EXCLUDE=TABLE:EMP。

 FLASHBACK_SCN　　　　　　　　　　用于将会话快照设置回以前状态的 SCN。

 FLASHBACK_TIME　　　　　　　　　　用于获取最接近指定时间的 SCN 的时间。

 FULL　　　　　　　　　　　　　　　　 从源导入全部对象(Y)。

 HELP　　　　　　　　　　　　　　　　 显示帮助消息(N)。

 INCLUDE　　　　　　　　　　　　　　 包括特定的对象类型, 例如 INCLUDE=TABLE_DATA。

 JOB_NAME　　　　　　　　　　　　　 要创建的导入作业的名称。

 LOGFILE　　　　　　　　　　　　　　  日志文件名(import.log)。

 NETWORK_LINK　　　　　　　　　　　链接到源系统的远程数据库的名称。

 NOLOGFILE　　　　　　　　　　　　　不写入日志文件。　　

 PARALLEL　　　　　　　　　　　　　  更改当前作业的活动worker的数目。

 PARFILE　　　　　　　　　　　　　　  指定参数文件。

 PARTITION_OPTIONS　　　　　　　　 指定应如何转换分区,其中有效关键字为:DEPARTITION,MERGE和(NONE)。

 QUERY　　　　　　　　　　　　　　　用于导入表的子集的谓词子句。

 REMAP_DATA　　　　　　　　　　　　指定数据转换函数,例如REMAP_DATA=EMP.EMPNO:REMAPPKG.EMPNO。

 REMAP_DATAFILE　　　　　　　　　　在所有DDL语句中重新定义数据文件引用。

 REMAP_SCHEMA　　　　　　　　　　 将一个方案中的对象加载到另一个方案。

 REMAP_TABLE　　　　　　　　　　　  表名重新映射到另一个表,例如 REMAP_TABLE=EMP.EMPNO:REMAPPKG.EMPNO。

 REMAP_TABLESPACE　　　　　　　　将表空间对象重新映射到另一个表空间。

 REUSE_DATAFILES　　　　　　　　　 如果表空间已存在, 则将其初始化 (N)。

 SCHEMAS　　　　　　　　　　　　　  要导入的方案的列表。

 SKIP_UNUSABLE_INDEXES　　　　　  跳过设置为无用索引状态的索引。

 SQLFILE　　　　　　　　　　　　　　  将所有的 SQL DDL 写入指定的文件。

 STATUS　　　　　　　　　　　　　　  在默认值(0)将显示可用时的新状态的情况下,要监视的频率(以秒计)作业状态。　　

 STREAMS_CONFIGURATION　　　　  启用流元数据的加载。

 TABLE_EXISTS_ACTION　　　　　　　导入对象已存在时执行的操作。有效关键字:(SKIP),APPEND,REPLACE和TRUNCATE。

 TABLES　　　　　　　　　　　　　　  标识要导入的表的列表。

 TABLESPACES　　　　　　　　　　　 标识要导入的表空间的列表。　

 TRANSFORM　　　　　　　　　　　　要应用于适用对象的元数据转换。有效转换关键字为:SEGMENT_ATTRIBUTES,STORAGE,OID和PCTSPACE。

 TRANSPORTABLE　　　　　　　　　  用于选择可传输数据移动的选项。有效关键字为: ALWAYS 和 (NEVER)。仅在 NETWORK_LINK 模式导入操作中有效。

 TRANSPORT_DATAFILES　　　　　　 按可传输模式导入的数据文件的列表。

 TRANSPORT_FULL_CHECK　　　　　验证所有表的存储段 (N)。

 TRANSPORT_TABLESPACES　　　　 要从中加载元数据的表空间的列表。仅在 NETWORK_LINK 模式导入操作中有效。

  VERSION　　　　　　　　　　　　　  要导出的对象的版本, 其中有效关键字为:(COMPATIBLE), LATEST 或任何有效的数据库版本。仅对 NETWORK_LINK 和 SQLFILE 有效。

------

**（2）命令　　　　　　　　　　　　说明**

------

 CONTINUE_CLIENT　　　　　　　　　返回到记录模式。如果处于空闲状态, 将重新启动作业。

 EXIT_CLIENT　　　　　　　　　　　　退出客户机会话并使作业处于运行状态。

 HELP　　　　　　　　　　　　　　　  总结交互命令。

 KILL_JOB　　　　　　　　　　　　　  分离和删除作业。

 PARALLEL　　　　　　　　　　　　　 更改当前作业的活动 worker 的数目。PARALLEL=<worker 的数目>。

 START_JOB　　　　　　　　　　　　  启动/恢复当前作业。START_JOB=SKIP_CURRENT 在开始作业之前将跳过作业停止时执行的任意操作。

 STATUS　　　　　　　　　　　　　　 在默认值 (0) 将显示可用时的新状态的情况下,要监视的频率 (以秒计) 作业状态。STATUS[=interval]。

 STOP_JOB　　　　　　　　　　　　　顺序关闭执行的作业并退出客户机。STOP_JOB=IMMEDIATE 将立即关闭数据泵作业。 