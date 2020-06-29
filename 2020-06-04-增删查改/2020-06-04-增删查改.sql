-- 使用上约束的学生表
create table student_0604 (
  id int primary key auto_increment comment '选择自增的数列作为主键',
  sn int unique comment '学号，可以不填，也就是 null，但填了就不能重复',
  name varchar(100) not null comment '不允许为 null',
  sex char(1) not null default '女' comment '性别'
);

-- 有约束情况下，进行插入
-- 观察 id 的自增和 性别的默认值
insert into student_0604 (sn, name) values ('1001', '孙悟空'), ('1002', '猪八戒');
-- 观察 id 的自增和 指定了性别的值
insert into student_0604 (sn, name, sex) values ('1003', '曹孟德', '男');
-- 观察 如果 unique 出现重复的情况，sn 出现重复了，会插入失败
insert into student_0604 (sn, name, sex) values ('1003', '孙仲谋', '男');
-- 观察，name 不允许为 null，同时没有默认值，如果插入时，没有指定 name 会插入失败
insert into student_0604 (sn) values (1004);
-- 观察，插入主键的情况
insert into student_0604 (id, sn, name) values (64, 1604, '老陈');
-- 再进一步观察，之后的主键是怎么自增的，直接在 64 后自增
insert into student_0604 (sn, name) values (1988, '张三');
-- 插入的时候，如果类型不对，会如何？给一定不能转换成数字的字符串作为 sn
insert into student_0604 (sn, name) values ('我肯定会失败', '里斯');
-- 插入的时候，如果主键重复了，会如何？插入失败
insert into student_0604 (id, sn, name) values (64, 1999, '老张');


-- 评论系统如何建表
-- 用户-实体
create table users (
  id int primary key auto_increment comment '自增用户 id',
  username varchar(200) not null unique comment '登录用的用户名',
  nickname varchar(200) not null comment '昵称，用户的显示名称',
  password varchar(200) not null comment '用户登录用的密码'
);

-- 文章-实体
create table articles (
  id int primary key auto_increment comment '自增用户 id',
  author_id int not null comment '作者 id',
  title varchar(200) not null comment '标题',
  published_at datetime not null comment '发表时间',
  content text not null '文章正文'
);

-- 评论-实体
create table comments (
  id int primary key auto_increment comment '自增用户 id',
  user_id int not null comment '评论者的用户 id',
  article_id int not null comment '评论哪篇文章的 id',
  published_at datetime not null comment '评论时间',
  content varchar(200) not null '评论内容'
);

-- 关系-点赞关系
create table user_like_article_relation (
  id int primary key auto_increment comment '自增用户 id',
  user_id int not null comment '点赞用户 id',
  article_id int not null comment '点赞哪篇文章的 id',
);

-- 动作-某个用户发表文章
insert into articles (author_id, title, published_at, content) values (?, ?, ?, ?);
-- 动作-用户注册
insert into users (username, nickname, password) values (?, ?, ?);
-- 动作-用户登录 - select 出 1 行，表示登录，否则用户名密码有错误；而且只会找到一个，因为 username 是 unique 的
select id, username, nickname from users where username = ? and password = ?;
-- 动作-用户评论某篇文章
insert into comments (user_id, article_id, published_at, content) values (?, ?, ?, ?);
-- 动作-用户点赞
insert into user_like_article_relation (user_id, article_id) values (?, ?);
-- 动作-用户取消点赞
delete from user_like_article_relation where user_id = ? and article_id = ?;
-- 动作-查看所有文章的标题列表，最新发表的文章在最前面
select title from articles order by published_at desc;
