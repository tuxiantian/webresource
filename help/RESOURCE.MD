### 查看端口被哪个进程占用并结束该进程
```
netstat -aon|findstr "8888"
tasklist|findstr "5536"
taskkill /f /t /im javaw.exe
```