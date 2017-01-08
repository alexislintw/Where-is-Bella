//
//  GameCommon.m
//  bella
//
//  Created by Alexis Lin on 13/7/26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameCommonLayer.h"

@implementation GameCommonLayer

-(id)init
{
	if( (self=[super init]) ) {
        winSize = [[CCDirector sharedDirector] winSize];
    }
    return self;
}

-(void)loadTouch
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    isCanInteraction = YES;
}

-(void)unloadTouch
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    isCanInteraction = NO;
}

-(void)playMusic:(NSString*)audioFileName
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults integerForKey:@"music"] == 0) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:audioFileName loop:YES];
    }
}

-(void)playSound:(NSString*)audioFileName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults integerForKey:@"sound"] == 0) {
        [[SimpleAudioEngine sharedEngine] playEffect:audioFileName];
    }
}


@end
