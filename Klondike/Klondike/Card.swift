//
//  Card.swift
//  Klondike
//
//  Created by Timothy J. Wood on 10/6/15.
//  Copyright © 2015 The Omni Group. All rights reserved.
//

import Cocoa


struct Card {
    enum Color {
        case Red
        case Black
    }
    
    enum Suit {
        case Hearts
        case Diamonds
        case Clubs
        case Spades
        
        var color: Color {
            switch (self) {
            case .Hearts, .Diamonds:
                return .Red
            case .Clubs, .Spades:
                return .Black
            }
        }

        static let every:[Suit] = [Hearts, Diamonds, Clubs, Spades]

        // It would be kind of nice to have `for x in Suit { ... }` work, but that couldn't for cases with associated data
        static func each(action:Suit -> ()) {
            for suit in every {
                action(suit)
            }
        }
    }
    
    enum Rank : Int {
        case Ace = 1 // could let this default to zero, but this might be nicer...
        case Two
        case Three
        case Four
        case Five
        case Six
        case Seven
        case Eight
        case Nine
        case Ten
        case Jack
        case Queen
        case King
        
        static let every:[Rank] = [
            Ace,
            Two,
            Three,
            Four,
            Five,
            Six,
            Seven,
            Eight,
            Nine,
            Ten,
            Jack,
            Queen,
            King,
        ]
        
        static func each(action:Rank -> ()) {
            for rank in every {
                action(rank)
            }
        }
    }

    let rank:Rank
    let suit:Suit
}

extension Card:CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(rank) of \(suit)"
    }
}
