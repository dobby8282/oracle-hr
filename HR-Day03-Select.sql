/*
SQL (Structured Query Language) - 구조적 질의 언어
    관계형 데이터베이스 시스템(RDBMS)에서 자료를 관리 및 처리하기 위해 설계된 언어

SQL문 작성
    대소문자를 구분하지 않는다.
    여러 줄에 입력할 수 있다.
    키워드는 여러 줄에 걸쳐 입력하거나 약어로 표기할 수 없다.
    절은 일반적으로 읽기 쉽고 편집하기 쉽도록 별도의 행에 둔다.
    코드의 가독성을 높이기 위해 들여쓰기를 사용.

1. SELECT 
    데이터베이스에서 정보를 검색

*/

-- 모든 열 선택 *
SELECT *
FROM departments;

-- 특정 열 선택
SELECT department_id, location_id
FROM departments;

/*
산술식
    산술 연산자를 사용하여 숫자/날짜 데이터 표현식 작성

    + 더하기
    - 빼기
    * 곱하기
    / 나누기
*/

-- 산술 연산자 사용
SELECT last_name, salary, salary + 300
FROM employees;

/*
연산자 우선순위
    곱하기와 나누기 는 더하기 빼기보다는 먼저 수행
*/
SELECT last_name, salary, 12*salary+100
FROM employees;

SELECT last_name, salary, 12*(salary+100)
FROM employees;

/*
산술식의 Null 값
    null 값을 포함하는 산술식은 null로 계산
*/
SELECT last_name, 12*salary*commission_pct
FROM employees;

/*
열 alias 정의
    열 머리글의 이름을 바꿉니다.
    계산에서 유용합니다.
    열 이름 바로 뒤에 나옵니다. (열 이름과 alias 사이에 선택
    사항인 AS 키워드가 올 수도 있습니다.)
    공백이나 특수 문자를 포함하거나 대소문자를 구분하는 경우
    큰 따옴표가 필요하다
*/
SELECT last_name AS name, commission_pct comm
FROM employees;

SELECT last_name "Name" , salary*12 "Annual Salary"
FROM employees;

/*
연결 연산자
    열이나 문자열을 다른 열에 연결합니다.
    두 개의 세로선(||)으로 나타냅니다.
    결과 열로 문자 표현식을 작성합니다.
*/
SELECT last_name||job_id AS "Employees"
FROM employees;

/*
리터럴 문자열
    리터럴은 SELECT 문에 포함된 문자, 숫자 또는 날짜입니다.
    날짜 및 문자 리터럴 값은 작은 따옴표로 묶어야 합니다.
    각 문자열은 반환되는 각 행에 한 번 출력됩니다
*/
SELECT last_name ||' is a '||job_id 
AS "Employee Details"
FROM employees;


/*
대체 인용(q) 연산자
    자신의 따옴표 구분자를 지정합니다.
    구분자를 임의로 선택합니다.
    가독성 및 사용성이 증가합니다.
*/
SELECT department_name || q'[ Department's Manager Id: ]'
|| manager_id
AS "Department and Manager" 
FROM departments;


