//
//  Options.swift
//  mirrAR
//
//  Created by Krishna Datt Shukla on 01/06/21.
//

import Foundation

public struct Options {
    let brandId: String //Brand ID
    let productData: [ProductData] //Array of Products
    
    public init(brandId: String, productData: [ProductData]) {
        self.brandId = brandId
        self.productData = productData
    }
}

public struct ProductData {
    let category: String // Bracelets, Earrings, Necklaces etc.
    let items: [String] // array of product code
    let type: String // wrist, neck, finger etc.
    
    public init(category: String, items: [String], type: String) {
        self.category = category
        self.items = items
        self.type = type
    }
}
