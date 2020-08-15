//
//  SetGame.swift
//  Set Card Game
//
//  Created by Marlon Trujillo Ariza on 8/12/20.
//  Copyright © 2020 Marlon Trujillo Ariza. All rights reserved.
//

import Foundation

struct SetGame {
    
    private(set) var deck: Array<Card>
    
    enum Color: String, CaseIterable {
        case red, blue, green
    }
    
    enum Shape: String, CaseIterable {
        case square, capulse, circle
    }
    
    enum Shading: String, CaseIterable{
        case solid, outline, striped
    }
    
    init(){
        deck = Array<Card>()
        var index = 0
        for color in Color.allCases {
            for shape in Shape.allCases{
                for shade in Shading.allCases{
                    for count in 1...3 {
                        let card = Card(Color: color.rawValue, Shape: shape.rawValue, Shading: shade.rawValue, Count: count, id: index)
                        index += 1
                        deck.append(card)
                    }
                }
            }
        }
        print(deck.count)
        deck.shuffle()
        
        for index in 0...12 {
            deck[index].onTable = true
        }
    }
    
    mutating func selectCard(_ card: Card){
        var selectedCardsIndices = deck.indices.filter{ deck[$0].isSelected }
        let indexOfCard = deck.firstIndex(of: card)!
        
        
        if selectedCardsIndices.count < 3 {
            deck[indexOfCard].isSelected = !deck[indexOfCard].isSelected
            selectedCardsIndices.append(indexOfCard)
            
            if selectedCardsIndices.count == 3 {
                if isSet(selectedCardsIndices) {
                    for index in selectedCardsIndices {
                        deck[index].isSet = true
                    }
                } else {
                    for index in selectedCardsIndices {
                        deck[index].wrongMatching = true
                    }
                }
            }
            
        } else {
            
            deck[indexOfCard].isSelected = !deck[indexOfCard].isSelected

            if isSet(selectedCardsIndices) {
                for index in selectedCardsIndices {
                    deck.remove(at: index)
                }
                
                drawNewCards()
            } else {
                for index in selectedCardsIndices {
                     deck[index].isSelected = false
                 }
            }

        }
    }
    
    func isSet(_ selectedIndices: Array<Int>) -> Bool {
        var categoryCount = 0
        
        if  matchingCategories(selectedIndices, categoryFunction: { deck[$0].Color }) { categoryCount += 1 }
        if  matchingCategories(selectedIndices, categoryFunction: { deck[$0].Shape }) { categoryCount += 1 }
        if  matchingCategories(selectedIndices, categoryFunction: { deck[$0].Shading }) { categoryCount += 1 }
        if  matchingCategories(selectedIndices, categoryFunction: { deck[$0].Count }) { categoryCount += 1 }
        
        if categoryCount == 1 { return true }
        
        return false
    }
    
    mutating func drawNewCards() {
        if deck.count >= 12 {
            for index in 0...12 {
                deck[index].onTable = true
            }
        }
    }
        
    func matchingCategories<C: Equatable>(_ selectedIndices: Array<Int>, categoryFunction getValue: (Int) -> C) -> Bool {
        let fistValue = getValue(selectedIndices.first!)
        
        for index in selectedIndices {
            if getValue(index) != fistValue {
                return false
            }
        }
        
        return true
    }
    
    
    struct Card: Equatable, Identifiable{
        var Color: String
        var Shape: String
        var Shading: String
        var Count: Int
        var isSelected: Bool = false
        var isSet: Bool = true
        var wrongMatching: Bool = false
        var onTable: Bool = false
        var id: Int
    }
}
