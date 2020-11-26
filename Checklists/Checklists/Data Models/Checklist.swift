//
//  Checklist.swift
//  Checklists
//
//  Created by Rajha Fajardo de Alencar Marcal on 23/11/20.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    
}
