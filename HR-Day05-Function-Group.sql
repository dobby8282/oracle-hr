/*
그룹 함수란
    그룹 함수는 행 집합 연산을 수행하여 그룹별로 하나의 결과를 산출합니다.

    AVG() : n의 평균값. null 값은 무시합니다.
    COUNT() : 행 개수 null이 아닌 값을 평가합니다.
    MAX() : 최대값. null 값은 무시합니다.
    MIN() : 최소값. null 값은 무시합니다
    STDDEV() : 표준 편차. null 값은 무시합니다
    SUM() : 합계 값. null 값은 무시합니다.
    VARIANCE() : 분산. null 값은 무시합니다.
    
*/

SELECT AVG(salary), MAX(salary),
    MIN(salary), SUM(salary)
FROM employees
WHERE job_id LIKE '%REP%';

SELECT COUNT(*)
FROM employees
WHERE department_id = 50;

SELECT COUNT(*)
FROM employees
WHERE department_id = 50;

SELECT COUNT(commission_pct)
FROM employees
WHERE department_id = 80;

-- COUNT(DISTINCT expr)은 expr의 null이 아닌 구분 값의 수를 반환합니다
SELECT COUNT(DISTINCT department_id)
FROM employees;

-- NVL 함수는 강제로 그룹 함수에 null 값이 포함되도록 합니다.
SELECT AVG(NVL(commission_pct, 0))
FROM employees;

/*
GROUP BY 절 사용
   GROUP BY 절을 사용하여 테이블의 행을 그룹으로 나눌 수 있습니다.
*/
-- 그룹 함수에 속하지 않는 SELECT 리스트의 모든 열은 GROUP BY 절에 있어야 합니다
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id ;

-- GROUP BY 열은 SELECT 리스트에 없어도 됩니다.
SELECT AVG(salary)
FROM employees
GROUP BY department_id ;

-- 여러 열에서 GROUP BY 절 사용
SELECT department_id, job_id, SUM(salary)
FROM employees
WHERE department_id > 40
GROUP BY department_id, job_id 
ORDER BY department_id;


/*
HAVING 절
    HAVING 절을 사용할 경우 Oracle 서버는 다음과 같이 그룹을 제한합니다
    1. 행이 그룹화됩니다.
    2. 그룹 함수가 적용됩니다.
    3. HAVING 절과 일치하는 그룹이 표시됩니다
*/

SELECT department_id, MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary)>10000 ;

SELECT job_id, SUM(salary) PAYROLL
FROM employees
WHERE job_id NOT LIKE '%REP%'
GROUP BY job_id
HAVING SUM(salary) > 13000
ORDER BY SUM(salary);

-- 그룹 함수 중첩
SELECT MAX(AVG(salary))
FROM employees
GROUP BY department_id;