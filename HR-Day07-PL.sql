/*
PL/SQL(Procedural Language extension to SQL)
    SQL을 확장한 절차적 언어입니다.
    여러 SQL을 하나의 블록(Block)으로 구성하여 SQL을 제어할 수 있습니다.
 
익명프로시저 - DB에 저장 되지 않습니다.
[기본 구조]
    DECLARE --변수 정의
    BEGIN -- 처리 로직 시작
    EXCEPTION -- 예외 처리    
    END -- 처리 로직 종료
*/
--
--select * from departments;

--실행 결과를 출력하도록 설정
SET SERVEROUTPUT ON
 
--스크립트 경과 시간을 출력하도록 설정
SET TIMING ON
 
 
DECLARE
--변수를 정의하는 영역
    /**
     * PL/SQL에서 사용할 변수를 정의.
     * IDENTIFIER [CONSTANT] DATATYPE [NOT NULL] [DEFAULT 값];
     */
     
    V_STRD_DT       VARCHAR2(8);
    
    V_STRD_DEPTNO   NUMBER;
    
    V_DEPTNO        NUMBER;
    V_DNAME         VARCHAR2(50);
    V_LOC           VARCHAR2(50);
    
    V_RESULT_MSG    VARCHAR2(500) DEFAULT 'SUCCESS';
 
BEGIN
--작업 영역
    /**
     * DEPTNO가 10인 부서의 부서번호, 부서명, 지역을 조회.
     */
    
    --기준일자 - 내장함수 사용.
    V_STRD_DT := TO_CHAR(SYSDATE, 'YYYYMMDD');
    
    --조회 부서번호 변수 설정
    V_STRD_DEPTNO := 10;
    
    BEGIN
        --조회 - INTO절로 조회된 데이터 저장.
        SELECT T1.department_id
             , T1.department_name
             , T1.location_id
          INTO V_DEPTNO
             , V_DNAME
             , V_LOC
          FROM departments T1
         WHERE T1.department_id = V_STRD_DEPTNO
        ;
    END
    ;
 
    --조회 결과 변수 설정
    V_RESULT_MSG := 'RESULT > DEPTNO='||V_DEPTNO||', DNAME='||V_DNAME||', LOC='||V_LOC;
    
    --조회 결과 출력
    DBMS_OUTPUT.PUT_LINE( V_RESULT_MSG );
    
EXCEPTION
--예외 처리
    WHEN VALUE_ERROR THEN 
        V_RESULT_MSG := 'SQLCODE['||SQLCODE||'], VALUE_ERROR_MESSAGE =>'||SQLERRM;
        
        DBMS_OUTPUT.PUT_LINE( V_RESULT_MSG );
    WHEN OTHERS THEN
        V_RESULT_MSG := 'SQLCODE['||SQLCODE||'], MESSAGE =>'||SQLERRM;
        
        DBMS_OUTPUT.PUT_LINE( V_RESULT_MSG );
        

END
;
--작업 종료


/*
프로시져 

[기본구조]
CREATE OR REPLACE PROCEDURE 프로시져이름 (파라미터1,파라미터2...);
    IS [AS]
        [선언부]
    BEGIN
        [실행부 - PL/SQL Block]
    [EXCEPTION]
        [EXCEPTION 처리]
END;
*/

-- 예제 emp 테이블 생성
CREATE TABLE emp AS
SELECT * FROM employees;

-- 프로시저 : 이름, 매개변수, 반환값(x)
CREATE OR REPLACE PROCEDURE print_hello_proc -- 매개 변수가 없으면 () 생략
    IS  -- 프로시저의 시작
        msg VARCHAR2(20) := 'hello world'; -- 변수 초기값 선언
    BEGIN  -- 문장의 시작
        DBMS_OUTPUT.PUT_LINE(msg);   
    END;   -- 문장의 끝
-- 프로시저 종료

EXEC print_hello_proc;


-- IN 매개변수
-- IN : 값이 프로시저 안으로 들어감
CREATE OR REPLACE PROCEDURE update_emp_salary_proc(eno IN NUMBER ) IS
    BEGIN
        UPDATE emp SET salary = salary*1.1
        WHERE employee_id = eno;
        COMMIT;
    END;

-- 3100   
SELECT * FROM emp 
WHERE employee_id = 115;
    
-- 3410    
EXEC update_emp_salary_proc(115);


-- OUT 매개변수
-- OUT : 프로시저는 반환값이 없으므로 OUT 매개변수를 활용
-- 사원 번호를 넣으면 사원명과 급여 반환
CREATE OR REPLACE PROCEDURE find_emp_proc(v_eno IN NUMBER, 
    v_fname OUT NVARCHAR2, v_lname OUT NVARCHAR2, v_sal OUT NUMBER)
IS
    BEGIN
        SELECT  first_name, last_name, salary 
        INTO v_fname, v_lname, v_sal
        FROM employees WHERE employee_id = v_eno;
    END;

VARIABLE v_fname NVARCHAR2(25);
VARIABLE v_lname NVARCHAR2(25);
VARIABLE v_sal NUMBER(8,2);

EXECUTE find_emp_proc(115,:v_fname,:v_lname,:v_sal);
PRINT v_fname;
PRINT v_lname;
PRINT v_sal;

--IN OUT 매개 변수
--매개변수로 시작하고 반환변수로 끝난다.
--프로시저가 다른 프로시저 호출 후 반환값을 보여줄때 사용
CREATE OR REPLACE PROCEDURE find_sal(v_eno IN OUT NUMBER) 
IS
    BEGIN
    SELECT salary
    INTO v_eno
    FROM employees WHERE employee_id = v_eno;
END;

DECLARE
    v_eno NUMBER := 115;
    BEGIN
    DBMS_OUTPUT.PUT_LINE('eno= '||v_eno);
    find_sal(v_eno);
    DBMS_OUTPUT.PUT_LINE('eno= '||v_eno);

    END;

VAR v_eno NUMBER;
EXEC :v_eno:=115;
PRINT v_eno;
EXEC find_sal(:v_eno);
PRINT v_eno;


/*
함수(Function)
    특정 기능들을 모듈화, 재사용 할 수 있어서 복잡한 쿼리문을 간결하게 만들수 있습니다.


[기본구조]
CREATE [OR REPLACE] FUNCTION function_name [(
    파라미터1,파라미터2...
)]
RETURN datatype -- 반환되는 값의 datatype
    IS [AS]
        [선언부]
    BEGIN
        [실행부 - PL/SQL Block]
    [EXCEPTION]
        [EXCEPTION 처리]
    RETURN 변수; -- 리턴문 필수
END;
*/

CREATE OR REPLACE FUNCTION FN_GET_DEPT_NAME(
	P_DEPT_NO IN NUMBER
) RETURN VARCHAR2
	IS 
		V_TEST_NAME VARCHAR2(30);
	BEGIN
		SELECT	department_name
		INTO	V_TEST_NAME
		FROM 	departments
		WHERE	department_id = P_DEPT_NO;
		
	RETURN  	V_TEST_NAME;
END;

SELECT FN_GET_DEPT_NAME(10) FROM DUAL;


/*
트리거(TRIGGER)
    INSERT, UPDATE, DELETE문이 TABLE에 대해 행해질 때 묵시적으로 수행되는 프로시저 입니다.

[기본구조]
CREATE OR REPLACE TRIGGER 트리거명
    - 트리거 옵션
    BEFORE OR AFTER
    INSERT OR UPDATE OR DELETE ON 테이블명
    [FOR EACH ROW]
DECLARE
    선언부;
BEGIN
    실행부;
    [INSERTING, UPDAING, DELETING] ****
[EXCEPTION]
    예외처리부
END;
*/
CREATE TABLE dept5
        (deptno NUMBER(6) primary key,
        dname VARCHAR2(200),
        loc VARCHAR2(200),
        create_date DATE DEFAULT SYSDATE,
        update_date DATE DEFAULT SYSDATE
        );
    
select * from dept5;

-- 직원테이블 수정 시 시스템시간으로 수정일시 업데이트
CREATE OR REPLACE TRIGGER TRIGGER1_dept5
	BEFORE UPDATE ON dept5
	FOR EACH ROW
	BEGIN
		:new.update_date := SYSDATE;
	END;
    
    
update dept5 set
dname = 'BBBB'
where deptno =2;