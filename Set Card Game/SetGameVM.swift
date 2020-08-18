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
    
    // MARK: - Access to the Model
    var deck: Array<SetGame.Card> {
        model.deck
    }
    
    var table: Array<SetGame.Card> {
        model.deck.filter({$0.onTable})
    }
    
    // MARK: - Intent(s)
    func select(_ card: SetGame.Card) {
        model.selectCard(card)
    }
    
    func draw3moreCards() {
        model.draw3moreCards()
    }

    func generateNewGame() {
        model = SetGame()
    }
}
