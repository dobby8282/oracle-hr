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
VALUES (70, 'Public Relations', 100, 1700);

-- null 값을 가진 행 삽입
-- 열 생략
INSERT INTO departments (department_id, 
department_name)
VALUES (30, 'Purchasing');
-- NULL 키워드 지정
INSERT INTO departments
VALUES (100, 'Finance', NULL, NULL);


/*
INSERT 문을 subquery로 작성
    
*/
INSERT INTO sales_reps(id, name, salary, commission_pct)
SELECT employee_id, last_name, salary, commission_pct
FROM employees
WHERE job_id LIKE '%REP%';


/*
UPDATE 문을 사용하여 테이블의 기존 값을 수정합니다
*/


