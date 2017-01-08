//
//  ScrollLayer.m
//  testscrollview
//
//  Created by Alexis Lin on 12/12/17.
//  Copyright 2012年 Alexis Lin. All rights reserved.
//

#import "ScrollLayer.h"

@implementation ScrollLayer

@synthesize delegate;
@synthesize currentScreen;

-(id)initWithLayers:(NSMutableArray *)layers AndCurrectScreen:(int)aScreen
{
	if ( (self = [super init]) ) {
        
        winSize = [[CCDirector sharedDirector] winSize];
        
		[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
		currentScreen = aScreen;
        
		scrollWidth = winSize.width;
		scrollHeight = winSize.height;
		startWidth = scrollWidth;
		startHeight = scrollHeight;
        
		int i = 0;
		for (CCLayer *aLayer in layers)
		{
			aLayer.anchorPoint = ccp(0,0);
			aLayer.position = ccp(i*scrollWidth,0);
            
            int suspectId = i + 1;
			[self addChild:aLayer z:1 tag:suspectId];
			i++;
		}
        
		totalScreens = i;
        
        [self move];
	}
	return self;
}

-(void)move
{
	float dest = (-1*(currentScreen-1)*scrollWidth);
	id changePage = [CCEaseBounce actionWithAction:[CCMoveTo actionWithDuration:0.2 position:ccp(dest,0)]];
	[self runAction:changePage];
}

- (void)onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:[touch view]];
	//touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
	startPos = touchPoint.x;
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:[touch view]];
	//touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
	self.position = ccp( -1*(((currentScreen-1)*scrollWidth)+(startPos-touchPoint.x)),0 );
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:[touch view]];
    
	int newX = touchPoint.x;
    int tolerance = winSize.width/20;
    
	if ( (startPos-newX) > tolerance && (currentScreen+1) <= totalScreens ) {
		currentScreen++;
        [self.delegate scrollDidDoneWithCurrentScreen:currentScreen];
    }
	else if ( (startPos-newX) < -1*tolerance && (currentScreen-1) > 0 ) {
		currentScreen--;
        [self.delegate scrollDidDoneWithCurrentScreen:currentScreen];
    }
    
	[self move];
}

-(void)enableLockButton
{
    for (int i=0; i<7; i++) {
        int suspectId = i+1;
        
        CCLayer *aSuspectLayer = (CCLayer*)[self getChildByTag:suspectId];
        CCLayer *aLockLayer = (CCLayer*)[aSuspectLayer getChildByTag:100];
        CCMenu *aMenu = (CCMenu*)[aLockLayer getChildByTag:1];
        [[[aMenu children] objectAtIndex:0] setIsEnabled:YES];
    }
}

-(void)disableLockButton
{
    for (int i=0; i<7; i++) {
        int suspectId = i+1;
        
        CCLayer *aSuspectLayer = (CCLayer*)[self getChildByTag:suspectId];
        CCLayer *aLockLayer = (CCLayer*)[aSuspectLayer getChildByTag:100];
        CCMenu *aMenu = (CCMenu*)[aLockLayer getChildByTag:1];
        [[[aMenu children] objectAtIndex:0] setIsEnabled:NO];
    }
}

-(void)unlock
{
    for (int i=0; i<7; i++) {
        int suspectId = i+1;
        
        CCLayer *aLayer = (CCLayer*)[self getChildByTag:suspectId];
        [[aLayer getChildByTag:100] removeFromParentAndCleanup:YES]; //lockLayer
        
        if (suspectId == 2) {
            //檢查第一位最後一個場景是否已經完成
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            BOOL aBoolIfPass = [userDefaults boolForKey:@"k-1-4"];
            if (aBoolIfPass == YES) {
                CCMenu *aMenu = (CCMenu*)[aLayer getChildByTag:10];
                [[[aMenu children] objectAtIndex:0] setIsEnabled:YES];
                [[[aMenu children] objectAtIndex:1] setIsEnabled:YES];
            }
        }
    }
}

- (void) dealloc
{
	[super dealloc];
}

@end