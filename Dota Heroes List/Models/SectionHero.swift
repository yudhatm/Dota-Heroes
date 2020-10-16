//
//  SectionHero.swift
//  Dota Heroes List
//
//  Created by Yudha on 14/10/20.
//  Copyright © 2020 Yudha. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionHero {
  var header: String
  var items: [Hero]
}

extension SectionHero: SectionModelType {
  typealias Item = Hero

   init(original: SectionHero, items: [Item]) {
    self = original
    self.items = items
  }
}
