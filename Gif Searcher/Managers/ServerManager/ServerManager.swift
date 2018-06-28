//
//  ServerManager.swift
//  GiphyApi
//
//  Copyright © 2018 Stas Taraseivch. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ServerManager: NSObject {
    
    static let shared = ServerManager()
    typealias Completion = (Bool, JSON, String) -> ()
    let apiKey = "E2bza7f5vk9uulyyWbpTawTlcGRwoLWg"
    
    //MARK: - Get
    
    
    func getTrendingGifs(completion: @escaping Completion) {
        
        Alamofire.request("https://api.giphy.com/v1/gifs/trending", method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["api_key" : apiKey]).response { (response) in
            self.responseHandler(response: response, completion: completion)
        }
    }
    
    func getGif(from id: Int, completion: @escaping Completion) {
        
        Alamofire.request("http://api.giphy.com/v1/gifs/\(id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["api_key" : apiKey]).response { (response) in
            self.responseHandler(response: response, completion: completion)
        }
    }
    
    func gifSearch(stringForSearch: String, completion: @escaping Completion) {
        
        Alamofire.request("https://api.giphy.com/v1/gifs/search", method: .get, parameters: ["q":stringForSearch], encoding: URLEncoding.default, headers: ["api_key" : apiKey]).response { (response) in
            self.responseHandler(response: response, completion: completion)
        }
        
    }
    //MARK: - ResponseHandler
    
    func responseHandler(response: DefaultDataResponse, completion: @escaping Completion){
        let status = response.response?.statusCode
        let data = response.data
        if let status = status {
            if status == 200 || status == 201 {
                if let data = data {
                    let json =  JSON(data: data)
                    completion(true, json, "")
                } else {
                    completion(true, [], "")
                }
            } else if status >= 500 {
                completion(false, "", "Сервер не работает")
            } else{
                
                if let data = data {
                    let json =  JSON(data: data)
                    print(json)
                    if let message = json["detail"].string{
                        completion(false, json, message)
                    } else {
                        completion(false, json, "Unknown error")
                    }
                }
                completion(false, [], "Unknown error")
            }
        }
    }
}

