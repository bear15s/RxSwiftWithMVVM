//
//  RPHomeViewModel.swift
//  RxSwiftWithMVVM
//
//  Created by zbmy on 2018/6/4.
//  Copyright © 2018年 HakoWaii. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Moya

class RPHomeViewModel: NSObject {
    public var extraHeight:Float = 18
    public var template_array = Variable<[Template]>([])
    let disposeBag = DisposeBag()
    
    func fetchHomeViewData(){
//        APIService.requestHomePageData()
        APIService.homePageSubject.single().subscribe{ (event) in
            switch event {
            case .next(let templates):
                self.template_array.value = templates
                break
            case .error(let error):
                print("error : \(error)")
                break
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
        
        APIService.request(.homepage(page: "1", page_size: "20"))
    }
    
}
