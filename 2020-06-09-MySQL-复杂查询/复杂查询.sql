-- 数据库约束
-- NOT NULL - 指示某列不能存储 NULL 值。
-- UNIQUE - 保证某列的每行必须有唯一的值。
-- FOREIGN KEY - 保证一个表中的数据匹配另一个表中的值的参照完整性。
-- CHECK - 保证列中的值符合指定的条件。对于MySQL数据库，对CHECK子句进行分析，但是忽略CHECK子句

create table student_0604 (
	-- PRIMARY KEY - NOT NULL 和 UNIQUE 的结合。确保某列（或两个列多个列的结合）有唯一标识，有助于更容易更快速地找到表中的一个特定的记录。
	-- 对于整数类型的主键，常配搭自增长auto_increment来使用。插入数据对应字段不给值时，使用最大值+1。
	id int primary key auto_increment,
	
	-- DEFAULT - 规定没有给列赋值时的默认值。
	name varchar(20) default 'unkown' comment "姓名",
	sex varchar(1) comment "性别",
	check (sex = '男' or sex = '女'),
	qq_mail varchar(20) comment "QQ邮箱",
	chinese decimal(3,1),
	math decimal(3,1),
	english decimal(3,1)
);



-- 新增
insert into student_0604 (id, name, sex, qq_mail, chinese, math, english) values
(1,'唐三藏','男',NULL, 67, 98, 56),
(2,'孙悟空','男','123', 87.5, 78, 77),
(3,'猪悟能','男','234', 88, 98.5, 90),
(4,'白骨精','女','345', 82, 84, 67),
(5,'黄眉大王','男','456', 55.5, 85, 45),
(6,'如来','男','111111', 70, 73, 78),
(7,'菩萨','女','5678', 75, 65, 37);

-- 将学生表中的所有数据复制到用户表
insert into test_user(name, email) select name, qq_mail from student;



create database hjb2_0609 charset utf8mb4;
use hjb2_0609;

create table persons (
    name varchar(20),
    height double,
    weight double
);

insert into persons (name, height, weight) values 
    ("张三", 172, 80),
    ("李四", 193, 93),
    ("王五", 163, 70),
    ("陈沛鑫", 166, 93),
    ("高博", 213, 121);
	

-- 查询
-- 聚合查询
SUM([DISTINCT] expr) 返回查询到的数据的 总和，不是数字没有意义
AVG([DISTINCT] expr) 返回查询到的数据的 平均值，不是数字没有意义
MAX([DISTINCT] expr) 返回查询到的数据的 最大值，不是数字没有意义
MIN([DISTINCT] expr) 返回查询到的数据的 最小值，不是数字没有意义

-- count 的能力，返回查询到的数据的数量
-- 统计共有多少人
select count(*) from persons;                       -- 5
select count(1) from persons;                       -- 5

select count(distinct 1) from persons;              -- 1
select count(name) from persons;                    -- 5
select count(height) from persons;                  -- 5
select count(weight) from persons;                  -- 5
select count(distinct name) from persons;           -- 5
select count(distinct height) from persons;         -- 5
select count(distinct weight) from persons;         -- 4

-- 多插入一个数据
insert into persons (name, height, weight) values ("段莎莎", null, null);

select count(*) from persons;                       -- 6
select count(1) from persons;                       -- 6
select count(distinct 1) from persons;              -- 1
select count(name) from persons;                    -- 6
select count(height) from persons;                  -- 5    null 不算
select count(weight) from persons;                  -- 5
select count(distinct name) from persons;           -- 6
select count(distinct height) from persons;         -- 5
select count(distinct weight) from persons;         -- 4

-- 如何知道 count 的结果呢？
-- 去掉 count 后得出的结果中
-- 再次去掉所有的 null
-- 剩下多少行，count 的结果就是多少


select max(*) from persons;                  -- 无法使用
select max(name) from persons;               -- 根据字符串大小做比较的
select max(height) from persons;             -- 213
select max(weight) from persons;             -- 121
select max(distinct height) from persons;    -- 213
select max(distinct weight) from persons;    -- 121

-- null 都不计算在内

-- 演示分组聚合
create table class_persons (
    class_name varchar(20),
    name varchar(20),
    height double,
    weight double
);

insert into class_persons (class_name, name, height, weight) values
    ("向日葵班", "林黛玉", 183, 92),
    ("向日葵班", "贾宝玉", 192, 95),
    ("向日葵班", "薛宝钗", 177, 83),

    ("玫瑰班", "唐三藏", 166, 82),
    ("玫瑰班", "孙悟空", 101, 63),
    ("玫瑰班", "猪悟能", 202, 400),

    ("月季班", "曹孟德", 173, 65),
    ("月季班", "刘玄德", 177, 58);

-- 需要分组统计-分组聚合
-- 可以统计每个班各自有多少人 -- count
-- 可以统计每个班，各自的最高身高是多少 -- max
-- 可以统计每个班，各自的平均体重是多少 -- avg

-- group by 后边跟 分组的凭据（相同的值分到一组去聚合）
select class_name, count(*) from class_persons group by class_name; 
select class_name, max(height) from class_persons group by class_name;
select class_name, avg(weight) from class_persons group by class_name;

-- 多次分组
create table jobs (
    company_name varchar(20),
    group_name varchar(20),
    name varchar(20),
    salary double
);

insert into jobs (company_name, group_name, name, salary) values 
    ("腾讯", "A", "孙悟空", 80000),
    ("腾讯", "A", "六耳猕猴", 60000),
    ("腾讯", "A", "大马猴", 30000),

    ("腾讯", "B", "唐僧", 180000),
    ("腾讯", "B", "唐三藏", 180000),
    ("腾讯", "B", "大唐高僧", 30000),

    ("阿里", "A", "张无忌", 300),
    ("阿里", "A", "赵敏", 8000),
    ("阿里", "A", "周芷若", 100),

    ("阿里", "B", "郭靖", 4000),
    ("阿里", "B", "杨康", 5000),
    ("阿里", "B", "黄蓉", 6000),
    ("阿里", "B", "哈利波特", 80000);

select company_name, count(*) from jobs group by company_name;
select group_name, count(*) from jobs group by group_name;
select company_name, group_name, count(*) from jobs group by company_name, group_name;
select company_name, group_name, count(*) from jobs group by group_name, company_name;

-- group by 的 select 后边跟的内容有限制
-- 只能出现两类：
-- 1. 聚合函数
-- 2. group by 后的分组凭证

select salary from jobs group by company_name; -- 分出了腾讯和阿里两个组，那 salary 应该放什么合适呢？salary 放谁的都不合适

-- having 是在 group 之后，再次对结果做筛选时使用
select company_name, group_name, sum(salary) from jobs group by group_name, company_name having sum(salary) > 10000;


-- 联表查询
-- 没有条件的联表，结果是一个笛卡尔积
-- 有效数据，需要通过一些条件过滤
-- 例如这里的 文章表的作者 id = 用户表的.id
select 
    articles.id as aid, 
    title, 
    users.id as uid, 
    nickname 
from articles, users 
where articles.author_id = users.id;

-- 使用联表查询，完成以下功能
-- 指定文章 id，查询出文章的信息（不包括点赞和评论），需要包含作者的昵称
select
    a.id,
    a.title,
    u.nickname,
    a.content,
    a.published_at
from
    articles as a, users as u
where
    a.author_id = u.id
    and
    a.id = 2;
	
-- 指定文章 id，查询出评论列表，需要包含评论者的昵称
select
    c.id,
    c.content,
    c.published_at,
    u.nickname
from
    comments as c, users as u
where
    c.user_id = u.id
    and
    c.article_id = 3
order by c.published_at desc;

-- 联表查询练习
create table school_classes (
    id int,
    name varchar(200)
);

create table school_students (
    id int,
    class_id int,
    name varchar(200)
);

-- 以三国、水浒为例，构造测试数据
-- 尝试完成 内联、外联（左联和右联）的查询	
	
	
	