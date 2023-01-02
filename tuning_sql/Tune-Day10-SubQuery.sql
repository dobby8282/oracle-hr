/*
서브쿼리 동작방식 2가지
 1. FILTER 동작방식
 2. JOIN 동작방식
*/

/*
FILTER 동작방식
    최대 메인 SQL에서 추출된 데이터 건수 만큼 서브쿼리가 반복적으로 수행되며 처리되는 방식
    
FILTER 동작방식 특징
    메인 SQL 추출 건수가 적을 경우에는 Filter 동작방식은 불리하지 않다.
    값의 종류가 적을 경우, 최소 값의 종류만큼 서브쿼리가 수행된다.
*/

@clean;

-- 메인 쿼리와 서브 쿼리의 관계과 M:1인 경우
CREATE INDEX orders_idx ON orders(orderdate);
CREATE INDEX customers_idx ON customers(custno, grade);


SELECT orderdate, paytype, status, custno
FROM orders o
WHERE orderdate BETWEEN TO_DATE('20140101', 'YYYYMMDD') AND TO_DATE('20140201', 'YYYYMMDD') - 1
AND EXISTS (SELECT /*+ NO_UNNEST */ 'x' FROM customers c
                  WHERE c.custno = o.custno
                  AND grade = 'VIP');

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


-- 메인 쿼리와 서브 쿼리의 관계과 1:M인 경우
CREATE INDEX customers_idx ON customers(city, grade, gender);
CREATE INDEX orders_idx ON orders(custno, orderdate);

SELECT custno, cname
FROM customers c
WHERE city = '서울'
AND grade = 'VIP'
AND gender = 'M'
AND EXISTS (SELECT /*+ NO_UNNEST */ 'x' FROM orders o
                  WHERE o.custno = c.custno
                  AND orderdate BETWEEN TO_DATE('20140101', 'YYYYMMDD') AND TO_DATE('20141231', 'YYYYMMDD'));

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));



/*
JOIN 동작방식
    조인 동작방식은 Filter 동작 방식에 비해 유연한 대처가 가능합니다.
    조인방법, 조인순서 유리한것을 선택할 수 있습니다.
*/


/*
NL SEMI / ANTI JOIN
    NL SEMI 조인은 메인 쿼리가 먼저 수행한 다음, 서브쿼리가 수행되는 상관 관계 서브쿼리이며, FILTER와 유사
*/

@clean;

CREATE INDEX customers_idx ON customers(city, grade, gender);
CREATE INDEX orders_idx ON orders(custno, orderdate);

SELECT custno, cname
FROM customers c
WHERE city = '서울'
AND grade = 'VIP'
AND gender = 'M'
AND EXISTS (SELECT /*+ UNNEST NL_SJ */ 'x' FROM orders o
                  WHERE o.custno = c.custno
                  AND orderdate BETWEEN TO_DATE('20140101', 'YYYYMMDD') AND TO_DATE('20141231', 'YYYYMMDD'));

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

-- Filter 방식
SELECT custno, cname
FROM customers c
WHERE city = '서울'
AND grade = 'VIP'
AND gender = 'M'
AND EXISTS (SELECT /*+ NO_UNNEST */ 'x' FROM orders o
                  WHERE o.custno = c.custno
                  AND orderdate BETWEEN TO_DATE('20140101', 'YYYYMMDD') AND TO_DATE('20141231', 'YYYYMMDD'));

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/*
1:M 관계인 경우, 공통적으로 서브쿼리 캐싱 효과는 없지만,
NL SJ은 Buffer Pinning 효과로 인하여 더 적은 블록 개수를 읽고 처리한다.
*/

/*
Buffer Pinning ?
    NL SEMI 조인에서는 메인 쿼리에서 공급된 컬럼 값에 해당하는 블록을 버퍼에 유지하기 때문에
    FILTER 서브쿼리보다 I/O 측면에서 유리
*/


/*
HASH SEMI 및 ANTI JOIN
: NL SEMI 조인에서 메인 쿼리에서 공급한 컬럼 값에 중복된 값이 거의 없는 경우, 조인 시도 횟수를 감소시키기 위해 사용
: 즉, 서브쿼리 캐싱 또는 Buffer Pinning 효과를 크게 기대 할 수 없는 경우
: 주로 메인 쿼리와 서브 쿼리의 관계가 1:M 관계인 경우
*/

@clean;

CREATE INDEX customers_idx ON customers(city, grade, gender);
CREATE INDEX orders_idx ON orders(orderdate);

SELECT /*+ LEADING(c o) */ DISTINCT c.custno, c.cname
FROM customers c, orders o
WHERE c.custno = o.custno
AND c.city = '서울'
AND c.grade = 'VIP'
AND c.gender = 'M'
AND o.orderdate BETWEEN TO_DATE('20140101', 'YYYYMMDD') AND TO_DATE('20141231', 'YYYYMMDD');
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


SELECT /*+ LEADING(c o) */ c.custno, c.cname
FROM customers c
WHERE EXISTS (SELECT /*+ UNNEST NL_SJ */ 'x' FROM orders o 
                      WHERE o.orderdate BETWEEN TO_DATE('20140101', 'YYYYMMDD') AND TO_DATE('20141231', 'YYYYMMDD')
                      AND o.custno = c.custno)
AND c.city = '서울'
AND c.grade = 'VIP'
AND c.gender = 'M';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));



SELECT /*+ LEADING(c o) */ c.custno, c.cname
FROM customers c
WHERE EXISTS (SELECT /*+ UNNEST HASH_SJ */ 'x' FROM orders o 
                      WHERE o.orderdate BETWEEN TO_DATE('20140101', 'YYYYMMDD') AND TO_DATE('20141231', 'YYYYMMDD')
                      AND o.custno = c.custno)
AND c.city = '서울'
AND c.grade = 'VIP'
AND c.gender = 'M';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/*
즉, 메인 쿼리와 서브 쿼리의 관계가 1:M 관계이고 메인 쿼리에서 리턴되는 값이 많은 경우에는 HASH SEMI 조인이 유리
단, M:1 관계인 경우에는 메인 쿼리에서 공급되는 컬럼의 값이 많이 중복된 경우, NL SEMI 조인이 유리
*/

