//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "OpeningLayer2.h"
#import "OpeningLayer3.h"

@implementation OpeningLayer2

+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	OpeningLayer2 *layer = [OpeningLayer2 node];
	[scene addChild: layer];
    
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //背景
        CCSprite *background = [CCSprite spriteWithFile:@"background_opening_1.png"];
        [background setPosition:ccp(size.width/2,size.height*0.63)];
        [self addChild:background];
        
        //角色
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"char_atlas_bella_walk.plist"];
        CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"char_atlas_bella_walk.png"];
        [self addChild:spriteBatchNode z:5];
        
        spriteBella = [CCSprite spriteWithSpriteFrameName:@"char_bella_walk_1.png"];
        [spriteBella setPosition:ccp(size.width*0.76,size.height*0.58)];
        
        [spriteBatchNode addChild:spriteBella];

        //對話盒
        NSString *dialogueText = NSLocalizedStringFromTable(@"a0s2d1",@"dialogues",nil);
        NSArray *arrDialogues = [[NSArray alloc] initWithObjects:dialogueText,nil];
        dialogueLayer = [[GRDialogueLayer alloc] initWithDialogue:arrDialogues];
        [dialogueLayer setDelegate:self];
        [self addChild:dialogueLayer];
        
        [arrDialogues release];
        
        //腳本控制
        [self scheduleOnce:@selector(playDialogues) delay:1];
        [self scheduleOnce:@selector(bellaWalking) delay:1];
    }
    return self;
}

-(void)bellaWalking
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:4];
    [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"char_bella_walk_1.png"]];
    [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"char_bella_walk_2.png"]];
    [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"char_bella_walk_3.png"]];
    [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"char_bella_walk_2.png"]];
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frames delay:0.4f];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
    [spriteBella runAction:repeat];
    [spriteBella runAction:[CCMoveTo actionWithDuration:20 position:ccp(size.width*0.35,size.height*0.45)]];
}

-(void)playDialogues
{
    [dialogueLayer startPlayDialogue];
}

-(void)dialogueDidEnd
{
    [self unscheduleAllSelectors];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[OpeningLayer3 scene] withColor:ccBLACK]];
}

@end
