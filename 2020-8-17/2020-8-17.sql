create table course (
	
);

create table record(
	id int primary key auto_increment,
	socre decimal(4,1), -- 150 分以下，1位小数（总长度，小数长度） 
	stu_id int,
	course_id int,
	foreign key (stu_id) references stu(id),
	foreign key (course_id) references course(id)
	
);

create table person(
	person_id int,
	firstName varchar,
	lastName varchar
);

create table address(
	address_id int,
	person_id int,
	city varchar,
	state varchar
);

select 
	p.firstName,
	p.lastName,
	ad.city,
	ad,state
from person p 
left join address ad on p.person_id = ad.person_id;


create table Employee(
	id int primary key auto_increment,
	Salary int
);

insert into Employee(id, Salary) values 
	(1,100),
	(2,200),
	(3,300);	

select ifnull (
    (select distinct Salary
    from Employee
    order by Salary desc
    limit 1,1),
    null
)as "SecondHighestSalary";















