//
//  ContentView.swift
//  Memorize
//
//  Created by 杜俊楠 on 2022/6/7.
//  Copyright © 2022 杜俊楠. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var gameVM:EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.GameCard) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.GameCard) -> Bool {
        return !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.GameCard) -> Animation {
        var delay = 0.0
        if let index = gameVM.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardContants.totalDealDuration / Double(gameVM.cards.count))
        }
        return Animation.easeInOut(duration: CardContants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.GameCard) -> Double {
        -Double(gameVM.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: gameVM.cards, aspectRatio:2/3, content:{ card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            }
            else {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            gameVM.choose(card)
                        }
                    }
            }
        })
        .foregroundColor(CardContants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(gameVM.cards.filter { isUndealt($0) }) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardContants.undealWidth, height: CardContants.undealHeight)
        .foregroundColor(CardContants.color)
        .onTapGesture {
            //deal cards
            for card in gameVM.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("洗牌") {
            withAnimation {
                gameVM.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("重开") {
            withAnimation {
                dealt = []
                gameVM.restart()
            }
        }
    }
    
    private struct CardContants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealHeight: CGFloat = 90
        static let undealWidth = undealHeight * aspectRatio
    }
    
    
    
}


struct CardView:View {

    private let card: EmojiMemoryGame.GameCard
    
    init(_ givenCard:EmojiMemoryGame.GameCard) {
        card = givenCard;
    }
     
    @State private var animatedBonusRemaining: Double = 0
    
    
    var body: some View {
        GeometryReader(content:{geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)){
                                    animatedBonusRemaining = 0
                                }
                            }
                    }
                    else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                .padding(5).opacity(0.5)
                
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ?360:0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(.system(size: DrawingConstans.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp) 
        })
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstans.fontSize / DrawingConstans.fontScale )
    }
    
    private struct DrawingConstans {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
    
    
}



















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
//        game.choose(game.cards.first!)
        EmojiMemoryGameView(gameVM: game)
    }
}
