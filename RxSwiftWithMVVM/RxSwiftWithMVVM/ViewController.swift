//
//  ViewController.swift
//  RxSwiftWithMVVM
//
//  Created by zbmy on 2018/6/4.
//  Copyright © 2018年 HakoWaii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
    }

    
    @IBAction func push(_ sender: UIButton) {
        let homeVC = RPHomeVC()
//        let nav = UINavigationController.init(rootViewController: homeVC)
        self.navigationController?.pushViewController(homeVC, animated: true)
//        self.present(homeVC, animated: true) {
//
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



