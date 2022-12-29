/*
실행계획 읽기
    - 테이블 액세스 프로세스와 그 테이블의 익덱스를 액세스하는 프로세스는 하나의 단위
    - 여러 문장 중에서 들여쓰기가 많이 되어 있는 문장이 먼저 실행
    - 들여쓰기가 적은(한 레벨 위의) 상위 프로세스에 종속
    - 들여쓰기가 같은 동일 레벨이라면 위에 있는(먼저 나오는) 문장이 먼저 실행
    - 하위 노드를 가진 노드의 경우에는 하위 노드가 먼저 실행
*/
-- EXPLAIN PLAN 
EXPLAIN PLAN FOR
SELECT d.dname, e.ename
FROM dept d, emp e
WHERE d.deptno = e.deptno
AND e.sal >= 3000
ORDER BY e.ename;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

/*

DBMS_XPLAN.DISPLAY_CURSOR

필요권한 부여
GRANT SELECT ON V_$SESSION TO tuning;
GRANT SELECT ON V_$SQL_PLAN_STATISTICS_ALL TO tuning;
GRANT SELECT ON V_$SQL TO tuning;
GRANT SELECT ANY DICTIONARY TO tuning;
*/
-- 통계 캡처레벨
ALTER SYSTEM SET STATISTICS_LEVEL = ALL;

SELECT d.dname, e.ename
FROM dept d, emp e
WHERE d.deptno = e.deptno
AND e.sal >= 3000
ORDER BY e.ename;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

