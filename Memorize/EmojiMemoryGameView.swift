//
//  ContentView.swift
//  Memorize
//
//  Created by 杜俊楠 on 2022/6/7.
//  Copyright © 2022 杜俊楠. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel:EmojiMemoryGame
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum:65))]) {
                    ForEach(viewModel.cards[0..<viewModel.cards.count]) {card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode:.fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
                .foregroundColor(.red)
            }
            Spacer()
            HStack {
//                remove
                Spacer()
//                add
            }
            .padding(.horizontal)
            .font(.largeTitle)
        }
        .padding(.horizontal)
    }
    
    /*
    var remove: some View {
        Button(action:{
            if self.emojiCount > 1 {
                self.emojiCount -= 1
            }
        }, label:{
            Image(systemName: "minus.circle")
        })
    }
    var add: some View {
        Button(action:{
            if self.emojiCount < self.emojis.count {
                self.emojiCount += 1
            }
        }, label:{
            Image(systemName: "plus.circle")
        })
    }
     */
}


struct CardView:View {

    let card: MemoryGame<String>.Card
    
    let shape = RoundedRectangle(cornerRadius: 20)
    var body: some View {
       
        ZStack {
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth:3)
                Text(card.content).font(.largeTitle)
            }
            else if card.isMatched {
                shape.opacity(0)
            }
            else {
                shape.fill()
            }
        }
    }
}



















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(viewModel: game)
    }
}
