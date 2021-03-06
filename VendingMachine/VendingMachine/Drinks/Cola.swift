//
//  Cola.swift
//  VendingMachine
//
//  Created by 윤동민 on 28/12/2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

class Cola: CarbonatedDrink {
    private var sugarAmount: Double
    
    init(name: String, volume: Int, brand: String, date: String, isZeroCalorie: Bool, sugarAmount: Double) {
        self.sugarAmount = sugarAmount
        super.init(name: name, volume: volume, price: 2000, brand: brand, date: date, isZeroCalorie: isZeroCalorie)
    }
    
    convenience init() {
        self.init(name: "콜라",
                  volume: 350,
                  brand: "다이어트콜라",
                  date: "20190303",
                  isZeroCalorie: false,
                  sugarAmount: 0.9)
    }
    
    func isHighSugarAmount() -> Bool {
        return sugarAmount > 1.0
    }

    override func convertToStringBeverage() -> String {
        return "\(type(of: self))"
    }
}
