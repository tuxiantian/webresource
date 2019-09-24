select a.tablespace_name "表空间名称",
       100 - round((nvl(b.bytes_free, 0) / a.bytes_alloc) * 100, 2) "占用率(%)",
       round(a.bytes_alloc / 1024 / 1024/1024, 2) "容量(G)",
       round((a.bytes_alloc - nvl(b.bytes_free, 0)) / 1024 / 1024/1024, 2) "使用(G)",
       round(nvl(b.bytes_free, 0) / 1024 / 1024/1024, 2) "空闲(G)",
       round((nvl(b.bytes_free, 0) / a.bytes_alloc) * 100, 2) "空闲率(%)",
       to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss') "采样时间"
  from (select f.tablespace_name,
               sum(f.bytes) bytes_alloc,
               sum(decode(f.autoextensible, 'YES', f.maxbytes, 'NO', f.bytes)) maxbytes
          from dba_data_files f
         group by tablespace_name) a,
       (select f.tablespace_name, sum(f.bytes) bytes_free
          from dba_free_space f
         group by tablespace_name) b
 where a.tablespace_name = b.tablespace_name;
 