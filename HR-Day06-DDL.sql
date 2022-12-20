/*
DDL(데이터 정의어)
    데이터 베이스 내의 객체(테이블,시퀀스...) 등을 생성하고 변경하고 삭제하기 위해서 사용되는 SQL문
*/

/*

CREATE TABLE 문
    데이터를 저장할 테이블을 생성합니다.
*/

CREATE TABLE dept
        (deptno NUMBER(6),
        dname VARCHAR2(200),
        loc VARCHAR2(200),
        create_date DATE DEFAULT SYSDATE);
    

DESC dept;


/*
데이터유형
    VARCHAR2(size) 가변 길이 문자 데이터 (4000)
    NUMBER(p,s) 가변 길이 숫자 데이터
    CHAR(size) 고정 길이 문자 데이터 (2000)
    DATE 날짜 및 시간 값
    LONG 가변 길이 문자 데이터(최대 2GB)
    CLOB 문자 데이터(최대 4GB)
    RAW and LONG RAW 원시 이진 데이터
    BLOB 바이너리 데이터(최대 4GB)
    BFILE 외부 파일에 저장된 바이너리 데이터(최대 4GB)
    ROWID 테이블에 있는 행의 고유한 주소를 나타내는 base-64 숫자 체계

*/

-- departments 테이블을 dept에 복사하기
INSERT INTO dept SELECT department_id, department_name , location_id, sysdate FROM departments;

-- dept테이블을 dept2에 복사하기
INSERT INTO dept2 SELECT * FROM dept;


-- 테이블 복사하기2 (CTAS 기법) => 제약조건은 복사가 안된다
CREATE TABLE dept3 AS SELECT * FROM dept;

-- 테이블의 구조만 복사 (조건이 항상 거짓이 되는 편법사용)
CREATE TABLE dapt4 AS SELECT * FROM dept WHERE 1=2;



create table dept3
(dept number(2) primary key,
dname varchar2(15) default'영업부',
loc char(1) check(loc in('1','2'))); -- check (loc > 0) 

insert into dept3 values(13,'회계','5');

SELECT  LAST.*
FROM    (SELECT ROWNUM RNUM,
                TEMP.*   
        FROM    (SELECT  dept3.dept
                      ,  dept3.loc
                FROM     dept3
                ) TEMP
        ORDER BY RNUM DESC
        )LAST

