select a.sid,
       a.serial#,
       a.username 用户名称,
       a.machine 客户端机器,
       a.program 客户端工具,
       a.status 用户会话状态,
       a.logon_time 用户登入时间,
       (select round(d.sofar * 100 / d.totalwork) || '%'
          from v$session_longops d
         where d.sid = a.sid
           and time_remaining <> 0
           and d.serial# = a.serial#
           and rownum <= 1) SQL进度,
       trunc(a.last_call_et / 60 / 60) || '时' ||
       trunc(mod(a.last_call_et, 60 * 60) / 60) || '分' ||
       mod(a.last_call_et, 60) || '秒' SQL已执行时间,
       c.parsing_schema_name SQL用户,
       c.sql_text 简要SQL,
       c.sql_fulltext 完整SQL,
       
       (select round(d.value / 1024 / 1024) || 'MB'
          from v$sesstat d
         where d.sid = a.sid
           and d.statistic# = 25) 占用PGA内存,
       (select round(d.value / 100 / 60, 2) || '分'
          from v$sesstat d
         where d.sid = a.sid
           and d.statistic# = 12) 占用CPU,
       'alter system kill session ''' || a.sid || ',' || a.serial# || ''';' KILL会话
  from v$session a, v$process b, v$sqlarea c
 where a.paddr = b.addr
   and a.sql_hash_value = c.hash_value
   and a.status = 'ACTIVE'
   and a.username is not null
 order by a.last_call_et desc
