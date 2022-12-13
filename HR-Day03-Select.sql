/*
SQL (Structured Query Language) - 구조적 질의 언어
    관계형 데이터베이스 시스템(RDBMS)에서 자료를 관리 및 처리하기 위해 설계된 언어

SQL문 작성
    SQL 문은 따로 지정하지 않는 한 대소문자를 구분하지 않는다.
    SQL 문은 한 줄 또는 여러 줄에 입력할 수 있다.
    키워드는 여러 줄에 걸쳐 입력하거나 약어로 표기할 수 없다.
    절은 일반적으로 읽기 쉽고 편집하기 쉽도록 별도의 행에 둔다.
    코드의 가독성을 높이기 위해 들여쓰기를 사용.

SELECT 
    데이터베이스에서 정보를 검색

*/

-- 모든 열 선택 *
SELECT *
FROM departments;

-- 특정 열 선택
SELECT department_id, location_id
FROM departments;





