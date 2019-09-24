select a.tablespace_name "��ռ�����",
       100 - round((nvl(b.bytes_free, 0) / a.bytes_alloc) * 100, 2) "ռ����(%)",
       round(a.bytes_alloc / 1024 / 1024/1024, 2) "����(G)",
       round((a.bytes_alloc - nvl(b.bytes_free, 0)) / 1024 / 1024/1024, 2) "ʹ��(G)",
       round(nvl(b.bytes_free, 0) / 1024 / 1024/1024, 2) "����(G)",
       round((nvl(b.bytes_free, 0) / a.bytes_alloc) * 100, 2) "������(%)",
       to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss') "����ʱ��"
  from (select f.tablespace_name,
               sum(f.bytes) bytes_alloc,
               sum(decode(f.autoextensible, 'YES', f.maxbytes, 'NO', f.bytes)) maxbytes
          from dba_data_files f
         group by tablespace_name) a,
       (select f.tablespace_name, sum(f.bytes) bytes_free
          from dba_free_space f
         group by tablespace_name) b
 where a.tablespace_name = b.tablespace_name;
 