//
//  MainViewModel.swift
//  Dota Heroes List
//
//  Created by Yudha on 14/10/20.
//  Copyright © 2020 Yudha. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelType {
    var heroObservable: Observable<[Hero]> { get }
    var errorObservable: Observable<Error> { get }
}

final class MainViewModel: MainViewModelType {
    init() {
        getHeroes()
    }
    
    var disposeBag = DisposeBag()
    
    lazy var heroObservable: Observable<[Hero]> = self.heroSubject.asObservable()
    lazy var errorObservable: Observable<Error> = self.errorSubject.asObservable()
    
    var heroSubject = PublishSubject<[Hero]>()
    var errorSubject = PublishSubject<Error>()
    
    func getHeroes() {
        let baseURL = URLs.BaseURL
        
        let observer = NetworkManager.shared.getHero()
        
        observer.subscribe(onNext: { hero in
            print(hero)
            
            print(hero.count)
            
            self.heroSubject.onNext(hero)
        }, onError: { error in
            print(error)
            self.errorSubject.onNext(error)
        }, onCompleted: {
            print("completed")
        })
        
        .disposed(by: disposeBag)
    }
}
