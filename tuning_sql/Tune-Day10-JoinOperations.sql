/*
NESTED LOOPS
    중첩 루프 조인
    
중첩 루프 조인의 특징
    먼저 수행되는 집합(선행 테이블)의 처리 범위가 전체 일량을 좌우함
    먼저 수행되는 집합이 상수로 바뀌어 후행 테이블에 조인절 조건으로 공급됨
    후행 테이블은 계속 루프를 돌면서 선행 테이블의 상수 공급이 종료될 때까지 조인을 시도함
    조인 되는 후행 테이블의 조인 컬럼에 인덱스가 존재해야 함.
    인덱스가 없으면 후행 테이블을 반복적으로 FULL TABLE SCAN하므로 비효율적

*/

CREATE INDEX emp_deptno_idx ON emp(deptno);


SELECT MAX(ROWNUM) FROM emp;
SELECT MAX(ROWNUM) FROM dept;

SELECT COUNT(*) FROM orders;
SELECT MAX(ROWNUM) FROM orders;

SELECT /*+ USE_NL(e d) */
    e.ename, d.dname
FROM emp e INNER JOIN dept d
ON (e.deptno = d.deptno);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

SELECT /*+ ORDERED USE_NL(e d) */ 
    E.ename, D.dname
FROM  emp E, dept D
WHERE E.deptno = D.deptno;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


/*
SORT MERGE
    각 테이블로부터 동시에 독립적으로
    데이터를 읽어 들인 후, 연결고리 칼럼을 대상으로 정렬 작업 수행합니다.
    정렬 종료후 조인을 합니다.
    
소트 머지 조인의 특징
: 두 테이블의 조인 컬럼으로 각각 정렬한 다음, 정렬 값을 서로 비교하면서 조인하는 방식
  중첩 루프 조인에서 조인 횟수에 의한 랜덤 액세스가 부담되는 경우에 사용
: 정렬 작업은 PGA 메모리를 사용하므로 조인 대상 건수가 많을수록 정렬을 위한 부담이 증가
  메모리 SORT_AREA_SIZE로 최적화
*/

SELECT /*+ USE_MERGE(e d) */
    e.ename, d.dname
FROM emp e INNER JOIN dept d
ON (e.deptno = d.deptno);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));



/*
HASH JOIN
    Driving 테이블로 하나를 선택
    Hashing을 통해 해시값을 만들어 메모리 적재합니다.
    다음으로 조인해야 할 테이블로부터 데이터를 읽어서
    Hashing을 통해 해시값을 만듭니다.
    
    메모리 HASH_AREA_SIZE로 최적화(SORT_AREA_SIZE 2배가 기본값)
    
Hash JOIN 사용기준
    수행 빈도가 낮고
    쿼리 수행 시간이 오래 걸리는
    대량 데이터 조인할 때
*/

SELECT /*+ USE_HASH(e d) */
    e.ename, d.dname
FROM emp e INNER JOIN dept d
ON (e.deptno = d.deptno);
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


