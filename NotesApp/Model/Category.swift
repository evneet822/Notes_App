//
//  Category.swift
//  NotesApp
//
//  Created by Evneet kaur on 2020-01-22.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import Foundation

class CategoryModel{
    internal init(title: String, notes: [Note]) {
        self.title = title
        self.notes = notes
    }
    
    var title : String
    var notes: [Note]
    
    static var categoryData = [CategoryModel]()
}
