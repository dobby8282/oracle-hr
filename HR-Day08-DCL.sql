/*
DCL( Data Control Languae ) 데이터 제의어
    DCL은 테이블에 데이터를 조작할때 필요한 권한을 조작하는 행위로
    Grant, Revoke가 있습니다.
*/

ALTER SESSION SET "_ORACLE_SCRIPT"=true;

-- 사용자 생성하기
CREATE USER scott IDENTIFIED BY tiger;
-- Grant 권한주기
