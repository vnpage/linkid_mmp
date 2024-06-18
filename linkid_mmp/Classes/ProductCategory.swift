//
//  ProductCategory.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 25/10/2023.
//

import Foundation

@objcMembers
public class ProductCategory {
    var categoryId: String
    var categoryName: String
    
    public init(categoryId: String, categoryName: String) {
        self.categoryId = categoryId
        self.categoryName = categoryName
    }
    
    public func toDictionary() -> [String: Any] {
        return ["c_id": categoryId, "c_name": categoryName]
    }
    
    public static func convertToArray(_ items: [ProductCategory]) -> [[String: Any]] {
        var itemsDictionary = [[String: Any]]()
        
        for item in items {
            itemsDictionary.append(item.toDictionary())
        }
        return itemsDictionary
    }
    
    public static func fromDictionary(_ data: [String: Any]) -> ProductCategory {
        let name = data["c_name"] as? String ?? ""
        let id = data["c_id"] as? String ?? ""
        let item: ProductCategory = ProductCategory(categoryId: id, categoryName: name)
        return item
    }
    
    public static func fromList(_ data: [[String: Any]]) -> [ProductCategory] {
        var results: [ProductCategory] = []
        data.forEach { item in
            let product = ProductCategory.fromDictionary(item)
            if product.categoryId != "" {
                results.append(product)
            }
        }
        return results
    }
}
