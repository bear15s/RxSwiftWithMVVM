//
//  APIService.swift
//  RxSwiftWithMVVM
//
//  Created by zbmy on 2018/6/27.
//  Copyright © 2018年 HakoWaii. All rights reserved.
//

import UIKit
import Moya
import RxSwift

protocol Publishable {
    
}

class APIService: NSObject {
    static let provider = MoyaProvider<API>.init()
    static let disposeBag = DisposeBag()
    static let commonSubject = PublishSubject<Any>()
    static let homePageSubject = PublishSubject<Array<Template>>()
    
    public class func publish(_ obj:Publishable){
        commonSubject.onNext(obj)
    }
    
    public class func request(_ apiType:API) -> (){
        provider.rx.request(apiType).subscribe { (event) in
            switch event {
            case .success(let element):
                // json to Dictionary
//                let dic:Dictionary<String, Any>? = try? JSONSerialization.jsonObject(with: element.data, options: .mutableContainers) as! Dictionary<String, Any>
                
                // Dictionary to models
                switch apiType {
                case .homepage(page: _, page_size: _):
                    
                    guard let jsonStr:String = String.init(data: element.data, encoding: .utf8) else{
                        return
                    }

                    guard let templates:[Template] = [Template].deserialize(from: jsonStr, designatedPath: "result.list") as? [Template] else {
                        return;
                    }
                    
                    APIService.homePageSubject.onNext(templates)
                    break
 
                }
                break
            case .error(let error):
                print("Error:\(apiType),Info:\(error)")
                break
            }
        }.disposed(by: disposeBag)
    }
    
    
}

enum API {
    case homepage(page:String,page_size:String)
}



extension API:TargetType{
    
    
    static let disposeBag = DisposeBag()
    
    var method: Moya.Method {
        return Moya.Method.get
    }
    
    // 测试用的数据
    var sampleData: Data {
        return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return Task.requestPlain
    }
    
    var headers: [String : String]? {
        return ["x-api-version":"7","Content-Type":"application/json"]
    }
    
    var baseURL: URL {
        switch self {
     
        default:
            return URL.init(string: "http://testappapi.rabbitpre.com")!
        }
    }
    
    var path: String {
        switch self {
        case .homepage(page: _, page_size: _):
            return "/market/esee/template/recommend_list"//?page=1&page_size=20
        }
    }
   
    var parameter:[String:Any]?{
        switch self {
        case .homepage(page: let page, page_size: let page_size):
            return ["page":page,"page_size":page_size]
        }
    }
    
//    var validationType: ValidationType { get }
}
