[![Build](https://github.com/wooky83/NetworkModule/actions/workflows/Build.yml/badge.svg)](https://github.com/wooky83/NetworkModule/actions/workflows/Build.yml)
# NetworkModule :sunglasses:
iOS HTTP Server 통신 구조 설계
1. PromiseKit + Alamofire 
- PromiseKit + Alamofire + Codable
- Promise pipe를 이용한 Exception 자동 재요청
- Server 예외에 대한 일괄처리
- 확장성, 캡슐화 용이
- simple
```
firstly {
    NetRequest.testJson<PersonBean>(["name": "wooky"])
}
.done {
    print("result is \($0)")
}
.catch {
    print("error is : \($0)")
}
```

2. Combine + URLSession
- 확장성, 캡슐화 용이
- simple
```
Service
    .jsonplaceholderUser()
    .sink(receiveCompletion: { completion in                
    }, receiveValue: { model in
    })
    .store(in: &self.cancellables)
```

3. Rxswift + RxAlamofire 
- 확장성, 캡슐화 용이
- simple
```
Service
    .rxAlamofireSuccess()
    .subscribe(onNext: { model in
    })
    .disposed(by: self.disposeBag)
```
