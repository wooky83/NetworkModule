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

    @IBOutlet weak var test1Btn: UIButton!
    @IBOutlet weak var test2Btn: UIButton!
    @IBOutlet weak var test1Txt: UITextView!
    @IBOutlet weak var test2Txt: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func test1BtnClicked(_ sender: UIButton) {
        firstly {
            NetRequest.userInfo(nil)
        }
        .done {[weak self] in
            self?.test1Txt.text = String(describing: $0)
        }
        .catch {
            print("error : \($0)")
        }
    }
    
    @IBAction func test2BtnClicked(_ sender: UIButton) {
        firstly {
            NetRequest.users()
        }
        .done {[weak self] in
            self?.test2Txt.text = String(describing: $0)
        }
        .catch {
            print("error : \($0)")
        }
    }
}

