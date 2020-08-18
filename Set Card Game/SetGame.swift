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
        case solid, outline, transparent
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
        deck.shuffle()
        
        for index in 0..<12 {
            deck[index].onTable = true
        }
    }
    
    mutating func selectCard(_ card: Card){
        var selectedCardsIndices = deck.indices.filter{ deck[$0].isSelected }
        let indexOfCard = deck.firstIndex(of: card)!
        
        
        if selectedCardsIndices.count < 3 {
            deck[indexOfCard].isSelected = !deck[indexOfCard].isSelected
            selectedCardsIndices = deck.indices.filter{ deck[$0].isSelected }
            
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
            
            if (!selectedCardsIndices.contains(indexOfCard)){
                deck[indexOfCard].isSelected = !deck[indexOfCard].isSelected
                
                if isSet(selectedCardsIndices) {
                    for index in selectedCardsIndices.reversed() {
                        deck.remove(at: index)
                    }
                    draw3moreCards()
                } else {
                    for index in selectedCardsIndices {
                         deck[index].isSelected = false
                        deck[index].wrongMatching = false
                        deck[index].isSet = false
                     }
                }
            }
        }
    }
    
    func isSet(_ selectedIndices: Array<Int>) -> Bool {
        var matchingCount = 0
        var uniqueCount = 0
        
        if  matchingCategories(selectedIndices, categoryFunction: { deck[$0].Color }) { matchingCount += 1 }
        if  uniqueCategories(selectedIndices, categoryFunction: { deck[$0].Color }) { uniqueCount += 1 }
        
        if  matchingCategories(selectedIndices, categoryFunction: { deck[$0].Shape }) { matchingCount += 1 }
        if  uniqueCategories(selectedIndices, categoryFunction: { deck[$0].Shape }) { uniqueCount += 1 }
        
        if  matchingCategories(selectedIndices, categoryFunction: { deck[$0].Shading }) { matchingCount += 1 }
        if  uniqueCategories(selectedIndices, categoryFunction: { deck[$0].Shading }) { uniqueCount += 1 }
        
        if  matchingCategories(selectedIndices, categoryFunction: { deck[$0].Count }) { matchingCount += 1 }
        if  uniqueCategories(selectedIndices, categoryFunction: { deck[$0].Count }) { uniqueCount += 1 }
        
        if matchingCount == 1 && uniqueCount == 3 { return true }
        
        return false
    }
    
    func matchingCategories<C: Equatable>(_ selectedIndices: Array<Int>, categoryFunction getValue: (Int) -> C) -> Bool {
        if (selectedIndices.count < 3 ){
            return false
        }
        
        let firstValue = getValue(selectedIndices.first!)
        
        for index in 1..<selectedIndices.count {
            if getValue(selectedIndices[index]) != firstValue {
                return false
            }
        }
        
        if getValue(selectedIndices[1]) != getValue(selectedIndices[2]) {
            return false
        }
        
        return true
    }
    
    func uniqueCategories<C: Equatable>(_ selectedIndices: Array<Int>, categoryFunction getValue: (Int) -> C) -> Bool {
        if(selectedIndices.count < 3) {
            return false
        }
        
        let firstValue = getValue(selectedIndices.first!)

        for index in 1..<selectedIndices.count {
          if getValue(selectedIndices[index]) == firstValue {
              return false
          }
        }

        if getValue(selectedIndices[1]) == getValue(selectedIndices[2]) {
          return false
        }
          
        return true
      }
    
    mutating func draw3moreCards() {
        
        let selectedCardsIndices = deck.indices.filter{ deck[$0].isSelected }
        
        if isSet(selectedCardsIndices) {
            for index in selectedCardsIndices.reversed() {
                deck.remove(at: index)
            }
            draw3moreCards()
        } else if ((deck.filter{ $0.onTable }.count) < deck.count){
            for index in 0..<(deck.filter{ $0.onTable }.count + 3) {
                deck[index].onTable = true
            }
        }
    }
        
    struct Card: Equatable, Identifiable{
        var Color: String
        var Shape: String
        var Shading: String
        var Count: Int
        var isSelected: Bool = false
        var isSet: Bool = false
        var wrongMatching: Bool = false
        var onTable: Bool = false
        var id: Int
    }
}
