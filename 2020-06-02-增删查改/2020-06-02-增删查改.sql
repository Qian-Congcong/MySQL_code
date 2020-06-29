-- DDL数据定义语言，用来维护存储数据的结构
	-- 代表指令: create, drop, alter
-- DML数据操纵语言，用来对数据进行操作
	-- 代表指令： insert，delete，update
	-- DML中又单独分了一个DQL，数据查询语言，代表指令： select
-- DCL数据控制语言，主要负责权限管理和事务
	-- 代表指令： grant，revoke，commit

	
-- 修改密码 
-- 用SET PASSWORD命令   

首先登录MySQL。  
-- 打开数据库
net start mysql

格式：mysql> set password for 用户名@localhost = password('新密码');  

例子：mysql> set password for root@localhost = password('123');  


-- 数据库的操作：创建数据库、删除数据库
-- 数据库路径
where mysql

-- 打开MySQL
mysql -uroot -p
mysql -h127.0.0.1 -P3306 -uroot -p mysql
-- ; \G 结尾


-- 对数据库的操作
-- 创建库
-- 名称 （英语 + 下划线 + 数字都可以，数字别开头）。
create database name charset utf8mb4;
-- 如果系统没有 name 的数据库，则创建一个名叫 name 的数据库，如果有则不创建
create database if not exists name;
-- 如果系统没有 name 的数据库，则创建一个使用utf8mb4字符集的 name 数据库，如果有则不创建
create database if not exists name chatacter set utf8mb4;

-- 删除库
drop database name;

-- 显示当前数据库
show databases;

-- 设置默认数据库  ， table 是在默认数据库下进行的
use name;
-- 查看当前的默认数据库
select database();
-- 查看某个数据库建库语句
show create database name;


-- 对表的操作
-- 需要先指定默认数据库 name
use name;

-- 查看表 name 的结构
desc name;

-- 创建表
create table students (
id int,
name varchar(50),
age int,
sex char(1),
brief varchar(200)
);
-- comment 增加字段说明
create table stu_test (
   id int,
   name varchar(20) comment '姓名',
   password varchar(50) comment '密码',
   age int,
   sex varchar(1),
   birthday timestamp,
   amout decimal(13,2),
   resume text
);

-- 删除表
drop table name;
-- 如果存在 name 表，则删除 name 表 
drop table if exists name;

-- 查看当前表
show tables;
-- 查看吗，默认数据库中建表语句
show create table name;



-- 核心 - 数据的操作 - DML
-- 增		删(删表删库做好区分)		查			改
-- CRUD （Create / Retrieve / Update / Delete）


-- 新增数据 Create
create table student_0604 (
id int,
sn int comment "学号",
name varchar(20) comment "名字",
qq_mail varchar(20) comment "QQ邮箱"
);

-- 插入数据 
insert into student values (100, 10000, "唐三藏", null);
insert into student values (101, 10001, "孙悟空", "sunwukong@qq.com");

insert into student (id, sn, name) values (102, 20001, "曹孟德"), (103, 20002, "孙仲谋");


-- 查询数据 Retrieve
drop table if exists exam_result;
create table exam_result (
id int,
name varchar(200),
chinese double,
math double,
english double
);

insert into exam_result values
(1,'唐三藏',67,98,56),
(2,'孙悟空',87.5,78,77),
(3,'猪悟能',88,98.5,90),
(4,'曹孟德', 82, 84,67),
(5,'刘玄德', 55.5,85,45),
(6,'孙权', 70,73,78.5),
(7,'宋公明', 75,65,30);

-- 开头，代表 sql 中注释
-- 查询 exam_result 所有数据行的所有列
select * from exam_result;

-- 查询 所有行，但只需要给出 name 列
select name from exam_result;
select id, name from exam_result;
-- 表达式不包含字段
select id, name, 10 from exam_result;
-- 表达式包含一个字段
select id, name, english + 10 from exam_result;
-- 表达式包含多个字段
select name, chinese + math + english from exam_result;
-- 结果集中，表头的列名=别名
select name, chinese + math + english as total from exam_result;
select name, chinese + math + english total from exam_result;
-- 去重 distinct
select distinct math from exam_result;  

-- 条件查询 where
select english > 60 from exam_result;

select * from exam_result where english > chinese;

select * from exam_result where english = 77;

select * from exam_result where english != 77; 

select * from exam_result where name = '唐三藏';

select * from exam_result where name != '唐三藏';

select * from exam_result where english > 60;

-- 查询英语成绩在 [67, 100] 左闭右闭，包含 67 和 100
select * from exam_result where english between 67 and 100;

select * from exam_result where english >= 67 and english <= 100;

-- 查询孙悟空、唐三藏的成绩
select * from exam_result where name in ('孙悟空', '唐三藏');

select * from exam_result where name = '孙悟空' or name = '唐三藏';

-- 查询除了孙悟空、唐三藏的成绩
select * from exam_result where name not in ('孙悟空', '唐三藏');

select * from exam_result where not (name = '孙悟空' or name = '唐三藏');

select * from exam_result where name != '孙悟空' and name != '唐三藏';

-- 查询已经登记过 qq 邮箱的同学
select * from student where qq_mail != null;           -- 错误
select * from student where null;                      -- 错误

select * from student where qq_mail is not null;       -- 正确

-- 查询没有登记过 qq 邮箱的同学
select * from student where qq_mail = null;            -- 错误
select * from student where null;                      -- 错误

select * from student where qq_mail is null;           -- 正确  鼓励使用这种方法
select * from student where qq_mail <=> null;          -- 正确  看到认识即可

-- 查询某个同学的成绩，条件是，该同学姓孙
select * from exam_result where name like '孙%';
-- % 代表
--   0个或者多个字符                  数目待定
--   如果出现，可以是任意字符         字符待定

-- 查询某个同学的成绩，条件是，该同学叫“什么孙”
select * from exam_result where name like '%孙';

-- 查询某个同学的成绩，条件是，该同学名字中带“孙”
select * from exam_result where name like '%孙%';

-- _ 匹配严格的一个任意字符

-- 查询某个同学的成绩，条件是，该同学叫“孙某”
select * from exam_result where name like '孙_';

-- 查询某个同学的成绩，条件是，该同学叫“孙某某”
select * from exam_result where name like '孙__';

-- 查询同学的成绩，条件是，同学不叫“孙某某”
select * from exam_result where name not like '孙__';

-- 排序 order by
-- 查询所有人的成绩，按照数学成绩排序，从低到高
select * from exam_result order by math;
select * from exam_result order by math asc;

-- 查询所有人的成绩，按照数学成绩排序，从高到低
select * from exam_result order by math desc;

-- 查询所有人的成绩，按照数学成绩排序，从高到低，如果数学成绩相等，按照语文成绩排序，从低到高
select * from exam_result order by math desc, chinese asc;

-- 查询所有人的成绩，按照数学成绩排序，从高到低，如果数学成绩相等，按照语文成绩排序，从低到高，
-- 如果语文成绩相等，按照id排序，从高到低
select * from exam_result order by math desc, chinese asc,id desc;

-- 分页查询 limit
-- 选出 id 排序，从低到高，前 3 个
select * from exam_result order by id limit 3;

-- 选出 id 排序，从低到高，5,6,7
select * from exam_result order by id limit 3 offset 4;
select * from exam_result order by id limit 4,3;


-- 修改 update
-- 修改学生信息，把 唐三藏的 qq 邮箱修改为 "tangtang@fo.com"
update student set qq_mail = "tangtang@fo" where name = "唐三藏";

-- 如果英语成绩小于 60 分，把英语成绩改为 60 分
-- 如果英语成绩大于等于 60 分，每个人的成绩都加上 5 分
update exam_result set english = english + 5 where english > 60;
update exam_result set english = 60 where english < 60; 
-- 或者
select id from exam_result where english < 60;
update exam_result set english = 60 where id in (上一步找出来的 id);
update exam_result set english = english + 5 where id not in (上一步找出来的 id);

-- 修改学生信息，把孙悟空的姓名改成孙猴子，同时，把学号改成 10101
update student set name = '孙猴子', sn = '10101' where name = '孙悟空';


-- 删除 delete
-- 删除学生表中，id 是 103 的同学
delete from student where id = 103;

-- 把学生表全部删干净
delete from student;



















