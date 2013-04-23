//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ashley Packard on 2/11/13.
//  Copyright (c) 2013 Ashley Packard. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingDeck.h"
#import "CardMatchingGame.h"


@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
- (IBAction)dealButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation CardGameViewController


- (IBAction)dealButtonPressed:(id)sender
{
	self.game = nil;
	[self setFlipCount:0];
	[self updateUI];
}

-(CardMatchingGame *)game
{
	if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingDeck alloc] init]];
	
	return _game;
}


-(void)setCardButtons:(NSArray *)cardButtons
{
	_cardButtons = cardButtons;
	
	[self updateUI];
}

-(void)updateUI
{
	for (UIButton *cardButton in self.cardButtons)
	{
		
		Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
		
		
		if(!card.isFaceUp)
		{
			UIImage *cardBackImage = [UIImage imageNamed:@"pats.png"];
			[cardButton setImage:cardBackImage forState:UIControlStateNormal];

		}
		else
		{
			[cardButton setImage:NULL forState:UIControlStateNormal];

		}
		
		[cardButton setTitle:card.contents forState:UIControlStateSelected];
		[cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
		cardButton.selected = card.isFaceUp;
		cardButton.enabled = !card.isUnplayable;
		cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
	}
	
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	
}

- (void) setFlipCount: (int)flipCount
{
	_flipCount = flipCount;
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
//	sender.selected = !sender.isSelected;
	
	self.lastFlipLabel.text = [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
	self.flipCount++;
	[self updateUI];

}

-(void) viewDidLoad
{
	[super viewDidLoad];
	
	UIImage *selectedImage1 = [UIImage imageNamed:@"tabbarimage-D.jpg"];
	UIImage *unselectedImage1 = [UIImage imageNamed:@"tabbarimage-D.jpg"];
	
	UIImage *selectedImage0 = [UIImage imageNamed:@"MatchismoTabBar.jpg"];
	UIImage *unselectedImage0 = [UIImage imageNamed:@"MatchismoTabBar.jpg"];
	
	
	UITabBar *tabBar = self.tabBarController.tabBar;
	
	UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
	[item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
	
	UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
	[item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
	
}


@end
