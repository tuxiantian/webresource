1. oracle游标动态赋值的小例子

```plsql
-- 实现1：动态给游标赋值
-- 实现2：游标用表的rowtype声明，但数据却只配置表一行的某些字段时，遍历游标时需fetch into到精确字段
CREATE OR REPLACE PROCEDURE proc_cursor1(
-- 参数区域
)
is
--变量区域
    -- 定义一个游标集类型
    type cur_type is ref cursor;
    -- 定义一个游标
    cur_student cur_type;
    -- 遍历游标时使用,此处类型匹配了student的一行数据
    stu_id student%rowtype;
    -- sql脚本
    v_sql varchar2(2000) :='';
begin
--执行区域
    v_sql := 'select id from student'; -- 查询的时候，并没有查询student一行的所有数据
    open cur_student for v_sql; --此处动态给游标赋值
    loop 
      fetch cur_student into stu_id.id; -- 游标的一行数据，只匹配student的某个字段时，要fetch into到精确字段
      exit when cur_student%notfound;
      update student t set t.age = (t.age+1) where t.id = stu_id.id;
    end loop;
end proc_cursor1;
```

2. oracle游标最常用的使用方法

   ```plsql
   -- oracle游标最常用的使用方法
   CREATE OR REPLACE PROCEDURE proc_cursor2(
   -- 参数区域
   )
   is
   --变量区域
       -- 声明游标并赋值
       Cursor cur_stu is select id from student;
   begin
   --执行区域
       for this_val in cur_stu LOOP
           begin
               update student t set t.age = (t.age+1) where t.id = this_val.id;
           end;
       end LOOP;
   end proc_cursor2;
   ```

   3. 带有参数的游标

      在定义了参数游标之后，当使用不同参数值多次打开游标时，可以生成不同的结果集。定义参数游标的语法如下：

      CURSOR cursor_name(parameter_name datetype) IS select_statement;

      注意，当定义参数游标时，游标参数只能指定数据类型，而不能指定长度。当定义参数游标时，一定要在游标子查询的where子句中引用该参数，否则就失去了定义参数游标的意义。

      ```
      declare
      cursor emp_cursor(no number) is
      select ename from emp where deptno=no;
      v_ename emp.ename%type;
      begin
          open emp_cursor(10);
          loop
              fetch emp_cursor into v_ename;
              exit when emp_cursor%notfound;
              dbms_output.put_line('雇员名: '||v_ename);
          end loop;
      end; 
      ```