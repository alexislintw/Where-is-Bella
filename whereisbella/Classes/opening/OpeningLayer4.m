//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "OpeningLayer4.h"
#import "OpeningLayer5.h"

@implementation OpeningLayer4

+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	OpeningLayer4 *layer = [OpeningLayer4 node];
	[scene addChild: layer];
    
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //背景
        CCSprite *background = [CCSprite spriteWithFile:@"background_opening_2.png"];
        [background setPosition:ccp(size.width/2,size.height/2)];
        [self addChild:background];

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
        [spriteKaden setOpacity:0];
        [self addChild:spriteKaden];
        
        spriteBella = [CCSprite spriteWithFile:@"char_bella_front_1.png"];
        [spriteBella setPosition:ccp(size.width*0.60,size.height*0.42)];
        [spriteBella setOpacity:0];
        [self addChild:spriteBella];
        
        spriteRyan = [CCSprite spriteWithFile:@"char_ryan_front_1.png"];
        [spriteRyan setPosition:ccp(size.width*0.45,size.height*0.42)];
        [spriteRyan setOpacity:0];
        [self addChild:spriteRyan];
        
        spriteAnnie = [CCSprite spriteWithFile:@"char_annie_front_1.png"];
        [spriteAnnie setPosition:ccp(size.width*0.3,size.height*0.42)];
        [spriteAnnie setOpacity:0];
        [self addChild:spriteAnnie];
        
        //第一批
        spriteJohnny = [CCSprite spriteWithFile:@"char_johnny_front_1.png"];
        [spriteJohnny setPosition:ccp(size.width*0.15,size.height*0.4)];
        [spriteJohnny setOpacity:0];
        [self addChild:spriteJohnny];
        
        spriteEmily = [CCSprite spriteWithFile:@"char_emily_front_1.png"];
        [spriteEmily setPosition:ccp(size.width*0.3,size.height*0.4)];
        [spriteEmily setOpacity:0];
        [self addChild:spriteEmily];
        
        spriteMichelle = [CCSprite spriteWithFile:@"char_michelle_front_1.png"];
        [spriteMichelle setPosition:ccp(size.width*0.45,size.height*0.4)];
        [spriteMichelle setOpacity:0];
        [self addChild:spriteMichelle];
        
        spritePierre = [CCSprite spriteWithFile:@"char_pierre_front_1.png"];
        [spritePierre setPosition:ccp(size.width*0.6,size.height*0.4)];
        [spritePierre setOpacity:0];
        [self addChild:spritePierre];
        
        spriteRobert = [CCSprite spriteWithFile:@"char_robert_front_1.png"];
        [spriteRobert setPosition:ccp(size.width*0.75,size.height*0.4)];
        [spriteRobert setOpacity:0];
        [self addChild:spriteRobert];
        
        //對話盒
        NSMutableArray *arrDialogues = [[NSMutableArray alloc] init];
        for (int i=0; i<2; i++) {
            NSString *aKey = [[NSString alloc] initWithFormat:@"a0s4d%d",i+1];
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
        [self scheduleOnce:@selector(fadeInCharacters) delay:1];
    }
    return self;
}

-(void)fadeInCharacters
{    
    [spriteJohnny runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:1.0f],
                            [CCFadeIn actionWithDuration:1],
                            [CCDelayTime actionWithDuration:2.4f],
                            [CCFadeOut actionWithDuration:1],
                            nil]];
    [spriteEmily runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:1.1f],
                            [CCFadeIn actionWithDuration:1],
                            [CCDelayTime actionWithDuration:2.3f],
                            [CCFadeOut actionWithDuration:1],
                            nil]];
    [spriteMichelle runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:1.2f],
                            [CCFadeIn actionWithDuration:1],
                            [CCDelayTime actionWithDuration:2.2f],
                            [CCFadeOut actionWithDuration:1],
                            nil]];
    [spritePierre runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:1.3f],
                             [CCFadeIn actionWithDuration:1],
                             [CCDelayTime actionWithDuration:2.1f],
                             [CCFadeOut actionWithDuration:1],
                             nil]];
    [spriteRobert runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:1.4f],
                             [CCFadeIn actionWithDuration:1],
                             [CCDelayTime actionWithDuration:2.0f],
                             [CCFadeOut actionWithDuration:1],
                             nil]];
    
    [spriteKaden runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:4.5f],
                            [CCFadeIn actionWithDuration:1],
                            //[CCDelayTime actionWithDuration:2.3f],
                            //[CCFadeOut actionWithDuration:1],
                            nil]];
    [spriteBella runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:4.6f],
                            [CCFadeIn actionWithDuration:1],
                            //[CCDelayTime actionWithDuration:2.2f],
                            //[CCFadeOut actionWithDuration:1],
                            nil]];
    [spriteRyan runAction:[CCSequence actions:
                           [CCDelayTime actionWithDuration:4.7f],
                           [CCFadeIn actionWithDuration:1],
                           //[CCDelayTime actionWithDuration:2.1f],
                           //[CCFadeOut actionWithDuration:1],
                           nil]];
    [spriteAnnie runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:4.8f],
                            [CCFadeIn actionWithDuration:1],
                            //[CCDelayTime actionWithDuration:2.0f],
                            //[CCFadeOut actionWithDuration:1],
                            nil]];
}

-(void)playDialogues
{
    [dialogueLayer startPlayDialogue];
}

-(void)dialogueDidEnd
{
    [self unscheduleAllSelectors];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[OpeningLayer5 scene] withColor:ccBLACK]];
}

@end
