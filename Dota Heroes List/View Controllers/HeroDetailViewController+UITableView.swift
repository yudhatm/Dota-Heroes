//
//  HeroDetailViewController+UITableView.swift
//  Dota Heroes List
//
//  Created by Yudha on 15/10/20.
//  Copyright © 2020 Yudha. All rights reserved.
//

import Foundation
import UIKit

extension HeroDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return heroModel.roles.count
        }
        
        if section == 1 {
            return 7
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView(reuseIdentifier: "headerView")
        
        switch section {
        case 0:
            headerView.textLabel?.text = "Role"
            
        case 1:
            headerView.textLabel?.text = "Attributes"
            
        default:
            break
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        if indexPath.section == 0 {
            let role = heroModel.roles[indexPath.row]
            
            cell.textLabel?.text = role
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Attack Type: \(heroModel.attackType)"
                
            case 1:
                cell.textLabel?.text = "Health: \(Int(heroModel.baseHealth))"
                
            case 2:
                cell.textLabel?.text = "Base Damage: \(heroModel.baseMinAttack) - \(heroModel.baseMaxAttack)"
                
            case 3:
                cell.textLabel?.text = "Speed: \(heroModel.moveSpeed)"
                
            case 4:
                cell.textLabel?.text = "Str: \(Int(heroModel.baseStr))"
                
            case 5:
                cell.textLabel?.text = "Agi: \(Int(heroModel.baseAgi))"
                
            case 6:
                cell.textLabel?.text = "Int: \(Int(heroModel.baseInt))"
                
            default:
                break
            }
        }
        
        return cell
    }
}

