//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "EndingLayer3.h"
#import "MainMenuLayer.h"


@implementation EndingLayer3

+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	EndingLayer3 *layer = [EndingLayer3 node];
	[scene addChild: layer];
    
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {

        //背景
        CCSprite *background = [CCSprite spriteWithFile:@"background_ending_3.png"];
        [background setPosition:kScreenCenter];
        [self addChild:background];
        
        //粒子效果
        CCParticleSystemQuad *redRibbon = [CCParticleSystemQuad particleWithFile:@"particle_red_ribbon.plist"];
        redRibbon.position = ccp(kScreenCenter.x,400);
        [self addChild:redRibbon];
        
        CCParticleSystemQuad *yellowRibbon = [CCParticleSystemQuad particleWithFile:@"particle_yellow_ribbon.plist"];
        yellowRibbon.position = ccp(kScreenCenter.x,400);
        [self addChild:yellowRibbon];
        
        //腳本控制
        [self scheduleOnce:@selector(nextCut) delay:9];
    }
    return self;
}

-(void)nextCut
{
    [self pauseSchedulerAndActions];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] withColor:ccBLACK]];
}

@end
