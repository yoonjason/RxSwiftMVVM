Rxswift 정리

RxSwift 비동기로 생기는 결과값을 completion으로 전달하는게 아니라(클로져)
return값으로 전달해주기 위해서 생긴 유틸리티이다.

비동기로 생기는 데이터를 retrun 값으로 전달해준다.
나중에 생기는 데이터 class

비동기로 생기는 데이터를 return 값으로 전달하기 위해서
나중에 생기는 데이터 Observable 이라는 class로 감싸서 전달한다.




Observable -> 나중에 생기는 데이터
Observable를 만들어서 리턴하는데 만들 때는 create()를 만든다.
바로 전달하는게 아니라 
onNext라고 하는 메소드를 통해서 리턴하게 된다.

Subscribe-> 데이터가 나중에 오면! 이벤트가 온다.
Next, error, complete  3개 온다.



Observable형태로 감싸서 리턴하면 나중에 생기는 데이터다.
나중에 생기는 데이터를 사용할 때는 나중에 오면을 호출하면 된다. (Subscribe)
그러면 event가 오는 데, event는 next, error, complete

Error -> 에러
Complete -> 데이터가 전달되고 끝났을 때
Next-> 데이터가 전달될 때

순환참조는 weak self
클로져에서 self를 사용을 하게되면 레퍼런스 카운트가 올라가기 때문에,
순환참조가 발생할 수 있지만

발생했다가 사라지게 하는 방법은 complete시키면 역할을 다했다고 생각해서 
onNext를 주고나서 onCompleted로 해주면 클로져의 역할은 끝났기 때문에 스스로 사라진다.
그러므로 레퍼런스 카운트가 사라지게된다.
쿨로저가 들고있는 self의 레퍼런스카운트가 사라진다.


1. 비동기로 생기는 데이터를  Observable로 감싸서 리턴하는 방법
2.  Observable로 오는 데이터를 받아서 처리하는 방법
3. 


Observable의 crate를 한다.
거기에 에러를 호출하거나 next로해서 데이터를 전달하거나 혹은 complete으로 종료를 시킨다.
취소됏을 때 해야하는 행동이 있다면
Observable을 create해서 return하는 그 사이에 취소했을 때 해야되는 행동을 집어넣어준다.

onnext는 여러개 전달이 되도 된다.
Observable의 끝은 complete이 불렸을 때 끝난다.

Create -> subscribe -> next로 데이터 전달 되다가 -> complete되면서 끝난다.


Observable의 생명주기
1.  Create
2.  Subscribe
3. onNext  
4.  ----  끝 ———
5. onCompleted  / onError 에러가 나도 끝난다.
6. Disposed

주의사항
한 번 만들어진 Observable은 Subscribe에 의해서 동작이 시작되고,
한 번 Subscribe에 의해서 동작이 시작되면 complete 이나 error나 dispose에 의해서 동작이 끝난다.
동작이 끝난 Observable은 다시 재사용이 불가하다.
한 번 complete되거나 error로 끝난 애들은 다시 재사용이 되지않는다.

Create 됐다고 해서 모든 데이터가 생성이 되거나 전달이 되거나 하지않는다.
Observable은 Subscribe됐을 때 동작한다. -> create안에 클로져가 실행된다.

subscribe에 의해서 결과가 리턴된다.





추가적인 귀찮은 것들을 없애주는 것이 있다.


56분 17초부터 다시 듣기
