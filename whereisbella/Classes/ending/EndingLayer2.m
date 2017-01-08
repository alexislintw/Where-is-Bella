//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "EndingLayer2.h"
#import "EndingLayer3.h"


@implementation EndingLayer2


+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	EndingLayer2 *layer = [EndingLayer2 node];
	[scene addChild: layer];
    
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {

        //layer
        layerScene = [CCLayerColor layerWithColor:ccc4(255,0,0,255)];
        [layerScene setContentSize:CGSizeMake(852,480)];
        [layerScene setAnchorPoint:ccp(0.5,0.5)];
        [layerScene setScale:0.67];
        [layerScene setPosition:ccp(-146-(44-k4InchWidthDiff),-80)];
        [self addChild:layerScene];

        //背景
        CCSprite *spriteBackground = [CCSprite spriteWithFile:@"background_ending_2.png"];
        [spriteBackground setAnchorPoint:ccp(0,0)];
        [spriteBackground setPosition:ccp(0,0)];
        [layerScene addChild:spriteBackground];
        
        //角色
        spriteBella1 = [CCSprite spriteWithFile:@"char_bella_sit_1.png"];
        [spriteBella1 setPosition:ccp(437,245)];
        [layerScene addChild:spriteBella1];
        
        spriteBella2 = [CCSprite spriteWithFile:@"char_bella_sit_2.png"];
        [spriteBella2 setPosition:ccp(437,245)];
        [spriteBella2 setOpacity:0];
        [layerScene addChild:spriteBella2];

        //對話盒
        CCSprite *dialogueBox = [CCSprite spriteWithFile:@"bkg_dialogue_box.png"];
        [dialogueBox setAnchorPoint:ccp(0,0)];
        [dialogueBox setPosition:ccp(0,0)];
        [self addChild:dialogueBox];

        //對白文字
        labDialogue = [CCLabelTTF labelWithString:@""
                                         fontName:kFontName
                                         fontSize:kFontSize
                                       dimensions:CGSizeMake(dialogueBox.contentSize.width*0.9,dialogueBox.contentSize.height/2)
                                       hAlignment:UITextAlignmentCenter];
        [labDialogue setColor:ccBLACK];
        [labDialogue setPosition:ccp(winSize.width/2,dialogueBox.contentSize.height/2)];
        [self addChild:labDialogue];

        //腳本控制
        [self scheduleOnce:@selector(showDialogues) delay:0];
        [self scheduleOnce:@selector(zoomIn) delay:1];
        [self scheduleOnce:@selector(fadeIn) delay:2];
        [self scheduleOnce:@selector(nextCut) delay:6];
    }
    return self;
}

-(void)showDialogues
{
    NSString *dialogueText = NSLocalizedStringFromTable(@"a8s2d1",@"dialogues",nil);
    [labDialogue setOpacity:0];
    [labDialogue setString:dialogueText];
    
    id fadeIn = [CCFadeIn actionWithDuration:2.0f];
    [labDialogue runAction:fadeIn];
}

-(void)zoomIn
{
    [layerScene runAction:[CCScaleTo actionWithDuration:3 scale:1]];
}

-(void)fadeIn
{
    [spriteBella2 runAction:[CCFadeIn actionWithDuration:0.5]];
}

-(void)nextCut
{
    [self pauseSchedulerAndActions];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[EndingLayer3 scene] withColor:ccBLACK]];
}

@end
