//
//  ComparisonGame.m
//  Matchismo
//
//  Created by Ashley Packard on 3/11/13.
//  Copyright (c) 2013 Ashley Packard. All rights reserved.
//

#import "ComparisonGame.h"
#import "PlayingCard.h"

@interface ComparisonGame()

@property (strong, nonatomic) NSMutableArray *cards;


@end

@implementation ComparisonGame


-(NSMutableArray *)cards
{
	if (!_cards) _cards = [[NSMutableArray alloc]init];
	return _cards;
}

-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
	self = [super init];
	
	if(self)
	{
		for (int i = 0; i < count; i++)
		{
			Card *card = [deck drawRandomCard];
			if(!card)
			{
				self = nil;
			}
			else
			{
				self.cards[i] = card;
			}
		}
	}
	return self;
}


-(Card *)cardAtIndex:(NSUInteger)index
{
	return (index < self.cards.count) ? self.cards[index] : nil;
}

-(void)flipCardAtIndex:(NSUInteger)index
{
	Card *card = [self cardAtIndex:index];
	
	if(!card.isFaceUp)
	{
		card.faceUp = !card.isFaceUp;

	}
	else
	{
		card.faceUp = false;
	}
	
}


// for my high low game :D
-(NSString *)compareTheCards:(int)index
{
	PlayingCard *currentCard = _cards[index];
	PlayingCard *mysteryCard = _cards[index+1];
		
	if(currentCard.rank < mysteryCard.rank)
	{
		return @"High";
	}
	else if (currentCard.rank > mysteryCard.rank)
	{
		return @"Low";
	}
	else
	{
		return @"Tie";
	}
	
	
}



@end
