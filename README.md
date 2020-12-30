# NetworkModule
iOS HTTP Server 통신 구조 설계 
- PromiseKit + Alamofire + Codable
- Promise pipe를 이용한 Exception 자동 재요청
- Server 예외에 대한 일괄처리
- 확장성, 캡슐화 용이
- simple
```
firstly {
    NetRequest.testJson(["name": "wooky"])
}
.done {
    print("result is \($0)")
}
.catch {
    print("error is : \($0)")
}
```
