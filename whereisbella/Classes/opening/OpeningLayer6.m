//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "OpeningLayer6.h"
#import "OpeningLayer7.h"


@implementation OpeningLayer6


+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	OpeningLayer6 *layer = [OpeningLayer6 node];
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
        spriteKaden = [CCSprite spriteWithFile:@"char_kaden_front_2.png"];
        [spriteKaden setPosition:ccp(size.width*0.75,size.height*0.42)];
        [self addChild:spriteKaden];
                
        spriteRyan = [CCSprite spriteWithFile:@"char_ryan_front_1.png"];
        [spriteRyan setPosition:ccp(size.width*0.6,size.height*0.42)];
        [self addChild:spriteRyan];
        
        spriteAnnie = [CCSprite spriteWithFile:@"char_annie_front_1.png"];
        [spriteAnnie setPosition:ccp(size.width*0.3,size.height*0.42)];
        [self addChild:spriteAnnie];

        //對話盒
        NSString *dialogueText = NSLocalizedStringFromTable(@"a0s6d1",@"dialogues",nil);
        NSArray *arrDialogues = [[NSArray alloc] initWithObjects:dialogueText,nil];
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
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[OpeningLayer7 scene] withColor:ccBLACK]];
}

@end
