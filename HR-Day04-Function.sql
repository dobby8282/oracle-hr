/*
함수(Function)
    매개변수를 받아 특정 계산(작업)을 수행하고 결과를 반환하는 구조로 되어있습니다.

함수 유형
    - 단일행 함수 - 단일행 매개변수를 받아 결과 값 반환
    - 여러행 함수 - 여러행 매개변수를 받아 결과 값 반환
*/

-- 단일행 함수

/*
대소문자 변환 함수
*/
-- LOWER() 함수 - 소문자로 변환
SELECT employee_id, last_name, department_id
FROM employees
WHERE last_name = 'higgins';

SELECT employee_id, last_name, department_id
FROM employees
WHERE LOWER(last_name) = 'higgins';

-- UPPER() 함수 - 대문자로 변환
SELECT UPPER('higgins') FROM dual;

-- INITCAP() 함수 - 첫글자만 대문자로 변환
SELECT employee_id, last_name, department_id
FROM employees
WHERE last_name = INITCAP('higgins');

/*
문자 조작 함수
*/
-- CONCAT() 함수 - 두개 파라미터 값을 연결합니다.
SELECT 'Hello'||'World' FROM dual;
SELECT CONCAT('Hello', 'World') FROM dual;

-- SUBSTR() - 지정된 길이의 문자열을 추출합니다.
SELECT SUBSTR('HelloWorld', 1, 5) FROM dual;

-- LENGTH() - 문자열 길이를 숫자 값으로 표시합니다.
SELECT LENGTH('HelloWorld') FROM dual;

-- INSTR() - 이름이 지정된 문자의 숫자 위치를 찾습니다.
SELECT INSTR('HelloWorld', 'W') FROM dual;

-- LPAD() - 길이가 n이 되도록 왼쪽부터 문자식으로 채운 표현식을 반환합니다.
SELECT LPAD('salary', 10, '*') FROM dual;

-- RPAD() - 길이가 n이 되도록 오른쪽부터 문자식으로 채운 표현식을 반환합니다.
SELECT RPAD('salary', 10, '*') FROM dual;

-- REPLACE() - 문자열 치환
SELECT REPLACE('JACK and JUE', 'J', 'BL') FROM dual;

-- TRIM() - 문자열에서 선행 문자나 후행 문자를 자릅니다.
SELECT TRIM('H' FROM 'HelloWorld') FROM dual;

/*
숫자 함수
*/
-- ROUND() - 지정된 소수점 자릿수로 값을 반올림 합니다.
SELECT ROUND(45.926, 2) FROM dual;

-- TRUNC() - 지정된 소수점 자릿수로 값을 truncate 합니다.
SELECT TRUNC(45.926, 2) FROM dual;

-- MOD() - 나눈 나머지를 반환 합니다.
SELECT MOD(1600, 300) FROM dual;

/*
날짜 함수
*/
/*
SYSDATE() 함수
    반환값 - 날짜, 시간
*/
SELECT sysdate FROM dual;

/*
날짜 연산 
    - 날짜에 숫자를 더하거나 빼서 결과 날짜 값을 구합니다.
    - 두 날짜 사이의 일수를 알아내기 위해 빼기 연산을 합니다.
    - 시간 수를 24로 나눠 날짜에 시간을 더합니다.
*/
SELECT last_name, (sysdate -hire_date)/7 AS WEEKS
FROM employees
WHERE department_id = 90;

/*
날짜 조작 함수

MONTHS_BETWEEN() - 두 날짜 간의 월수
ADD_MONTHS() - 날짜에 월 추가
NEXT_DAY() - 지정된 날짜의 다음날
LAST_DAY() - 월의 마지막 날
ROUND() - 날짜 반올림
TRUNC() - 날짜 truncate
*/

SELECT MONTHS_BETWEEN('22-12-16', '21-12-16') FROM dual;
SELECT ADD_MONTHS('22-12-16', 1) FROM dual;
SELECT NEXT_DAY('22-12-16', 1) FROM dual;
SELECT LAST_DAY('23-02-16') FROM dual;
SELECT ROUND(SYSDATE, 'MONTH') FROM dual;
SELECT TRUNC(SYSDATE, 'MONTH') FROM dual;


/*
변환함수
*/

/*
TO_CHAR() 함수 - 날짜 또는 숫자 사용가능

    YYYY - 숫자로 된 전체 연도
    YEAR - 영어 철자로 표기된 연도
    MM   - 월의 2자리 값
    MONTH - 전체 월 이름
    MON  - 월의 3자 약어
    DY   - 3문자로 된 요일 약어
    DAY  - 요일의 전체 이름
    DD   - 숫자 형식의 월간 일
    AM 또는 PM  - 자오선 표시
    A.M. 또는 P.M. - 마침표가 있는 자오선 표시
    HH 또는 HH12 또는 HH24 - 하루 시간 또는 반일 시간(1-12) 또는 전일 시간(0-23)
    MI   - 분(0-59)
    SS   - 초(0-59)
    
    TIMESTAMP 타입
    FF   - 밀리세컨드

*/
SELECT last_name, TO_CHAR(hire_date, 'YYYY/MM/DD HH24:MI:SS') AS HIREDATE
FROM employees;

SELECT TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF2') FROM dual;


/*
TO_CHAR() 숫자에 사용

    9    - 숫자로 나타냄
    0    - 0이 표시되도록 강제 적용
    $    - 부동 달러 기호 배치
    L    - 부동 로컬 통화 기호 사용
    .    - 소수점 출력
    ,    - 천단위 표시자로 쉼표 출력

*/
SELECT TO_CHAR(salary, 'L99,999.00') SALARY
FROM employees
WHERE last_name = 'Ernst';

-- TO_DATE() - 문자를 DATE 타입으로 반환
SELECT last_name, TO_CHAR(hire_date, 'YYYY-MM-DD')
FROM employees 
WHERE hire_date < TO_DATE('2005-01-01', 'YYYY-MM-DD')
;

/*
함수 중첩
    단일 행 함수는 어떠한 레벨로도 중첩될 수 있습니다.
    중첩된 함수는 가장 깊은 레벨에서 가장 낮은 레벨로 평가됩니다.
*/
SELECT last_name, UPPER(CONCAT(SUBSTR(LAST_NAME, 1, 8), '_US'))
FROM employees
WHERE department_id = 60;


/*
NVL() 함수
    null 값을 실제 값으로 반환합니다.
    null은 연산이 안됩니다.
*/

SELECT last_name, salary, NVL(commission_pct, 0),
    (salary*12) + (salary*12*NVL(commission_pct, 0)) AN_SAL
FROM employees;

/*
NVL2() 함수
    첫번째 표현식을 검사합니다. 첫번째 표현식이 null이 아니면 NVL2 함수는 두번째 표현식을 반환합니다.
    첫번째 표현식이 null이면 세번째 표현식이 반환하빈다.
*/
SELECT last_name, salary, commission_pct,
    NVL2(commission_pct,
            'SAL+COMM', 'SAL') income
FROM employees
WHERE department_id IN (50, 80)
;

/*
NULLIF() 함수
    두 표현식을 비교 같으면 null 반환, 다르면 expr1을 반환 합니다.
    그러나 expr1에 대해 리터럴 NULL을 지정할 수 없습니다.
*/

SELECT first_name, LENGTH(first_name) "expr1",
    last_name, LENGTH(last_name) "expr2",
    NULLIF(LENGTH(first_name), LENGTH(last_name)) result
FROM employees
;


/*
COALESCE() 함수
    리스트에서 null이 아닌 첫번째 표현식을 반환합니다
*/
SELECT last_name, employee_id,
COALESCE(TO_CHAR(commission_pct),TO_CHAR(manager_id),
'No commission and no manager') 
FROM employees;


/*
조건부 표현식
    SQL 문에서 IF-THEN-ELSE 논리를 사용할 수 있습니다
    - CASE 식
    - DECODE 함수

*/


/*
CASE 식
    IF-THEN-ELSE 문 작업을 수행하여 조건부 조회를 편리하게
    수행하도록 합니다
*/
SELECT last_name, job_id, salary,
    CASE job_id WHEN 'IT_PROG' THEN 1.10*salary
                WHEN 'ST_CLERK' THEN 1.15*salary
                WHEN 'SA_REP' THEN 1.20*salary
    ELSE salary END "REVISED_SALARY"
FROM employees;

/*
DECODE() 함수
*/

SELECT last_name, job_id, salary,
    DECODE(job_id, 'IT_PROG', 1.10*salary,
                    'ST_CLERK', 1.15*salary,
                    'SA_REP', 1.20*salary,
            salary)
    REVISED_SALARY
FROM employees;


