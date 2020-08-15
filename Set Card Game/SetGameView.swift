//
//  SetGameView.swift
//  Set Card Game
//
//  Created by Marlon Trujillo Ariza on 8/12/20.
//  Copyright © 2020 Marlon Trujillo Ariza. All rights reserved.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: SetGameVM
    
    var body: some View {
        Grid (viewModel.deck.filter({$0.onTable})){ card in
            CardView(card: card)
        } .padding(5)
    }
}

struct CardView: View {
    var card: SetGame.Card

    var body: some View {
        cardBody()
    }
    
    func cardBody() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.white)
                .shadow(radius: 2)
            VStack {
                ForEach(0..<card.Count){ i in
                    self.cardShape()
                        .foregroundColor(self.cardColor())
                }
            }
        }
        .aspectRatio(4/5, contentMode: .fit)
        .padding(5)
    }
    
    func cardShape() -> AnyView {
        switch card.Shape {
            case "capulse": return AnyView(
                Capsule(style: .continuous)
                    .aspectRatio(2.5/1, contentMode: .fit)
                    .padding(12)
                )
            case "square": return AnyView(
                Rectangle()
                    .aspectRatio(1, contentMode: .fit)
                    .padding(12)
            )
            case "circle": return AnyView(
                Circle()
                    .stroke(lineWidth: 5)
                    .padding(12)
            )
            default: return AnyView(Text("\(card.Shape)"))
        }
    }
    
    func cardColor() -> Color {
        switch card.Color {
        case "red": return Color.red
        case "blue": return Color.blue
        case "green": return Color.green
        default: return Color.black
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(viewModel: SetGameVM())
    }
}
