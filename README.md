# NetworkModule
iOS PromiseKit + Alamofire을 이용한 Network 설계


example
  firstly {
       NetRequest.userInfo(nil)
  }.done {[weak self] in
       self?.test1Txt.text = String(describing: $0)
  }.catch {
       print("error : \($0)")
  }
