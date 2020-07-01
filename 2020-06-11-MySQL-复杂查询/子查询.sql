-- 建测试库和表
create database hjb2_200611 charset utf8mb4;
use hjb2_200611;

create table students (
  id int primary key auto_increment,
  name varchar(20),
  height int,
  weight int
);

insert into students (name, height, weight) values
  ('张三', 177, 63),
  ('李四', 169, 73),
  ('王五', 183, 53),
  ('赵六', 202, 103);
  
create table employee (
  id int primary key auto_increment,
  depart_id int,
  name varchar(20),
  salary int
);

insert into employee (depart_id, name, salary) values
  (1, '孙悟空', 7000),
  (1, '观世音', 9000),
  (1, '如来佛', 12000),
  (1, '唐三藏', 8000),
  
  (2, '贾宝玉', 6000),
  (2, '林黛玉', 4000),
  
  (3, '郭靖', 17000),
  (3, '黄蓉', 9000),
  (3, '杨过', 13000);
  
-- 所有子查询必须用小括号包裹起来
select * from (select name, height from students) t where t.name = '张三';

-- 查询部门人数 < 3 人的部门
select depart_id, count(*) from employee group by depart_id having count(*) < 3;

select 
  depart_id, cnt 
from (select depart_id, count(*) cnt from employee group by depart_id) t
  where t.cnt < 3;
  
-- 找到比孙悟空工资高的人
-- 不用子查询
-- 1. 找到孙悟空的工资
select salary from employee where name = '孙悟空';
-- 2. 找到表中工资 > 上面结果的所有人
select name, salary from employee where salary > ?;

-- 用子查询
select name, salary from employee where salary > (
  select salary from employee where name = '孙悟空'
);

-- 找到部门 3 的人的工资
select salary from employee where depart_id = 3;  -- 结果只有一列，但有多行
-- 找到所有人中，工资和部门 3 相同，但不是部门 3 的人的工资
select * from employee where salary in (17000, 9000, 13000);

select * from employee where salary in (
  select salary from employee where depart_id = 3
) and depart_id != 3;

-- 配合 max 使用

select * from employee where salary > 9000 and depart_id != 3;
select * from employee where salary > any(17000, 9000, 13000);
-- 视为
-- select * from employee where salary > min(17000, 9000, 13000);
select * from employee where salary > any(
  select salary from employee where depart_id = 3
) and depart_id != 3;


select * from employee where salary > all(7000, 9000, 12000, 8000) and depart_id != 1;
-- 视为
-- select * from employee where salary > max(7000, 9000, 12000, 8000) and depart_id != 1
select * from employee where salary > all(
  select salary from employee where depart_id = 1
) and depart_id != 1;



