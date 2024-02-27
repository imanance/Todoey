//
//  Category.swift
//  Todoey
//
//  Created by Iman on 2024-02-23.
//

import Foundation
import RealmSwift

class Category: Object {
#if true
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
#else
    @Persisted var name: String = ""
    @Persisted var color: String = ""
#endif
    let items = List<Item>()
}
