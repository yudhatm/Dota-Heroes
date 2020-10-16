//
//  Coordinator.swift
//  Dota Heroes List
//
//  Created by Yudha on 13/10/20.
//  Copyright © 2020 Yudha. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
