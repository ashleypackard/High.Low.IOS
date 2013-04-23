//
//  HighLowGameViewController.m
//  Matchismo
//
//  Created by Ashley Packard on 3/11/13.
//  Copyright (c) 2013 Ashley Packard. All rights reserved.
//

#import "HighLowGameViewController.h"
#import "PlayingDeck.h"
#import "ComparisonGame.h"



@interface HighLowGameViewController ()
@property (strong, nonatomic) IBOutlet UIButton *lowButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *highButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *mysteryCardButton;
@property (strong, nonatomic) IBOutlet UILabel *CardsRemaining;
@property (strong, nonatomic) IBOutlet UIButton *currentCardButton;
- (NSArray *)mooseCardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
- (IBAction)lowButtonClicked:(UIButton *)sender;
- (IBAction)highButtonClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (strong, nonatomic) ComparisonGame *game;
@property (nonatomic) int scoreCount;
@property (nonatomic) int currentCardcount;
@property (nonatomic) int mysteryCardCount;
@property (nonatomic) int uselessCount;
@property (nonatomic) NSString *cardImage;
@property(nonatomic) NSString *winningText;

-(int)getScoreCount;
- (IBAction)UITBRules:(UIBarButtonItem *)sender;
- (IBAction)UITBStartOver:(UIBarButtonItem *)sender;
- (IBAction)UITBOptions:(UIBarButtonItem *)sender;
@end


@implementation HighLowGameViewController

- (IBAction)UITBRules:(UIBarButtonItem *)sender
{
	UIAlertView* rulesAlert = [[UIAlertView alloc]
		
		initWithTitle:@"Rules" message:@"At the beginning of the game you are dealt one card face up. \r\r You must decide whether the next card off the top of the deck will be higher or lower than the current card. \r\rYou earn 2 points for every correct guess and lose 1 point for every wrong guess. Points are niether lost nor gained when the result is a tie."delegate:self
		cancelButtonTitle: nil otherButtonTitles:@"Let's Play", nil];
	
	
	rulesAlert.alertViewStyle = UIAlertViewStyleDefault;
	[rulesAlert show];
}

- (IBAction)UITBStartOver:(UIBarButtonItem *)sender
{
	[self letsPlayAgain];
}

-(void) letsPlayAgain
{
	self.game = nil;
	[self setScoreCount:0];
	[self reDeal];
}

- (IBAction)UITBOptions:(UIBarButtonItem *)sender
{

	[self chooseLayout:sender];

}

- (void) chooseLayout: (id) sender
{
	UIActionSheet* sheet =
	[[UIActionSheet alloc] initWithTitle:@"Choose a different card image:" delegate:self cancelButtonTitle:(NSString *)@"Cancel" destructiveButtonTitle:nil
					   otherButtonTitles:@"Moose", @"Giraffe", @"Tiger", @"Turtle", @"Shark",
	 nil];
	[sheet showInView: self.tabBarController.view];
}

- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)ix
{
	if (ix == as.cancelButtonIndex)
	return;
	
	NSString* s = [as buttonTitleAtIndex:ix];
	
	_cardImage = [s stringByAppendingString:@".jpg"];
	
	
}


-(void)setUselessCount:(int)uselessCount
{
	_uselessCount = uselessCount;
}

-(void)setMysteryCardCount:(int)mysteryCardCount
{
	// the mystery card is one above the current and if it hits 51 then no more cards
	if(mysteryCardCount == 51)
//	if(mysteryCardCount == 5)
	{
		
		[self setResultsLabelText:@"The deck is empty."];
		[self enableHighLowButtons];
	
		NSString *first = @"You finished the game with a score of ";
		NSString *second = [NSString stringWithFormat:@"%d.", _scoreCount];
		
		_winningText = [first stringByAppendingString:second];
				
		UIAlertView* alert = [[UIAlertView alloc]
								   
								   initWithTitle:@"Congratulations!"
							  message:_winningText
							  delegate:self
								   cancelButtonTitle:@"OK" otherButtonTitles:@"Play Again", nil];
		
		
		alert.alertViewStyle = UIAlertViewStyleDefault;
		[alert show];
		

	}
	else
	{
		_mysteryCardCount = mysteryCardCount + 1;
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 1)
	{
		[self letsPlayAgain];
	}
}


-(void)setCurrentCardcount:(int)currentCardcount
{
	_currentCardcount = currentCardcount;
}


-(NSArray *)mooseCardButtons
{
	return @[_currentCardButton, _mysteryCardButton];
}
-(void)setHighButtonOutlet:(UIButton *)highButtonOutlet
{
	_highButtonOutlet = highButtonOutlet;
}

-(void)setLowButtonOutlet:(UIButton *)lowButtonOutlet
{
	_lowButtonOutlet = lowButtonOutlet;
}

-(void)enableHighLowButtons
{
	_highButtonOutlet.enabled = !_highButtonOutlet.enabled;
	_lowButtonOutlet.enabled = !_lowButtonOutlet.enabled;
}


- (IBAction)lowButtonClicked:(UIButton *)sender
{
	[self enableHighLowButtons];
	
	
	NSString *resultsFromCompare = [self.game compareTheCards:_currentCardcount];
	NSString *resultsLabelTextIs;
	int tempScore = 0;

	[self flipCard:_mysteryCardCount];
	
	if([resultsFromCompare isEqual: @"Low"])
	{
		tempScore = _scoreCount + 2;
		
		resultsLabelTextIs = @"You guessed correctly! +2";
	}
	else if ([resultsFromCompare isEqualToString:@"High"])
	{
		tempScore = _scoreCount - 1;
		
		resultsLabelTextIs = @"You guessed incorrectly! -1";
		
	}
	else
	{
		resultsLabelTextIs = @"It was a tie!";
		tempScore = _scoreCount;
		
	}
	
	[self setResultsLabelText:resultsLabelTextIs];
	[self setScoreCount:tempScore];
	[self resetTheGame];
}



- (IBAction)highButtonClicked:(UIButton *)sender
{
	[self enableHighLowButtons];
	
		
	NSString *resultsFromCompare = [self.game compareTheCards:_currentCardcount];
	NSString *resultsLabelTextIs;
	int tempScore = 0;
	
	[self flipCard:_mysteryCardCount];

	if([resultsFromCompare isEqual: @"High"])
	{
		tempScore = _scoreCount + 2;
		
		[self setScoreCount:tempScore];
		resultsLabelTextIs = @"You guessed correctly! +2";
	}
	else if ([resultsFromCompare isEqualToString:@"Low"])
	{
		tempScore = _scoreCount - 1;
		resultsLabelTextIs = @"You guessed incorrectly! -1";
				
	}
	else
	{
		resultsLabelTextIs = @"It was a tie!";
		tempScore = _scoreCount;
	}
			
	[self setResultsLabelText:resultsLabelTextIs];
	[self setScoreCount:tempScore];

	[self resetTheGame];
		
	
	
}


-(void) resetTheGame
{

	double delayInSeconds = 1.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[self enableHighLowButtons];
		
		[self flipCard:_mysteryCardCount];
		
		_uselessCount += 1;
		
		
		[self setMysteryCardCount:_uselessCount];
		[self setCurrentCardcount:_uselessCount];
				
		// flip to moose side

		[self updateUIForFaceUp:_currentCardcount];
		
	});
	
}


-(void) setScoreCount:(int)scoreCount
{
	_scoreCount = scoreCount;
	
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.scoreCount];
}

-(int) getScoreCount
{
	return _scoreCount;
}


-(void)setResultsLabelText:(NSString *)result
{
	self.resultsLabel.text = [NSString stringWithString:result];
}

-(void)setCardsRemainingText
{
	self.CardsRemaining.text = [ NSString stringWithFormat:@"Cards left in deck: %d", (51 - _currentCardcount)];
}


-(ComparisonGame *)game
{

	if(!_game) _game = [[ComparisonGame alloc] initWithCardCount:52 usingDeck:[[PlayingDeck alloc] init]];

	return _game;
}

-(void)setCurrentCardButton:(UIButton *)currentCardButton
{
	_currentCardButton = currentCardButton;
}

-(void)setMysteryCardButton:(UIButton *)mysteryCardButton
{
	_mysteryCardButton = mysteryCardButton;
}


-(void)updateUI:(NSUInteger)index
{
	
	NSUInteger buttonIndex = index - _currentCardcount;
	
	UIButton *mooseCardButton = [self.mooseCardButtons objectAtIndex:buttonIndex];
	
	Card *card = [self.game cardAtIndex:index];
	
	if(!card.isFaceUp)
	{
		
		UIImage *cardBackImageMoose =
		[UIImage imageNamed: _cardImage];
		[mooseCardButton setImage:cardBackImageMoose forState:UIControlStateNormal];
		
	}
	else
	{
		[mooseCardButton setImage:NULL forState:UIControlStateNormal];
		
	}
	
	[mooseCardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
	
	mooseCardButton.selected = card.isFaceUp;
	[self setCardsRemainingText];
	
}



-(void)updateUIForFaceUp:(NSUInteger)index
{
	NSUInteger buttonIndex = index - _currentCardcount;
	
	UIButton *mooseCardButton = [self.mooseCardButtons objectAtIndex:buttonIndex];
	
	Card *card = [self.game cardAtIndex:index];
	
	
	[mooseCardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
	
	[self setCardsRemainingText];
		
}


- (IBAction)flipCard:(NSUInteger)index
{
	
	[self.game flipCardAtIndex:index];
	[self updateUI:index];
	
}

-(BOOL)checkTORHLButtons
{
	// you really only need to check one because they both act
	// the same!
	return _highButtonOutlet.enabled;

}

-(void)reDeal
{
	// Load the first card in the deck
	[self setMysteryCardCount:0];
	[self setCurrentCardcount:0];
	[self setUselessCount:0];
	[self flipCard:0];
	
	if([self checkTORHLButtons] == false)
	{
		[self enableHighLowButtons];
	}
	
	[self setResultsLabelText:@"Deck Shuffled, and game restarted."];
	[self setCardsRemainingText];
}

-(void) viewDidLoad
{
	
	// Load the first card in the deck
	[self flipCard:0];
	[self setMysteryCardCount:0];
	_cardImage = @"moose.jpg";
	
	
}

@end
