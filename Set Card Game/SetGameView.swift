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
        VStack {
            ZStack{
                Text("Set")
                    .font(Font.bold(Font.largeTitle)())
                    .padding().shadow(color: Color(.displayP3, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 1, x: 5, y: 5)
                
                HStack {
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut){
                                self.viewModel.generateNewGame()
                            }
                        }, label: {
                            Text("New Game").font(Font.body)
                        })
                            .padding()
                }
            }

            
            Grid (viewModel.table){ card in
                CardView(card: card).onTapGesture {
                    self.viewModel.select(card)
                }
            }
            
            Button(action: {
                withAnimation(.easeInOut){
                    self.viewModel.draw3moreCards()
                }
            }, label: {
                Text("Draw New Cards")
            })
                .opacity(viewModel.table.count < viewModel.deck.count ? 1 : 0).padding()
        }
    }
}

struct CardView: View {
    var card: SetGame.Card

    var body: some View {
        GeometryReader{ geometry in
            self.cardBody(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func cardBody(for size: CGSize) -> some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.white)
                .shadow(radius: 3)
            
            HStack {
                ForEach(0..<card.Count){ i in
                    self.cardShape()
                        .foregroundColor(self.cardColor())
                }
            }.padding((card.Count < 3) ? 10 : 6)
            
            if (card.isSelected){
                if (card.isSet){
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 5)
                        .foregroundColor(Color.green)
                } else if (card.wrongMatching){
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 5)
                        .foregroundColor(Color.red)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 5)
                        .foregroundColor(Color.yellow)
                }
            }
            } .aspectRatio(1, contentMode: .fit).padding(5)
    }
    
    func cardShape() -> AnyView {
        switch card.Shape {
        case "capulse": return AnyView(getShading(shape: Capsule()).aspectRatio(1/2, contentMode: .fit))
            case "diamond": return AnyView(getShading(shape: Diamond()).aspectRatio(1/2, contentMode: .fit))
            case "circle": return getShading(shape: Circle())
            default: return AnyView(Text("\(card.Shape)"))
        }
    }
    
    func getShading<s: Shape>(shape: s) -> AnyView {
        switch card.Shading {
        case "outline":
            return AnyView(shape.stroke(lineWidth: 2))
        case "transparent":
            return AnyView(shape.opacity(0.5))
        default:
            return AnyView(shape)
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
