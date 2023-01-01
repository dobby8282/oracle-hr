/*
FILTER 서브쿼리
: 상관관계 서브쿼리
: 메인 쿼리의 컬럼이 서브 쿼리의 조인 절에서 참조
: 메인 쿼리가 먼저 수행되고 서브 쿼리의 조인 키에 해당하는 값을 받아서 수행
*/

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
FILTER 서브쿼리의 활용
: 조인 수행 시, SELECT 절에서 참조되지 않는 테이블은 FILTER 서브쿼리로 변경하여 서브쿼리 캐싱 효과를 얻을 수 있다.
: 또한, 서브쿼리 캐싱 효과를 극대화하려면 M:1 관계에서 1쪽 테이블이 서브쿼리로 되어야 서브쿼리로 전달되는 값이 많이 중복되어 캐시 효과가 극대화된다.
: 참고로 아웃터 조인 수행시, SELECT 절에서 참조되지 않는 테이블의 경우에는 SELECT 절의 스칼라 서브쿼리로 변경한다.
*/

