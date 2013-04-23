//
//  HComparisonGame.h
//  Matchismo
//
//  Created by Ashley Packard on 3/11/13.
//  Copyright (c) 2013 Ashley Packard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"


@interface ComparisonGame : NSObject

// our designated initializer
-(id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;

-(void)flipCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex:(NSUInteger)index;


-(NSString *)compareTheCards:(int) index;


@end
