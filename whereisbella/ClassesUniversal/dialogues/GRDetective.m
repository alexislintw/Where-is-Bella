//
//  GRDetective.m
//  bella
//
//  Created by Alexis Lin on 13/5/23.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GRDetective.h"


@implementation GRDetective

-(id)initWithDetectiveId:(int)anId
{
	if( (self=[super init]) ) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"detectives" ofType:@"plist"];
        NSDictionary *dicDetectives = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSString *aKey = [[NSString alloc] initWithFormat:@"k-%d",anId];
        NSDictionary *aDetective = [[NSDictionary alloc] initWithDictionary:[dicDetectives objectForKey:aKey]];
        [aKey release];
        [dicDetectives release];
        
        if (aDetective != nil) {
            spriteFront = [CCSprite spriteWithFile:[aDetective objectForKey:@"kFrontImage"]];
            spriteSide = [CCSprite spriteWithFile:[aDetective objectForKey:@"kSideImage"]];
            [spriteFront setAnchorPoint:ccp(0.5,0)];
            [spriteSide setAnchorPoint:ccp(0.5,0)];
            [self addChild:spriteFront];
            [self addChild:spriteSide];
            
            [spriteFront setScale:0.8f];
            [spriteSide runAction:[CCFadeOut actionWithDuration:0]];
            
            [aDetective release];
        }
    }

    return self;
}

-(void)stepup
{
    id actionForFront = [CCSequence actions:
                         [CCScaleTo actionWithDuration:0.6f scale:1.0f],
                         [CCFadeOut actionWithDuration:0],
                         nil];
    id actionForSide = [CCSequence actions:
                        [CCDelayTime actionWithDuration:0.6f],
                        [CCFadeIn actionWithDuration:0],
                        nil];

    [spriteFront runAction:actionForFront];
    [spriteSide runAction:actionForSide];
}

-(void)stepdown
{
    id actionForSide = [CCFadeOut actionWithDuration:0];
                        
    id actionForFront = [CCSequence actions:
                         [CCFadeIn actionWithDuration:0],
                         [CCScaleTo actionWithDuration:1 scale:0.8],
                         nil];
    
    [spriteSide runAction:actionForSide];
    [spriteFront runAction:actionForFront];
    
    [spriteFront setColor:ccc3(220,220,220)];
}

@end
