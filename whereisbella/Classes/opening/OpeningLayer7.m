//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "OpeningLayer7.h"
#import "DialogueLayer.h"


@implementation OpeningLayer7


+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	OpeningLayer7 *layer = [OpeningLayer7 node];
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
        
        CCSprite *spriteRibbon = [CCSprite spriteWithFile:@"bkg_ribbon.png"];
        [spriteRibbon setPosition:ccp(size.width/2,size.height/2)];
        [self addChild:spriteRibbon];
        
        //粒子效果
        CCParticleSystemQuad *bubble = [CCParticleSystemQuad particleWithFile:@"particle_bubble.plist"];
        bubble.position = ccp(size.width/2,size.height*0.26);
        [self addChild:bubble];
        
        //角色
        CCSprite *spriteDoll = [CCSprite spriteWithFile:@"char_doll_side_2.png"];
        [spriteDoll setAnchorPoint:ccp(0.5,0.2)];
        [spriteDoll setPosition:ccp(size.width*0.41,size.height*0.39)];
        [self addChild:spriteDoll];
        
        CCSprite *spriteRobot = [CCSprite spriteWithFile:@"char_robot_side_2.png"];
        [spriteRobot setAnchorPoint:ccp(0.5,0.2)];
        [spriteRobot setPosition:ccp(size.width*0.75,size.height*0.39)];
        [self addChild:spriteRobot];

        //對話盒
        NSMutableArray *arrDialogues = [[NSMutableArray alloc] init];
        for (int i=0; i<2; i++) {
            NSString *aKey = [[NSString alloc] initWithFormat:@"a0s7d%d",i+1];
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
    }
    return self;
}

-(void)playDialogues
{
    [dialogueLayer startPlayDialogue];
}

-(void)dialogueDidEnd
{
    [self unscheduleAllSelectors];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[DialogueLayer sceneWithSuspectId:0 AndSceneId:0] withColor:ccBLACK]];
}

@end
