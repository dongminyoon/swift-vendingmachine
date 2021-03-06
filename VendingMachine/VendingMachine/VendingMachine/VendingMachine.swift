//
//  VendingMachine.swift
//  VendingMachine
//
//  Created by 윤동민 on 03/01/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

protocol UserAvailableMode {
    func isAbleToInsert(coin: Int) -> State
    func isAbleToPick(menu: Int) -> State
    func pick(menu: Int) -> Beverage
    func insert(coin: Int)
    func getPurchaseListInsertedCoin() -> [String]
}

protocol ManageableMode {
    func isAbleToAdd(menu: Int) -> State
    func isAbleToRemove(menu: Int) -> State
    func addStock(menu: Int)
    func removeDrink(_ menu: Int) -> Beverage
}

protocol PrintableMachingState {
    func machineStateInUserMode(form: (Coin, Stock) -> Void)
    func machineStateInManagerMode(form: (Stock) -> Void)
}

class VendingMachine {
    private var coin: Coin = Coin()
    private var stock: Stock = Stock()
    private var purchaseHistory: PurchaseHistory = PurchaseHistory()
    
    init() {
        stock.add(BananaMilk())
        stock.add(BananaMilk())
        stock.add(ChocoMilk())
        stock.add(ChocoMilk())
        stock.add(Cola())
        stock.add(Cola())
        stock.add(Fanta())
        stock.add(Fanta())
        stock.add(Cantata())
        stock.add(Cantata())
        stock.add(TOP())
        stock.add(TOP())
    }
    
    private func canBuy(_ price: Int) -> Bool {
        return coin.isEnoughToBuy(of: price)
    }
    
    func searchExpirationList() -> [Beverage] {
        let todayDate: Date = Date()
        return stock.searchExpirationList(to: todayDate)
    }
    
    func getPuchaseHistory() -> [String] {
        return purchaseHistory.convertToStrngHistory()
    }
}

extension VendingMachine: PrintableMachingState {
    func machineStateInUserMode(form: (Coin, Stock) -> Void) {
        form(coin, stock)
    }
    
    func machineStateInManagerMode(form: (Stock) -> Void) {
        form(stock)
    }
}

extension VendingMachine: ManageableMode {
    func isAbleToAdd(menu: Int) -> State {
        guard stock.isExist(menu) else { return .notExist }
        return .success
    }
    
    func isAbleToRemove(menu: Int) -> State {
        guard stock.isExist(menu) else { return .notExist }
        guard !stock.isEmptyStock(menu) else { return .notEnough }
        return .success
    }
    
    func addStock(menu: Int) {
        guard let drink = DrinkCategory(rawValue: menu) else { return }
        stock.add(drink.createDrinkByMenu())
    }
    
    func removeDrink(_ menu: Int) -> Beverage {
        return stock.pickOneDrink(menu: menu)
    }
}

extension VendingMachine: UserAvailableMode {
    func isAbleToInsert(coin: Int) -> State {
        if coin < 0 { return .negative }
        return .success
    }
    
    func isAbleToPick(menu: Int) -> State {
        guard stock.isExist(menu) else { return .notExist }
        guard !stock.isEmptyStock(menu) else { return .notEnough }
        guard canBuy(stock.getPrice(menu: menu)) else { return .fail }
        return .success
    }
    
    func pick(menu: Int) -> Beverage {
        let picked = stock.pickOneDrink(menu: menu)
        purchaseHistory.addHistory(of: picked)
        coin.minus(stock.getPrice(menu: menu))
        return picked
    }
    
    func insert(coin: Int) {
        self.coin.add(coin)
    }
    
    func getPurchaseListInsertedCoin() -> [String] {
        return stock.getPurchaseList(with: coin)
    }
}
