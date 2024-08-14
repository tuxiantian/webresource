select a.sid,
       a.serial#,
       a.username �û�����,
       a.machine �ͻ��˻���,
       a.program �ͻ��˹���,
       a.status �û��Ự״̬,
       a.logon_time �û�����ʱ��,
       (select round(d.sofar * 100 / d.totalwork) || '%'
          from v$session_longops d
         where d.sid = a.sid
           and time_remaining <> 0
           and d.serial# = a.serial#
           and rownum <= 1) SQL����,
       trunc(a.last_call_et / 60 / 60) || 'ʱ' ||
       trunc(mod(a.last_call_et, 60 * 60) / 60) || '��' ||
       mod(a.last_call_et, 60) || '��' SQL��ִ��ʱ��,
       c.parsing_schema_name SQL�û�,
       c.sql_text ��ҪSQL,
       c.sql_fulltext ����SQL,
       
       (select round(d.value / 1024 / 1024) || 'MB'
          from v$sesstat d
         where d.sid = a.sid
           and d.statistic# = 25) ռ��PGA�ڴ�,
       (select round(d.value / 100 / 60, 2) || '��'
          from v$sesstat d
         where d.sid = a.sid
           and d.statistic# = 12) ռ��CPU,
       'alter system kill session ''' || a.sid || ',' || a.serial# || ''';' KILL�Ự
  from v$session a, v$process b, v$sqlarea c
 where a.paddr = b.addr
   and a.sql_hash_value = c.hash_value
   and a.status = 'ACTIVE'
   and a.username is not null
 order by a.last_call_et desc
