//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 杜俊楠 on 2022/6/11.
//  Copyright © 2022 杜俊楠. All rights reserved.
//VM 

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    typealias GameCard = MemoryGame<String>.Card
    
    private static let emojis = ["✈️","🚗","🚒","🚂","🛳","🚀","🚜","🚕","🚙","🚌","🚎","🏎","🚓"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 8, creatCardContent: {indexPairs in
            emojis[indexPairs]
        })
    }
    
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<GameCard> {
        model.cards
    } 
     
    //MARK:intents
    func choose(_ card:GameCard) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
    
    
    
    
}
