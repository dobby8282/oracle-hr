/*
선택을 사용하여 행 제한
    WHERE 절을 사용하여 반환되는 행을 제한합니다.
WHERE 
    조건을 충족하는 행으로 query를 제한합니다.
    
    세가지 요소
    - 열이름
    - 비교 조건
    - 열 이름, 상수 또는 값 리스트
*/

-- WHERE 절 사용
SELECT employee_id, last_name, job_id, department_id
FROM employees
WHERE department_id = 90;

/*
문자열 및 날짜
    문자열 및 날짜 값은 작은 따옴표로 묶습니다.
    문자 값은 대소문자를 구분하고 날짜 값은 형식을 구분합니다.
    기본 날짜 표시 형식은 DD-MON-RR입니다.
*/
SELECt last_name, job_id, department_id
FROM employees
WHERE last_name = 'Whalen';

SELECT last_name, hire_date
FROM employees
WHERE 1= 1
AND hire_date = '03/06/17'
;

/*
비교 연산자
    특정 표현식을 다른값이나 표현식과 비교하는 조건에서 사용됩니다.
    
    =   같음
    >   보다 큼
    >=  보다 크거나 같음
    <   보다 작음
    <=  보다 작거나 같음
    <>  같지 않음
    BETWEEN ... AND ...     두 값 사이(경계값 포함)
    IN(set)                 값 리스트 중 일치하는 값 검색
    LIKE                    일치하는 문자 패턴 검색
    IS NULL                 NULL 값인지 여부
*/

-- 비교 연산자 사용
SELECT last_name, salary
FROM employees
WHERE salary <= 3000;

-- BETWEEN 연산자를 사용하는 범위 조건
SELECT last_name, salary
FROM employees
WHERE salary BETWEEN 2500 AND 3500;

-- IN 연산자를 사용하는 멤버조건
SELECT employee_id, last_name, salary, manager_id
FROM employees
WHERE manager_id IN (100, 101, 201);

/*
LIKE 연산자를 사용하여 패턴 일치
    LIKE 연산자를 사용하여 유효한 검색 문자열 값의 대체 문자 검색을 수행합니다.
    검색조건에는 리터럴 문자나 숫자가 포함될 수 있습니다.
        - % 는 0개 이상의 문자를 나타냅니다
        - _ 은 한 문자를 나타냅니다.
*/
SELECT first_name
FROM employees
WHERE first_name LIKE 'A%';

-- 대체 문자 결합
SELECT last_name
FROM employees
WHERE last_name LIKE '_o%';

-- ESCAPE 식별자 
SELECT employee_id, last_name, job_id
FROM employees 
WHERE job_id LIKE '%SA\_%' ESCAPE '\';
/*
NULL 조건 사용
    IS NULL 연산자로 null을 테스트 합니다
*/
SELECT last_name, manager_id
FROM employees
WHERE manager_id IS NULL;
/*
논리 연산자를 사용하여 조건정의
    AND : 구성 요소 조건이 모두 참인 경우 TRUE 반환
    OR  : 구성 요소 조건 중 하나가 참인 경우 TRUE 반환
    NOT : 조건이 거짓인 경우 TRUE를 반환합니다.
*/
-- AND 연산자 사용
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE salary >= 10000
AND job_id LIKE '%MAN%';
-- OR 연산자 사용
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE salary >= 10000
OR job_id LIKE '%MAN%';
-- NOT 연산자 사용
SELECT last_name, job_id
FROM employees
WHERE job_id NOT IN ('IT_PROG', 'ST_CLERK', 'SA_REP');
/*
ORDER BY 절
    ORDER BY 절을 사용하여 검색된 행을 정렬합니다.
    - ASC : 오름차순, 기본값
    - DESC : 내림차순
    SELECT 문의 맨 마지막에 옵니다.    
*/
SELECT last_name, job_id, department_id, hire_date
FROM employees
ORDER BY hire_date;
-- 내림차순 정렬
SELECT last_name, job_id, department_id, hire_date
FROM employees
ORDER BY hire_date DESC;
-- 열  alias를 기준으로 정렬
SELECT employee_id, last_name, salary*12 annsal
FROM employees
ORDER BY annsal
;
-- 열 숫자 위치를 사용하여 정렬
SELECT last_name, job_id, department_id, hire_date
FROM employees
ORDER BY 3;
-- 여러 열을 기준으로 정렬
SELECT last_name, job_id, department_id, salary
FROM employees
ORDER BY department_id, salary DESC;
