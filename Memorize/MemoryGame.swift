//
//  MemoryGame.swift
//  Memorize
//
//  Created by 杜俊楠 on 2022/6/11.
//  Copyright © 2022 杜俊楠. All rights reserved.
//model

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard:Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach({ cards[$0].isFaceUp = ($0 == newValue) })}
    }
    
    mutating func choose(_ card:Card) {
//        if let choosenIndex = index(of: card) {
        if let choosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[choosenIndex].isFaceUp,
            !cards[choosenIndex].isMatched {
            
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[choosenIndex].content == cards[potentialMatchIndex].content {
                    cards[choosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[choosenIndex].isFaceUp = true
            }
            else {
                indexOfTheOneAndOnlyFaceUpCard = choosenIndex
            }
        }
    }
    
    func index(of card: Card) -> Int? {
        for index in 0..<cards.count {
            if (cards[index].id == card.id) {
                return index
            }
        }
        return nil
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards:Int, creatCardContent:(Int)->CardContent)  {
        cards = []
        //add numberOfCards *2
        for indexPairs in 0..<numberOfPairsOfCards {
            let content: CardContent = creatCardContent(indexPairs)
            cards.append(Card(id: (indexPairs*2), content: content))
            cards.append(Card(id: (indexPairs*2)+1, content: content))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        let id: Int
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                }
                else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                }
                else {
                    stopUsingBonusTime()
                }
            }
        }
        let content:CardContent
        
        
        // MARK: - Bonus Time
        /// It gives bonus points if user matches the card before a certain amount of time during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has even been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned up (and is still face up)
        var lastFaceUpDate: Date?
        
        // the accumulated time this card has been face up in the past
        /// not incuding the current time it's been face up if it is currently so
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // % of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        }
        else {
            return nil
        }
    }
}
