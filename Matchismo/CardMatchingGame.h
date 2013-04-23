//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Ashley Packard on 2/15/13.
//  Copyright (c) 2013 Ashley Packard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// our designated initializer
-(id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;

-(NSString *)flipCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;


@end
