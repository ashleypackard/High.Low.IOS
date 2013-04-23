//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Ashley Packard on 2/15/13.
//  Copyright (c) 2013 Ashley Packard. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;

@end

@implementation CardMatchingGame

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

// I'm removing this, it's silly
//#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 10

//
//-(void)flipCardAtIndex:(NSUInteger)index
//{
//	Card *card = [self cardAtIndex:index];
//	
//	if(!card.isUnplayable)
//	{
//		if(!card.isFaceUp)
//		{
//			for(Card *otherCard in self.cards)
//			{
//				if(otherCard.isFaceUp && !otherCard.isUnplayable)
//				{
//					int matchScore = [card match:@[otherCard]];
//					if(matchScore)
//					{
//						otherCard.unplayable = YES;
//						card.unplayable = YES;
//						self.score += matchScore * MATCH_BONUS;
//					}
//					else
//					{
//						otherCard.faceUp = NO;
//						self.score -= MISMATCH_PENALTY;
//					}
//					
//					break;
//				}
//			}
//			
//			self.score -= FLIP_COST;
//		}
//		
//		card.faceUp = !card.isFaceUp;
//	}
//}

- (NSString *)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    int numberOfMatchingCards = 2;
	NSString *descriptionOfLastFlip;
	
	
    if (card && !card.isUnplayable)
	{
        if (!card.isFaceUp)
		{
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            // Added an array to contain the cards
            NSMutableArray *otherContents = [[NSMutableArray alloc] init];
            // added an array to contain the contents.
            for (Card *otherCard in self.cards)
			{
                if (otherCard.isFaceUp && !otherCard.isUnplayable)
				{
                    [otherCards addObject:otherCard];
                    [otherContents addObject:otherCard.contents];
                    // adds the data to the arrays
                }
            }
            if ([otherCards count] < numberOfMatchingCards - 1)
			{
                descriptionOfLastFlip = [NSString stringWithFormat:@"Flipped up %@", card.contents];
                // numberOfMatchingCards is an int which is set to 2. (Basically the if is asking if there is
//				atleast one card in the array.
				// if there is one card it displays which card got flipped.
            }
			else
			{
                int matchScore = [card match:otherCards];
                if (matchScore)
				{
                    card.unplayable = YES;
                    for (Card *otherCard in otherCards)
					{
                        otherCard.unplayable = YES;
                    }
                    self.score += matchScore + MATCH_BONUS;
                    descriptionOfLastFlip =
                    [NSString stringWithFormat:@"Matched %@ & %@ for +%d",
                     card.contents,
                     [otherContents componentsJoinedByString:@" & "],
                     matchScore + MATCH_BONUS];
					//This is the if which checks if the two cards were a match, it then displays the contents of both cards and the score.
                }
				else
				{
                    for (Card *otherCard in otherCards)
					{
                        otherCard.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                    descriptionOfLastFlip =
                    [NSString stringWithFormat:@"%@ & %@ don't match! -%d",
                     card.contents,
                     [otherContents componentsJoinedByString:@" & "],
                     MISMATCH_PENALTY];
					// this is the if which checks if the two cards are not a match and displays contents and penalty.
                } //end else
            } // end else
//            self.score -= FLIP_COST;
        } // end if
        card.faceUp = !card.faceUp;
    }// end if
	
	return descriptionOfLastFlip;
} // end function

@end
