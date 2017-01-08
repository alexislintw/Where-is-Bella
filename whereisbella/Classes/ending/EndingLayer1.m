//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "EndingLayer1.h"
#import "EndingLayer2.h"


@implementation EndingLayer1


+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	EndingLayer1 *layer = [EndingLayer1 node];
	[scene addChild: layer];
    
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {

        //layer
        layerScene = [CCLayerColor layerWithColor:ccc4(255,0,0,255)];
        [layerScene setContentSize:CGSizeMake(852,480)];
        [layerScene setAnchorPoint:ccp(0.5,0)];
        [layerScene setScale:0.67];
        [layerScene setPosition:ccp(-140-(44-k4InchWidthDiff),90)];
        [self addChild:layerScene];
        
        //背景
        spriteBackground = [CCSprite spriteWithFile:@"background_ending_1.png"];
        [spriteBackground setAnchorPoint:ccp(0,0)];
        [spriteBackground setPosition:ccp(0,0)];
        [layerScene addChild:spriteBackground];
        
        //角色
        CCSprite *spriteInside = [CCSprite spriteWithFile:@"icon_car_inside.png"];
        [spriteInside setPosition:ccp(512,114)];
        [layerScene addChild:spriteInside];

        spriteWindow = [CCSprite spriteWithFile:@"icon_car_window.png"];
        [spriteWindow setPosition:ccp(510,132)];
        [layerScene addChild:spriteWindow];
        
        CCSprite *spriteCar = [CCSprite spriteWithFile:@"icon_car.png"];
        [spriteCar setPosition:ccp(410,80)];
        [layerScene addChild:spriteCar];

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
        [self scheduleOnce:@selector(showDialogues) delay:1];
        [self scheduleOnce:@selector(zoomIn) delay:1];
        [self scheduleOnce:@selector(pullDown) delay:3];
        [self scheduleOnce:@selector(nextCut) delay:5];
    }
    return self;
}

-(void)showDialogues
{
    NSString *dialogueText = NSLocalizedStringFromTable(@"a8s1d1",@"dialogues",nil);
    [labDialogue setOpacity:0];
    [labDialogue setString:dialogueText];
    
    id fadeIn = [CCFadeIn actionWithDuration:2.0f];
    [labDialogue runAction:fadeIn];
}

-(void)zoomIn
{
    //音效
    [self playMusic:@"ThemeSong3.mp3"];
    
    [layerScene runAction:[CCScaleTo actionWithDuration:2 scale:1]];
}

-(void)pullDown
{
    [spriteWindow runAction:[CCMoveBy actionWithDuration:2 position:ccp(0,-80)]];
}

-(void)nextCut
{
    [self pauseSchedulerAndActions];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[EndingLayer2 scene] withColor:ccBLACK]];
}

@end
