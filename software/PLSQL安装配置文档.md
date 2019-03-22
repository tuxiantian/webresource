---
typora-root-url: ..
---

# 安装

安装plsqldev1302x64.msi

注册

PLSQL Developer 13.0.0.1883 注册码
product code： 4vkjwhfeh3ufnqnmpr9brvcuyujrx3n3le 
serial Number：226959 
password: xs374ca

系统变量

ORACLE_HOME=D:\Oracle\instantclient_11_2 
TNS_ADMIN=%ORACLE_HOME%\network\admin 
NLS_LANG=SIMPLIFIED CHINESE_CHINA.ZHS16GBK 

配置plsql

![89C79CEF-1F18-44df-BA83-824B0AA34C7B](/images/software/PLSQL安装文档/89C79CEF-1F18-44df-BA83-824B0AA34C7B.jpg)

配置tnsnames.ora

![TIM截图20190308113837](/images/software/PLSQL安装文档/TIM截图20190308113837.png)
```
yun_od =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 47.98.34.225)(PORT = 8903))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = xe)
    )
  )
```

登陆plsql

# 配置

![62D39307-E35A-47d0-A188-198D5144A46A](/images/software/PLSQL安装文档/62D39307-E35A-47d0-A188-198D5144A46A.jpg)

![7108EC0C-5A8D-4c86-811E-F9F89F5093BB](/images/software/PLSQL安装文档/7108EC0C-5A8D-4c86-811E-F9F89F5093BB.jpg)

![AB24F2F4-2C37-4249-88D0-4AA225E75DF2](/images/software/PLSQL安装文档/AB24F2F4-2C37-4249-88D0-4AA225E75DF2.jpg)

![AF77ECA7-CCB8-4466-BFF4-93ECE661BC46](/images/software/PLSQL安装文档/AF77ECA7-CCB8-4466-BFF4-93ECE661BC46.jpg)

![DD70BFA7-132D-4382-85E1-F2C6B62DDB4A](/images/software/PLSQL安装文档/DD70BFA7-132D-4382-85E1-F2C6B62DDB4A.jpg)

代码助手

```
sf=select * from
sfr=select a.*, rowid from

```

![TIM截图20190322113656](/images/software/PLSQL安装文档/TIM截图20190322113656.png)

