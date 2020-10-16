//
//  NetworkManager.swift
//  Dota Heroes List
//
//  Created by Yudha on 14/10/20.
//  Copyright © 2020 Yudha. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import Network

class NetworkManager {
    static var shared = NetworkManager()
    
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    
    var isInternetConnected = false
    
    var header: HTTPHeaders = [:]
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }
    
    //Set headers
    private func setHeaders() -> HTTPHeaders {
        header = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Ciam-Type": "",
            "Channel": "ios",
            "Accept-Language": "id",
            "User-Agent": "duniagames-ios",
            "x-app-version" : appVersion!,
            "x-device": ""
        ]
        return header
    }
    
    func getHero() -> Observable<[Hero]> {
        return getRequest(URLs.BaseURL, parameters: [:])
    }
    
    func getRequest<T: Codable> (_ baseURL: String = "", parameters: [String: Any] = [:]) -> Observable<T> {
        
        return Observable<T>.create { observer in
            let request = AF.request(baseURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: self.setHeaders(), interceptor: nil)
                .responseDecodable { (responseData: AFDataResponse<T>) in
                    switch responseData.result {
                    case .success(let value):
                        print("response: \(value)")
                        if let statusCode = responseData.response?.statusCode, statusCode == 200 {
                            observer.onNext(value)
                            observer.onCompleted()
                        }
                        else {
                            observer.onError(NSError(domain: "networkError", code: responseData.response?.statusCode ?? -1, userInfo: nil))
                        }
                        
                    case .failure(let error):
                        print("Something went error")
                        print(responseData.response?.statusCode)
                        print(error)
                        print(error.localizedDescription)
                        print(responseData.result)
                        
                        observer.onError(error)
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func postRequest<T: Codable> (_ baseURL: String = "", parameters: [String: Any] = [:]) -> Observable<T> {
        
        return Observable<T>.create { observer -> Disposable in
            let request = AF.request(baseURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.setHeaders(), interceptor: nil)
                .responseDecodable { (responseData: AFDataResponse<T>) in
                    switch responseData.result {
                    case .success(let value):
                        print("response: \(value))")
//
                        if let statusCode = responseData.response?.statusCode, statusCode == 200 {
                            observer.onNext(value)
                            observer.onCompleted()
                        }
                        else {
                            observer.onError(NSError(domain: "networkError", code: responseData.response?.statusCode ?? -1, userInfo: nil))
                        }
                        
                    case .failure(let error):
                        print("Something went error")
                        print(responseData.response?.statusCode)
                        print(error)
                        print(error.localizedDescription)
                        print(responseData.result)
                        
                        observer.onError(error)
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Internet connected")
                self.isInternetConnected = true
            }
            else {
                print("No internet")
                self.isInternetConnected = false
            }
        }
    }
    
    func stopNetworkMonitoring() {
        monitor.cancel()
    }
}

