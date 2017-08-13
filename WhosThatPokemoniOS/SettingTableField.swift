//
//  SettingTableField.swift
//  WhosThatPokemoniOS
//
//  Created by Dylan Conway on 11/08/2017.
//  Copyright © 2017 Routematch Ireland. All rights reserved.
//

import Foundation

enum CellType: String {
    case none = ""
    case toggle = "SettingsSwitchTableCell"
}


class SettingTableField {
    
    var title: String = ""
    var value: SettingKey = .none
    var cellType: CellType = .none
    
    var switchOn: Bool = false
    
    convenience init(withTitle title: String, withValue value: SettingKey, cellType: CellType) {
        self.init()
        
        self.title = title
        self.value = value
        self.cellType = cellType
        
        self.switchOn = UserDefaults.standard.bool(forKey: self.value.rawValue)
    }
}
