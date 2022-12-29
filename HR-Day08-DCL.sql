/*
DCL( Data Control Languae ) 데이터 제의어
    DCL은 테이블에 데이터를 조작할때 필요한 권한을 조작하는 행위로
    Grant, Revoke가 있습니다.
    
*/

ALTER SESSION SET "_ORACLE_SCRIPT"=true;

-- 사용자 생성하기
CREATE USER scott IDENTIFIED BY tiger;


-- Grant 권한주기
GRANT CREATE SESSION TO scott; -- 데이터베이스에 접근 할 수 있는 권한
REVOKE CREATE SESSION FROM scott; 

GRANT CREATE DATABASE LINK TO scott; 
GRANT CREATE SEQUENCE TO scott;
GRANT CREATE SYNONYM TO scott;
GRANT CREATE TABLE TO scott;
GRANT DROP ANY TABLE TO scott;
GRANT CREATE PROCEDURE TO scott;
GRANT CREATE TRIGGER TO scott;
GRANT CREATE VIEW TO scott;

-- 모든 권한주기
GRANT CONNECT, DBA, RESOURCE TO scott;

-- 권한 해제하기
REVOKE CONNECT, DBA, RESOURCE FROM scott;

-- 사용자 비밀번호 바꾸기
ALTER USER scott IDENTIFIED BY 비밀번호;

-- 롤 권한 조회
SELECT * FROM dba_sys_privs WHERE grantee='SCOTT';


/*
ROLE - 권한 그룹
*/

-- role 생성방법
CREATE ROLE role01;

-- role 권한 할당
GRANT CREATE SESSION, CREATE TABLE, INSERT ANY TABLE TO role01;

-- role 부여
GRANT role01 TO scott;
REVOKE role01 FROM scott;

-- 사용자 삭제하기
DROP USER scott;
DROP USER scott CASCADE;

SELECT * FROM DBA_USERS;

