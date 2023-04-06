/* 인덱스의 종류 :
    B-tree 인덱스, 여기서 B는 Balance라는 의미
    비트맵 인덱스,
    IOT,
    클러스터형 인덱스
*/

-- 테이블을 생성할 때 오브젝트를 생성한다 라고 말하지만
-- 인덱스도 생성할 때 오브젝트를 생성한다 라고 말한다.

-- 인덱스가 생성되면 테이블과 매핑되는 또 다른 테이블이 하나 생성된다라고 생각하면 된다.

-- 인덱스의 저장방식 :
-- 인덱스 컬럼을 기준으로 소팅이 되어서 저장이 되어 있습니다.
-- 보통 테이블은 데이터들이 물리적으로 흩어져서 저장되어 있어서
-- 어떤 특정 조건의 데이터들을 찾으려면
-- 테이블 풀 스캔을 한다고 하잖아요 그래서
-- 만약에 테이블 안의 데이터들이 매우 방대 하다면 굉장히 많은시간이 소요 된다.
-- 하지만, 인덱스는 정렬되어서 저장이 되어 있기 때문에 특정 조건의 데이터들을 검색을 할 때
-- 시작점을 지정을해서 거기서부터 스캔을 할 수가 있는 거에요.
-- 테이블과 인덱스가 매핑되어 있다고 했잖아요 그래서
-- 인덱스에서 먼저 데이터들을 찾은 다음에 그 테이블로 매핑된 곳을 가서 나머지 데이터들을 꺼내오는 방식인거에요
-- 매핑 방식은 객체지향에서 포인터 처럼 인덱스가 해당 테이블의 블럭에 주소를 가지고 있다고 생각하시면 되는데요
-- 여기서 블럭은 데이터가 저장되는 최소 단위이고, 거기엔 테이블의 데이터들이 로우 단위로 저장이 되어 있어요
-- 만약에 테이블의 컬럼수가 되게 많다면 하나의 블럭에 저장되는 로우수가 적어지겠고
-- 만약에 테이블의 컬럼수가 적다면 하나의 블럭에 저장되는 로우 수가 많아지겠죠


-- [ 어떤 컬럼을 인덱스로 설정을해야 효율적일까요? ]
-- 아까 특정 조건부터 스캔을 한다고 했었잖아요
-- 조건 ~ 하면 where절이죠.
-- where절에 자주 등장하는 컬럼을 인덱스로 설정해주면 효율적이겠죠
-- 그리고 두번째로는 order by 절
-- order by절에 자주 등장하는 컬럼을 인덱스로 지정을 해놓으면,
-- 인덱스는 소팅이 되어서 저장되어 있다고 했기 때문에
-- 별도로 order by를 수행할 필요 없이 인덱스에서 바로 꺼내서
-- 출력을 하면 되니까 효율적이겠죠.
-- 그리고 인덱스는 단일 컬럼으로 구성할 수도 있지만, 여러 컬럼을 조합해서 결합 인덱스로 구성을 할 수도 있어요.
-- 그럴 경우에는 select절에 등장하는 컬럼들을 잘 조합을 해서 인덱스로 구성을 해 놓으면
-- 별도로 테이블에 가서 데이터를 꺼내올 필요 없이 
-- 그냥 인덱스만 스캔을 해서 바로 출력을 하면 되니까, 되게 빠르게 되겠죠.

-- [ 인덱스의 단점 ]
-- 그런데 이렇게 좋다고해서 인덱스를 마구잡이로 생성하시면 안됩니다.
-- 아까 인덱스가 오브젝트라고 했잖아요.
-- SELECT절은 빨라질 지 몰라도 INSERT나 UPDATE는 속도가 오히려 느려져요.
-- 왜냐하면, 특히 INSERT 같은 경우에는 인덱스가 정렬이 된 상태로 저장이 되어야 하기 때문에
-- 어느자리에 INSERT를 할지 찾아서 저장을 할거 잖아요.
-- 그리고 테이블에만 INSERT나 UPDATE를 하는게 아니라
-- 인덱스도 똑같이 해줘야 하기 때문에, 두군데에다가 하니까 오히려 느려지겠죠.
-- 결합인덱스 같은 경우에는 결합하는 컬럼들의 순서가 되게 중요한데요.
-- where절에서 equal 조건으로 많이 쓰이는 컬럼들이 앞으로 오는게 효율적이고
-- 그리고 분별력이 높은 컬럼이 앞으로 오는게 효율적입니다.
-- 예컨대 성별 같은 컬럼보다는 아이디 같이 분별력이 높은 컬럼이 앞으로 와야지 바로 인덱스를 스캔해서 찾을 수 있겠죠.
-- 그리고 이렇게 애써 인덱스를 생성해 놓고도 SQL을 잘못 작성을 해서 무용지물이 되는 경우가 있어요.
-- 이런 경우에 대해서는 제가 정리를 해봤으니 참고해주시면 될것 같습니다.

-- [ 1. 인덱스 컬럼을 가공 ]
-- EX ) WHERE SUBSTR(ORDER_NO, 1, 4) = '2019' => WHERE ORDER_NO LIKE '2019%'

-- [ 2. 인덱스 컬럼의 묵시적 형변환 ] ( 같은 타입으로 비교해야 함 )
-- EX ) WHERE REG_DATE = '20190730'              => WHERE REG_DATE = TO_DATE('20190730', 'YYYYMMDD')

-- [ 3. 인덱스 컬럼 부정형 비교 ]
-- EX ) WHERE MEM_TYPE != '10'                     => WHERE MEM_TYPE IN ('20', '30')

-- [ 4. LIKE 연산자 사용 시 %가 앞에 위치 ]

-- [ 5. OR 조건 사용 ]                                    => UNION ALL로 대체


-- [ 인덱스의 스캔 방식 ]
-- 덧붙여 설명을 하자면 인덱스 스캔 방식에도 여러가지가 있는데요.
-- 아까 잠깐 설명을 드렸던, 어떤 시작점부터 특정범위를 스캔하는 방식을
-- INDEX RANGE SCAN 이라고 하구요,
-- 그 다음에 INDEX FULL SCAN 도 있고,
-- INDEX SKIP SCAN, INDEX FAST FULL SCAN도 있으니까 참고하시면 좋을것 같습니다.
-- 그리고 인덱스를 탄다고 해서 무조건 속도가 빨라지는건 아니에요.
-- 인덱스 손익 분기점이라는게 있는데, 테이블이 가지고 있는 전체 데이터양의 10에서 15프로
-- 이내의 데이터가 출력이 될때만 인덱스를 타는게 효율적이고,
-- 그 이상이 될 때에는 오히려 풀스캔을 하는게 더 빠릅니다.


-- [ 옵티마이저 ] 
-- 옵티마이저는 기본적으로 최적의 실행계획을 도출하도록 설계가 되어이기 때문에
-- 인덱스가 타는게 더 효율적이라고 판단이 되면은 알아서 타게 되어있어요.
-- 저번에 인덱스 손익분기점 이라는 것에 대해 이야기 했었죠
-- 옵티마이저는 CBO라고 해서 실행을 할때 비용이 덜 드는 방향으로
-- 풀스캔을 하든 인덱스 스캔을 하든 다 알아서 해줍니다.
-- 다만 한 테이블에 인덱스가 너무 많이 생성되어 있다고 할 경우에는
-- 옵티마이저가 가끔씩 미쳐가지고 판단미스를 할 때가 있어요
-- 그럴 때 힌트를 사용해서 이 인덱스를 꼭 타라고 쐐기 박아주면 됩니다.
