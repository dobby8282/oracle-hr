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


SELECT  d.dname, e.ename
FROM emp e, dept d
WHERE 1=1 
AND e.sal >= 3000
AND e.deptno = d.deptno

ORDER BY e.ename;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


/*
INDEX UNIQUE SCAN
: 고유 인덱스가 정의된 컬럼이 조건절에서 '='로 비교되는 경우
: 그 외의 경우는 전부 INDEX RANGE SCAN이 발생
*/

SELECT *
FROM products
WHERE prodno = 11000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


SELECT /*+ FULL(p) */ *
FROM products p
WHERE prodno = 11000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


/*
FULL TABLE SCAN

: 테이블에 할당된 첫 번째 블록부터 HWM 아래의 모든 블록을 읽음
: 1회의 I/O에 대해서 여러 개의 블록을 읽음
: DB_FILE_MULTIBLOCK_READ_COUNT 파라메터로 한 번에 읽어야 할 블록의 개수를 지정

*/
SHOW PARAMETER DB_FILE_MULTIBLOCK_READ_COUNT;

SELECT * FROM orderdetails;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


/*
INDEX RANGE SCAN
: INDEX UNIQUE SCAN을 제외한 모든 INDEX SCAN은 INDEX RANGE SCAN 이다.
: 고유 인덱스가 정의된 컬럼이 조건절에서 '=' 비교 연산자를 제외한 모든 연산자로 비교되는 경우
: 비고유 인덱스가 정의된 컬럼이 조건절에 기술되는 경우
*/

CREATE INDEX products_price_idx ON products(price);

SELECT *
FROM products
WHERE price BETWEEN 3350 AND 4500;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


/*
INDEX RANGE SCAN DESCENDING
: INDEX RANGE SCAN에서는 조건절의 범위를 검색 할 때, 기본적으로 최소 경계값부터 검색을 시작하여 최대 경계값에서 검색을 종료
: 만약, 최대 경계값에서 검색을 시작하여 최소 경계값에서 검색을 종료해야하는 경우에 사용
*/
CREATE INDEX products_price_idx ON products(price);

SELECT /*+ INDEX_DESC(products products_price_idx) */ *
FROM products
WHERE price BETWEEN 3350 AND 4500;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));



/*
INDEX RANGE SCAN(MIN/MAX)
    앞서 언급한 최대값 찾기에서 다음과 같이 결합(복합) 인덱스를 정의
*/

CREATE INDEX products_idx ON products(psize, price);

SELECT /*+ INDEX(products products_idx) */ MAX(price) FROM products
WHERE psize = 'XL';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/*
INDEX 컬럼 가공
    인덱스가 정의된 컬럼을 가공하면 인덱스를 활용 할 수 없음
*/

CREATE INDEX products_price_idx ON products(price);

SELECT /*+ INDEX(products products_price_idx) */ * 
FROM products
WHERE TRUNC(price) BETWEEN 3350 AND 4500;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

-- 비교
SELECT /*+ INDEX(products products_price_idx) */ * 
FROM products
WHERE price BETWEEN 3350 AND 4500;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


/*
INDEX RANGE SCAN 과 FULL TABLE SCAN
    테이블 대부분의 데이터를 찾을때는 FULL TABLE SCAN 방식이 유리하다
*/



--1511565
SELECT count(*) FROM orders;

CREATE INDEX orders_custno_idx ON orders(custno);

SELECT /*+ FULL(orders) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 100;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

SELECT /*+ INDEX(orders orders_custno_idx) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 100;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


SELECT /*+ FULL(orders) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 5000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

--|   0 | SELECT STATEMENT   |        |      1 |        |      1 |00:00:23.13 |     503K|    503K|
--|   0 | SELECT STATEMENT                     |                   |      1 |        |      1 |00:06:23.40 |     757K|    731K|
SELECT /*+ INDEX(orders orders_custno_idx) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 5000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));



/*
INDEX FAST FULL SCAN
: INDEX FULL SCAN은 인덱스에 포함되지 않은 컬럼이 SQL에 포함되어 있을 때도 발생하지만
  INDEX FAST FULL SCAN은 인덱스에 포함된 컬럼들만 SQL에 사용되었을 때 발생
: Multi Block I/O에 의해 리프 블록에 접근하므로, 데이터의 출력 순서를 보장하지 않음
*/


CREATE INDEX orders_idx ON orders(orderdate, paytype, custno);

SELECT /*+ INDEX_FFS(o orders_idx) */ TO_CHAR(orderdate, 'YYYYMM') yyyymm, COUNT(custno) total
FROM orders o
WHERE paytype = '신용카드'
GROUP BY TO_CHAR(orderdate, 'YYYYMM');
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));






