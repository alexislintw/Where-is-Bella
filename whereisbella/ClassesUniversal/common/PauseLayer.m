//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/8/15.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "PauseLayer.h"
#import "ScenesLayer.h"
#import "HiddenObjectGameLayer.h"
#import "FindDifferenceGameLayer.h"

@implementation PauseLayer

@synthesize delegate;

-(id)init
{
	if( (self=[super init]) ) {
        
        //選單
        CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(100,100,100,100)];
        [self addChild:layer];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"bkg_pause.png"];
        [bg setPosition:kScreenCenter];
        [layer addChild:bg];
        
        CCMenuItemSprite *itemResume = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_medium.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_medium_sel.png"] disabledSprite:[CCSprite spriteWithFile:@"btn_tag_medium_dis.png"] target:self selector:@selector(pressResume)];
        CCLabelTTF *labResume = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kResume",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labResume setPosition:ccp(POINT_MEDIUM_BUTTON_LABEL_CENTER.x,POINT_MEDIUM_BUTTON_LABEL_CENTER.y)];
        [itemResume addChild:labResume];
        
        CCMenuItemSprite *itemRestart = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_medium.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_medium_sel.png"] disabledSprite:[CCSprite spriteWithFile:@"btn_tag_medium_dis.png"] target:self selector:@selector(pressRestart)];
        CCLabelTTF *labRestart = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kRestart",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labRestart setPosition:ccp(POINT_MEDIUM_BUTTON_LABEL_CENTER.x,POINT_MEDIUM_BUTTON_LABEL_CENTER.y)];
        [itemRestart addChild:labRestart];
        
        CCMenuItemSprite *itemBack = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_medium.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_medium_sel.png"] disabledSprite:[CCSprite spriteWithFile:@"btn_tag_medium_dis.png"] target:self selector:@selector(pressBack)];
        CCLabelTTF *labBack = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kBack",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labBack setPosition:ccp(POINT_MEDIUM_BUTTON_LABEL_CENTER.x,POINT_MEDIUM_BUTTON_LABEL_CENTER.y)];
        [itemBack addChild:labBack];
        
        CCMenu *menu = [CCMenu menuWithItems:itemResume,itemRestart,itemBack,nil];
        [menu alignItemsVerticallyWithPadding:10];
        [layer addChild:menu];
    }
    return self;
}

-(void)pressResume
{
    [self removeFromParentAndCleanup:YES];
    
    [[self delegate] resumeGame];
}

-(void)pressRestart
{
    [[self delegate] restartGame];
}

-(void)pressBack
{
    [[self delegate] endGame];
}

@end
