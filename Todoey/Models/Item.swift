//
//  Item.swift
//  Todoey
//
//  Created by Iman on 2024-02-23.
//

import Foundation
import RealmSwift

class Item: Object {
#if true
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
#else
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var dateCreated: Date?
#endif
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
