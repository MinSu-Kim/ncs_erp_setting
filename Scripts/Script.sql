-- ncs_erp
drop database if exists ncs_erp;
CREATE database ncs_erp;

-- 부서
CREATE TABLE ncs_erp.department (
	dcode INT(11)  NOT NULL AUTO_INCREMENT COMMENT '부서코드', -- 부서코드
	dname CHAR(10) NOT NULL COMMENT '부서명', -- 부서명
	floor INT(11)  NULL     COMMENT '위치', -- 위치
	PRIMARY KEY (dcode)
)
COMMENT '부서';

-- 직책
CREATE TABLE ncs_erp.title (
	tcode CHAR(4)     NOT NULL COMMENT '직책코드', -- 직책코드
	tname VARCHAR(10) NULL     COMMENT '직책명', -- 직책명
	PRIMARY KEY (tcode)
)
COMMENT '직책';

-- 사원
SET FOREIGN_KEY_CHECKS = 0;
drop table ncs_erp.employee;
CREATE TABLE ncs_erp.employee (
	eno      CHAR(6)     NOT NULL COMMENT '사번', -- 사번
	ename    VARCHAR(20) NOT NULL COMMENT '사원명', -- 사원명
	salary   INT(11)     NULL     COMMENT '급여' default 0, -- 급여
	dno      INT(11)     NULL     COMMENT '부서' default 1, -- 부서
	gender   TINYINT(1)  NULL     COMMENT '성별' default 0, -- 성별
	joindate DATE        NULL     COMMENT '입사일' default NULL, -- 입사일
	title    CHAR(4)     NULL     COMMENT '직책' default NULL, -- 직책
	PRIMARY KEY (eno),
	CONSTRAINT fk_employee_department_dno FOREIGN KEY (dno) REFERENCES ncs_erp.department (dcode),
	CONSTRAINT FK_title_TO_employee FOREIGN KEY (title)	REFERENCES ncs_erp.title (tcode)
)
COMMENT '사원';

-- 취미
CREATE TABLE ncs_erp.hobby (
	hcode INTEGER     NOT NULL AUTO_INCREMENT COMMENT '취미코드', -- 취미코드
	hobby VARCHAR(20) NULL     COMMENT '취미명', -- 취미명
	PRIMARY KEY (hcode)
)
COMMENT '취미';

-- 개인취미
CREATE TABLE ncs_erp.person_hobby (
	eno   CHAR(6) NOT NULL COMMENT '사번', -- 사번
	hcode INTEGER NOT NULL COMMENT '취미코드', -- 취미코드
	PRIMARY KEY (eno, hcode),
	CONSTRAINT FK_employee_TO_person_hobby FOREIGN KEY (eno)REFERENCES ncs_erp.employee (eno),
	CONSTRAINT FK_hobby_TO_person_hobby FOREIGN KEY (hcode)REFERENCES ncs_erp.hobby (hcode)
)
COMMENT '개인취미';

grant select, insert, update, delete on ncs_erp.* to 'user_ncs' identified by 'rootroot';

-- 값입력
-- 부서
INSERT INTO ncs_erp.department (dname, floor) values
('마케팅', 10),('개발', 9),('인사', 6),('총무', 7),('경영', 4);

-- 취미
INSERT INTO ncs_erp.hobby(hcode, hobby)values 
(1, '볼링'), (2, '야구'), (3, '당구');

-- 직책
INSERT INTO ncs_erp.title(tcode, tname) values 
('T001', '사장'),('T002', '부장'),('T003', '과장'),('T004', '대리'),('T005', '사원');

-- 사원
SET FOREIGN_KEY_CHECKS = 0;
delete from ncs_erp.employee;

INSERT INTO ncs_erp.employee (eno, ename, salary, dno, gender, joindate, title) values 
('E17001', '나사장', 5000000, 5, 1, '2017-03-01', 'T001'),
('E17002', '나부장', 4000000, 1, 1, '2017-03-01', 'T002'),
('E17003', '너부장', 4000000, 2, 0, '2017-03-01', 'T002'),
('E17004', '나과장', 3500000, 1, 1, '2017-03-01', 'T003'),
('E17005', '너과장', 3500000, 2, 0, '2017-03-01', 'T003'),
('E17006', '나대리', 3000000, 1, 1, '2017-03-01', 'T004'),
('E17007', '너대리', 3000000, 2, 0, '2017-03-01', 'T004'),
('E17008', '나사원', 2500000, 1, 1, '2017-03-01', 'T005'),
('E17009', '그사원', 2000000, 1, 0, '2017-03-01', 'T005'),
('E17010', '너사원', 2500000, 2, 1, '2017-03-01', 'T005'),
('E17011', '이사원', 2000000, 3, 0, '2017-03-01', 'T005');

SET FOREIGN_KEY_CHECKS = 1;

-- 사원별 취미
INSERT INTO ncs_erp.person_hobby (eno, hcode) values 
('E17001', 1),('E17001', 2),
('E17002', 1),('E17002', 2),('E17002', 3),
('E17003', 1),('E17003', 2),
('E17004', 1),('E17004', 2),('E17004', 3),
('E17005', 1),('E17005', 2),
('E17006', 1),
('E17007', 1),('E17007', 2),
('E17008', 1),('E17008', 2),('E17008', 3),
('E17009', 1),
('E17010', 1),('E17010', 2),
('E17011', 1),('E17011', 2),('E17011', 3);


-- ////////////////////// 백업 ////////////////////////

-- export department
select * 
into outfile 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/department.txt' 
character set 'UTF8' 
fields TERMINATED by ',' 
LINES TERMINATED by '\r\n' 
from ncs_erp.department;

-- export employee
INSERT INTO ncs_erp.employee (eno, ename) values 
('E17012', '설동훈');

select * 
into outfile 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/employee.txt' 
character set 'UTF8' 
fields TERMINATED by ',' 
LINES TERMINATED by '\r\n' 
from ncs_erp.employee;


-- export hobby
select * 
into outfile 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/hobby.txt' 
character set 'UTF8' 
fields TERMINATED by ',' 
LINES TERMINATED by '\r\n' 
from ncs_erp.hobby;

-- export person_hobby
select * 
into outfile 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/person_hobby.txt' 
character set 'UTF8' 
fields TERMINATED by ',' 
LINES TERMINATED by '\r\n' 
from ncs_erp.person_hobby;

-- export title
select * 
into outfile 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/title.txt' 
character set 'UTF8' 
fields TERMINATED by ',' 
LINES TERMINATED by '\r\n' 
from ncs_erp.title;



-- import department
call procedure_create();

SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA
local INFILE 'D:/workspace_ncs/ncs_erp_setting/DataFiles/department.txt'
INTO TABLE ncs_erp.department
character set 'UTF8' 
fields TERMINATED by ',';


LOAD DATA
local INFILE 'D:/workspace_ncs/ncs_erp_setting/DataFiles/employee.txt'
INTO TABLE ncs_erp.employee
character set 'UTF8' 
fields TERMINATED by ',';

LOAD DATA
local INFILE 'D:/workspace_ncs/ncs_erp_setting/DataFiles/hobby.txt'
INTO TABLE ncs_erp.hobby
character set 'UTF8' 
fields TERMINATED by ',';

LOAD DATA
local INFILE 'D:/workspace_ncs/ncs_erp_setting/DataFiles/person_hobby.txt'
INTO TABLE ncs_erp.person_hobby
character set 'UTF8' 
fields TERMINATED by ',';

LOAD DATA
local INFILE 'D:/workspace_ncs/ncs_erp_setting/DataFiles/title.txt'
INTO TABLE ncs_erp.title
character set 'UTF8' 
fields TERMINATED by ',';

SET FOREIGN_KEY_CHECKS = 1;


select * from ncs_erp.department;
select * from ncs_erp.employee;
select * from ncs_erp.hobby;
select * from ncs_erp.person_hobby;
select * from ncs_erp.title;


select *
from ncs_erp.employee e join ncs_erp.department d on e.dno = d.dcode 
	join ncs_erp.title t on e.title=t.tcode 
	join ncs_erp.person_hobby ph on e.eno = ph.eno 
	join ncs_erp.hobby h on ph.hcode = h.hcode
order by e.eno;
where e.eno = 'E17001';



-- procedure
drop procedure if exists mysql.procedure_create;

DELIMITER $$
$$
CREATE PROCEDURE mysql.procedure_create()
BEGIN

	drop database if exists ncs_erp;
	CREATE database ncs_erp;
	
	CREATE TABLE ncs_erp.department (
		dcode INT(11)  NOT NULL AUTO_INCREMENT COMMENT '부서코드',
		dname CHAR(10) NOT NULL COMMENT '부서명',
		floor INT(11)  NULL     COMMENT '위치',
		PRIMARY KEY (dcode)
	)
	COMMENT '부서';
	
	CREATE TABLE ncs_erp.title (
		tcode CHAR(4)     NOT NULL COMMENT '직책코드',
		tname VARCHAR(10) NULL     COMMENT '직책명',
		PRIMARY KEY (tcode)
	)
	COMMENT '직책';
	
	CREATE TABLE ncs_erp.employee (
		eno      CHAR(6)     NOT NULL COMMENT '사번',
		ename    VARCHAR(20) NOT NULL COMMENT '사원명',
		salary   INT(11)     NULL     COMMENT '급여',
		dno      INT(11)     NULL     COMMENT '부서',
		gender   TINYINT(1)  NULL     COMMENT '성별',
		joindate DATE        NULL     COMMENT '입사일',
		title    CHAR(4)     NULL     COMMENT '직책',
		PRIMARY KEY (eno),
		CONSTRAINT fk_employee_department_dno FOREIGN KEY (dno) REFERENCES ncs_erp.department (dcode),
		CONSTRAINT FK_title_TO_employee FOREIGN KEY (title)	REFERENCES ncs_erp.title (tcode)
	)
	COMMENT '사원';
	
	CREATE TABLE ncs_erp.hobby (
		hcode INTEGER     NOT NULL AUTO_INCREMENT COMMENT '취미코드',
		hobby VARCHAR(20) NULL     COMMENT '취미명',
		PRIMARY KEY (hcode)
	)
	COMMENT '취미';
	
	CREATE TABLE ncs_erp.person_hobby (
		eno   CHAR(6) NOT NULL COMMENT '사번',
		hcode INTEGER NOT NULL COMMENT '취미코드', 
		PRIMARY KEY (eno, hcode),
		CONSTRAINT FK_employee_TO_person_hobby FOREIGN KEY (eno)REFERENCES ncs_erp.employee (eno),
		CONSTRAINT FK_hobby_TO_person_hobby FOREIGN KEY (hcode)REFERENCES ncs_erp.hobby (hcode)
	)
	COMMENT '개인취미';
	
	grant select, insert, update, delete on ncs_erp.* to 'user_ncs' identified by 'rootroot';
end $$
DELIMITER ;

call procedure_create();


set autocommit= 0;
-- 01. 사원번호가 'E17008' 사원의 소속부서를 3번부서로 옮기고 급여를 5%올리시오.

select * from ncs_erp.employee where eno = 'E17008';
update ncs_erp.employee
set dno=3, salary = salary * 1.05
where eno = 'E17008';
select * from ncs_erp.employee where eno = 'E17008';
rollback;
select * from ncs_erp.employee where eno = 'E17008';

-- 02. 연봉이 4000000원 이상일겨우 '3시 퇴근', 3000000원 이상일 경우 '5시 퇴근' 2000000원 이상일 겨우 '7시 퇴근' 그외 나머지 '야근' 을 사원명, 직책명, 퇴근시간으로 검색하시오.
SELECT ename, t.tname,
CASE
	WHEN salary >= 4000000 THEN '3시 퇴근'
	WHEN salary >= 3000000 THEN '5시 퇴근'
	WHEN salary >= 2000000 THEN '7시 퇴근'
	ELSE '야근'
END as '퇴근시간'
FROM ncs_erp.employee e join ncs_erp.title t on e.title = t.tcode;


-- 03. 사원테이블에서 모든 사원들의 직책이 중복되지 않도록 직책명을 검색하시오.
select distinct t.tname
from ncs_erp.employee e join ncs_erp.title t on e.title = t.tcode;

-- 04. 2번 부서에 근무하는 사원들에 관한 모든 정보를 검색하시오.
select *
from ncs_erp.employee
where dno = 2;


-- 05. '이씨' 성을 가진 사원의 이름, 직책명, 소속 부서번호를 검색하시오.
select ename, t.tname, dno
from ncs_erp.employee e join ncs_erp.title t on e.title = t.tcode
where ename like '이%';

-- 06. 직급이 '과장'이면서 1번부서에 근무하는 사원들의 이름과 급여를 검색하시오.
select ename, salary
from ncs_erp.employee e join ncs_erp.title t on e.title = t.tcode
where t.tname = '과장' and e.dno = 1;

-- 07. 직급이 '과장'이면서 1번부서에 속하지 않은 사원들의 이름과 급여를 검색하시오.
select ename, salary
from ncs_erp.employee e join ncs_erp.title t on e.title = t.tcode
where t.tname = '과장' and e.dno <> 1;

-- 08. 급여가 '3000000원 이상이고 4500000원이하인 사원들의 이름, 직책명, 급여를 검색하시오.
select ename, t.tname, salary
from ncs_erp.employee e join ncs_erp.title t on e.title = t.tcode
where salary between 3000000 and 4500000;

-- 09. 1번 부서나 3번 부서에 소속된 사원들에 관한 모든 정보를 검색하시오.
select *
from ncs_erp.employee
where dno in (1, 3);

-- 10. 직급이 '과장'인 사원들에 대해 이름과  현재 급여, 급여가 10% 인상됐을 때의 값(newSalary)을 검색하시오.
select ename, salary, salary *1.1 as 'newSalary'
from ncs_erp.employee e join ncs_erp.title t on e.title = t.tcode
where t.tname = '과장';

-- 11. 모든 사원들의 평균 급여와 최대 급여를 검색하시오.
select avg(salary) as avgsal, max(salary) as maxsal
from ncs_erp.employee;

-- 12. 모든 사원들에 대하여 사원들이 속한 부서번호별로 그룹화하고, 각 부서마다 부서번호, 평균급여, 최대급여 검색하시오.
select dno, avg(salary) as avgsal, max(salary) as maxsal
from ncs_erp.employee
group by dno;

-- 13. 모든 사원들에 대해 사원들이 속한 부서번호별로 그룹화하고, 평균급여가 2500000원 이상인 부서에 대해서 부서번호, 평균 급여, 최대급여를 검색하시오.
select dno, avg(salary) as avgsal, max(salary) as maxsal
from ncs_erp.employee
group by dno
having avg(salary) >= 2500000;

-- 14. 모든 사원의 이름과 이 사원이 속한 부서이름을 검색하시오.
select e.ename, d.dname
from ncs_erp.employee e join ncs_erp.department d on e.dno = d.dcode;

-- 15. 모든 사원에 대해서 취미가 2개 초과하는 사원을 검색하시오.
select * 
from ncs_erp.employee e 
where 2 < (select count(*) from ncs_erp.person_hobby ph where ph.eno = e.eno group by eno);

-- 16. 모든 사원에 대해서 소속 부서이름, 사원의 이름, 직급, 급여를 검색하라. 부서 이름에 대해서 오름차순, 부서이름이 같을 경우에는 SALARY에 대해서 내림차순으로 정렬하라.
SELECT dname, ename, title, salary
FROM ncs_erp.employee e join ncs_erp.department d on e.dno = d.dcode
ORDER BY dname, salary DESC;

-- 17. 마케팅이나 개발부에 근무하는 사원들의 이름을 검색하시오.
select ename
from ncs_erp.employee
where dno in (
	select dno
	from ncs_erp.department
	where dname='마케팅' or dname='개발'
);

-- 18. 자신이 속한 부서의 사원들의 평균 급여보다 많은 급여를 받는 사원들에 대해서 이름, 부서번호, 급여를 검색하시오.
select ename, dno, salary
from ncs_erp.employee e
where salary > (
	select avg(salary)
	from ncs_erp.employee
	where dno=e.dno
);


-- 19. 3번 부서에 근무하는 사원들의 사원번호, 사원명, 직급으로 이루어진 뷰(v_emp)를 작성하는  SQL문을 작성하시오.
create view v_emp as
select eno,ename, title
from ncs_erp.employee
where dno=3;

select * from v_emp; 


-- 20.'마케팅'에 근무하는 사원명, 직책, 급여로 이루어진 뷰(v_plan)를 작성하는 SQL문을 작성하시오.

create view v_plan as
select ename, title, salary
from  ncs_erp.employee
where dno = (select dno from  ncs_erp.department where dname = '마케팅');

select * from v_plan;


-- 01. 새로운 사원이 입사할 때마다, 사원의 급여가 1500000 미만인 경우에는 급여를 10% 인상하는 트리거를 작성하라. 여기서 이벤트는 새로운 사원 투플이 삽입될 때, 조건은 급여<1500000, 동작은 급여를 10% 인상하는 것이다.
DELIMITER $$
$$
CREATE TRIGGER RAISE_SALARY
before INSERT on ncs_erp.EMPLOYEE
FOR EACH ROW BEGIN
IF(NEW.SALARY < 1500000)
THEN
SET NEW.SALARY = NEW.SALARY * 1.1;
END IF;
end $$
DELIMITER ;

INSERT INTO ncs_erp.EMPLOYEE values ('E17012', '김태희', 1000000, 5, 1, '2017-03-01', 'T005');
SELECT * FROM ncs_erp.EMPLOYEE;


select * from ncs_erp.employee;

SET FOREIGN_KEY_CHECKS = 0;
delete from ncs_erp.employee;

LOAD DATA LOCAL INFILE 'D:/workspace_ncs/ncs_erp_setting/DataFiles/employee.txt' INTO TABLE ncs_erp.employee character set 'UTF8' fields TERMINATED by ',';


select max(eno) 
FROM ncs_erp.employee;

select eno, ename, salary, dno, gender, date_format(joindate, '%Y-%m-%d') as joindate, title from ncs_erp.employee;

select eno, ename, salary, dno, gender, date_format(joindate, '%Y-%m-%d') as joindate, title from ncs_erp.employee;


-- 데이터베이스 존재 확인
SELECT EXISTS (
	SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'ncs_erp'
)AS flag;

-- 데이터베이스내 테이블 확인
SELECT EXISTS (
	SELECT 1
	FROM Information_schema.tables 
	WHERE table_name = 'department' 
	AND table_schema = 'ncs_erp'
)AS flag;

SELECT EXISTS (
	SELECT 1
	FROM Information_schema.tables 
	WHERE table_name = 'employee' 
	AND table_schema = 'ncs_erp'
)AS flag;

SELECT EXISTS (
	SELECT 1
	FROM Information_schema.tables 
	WHERE table_name = 'title' 
	AND table_schema = 'ncs_erp'
)AS flag;


select * from information_schema.TABLES where TABLE_NAME = 'employee'

select 1 from information_schema.SCHEMATA where SCHEMA_NAME = 'ncs_erp';
select 1 from information_schema.TABLES where TABLE_NAME = 'employee' and TABLE_SCHEMA = 'ncs_erp';

select 1 from `user` where user = 'user_ncs';





