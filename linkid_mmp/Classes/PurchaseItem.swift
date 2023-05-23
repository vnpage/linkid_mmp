//
//  PurchaseItem.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 28/02/2023.
//

import Foundation

public class PurchaseItem {
    var itemName: String
    var itemId: String
    var price: String
    
    init(itemName: String, itemId: String, price: String) {
        self.itemName = itemName
        self.itemId = itemId
        self.price = price
    }
    
    public static func convertToArray(_ items: [PurchaseItem]) -> [[String: Any]] {
        var itemsDictionary = [[String: Any]]()
        
        for item in items {
            itemsDictionary.append(convertToDictionary(item))
        }
        return itemsDictionary
    }
    
    public static func convertToDictionary(_ item: PurchaseItem) -> [String: Any] {
        return ["itemName": item.itemName, "itemId": item.itemId, "price": item.price]
    }
}
