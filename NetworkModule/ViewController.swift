//
//  ViewController.swift
//  NetworkModule
//
//  Created by wooky83 on 14/12/2018.
//  Copyright © 2018 wooky. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func test1BtnClicked(_ sender: UIButton) {
        firstly {
            NetRequest.userInfo(["q": "wooky83"])
        }
        .done {
            print("testJson is \($0)")
        }
        .catch { error in
            print("error : \(error)")
        }
        .finally {
            print("finally")
        }
    }
    
    @IBAction func test2BtnClicked(_ sender: UIButton) {
        firstly {
            NetRequest.testPostJson(["name": "sung"])
        }
        .done {
            print("testJson is \($0)")
        }
        .cauterize()
    }
    
  
    @IBAction func test3BtnClicked(_ sender: UIButton) {
        firstly {
            NetRequest.testJson(["name": "wooky"])
        }
        .done {
            print("testJson is \($0)")
        }
        .catch {
            print("error : \($0)")
        }
    }
    
    @IBAction func test4BtnClicked(_ sender: UIButton) {
        firstly {
            NetRequest.testAuthJson(nil)
        }
        .done {
            print("testJson is \($0)")
        }
        .catch {
            print("error : \($0)")
        }
    }
 
    @IBAction func test5BtnClicked(_ sender: UIButton) {
        firstly {
            NetRequest.jsonplaceholderUser(nil)
        }
        .done {
            print("jsonplaceholderUsers is \($0.userId)")
        }
        .catch {
            print("jsonplaceholderUsers : \($0)")
        }
    }
}

