-- 建库
create database huojianban2_boke charset utf8mb4;
use huojianban2_boke;

-- 建表
-- 用户表
create table users (
    id int primary key auto_increment comment "自增 id",
    username varchar(200) not null unique comment "唯一的用户名",
    nickname varchar(200) not null comment "显示名称",
    password varchar(200) not null comment "登录密码"
);

-- 文章表
create table articles (
    id int primary key auto_increment comment "自增 id",
    author_id int not null comment "作者 id",
    title varchar(200) not null comment "文章标题",
    published_at datetime not null comment "文章发表时间",
    content text not null comment "文章正文"
);

-- 评论表
create table comments (
    id int primary key auto_increment comment "自增 id",
    user_id int not null comment "评论者 id",
    article_id int not null comment "文章 id",
    published_at datetime not null comment "评论时间",
    content varchar(200) not null comment "评论正文"
);

-- 点赞关系表
create table like_relations (
    user_id int not null comment "评论者 id",
    article_id int not null comment "文章 id",
    primary key (user_id, article_id)
);