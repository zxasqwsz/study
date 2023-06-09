-- JOIN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

--일단 조회
SELECT Employee_id,  first_name,department_id
from employees;

--department_id의 이름이 알고싶어...
select department_id,department_name
from departments;

--한꺼번에 볼수는 없나? department_id기준으로 조인이 가능할까?
SELECT employee_id, first_name, 
employees.department_id,
departments.department_name
from employees, departments
where employees.department_id = departments.department_id; --오라클식 조인
--NULL이 있는곳(employees.department_id가 NULL인놈)은 배제되서 106명이 나온다.

SELECT employee_id, first_name, 
employees.department_id,
departments.department_name
from employees join departments
on employees.department_id = departments.department_id; --ANSI식 조인

--2) 사원테이블과 부서테이블을 조인해서 사원ID가 100인 사람의 사원ID와 근무
--지ID를 출력해라.
SELECT employee_id, first_name, 
departments.location_id
from employees, departments
where employees.department_id = departments.department_id
AND employees.employee_id=100 ; --오라클식 조인
SELECT employee_id, first_name, 
departments.location_id
from employees JOIN departments
on employees.department_id = departments.department_id
AND employee_id=100 ; --ANSI식 조인

--테이블에 별칭 부여
SELECT employee_id, first_name, 
e.department_id,
d.department_name
from employees e, departments d --AS를 붙이면 오류
where e.department_id = d.department_id; --오라클식 조인
SELECT employee_id, first_name, 
e.department_id,
d.department_name
from employees e join departments d --AS를 붙이면 오류
on e.department_id = d.department_id; --ANSI 조인

--3 테이블끼리의 조인 
--일단 emps+jobs를 조인
Select e.employee_id as 사원번호, j.job_title as 업무제목
from employees e , jobs j
where e.job_id=j.job_id; --오라클식
Select e.employee_id as 사원번호, j.job_title as 업무제목
from employees e join jobs j
on (e.job_id=j.job_id); --ANSI 식

--(emps join dept) join job 오라클에선 조인순서를 잘 지켜야한다 
Select e.employee_id as 사원번호,
    d.department_name as 근무부서, 
    j.job_title as 업무제목
from employees e , departments d, jobs j
where e.department_id=d.department_id 
    and e.job_id=j.job_id; --오라클식
    
Select e.employee_id as 사원번호,
    d.department_name as 근무부서, 
    j.job_title as 업무제목
from employees e 
    join departments d on (e.department_id=d.department_id)
    join jobs j on (e.job_id=j.job_id); --ANSI 식

--사원테이블과 부서테이블,업무테이블을 조인해서 사원ID가 100인 사람의 사원ID
--와 근무지ID,업무제목를 출력해라.
SELECT e.employee_id 사원ID, d.location_id 근무지ID, j.job_title 업무제목
FROM employees e, departments d, jobs j
WHERE e.department_id = d.department_id
    AND j.job_id = e.job_id
    AND e.employee_id=100; --오라클식
    
SELECT e.employee_id 사원ID, d.location_id 근무지ID, j.job_title 업무제목
FROM employees e 
join departments d
on e.department_id = d.department_id
join jobs j
on j.job_id = e.job_id
WHERE employee_id=100; --ANSI식


--(depts join loc) join country
select d.department_id,d.department_name,l.city, l.country_id, c.country_name
from departments d join locations l
on (d.location_id=l.location_id)
join countries c
on (l.country_id=c.country_id);

--Q1) employees 와 departments 테이블을 조인하여 사원이름이 ‘Steven’인
--사원의 이름과 성, 부서명을 출력하되 부서명이 Executive일때는 행정
--부, Shipping일때는 발송부라고 출력하라.
Select e.first_name AS 이름 ,e.last_name AS 성,
CASE
    WHEN d.department_name ='Executive' THEN '행정부'
    WHEN d.department_name ='Shipping' THEN '발송부'
    ELSE '미정'
END AS 부서명,
CASE d.department_name
    WHEN 'Executive' THEN '행정부'
    WHEN 'Shipping' THEN '발송부'
    ELSE '미정'
END AS 부서명
FROM employees e join departments d
on e.department_id = d.department_id
WHERE e.first_name='Steven';


--Q2) employees 와 departments 테이블을 조인하여 급여가 12000이상인
--사원의 부서ID,부서명,이름,급여를 출력하라.(급여의 내림차순으로 정렬)
SELECT e.department_id as 부서ID, 
    d.department_name as 부서명,
    e.first_name as 이름,
    e.salary as 급여
FROM employees e JOIN departments d
ON e.department_id=d.department_id
WHERE e.salary >= 12000
ORDER BY e.salary DESC;


----------------------------
--NON EQUI Join
select e.employee_id,e.salary,s.min_sal,s.max_sal,s.grade
from employees e 
join sal_grade s 
    ON e.salary between s.min_sal and s.max_sal
where department_id=30;


-- SELF JOIN
--employees 테이블에서 자신의 매니저의 이름을 검색하세요.
Select e1.employee_id,e1.first_name as 사원, e2.first_name as 매니저
FROM employees e1, employees e2
WHERE e1.manager_id = e2.employee_id
order by e1.employee_id;


--left outer join
--한쪽 테이블에는 해당데이터가 존재하는데 다른쪽 테이블엔 존재하지
--않을경우 모든 데이터를 출력하게 하는 조인
select e1.employee_id,e1.first_name,e2.first_name
from employees e1, employees e2
WHERE e1.manager_id = e2.employee_id (+)
order by e1.employee_id; --오라클식

select e1.employee_id,e1.first_name,e2.first_name
from employees e1 left join employees e2
on e1.manager_id = e2.employee_id
order by e1.employee_id; --ANSI식

--right outer join
-- 오른쪽에있는 모든것들이 나온다
-- 조인 후 사원이 없는 부서명도 같이 출력되도록 할것
select e1.employee_id,e1.first_name, d.department_name
from employees e1, departments d
where e1.department_id(+)  = d.department_id;

select e1.employee_id,e1.first_name, d.department_name
from employees e1 right join departments d
on e1.department_id  = d.department_id;

--조인후 부서배정이 안된 사원도 출력할것!
select e1.employee_id,e1.first_name, d.department_name
from employees e1 left join departments d
on e1.department_id  = d.department_id;

--using
--on e1.department_id  = d.department_id; 같은걸 축소해서 쓰는 역할
select e1.employee_id,e1.first_name, d.department_name
from employees e1 join departments d
using (department_id);

--full outer join
--왼쪽에 널값이랑 오른쪽에 있는 널값도 다 출력해준다
select nvl(e1.employee_id, 0 ) as 사번, --사번이 널이면 0 출력 (NUMBER)
NVL(e1.first_name,'사원없음') AS 이름, --사원이 널이면 사원없음을 출력
NVL(d.department_name,'부서없음') AS 부서명 --부서명이 없으면 부서없음을 출력
from employees e1 full join departments d
using (department_id);

--NATURAL JOIN
SELECT employee_id,department_name
from employees natural join departments;

--1.사원 테이블과 부서 테이블을 조인하여 모든 사원ID,사원이름,급여,부서명을
--출력하라. (부서명 내림차순 정렬)
SELECT e.employee_id as 사원ID, 
e.first_name as 사원이름, 
e.salary as 급여,
d.department_name as 부서명
FROM employees e FULL join departments d
using (department_id)
ORDER BY 부서명 DESC;

--해답
--SELECT e.employee_id 사원ID, e.first_name 사원이름,
--e.salary 급여, d.department_name 부서명
--FROM employees e LEFT OUTER JOIN departments d
--USING(department_id) order by d.department_name desc;

--2. 사원 테이블과 부서 테이블을 조인하여 직업ID가 ‘IT_PROG‘ 인 사원들의
--사원이름, 직업ID,부서명, 위치ID를 출력하세요.
SELECT 
    e.first_name as 사원이름,
    e.job_id as 직업ID,
    d.department_name as 부서명,
    d.location_id as 위치ID
FROM 
employees e join departments d
using (department_id)
WHERE e.job_id='IT_PROG';

--해답
--SELECT e.first_name 사원이름, e.job_id 직업ID, d.department_name 부서명,
--d.location_id 위치ID
--FROM employees e INNER JOIN departments d
--ON e.department_id=d.department_id AND job_id='IT_PROG';

--3. 부서 테이블과 사원 테이블에서 사번, 사원명, 업무, 급여 , 부서명을
--검색하시오. 단, 업무명이 '%Manager' 이며 급여가 8000 이상인
--사원에 대하여 사번을 기준으로 오름차순 정렬할 것.
SELECT 
    e.employee_id as 사번,
    e.first_name as 사원명,
    j.job_title as 업무,
    e.salary as 급여,
    d.department_name as 부서명
FROM departments d 
    JOIN employees e
        USING (department_id)
    JOIN jobs j
        USING (job_id)
WHERE 
    e.salary >= 8000  AND j.job_title LIKE '%Manager'
ORDER BY 사번 ASC;        

--해답
--select e.employee_id 사번, e.first_name 사원명,j.job_title 업무명,
--e.salary 급여, d.department_name 부서명
--from employees e JOIN departments d ON e.department_id = d.department_id
--JOIN jobs j ON j.job_id = e.job_id AND job_title LIKE '%Manager' AND
--e.salary>=8000
--order by e.employee_id asc;


--JAVA JDBC 연동계정
CREATE TABLE TEST
(
  NUM NUMBER NOT NULL 
, NAME VARCHAR2(20) NOT NULL 
, AGE NUMBER NOT NULL 
, CONSTRAINT TEST__PK PRIMARY KEY 
  (
    NUM 
  )
  ENABLE 
);
-------------------------------------------------------------------------------

--Data Insert
--INSERT INTO 테이블(칼럼명들) VALUES(값들);--기본뼈대
INSERT INTO TEST(NUM,NAME,AGE) VALUES(1,'kim1',11);
INSERT INTO TEST(NUM,NAME,AGE) VALUES(2,'kim1',11);
--INSERT INTO TEST_TABLE(NUM,NAME,AGE) VALUES(3,'',11); --공간에 아무것도 안 넣어도 NULL로 인식해서 오류
INSERT INTO TEST(NUM,NAME,AGE) VALUES(3,'kim3',11);
INSERT INTO TEST(NUM,NAME,AGE) VALUES(4,'kim4',44);

Select * from test;

Select * from test where num=1;

---------------------------------------------------------------------------------
--1.사원 테이블과 부서 테이블을 조인하여 모든 사원ID,사원이름,급여,부서명을
--출력하라. (부서명 내림차순 정렬) 을 이클립스에서 실행하라

Select e.employee_id , e.first_name, e.last_name, e.salary, e.hire_date ,d.department_name
From employees e left outer join departments d
on (e.department_id=d.department_id)
order by e.employee_id desc;

select count(*) as cnt from employees;

--emp job join?

Select e.employee_id , e.first_name, e.last_name, e.salary, e.hire_date ,j.job_title
From employees e join jobs j
on (e.job_id=j.job_id)
order by e.employee_id desc;

