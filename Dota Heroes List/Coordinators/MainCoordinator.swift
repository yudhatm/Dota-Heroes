//
//  MainCoordinator.swift
//  Dota Heroes List
//
//  Created by Yudha on 13/10/20.
//  Copyright © 2020 Yudha. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ViewController.instantiate(storyboardName: .main)
        let viewModel = MainViewModel()
        vc.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToHeroDetail(heroModel: HeroRealm, similiarHeroes: [HeroRealm]) {
        let vc = HeroDetailViewController.instantiate(storyboardName: .main)
        vc.heroModel = heroModel
        vc.similiarHeroes = similiarHeroes
        navigationController.pushViewController(vc, animated: true)
    }
}
