//
//  PurchaseItem.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 28/02/2023.
//

import Foundation

@objcMembers
public class ProductItem {
    var productName: String
    public var productId: String
    var productImage: String
    var productPrice: String
    var productQuantity: Int = 1
    var productCategories: [ProductCategory] = []
    
    public init(id: String, name: String, image: String, price: String? = "", quantity: Int? = 1, categories: [ProductCategory]? = []) {
        self.productName = name
        self.productId = id
        self.productImage = image
        self.productPrice = price ?? ""
        self.productQuantity = quantity ?? 1
        self.productCategories = categories ?? []
    }
    
    public func setQuantity(quantity: Int) {
        self.productQuantity = quantity
    }
    
    public func addCategory(category: ProductCategory) {
        productCategories.append(category)
    }
    
    public static func convertToArray(_ items: [ProductItem]) -> [[String: Any]] {
        var itemsDictionary = [[String: Any]]()
        for item in items {
            itemsDictionary.append(item.toDictionary())
        }
        return itemsDictionary
    }
    
    public func toDictionary() -> [String: Any] {
        return ["p_name": productName, "p_id": productId, "p_img": productImage, "p_price": productPrice, "p_quantity": productQuantity, "p_categories": ProductCategory.convertToArray(productCategories)]
    }
    
    public static func fromDictionary(_ data: [String: Any]) -> ProductItem {
        let name = data["p_name"] as? String ?? ""
        let id = data["p_id"] as? String ?? ""
        let img = data["p_img"] as? String ?? ""
        let price = data["p_price"] as? String ?? ""
        let quantity = data["p_quantity"] as? Int ?? 1
        let cats = data["p_categories"] as? [[String: Any]] ?? []
        let item: ProductItem = ProductItem(id: id, name: name, image: img, price: price, quantity: quantity, categories: ProductCategory.fromList(cats))
        return item
    }
    
    public static func fromList(_ data: [[String: Any]]) -> [ProductItem] {
        var results: [ProductItem] = []
        data.forEach { item in
            let product = ProductItem.fromDictionary(item)
            if product.productId != "" {
                results.append(product)
            }
        }
        return results
    }
    
    public static func convertToJsonString(listName: String, products: [ProductItem]) -> String {
        let _products : [[String: Any]] = ProductItem.convertToArray(products)
        let data : [String: Any] =  [
            "products": _products,
            "p_group": listName
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString ?? "{}"
        } catch {
            print("Error converting array to JSON string: \(error.localizedDescription)")
            return "{}"
        }
    }
}
