### sed命令
截取一段时间的日志
```shell
sed -n '/2014-06-04 14:00:/,/2014-06-04 15:00:/p' catalina.out > ~/catalina.out.20140604-14 
```
只查看文件的第5行到第10行  
```shell
sed –n '5,10p' /etc/passwd 
```
显示第一行
```shell
sed -n '1p' filename 
```
删除文件中的空行  
```shell
sed '/^$/d' file  
```
替换内容
1. 替换并输出（不修改源文件）： 
```shell
sed  's/dog/cat/g' file 
```
dog被替换的内容，cat替换的内容 

2. 备份后直接替换至源文件：  
```shell
sed -i.bak 's/dog/cat/g' file 
```
进程处理文件中的记录调用省端接口，常有超时的任务，要统计日志文件中超时任务的数量  
```shell
sed -n '起始行号,结束行号p'| grep 'java.util.concurrent.TimeOutException'|wc -l  
```