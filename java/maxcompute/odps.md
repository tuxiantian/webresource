ODPS sql文档: http://help.aliyun-inc.com/internaldoc/detail/27860.html?spm=a2c1f.8259796.3.39.a26c96d5VDYzg5

将数据导入odps表

odpscmd -e "tunnel u -fd '\t' seller.txt icbu_translate.seller1117"

将数据导出odps表

odpscmd -e "tunnel d -fd '\t' icbu_translate.temp_data_1210 ./temp_data_1210.dat"



将查询结果写入odps表中

create table xxx as $sql;



use icbu_translate_dev;

1进去之后执行odpscmd_pub命令，就可以交互式执行sql任务

2.或者把sql放在一个xx.sql文件中，然后执行"odpscmd_pub -f xx.sql"也可以执行。



https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

odpscmd

列重命名

alter table xx change column member_id rename to ali_member_id;

新建分区：alter table translate.cgs_products_action2 add partition(ds=20200919);