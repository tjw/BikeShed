//
//  Deck.swift
//  Klondike
//
//  Created by Timothy J. Wood on 10/6/15.
//  Copyright © 2015 The Omni Group. All rights reserved.
//

import Foundation

/// A
struct Deck {
    
    let cards:[Card]
    
    init() {
        cards = Card.Suit.every.flatMap {
            suit in Card.Rank.every.map {
                return Card(rank:$0, suit:suit)
            }
        }
    }

    var shuffled:Deck {
        return Deck(cards:cards.shuffle())
    }
    
    
    // Caller is responsible for making sure the cards are unique, unless they are a CHEATER
    private init(cards:[Card]) {
        self.cards = cards
    }
}
