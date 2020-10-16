//
//  HeroRealm.swift
//  Dota Heroes List
//
//  Created by Yudha on 16/10/20.
//  Copyright © 2020 Yudha. All rights reserved.
//

import Foundation
import RealmSwift

class HeroRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var localizedName: String = ""
    @objc dynamic var attackType: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var icon: String = ""
    
    let roles = List<String>()
    
    //Hero Attributes
    @objc dynamic var primaryAttribute: String = ""
    @objc dynamic var baseHealth: Double = 0.0
    @objc dynamic var baseMana: Double = 0.0
    @objc dynamic var baseMinAttack: Double = 0.0
    @objc dynamic var baseMaxAttack: Double = 0.0
    @objc dynamic var moveSpeed: Double = 0.0
    @objc dynamic var baseStr: Double = 0.0
    @objc dynamic var baseAgi: Double = 0.0
    @objc dynamic var baseInt: Double = 0.0
    
    convenience init(hero: Hero) {
        self.init()
        
        self.id = hero.id
        self.name = hero.name
        self.localizedName = hero.localizedName
        self.attackType = hero.attackType
        self.image = hero.image
        self.icon = hero.icon
        
        roles.append(objectsIn: hero.roles)
        
        self.primaryAttribute = hero.primaryAttribute
        self.baseHealth = hero.baseHealth
        self.baseMana = hero.baseMana
        self.baseMinAttack = hero.baseMinAttack
        self.baseMaxAttack = hero.baseMaxAttack
        self.moveSpeed = hero.moveSpeed
        self.baseStr = hero.baseStr
        self.baseAgi = hero.baseAgi
        self.baseInt = hero.baseInt
    }
}
