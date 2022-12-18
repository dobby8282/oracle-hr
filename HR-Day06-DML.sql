/*
DML(데이터 조작어)
    DML 문은 다음과 같은 경우에 실행합니다.
    – 테이블에 새 행 추가
    – 테이블의 기존 행 수정
    – 테이블에서 기존 행 제거
    트랜잭션은 논리적 작업 단위를 형성하는 DML 문의 모음으로 구성됩니다.
*/

/*
INSERT 문
    각 열에 대한 값을 포함하는 새 행을 삽입합니다.
    
[기본형식]
    INSERT INTO 테이블명 (칼럼명1,칼럼명2.....)
    VALUES(값1,값2.....);
    
    또는
    INSERT INTO table (칼럼명1,칼럼명2.....) subquery;
*/
INSERT INTO departments(department_id, 
        department_name, manager_id, location_id)
VALUES (280, 'Public Relations', 100, 1700);

commit;


-- null 값을 가진 행 삽입
-- 열 생략
INSERT INTO departments (department_id, 
department_name)
VALUES (290, 'Purchasing');
-- NULL 키워드 지정
INSERT INTO departments
VALUES (300, 'Finance', NULL, NULL);


/*
INSERT 문을 subquery로 작성
    
CREATE TABLE sales_reps
AS (SELECT employee_id id, last_name name, salary, commission_pct
FROM employees WHERE 1=2);    
*/
CREATE TABLE sales_reps
AS (SELECT employee_id id, last_name name, salary, commission_pct
FROM employees WHERE 1=2);  

INSERT INTO sales_reps(id, name, salary, commission_pct)
SELECT employee_id, last_name, salary, commission_pct
FROM employees
WHERE job_id LIKE '%REP%';

SELECT * FROM departments;

ROLLBACK;

/*
UPDATE 문
    테이블의 기존 값을 수정합니다

[기본형식]
    UPDATE 테이블명 
    SET 칼럼명1 = 수정값, 칼럼명2 = 수정값
    WHERE 조건절
*/

create table copy_emp
as select *
from employees
where 1 = 2;

insert into copy_emp
select *
from employees;

UPDATE employees
SET department_id = 50
WHERE employee_id = 113;

UPDATE copy_emp
SET department_id = 110;

-- 다른 테이블을 기반으로 행 갱신

UPDATE copy_emp
SET department_id = (SELECT department_id
                        FROM employees
                        WHERE employee_id = 100)
WHERE job_id = (SELECT job_id
                FROM employees
                WHERE employee_id = 200);

/*
DELETE 문
    DELETE 문을 사용하여 테이블에서 기존 행을 제거할 수 있습니다.
*/

DELETE FROM departments
WHERE department_id = 300;

DELETE FROM copy_emp;


/*
TRUNCATE 문
    테이블은 빈 상태로, 테이블 구조는 그대로 남겨둔채 테이블에서 모든 행을 제거합니다.
    DML 문이 아니라 DDL(데이터 정의어) 문이므로 쉽게 언두할 수 없습니다
*/

TRUNCATE TABLE copy_emp;


/*
COMMIT 또는 ROLLBACK 전의 데이터 상태
    이전의 데이터 상태를 복구할 수 있습니다.
    현재 유저는 SELECT 문을 사용하여 DML 작업의 결과를 확인할 수 있습니다.
    다른 유저는 현재 유저가 실행한 DML 문의 결과를 볼 수 없습니다.
    영향을 받는 행이 잠기므로 다른 유저가 영향을 받는 행의 데이터를 변경할 수 없습니다.
*/

COMMIT;

ROLLBACK;
/*
SAVEPOINT
    변경 사항을 표시자로 롤백
    
UPDATE...
SAVEPOINT update_done;
INSERT...
ROLLBACK TO update_done;
*/

/*
SELECT 문의 FOR UPDATE 절
    EMPLOYEES 테이블에서 job_id가 SA_REP인 행을 잠급니다.
*/
SELECT employee_id, salary, commission_pct, job_id
FROM employees 
WHERE job_id = 'SA_REP'
FOR UPDATE 
ORDER BY employee_id;


