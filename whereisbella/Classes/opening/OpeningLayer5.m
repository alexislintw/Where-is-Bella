//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "OpeningLayer5.h"
#import "OpeningLayer6.h"


@implementation OpeningLayer5


+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	OpeningLayer5 *layer = [OpeningLayer5 node];
	[scene addChild: layer];
    
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //背景
        CCSprite *spriteBackground = [CCSprite spriteWithFile:@"background_opening_2.png"];
        [spriteBackground setPosition:ccp(size.width/2,size.height/2)];
        [self addChild:spriteBackground];

        //粒子效果
        CCParticleSystemQuad *redRibbon = [CCParticleSystemQuad particleWithFile:@"particle_red_ribbon.plist"];
        redRibbon.position = ccp(size.width/2,size.height*1.05);
        [self addChild:redRibbon];
        
        CCParticleSystemQuad *yellowRibbon = [CCParticleSystemQuad particleWithFile:@"particle_yellow_ribbon.plist"];
        yellowRibbon.position = ccp(size.width/2,size.height*1.05);
        [self addChild:yellowRibbon];

        //角色
        spriteDoll = [CCSprite spriteWithFile:@"char_doll_front_1.png"];
        [spriteDoll setAnchorPoint:ccp(0.5,0.2)];
        [spriteDoll setPosition:ccp(size.width*0.43,size.height*0.39)];
        [spriteDoll setScale:0.8];
        [self addChild:spriteDoll];

        spriteDoll2 = [CCSprite spriteWithFile:@"char_doll_side_1.png"];
        [spriteDoll2 setAnchorPoint:ccp(0.5,0.2)];
        [spriteDoll2 setPosition:ccp(size.width*0.43,size.height*0.39)];
        [spriteDoll2 setOpacity:0];
        [self addChild:spriteDoll2];

        spriteRobot = [CCSprite spriteWithFile:@"char_robot_front_1.png"];
        [spriteRobot setAnchorPoint:ccp(0.5,0.2)];
        [spriteRobot setPosition:ccp(size.width*0.7,size.height*0.39)];
        [spriteRobot setScale:0.8];
        [spriteRobot setOpacity:0];
        [self addChild:spriteRobot];
                
        spriteRobot2 = [CCSprite spriteWithFile:@"char_robot_side_1.png"];
        [spriteRobot2 setAnchorPoint:ccp(0.5,0.2)];
        [spriteRobot2 setPosition:ccp(size.width*0.7,size.height*0.39)];
        [spriteRobot2 setOpacity:0];
        [self addChild:spriteRobot2];

        //對話盒
        NSMutableArray *arrDialogues = [[NSMutableArray alloc] init];
        for (int i=0; i<2; i++) {
            NSString *aKey = [[NSString alloc] initWithFormat:@"a0s5d%d",i+1];
            NSString *aText = NSLocalizedStringFromTable(aKey,@"dialogues",nil);
            [arrDialogues addObject:aText];
            
            [aKey release];
        }
        dialogueLayer = [[GRDialogueLayer alloc] initWithDialogue:arrDialogues];
        [dialogueLayer setDelegate:self];
        [self addChild:dialogueLayer];
        
        [arrDialogues release];
        
        //腳本控制
        [self scheduleOnce:@selector(playDialogues) delay:1];
        [self scheduleOnce:@selector(playBGM) delay:4.8];
        [self scheduleOnce:@selector(zoomIn) delay:0];
    }
    return self;
}

-(void)playBGM
{
    [self playMusic:@"ThemeSong2.mp3"];
}

-(void)zoomIn
{
    [spriteDoll runAction:[CCSequence actions:
                           [CCDelayTime actionWithDuration:1],
                           [CCScaleTo actionWithDuration:2.5 scale:1],
                           [CCDelayTime actionWithDuration:4],
                           [CCFadeOut actionWithDuration:1],
                           nil]];
    
    [spriteDoll2 runAction:[CCSequence actions:
                           [CCDelayTime actionWithDuration:7.5],
                           [CCFadeIn actionWithDuration:1],
                           nil]];
    
    [spriteRobot runAction:[CCSequence actions:
                           [CCDelayTime actionWithDuration:4],
                           [CCFadeIn actionWithDuration:0.1],
                           [CCScaleTo actionWithDuration:2 scale:1],
                           [CCDelayTime actionWithDuration:1],
                           [CCFadeOut actionWithDuration:1],
                           nil]];
    
    [spriteRobot2 runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:7.1],
                            [CCFadeIn actionWithDuration:1],
                            nil]];
}

-(void)playDialogues
{
    [dialogueLayer startPlayDialogue];
}

-(void)dialogueDidEnd
{
    [self unscheduleAllSelectors];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[OpeningLayer6 scene] withColor:ccBLACK]];
}

@end
