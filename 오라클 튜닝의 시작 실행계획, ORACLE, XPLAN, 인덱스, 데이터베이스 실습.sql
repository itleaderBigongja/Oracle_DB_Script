-- ┌────────────────────────────────
-- │ 튜닝의 시작 실행계획, ORACLE, XPLAN, 인덱스, 데이터베이스 실습
-- └────────────────────────────────

-- ALTER SESSION SET STATISTICS_LEVEL=ALL;" 명령은 
-- 현재 세션에서 모든 SQL 문의 성능 통계 정보를 수집하도록 설정하는 Oracle 데이터베이스 명령
ALTER SESSION SET STATISTICS_LEVEL=ALL;

-- 인덱스 생성 후 조회 => 실행 계획표 실행
SELECT * FROM MEMBER WHERE ID = 'takyou';

-- MEMBER 테이블의 ID컬럼을 인덱스 키로 잡아서 인덱스 생성
CREATE INDEX INDEX_MEM ON MEMBER(ID);

-- 실행 계획표
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

-- ┌───────────────
-- │ 실행계획표 보는 방법
-- └───────────────
/*
    실행 계획표는 밑에서부터 읽으면 된다.
    밑에서부터 차례차례 해석해서 읽어오면 된다.
    
    1. ID로 식별됨
    2. ID컬럼의 데이터가 'takyou'로 접근
    3. 순서 보여주기
    4. [2]. INDEX RANGE SCAN로 찾았다.
    5. [1]. 인덱스 행 ID 배치에 의한 테이블 액세스
    6. [0]. SELECT 문 선택
*/

/*  오라클의 인덱스 스캔 종류 :
    오라클에서 INDEX SCAN은 데이터베이스 쿼리의 실행 계획을 결정하는 데 중요한 역할을 합니다.
    인덱스는 데이터를 빠르게 찾을 수 있도록 키 - 값 쌍을 저장하는 자료 구조 입니다.
    
    INDEX FULL SCAN :
    인덱스 풀 스캔은 전체를 스캔하여 조건에 맞는 모든 레코드를 찾는 방법 입니다.
    이 방법은 인덱스의 높은 selectivity(고유성)를 가지는 컬럼을 조회할 때 유용 합니다.
    하지만 인덱스의 모든 블록을 스캔하기 때문에 대량의 데이터를 조회할 때는 비효율적일 수 있습니다.
    
    INDEX RANGE SCAN :
    인덱스 범위 스캔은 인덱스에서 특정 범위에 해당하는 레코드를 찾는 방법 입니다.
    이 방법은 WHERE 조건절에 범위 연산자( >, <, BETWEEN 등 )가 사용되는 경우 유용 합니다.
    인덱스의 특정 블록만을 스캔하기 때문에 인덱스 풀 스캔보다 빠를 수 있습니다.
    
    INDEX SKIP SCAN :
    인덱스에서 첫 번째 컬럼에 대한  조건이 있는 경우, 그리고 
    두번째 컬럼은 인덱스의 두 번째 블록에서만 값을 가지는 경우에 사용 됩니다.
    이 방법은 두 번째 컬럼의 값이 높은 selectivity를 가지는 경우 유용합니다. 
    인덱스의 일부 블록만을 스캔하기 때문에 인덱스 범위 스캔보다 더 빠를 수 있습니다.
*/