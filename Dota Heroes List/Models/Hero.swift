//
//  Hero.swift
//  Dota Heroes List
//
//  Created by Yudha on 14/10/20.
//  Copyright © 2020 Yudha. All rights reserved.
//

import Foundation

class Hero: Codable {
    var id: Int
    var name: String
    var localizedName: String
    var attackType: String
    var roles: [String]
    var image: String
    var icon: String
    
    //Hero Attributes
    var primaryAttribute: String
    var baseHealth: Double
    var baseMana: Double
    var baseMinAttack: Double
    var baseMaxAttack: Double
    var moveSpeed: Double
    var baseStr: Double
    var baseAgi: Double
    var baseInt: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case localizedName = "localized_name"
        case attackType = "attack_type"
        case roles
        case image = "img"
        case icon
        
        case primaryAttribute = "primary_attr"
        case baseHealth = "base_health"
        case baseMana = "base_mana"
        case baseMinAttack = "base_attack_min"
        case baseMaxAttack = "base_attack_max"
        case moveSpeed = "move_speed"
        case baseStr = "base_str"
        case baseAgi = "base_agi"
        case baseInt = "base_int"
    }
}
