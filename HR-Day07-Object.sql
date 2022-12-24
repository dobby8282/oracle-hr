/*
데이터베이스 객체
    테이블 : 기본 저장단위이며 행으로 구성되어 있습니다.
    뷰 : 하나 이상의 테이블에 있는 데이터의 부분 집합을 논리적으로 나타냅니다.
    시퀀스 : 숫자 값을 생성합니다.
    인덱스 : 데이터 검색 query의 성능을 향상시킵니다.
    동의어 : 객체에 다른 이름을 부여합니다.
*/

-- 뷰 생성
CREATE VIEW empvu80
AS SELECT employee_id, last_name, salary
    FROM employees
    WHERE department_id = 80;

DESCRIBE empvu80;

SELECT * FROM empvu80;

-- alias 사용 뷰 생성
CREATE VIEW salvu50
AS SELECT employee_id ID_NUMBER, last_name NAME,
        salary*12 ANN_SALARY
    FROM employees
    WHERE department_id = 50;
    
-- 뷰 수정
CREATE OR REPLACE VIEW empvu80
    (id_number, name, sal, department_id)
AS SELECT employee_id, first_name || ' ' || last_name, 
        salary, department_id
    FROM employees
    WHERE department_id = 80;

SELECT * FROM empvu80;

UPDATE empvu80 SET 
department_id = 90
WHERE id_number = 145;

ROLLBACK;


/*
복합 뷰 생성
    두 개 이상 기본 테이블에 의해 정의된 뷰
*/
CREATE OR REPLACE VIEW dept_sum_vu
        (name, minsal, maxsal, avgsal)
AS SELECT d.department_name, MIN(e.salary), 
        MAX(e.salary),AVG(e.salary)
FROM employees e JOIN departments d
ON (e.department_id = d.department_id)
GROUP BY d.department_name;

/*
뷰 DML 작업 수행 규칙
    1. 행 제거할수 없는 경우
        - 그룹 함수
        - GROUP BY 절
        - DISTINCT 키워드
        - Pseudocolumn ROWNUM 키워드
    2. 뷰의 데이터를 수정할 수 없는 경우
        - 그룹 함수
        - GROUP BY 절
        - DISTINCT 키워드
        - Pseudocolumn ROWNUM 키워드
        - 표현식으로 정의되는 열
    3. 뷰를 통해 데이터를 추가할 수 없는경우
        - 그룹 함수
        - GROUP BY 절
        - DISTINCT 키워드
        - Pseudocolumn ROWNUM 키워드
        - 표현식으로 정의되는 열
        - 뷰에서 선택되지 않은 기본 테이블의 NOT NULL 열
*/

-- WITH CHECK OPTION 절 사용 - DML 작업이 뷰 영역에만 적용
CREATE OR REPLACE VIEW empvu20
AS SELECT *
    FROM employees
    WHERE department_id = 20
    WITH CHECK OPTION CONSTRAINT empvu20_ck;

UPDATE empvu20
SET department_id = 10
WHERE employee_id = 201;


-- DML 작업거부
CREATE OR REPLACE VIEW empvu10
    (employee_number, employee_name, job_title)
AS SELECT employee_id, last_name, job_id
    FROM employees
    WHERE department_id = 10
    WITH READ ONLY ;
    
-- 뷰 제거 
DROP VIEW empvu80;

/*
시퀀스(Sequence)
    연속적인 숫자 값을 자동으로 증감 시켜서 값을 리턴하는 객체입니다.
    
INCREMENT BY : 시퀀스 실행 시 증가시킬 값
START WITH : 시퀀스의 시작값이다. (MINVALUE과 같거나 커야 한다)
MINVALUE : 시퀀스가 시작되는 최솟값이다.
MAXVALUE : 시퀀스가 끝나는 최댓값이다.
NOCYCLE | CYCLE : NOCYCLE (반복안함), CYCLE(시퀀스의 최댓값에 도달 시 최솟값 1부터 다시시작)
NOCACHE | CACHE : NOCACHE(사용안함), CACHE(캐시를 사용하여 미리 값을 할당해 놓아서 속도가 빠르며, 동시 사용자가 많을 경우 유리)
NOORDER | ORDER : NOORDER(사용안함), ORDER(요청 순서로 값을 생성하여 발생 순서를 보장하지만 조금의 시스템 부하가 있음)
*/
CREATE SEQUENCE my_seq
       INCREMENT BY 1       -- 증가값(1씩증가)
       START WITH 1         -- 시작값
       MINVALUE 1           -- 최소값
       MAXVALUE 99999999    -- 최대값
       NOCYCLE              -- 최대값 도달시 시작값 부터 반복안함
       NOCACHE              -- CACHE 사용안함
       NOORDER;             -- 요청 순서대로 값을 생성할지 여부
   
SELECT my_seq.NEXTVAL FROM dual;
DROP SEQUENCE my_seq;
SELECT my_seq.CURRVAL FROM dual;

SELECT * FROM dept2;

INSERT INTO dept2 VALUES (my_seq.NEXTVAL, 'A', 1);
INSERT INTO dept2 VALUES (my_seq.NEXTVAL, 'B', 2);
INSERT INTO dept2 VALUES (my_seq.NEXTVAL, 'C', 1);

/*
인덱스
    Oracle 서버 인덱스는 포인터를 사용하여 행 검색 속도를 높일 수 있는 스키마 객체입니다.
*/

-- EMPLOYEES 테이블의 LAST_NAME 열에 대한 query 액세스 속도를 향상시킵니다.
CREATE INDEX emp_last_name_idx
    ON employees(last_name);

-- 인덱스 제거
DROP INDEX emp_last_name_idx;
    

/*
동의어
    동의어를 생성하여 객체에 대체 이름을 부여할 수 있습니다.
*/
-- 동의어 생성
CREATE SYNONYM d_sum
FOR dept_sum_vu;

select * from d_sum;

-- 동의어 제거
DROP SYNONYM d_sum;

