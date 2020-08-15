//
//  SetGameVM.swift
//  Set Card Game
//
//  Created by Marlon Trujillo Ariza on 8/14/20.
//  Copyright © 2020 Marlon Trujillo Ariza. All rights reserved.
//

import SwiftUI

class SetGameVM: ObservableObject {
    @Published private var model = SetGame()
    
    func generateNewGame() {
        model = SetGame()
    }
    
    // MARK: - Access to the Model
    var deck: Array<SetGame.Card> {
        model.deck
    }
    
    // MARK: - Intent(s)
    func select(card: SetGame.Card) {
        model.selectCard(card)
    }
}
