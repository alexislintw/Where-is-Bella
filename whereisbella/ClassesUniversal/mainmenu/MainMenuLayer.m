//
//  MainMenuLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "OpeningLayer1.h"
#import "GameSettingLayer.h"
#import "HelpLayer.h"

@implementation MainMenuLayer

+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
	[scene addChild: layer];
    
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {

        [[CCDirector sharedDirector] purgeCachedData];
        
        //音效
        [self playMusic:@"ThemeSong1.mp3"];
                
        //背景
        CCSprite *background = [CCSprite spriteWithFile:@"background_opening.png"];
        [background setPosition:kScreenCenter];
        [self addChild:background];
        
        //標題
        CCSprite *banner = [CCSprite spriteWithFile:@"icon_opening_banner.png"];
        [banner setPosition:kBannerPosition];
        [self addChild:banner];
        
        CCSprite *title = [CCSprite spriteWithFile:@"icon_opening_title.png"];
        [title setPosition:ccp(winSize.width/2,winSize.height*0.8)];
        [self addChild:title];
        
        CCSprite *magnifier = [CCSprite spriteWithFile:@"icon_opening_magnifier.png"];
        [magnifier setPosition:ccp(winSize.width*0.756,winSize.height*0.82)];
        [self addChild:magnifier];
        
        //選單        
        CCMenuItemSprite *itemPlay = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_large.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_large_sel.png"] target:self selector:@selector(pressPlay)];
        CCLabelTTF *labPlay = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kPlay",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeMainMenuButton];
        [labPlay setPosition:ccp(POINT_LARGE_BUTTON_LABEL_CENTER.x,POINT_LARGE_BUTTON_LABEL_CENTER.y)];
        [itemPlay addChild:labPlay];
        
        float duration = 5;
        id scaleVerDown = [CCScaleTo actionWithDuration:duration * 5/30.f scaleX:1.0f scaleY:1.1f];
        id scaleVerBouncing = [CCEaseBounceInOut actionWithAction:scaleVerDown];
        id swell = [CCScaleTo actionWithDuration: duration * 15/30.f scale:1.1f];
        id swellEase = [CCEaseElasticOut actionWithAction:swell];
        id buttonAction = [CCRepeatForever actionWithAction:[CCSequence actions:scaleVerBouncing,swellEase,nil]];
        [itemPlay runAction:buttonAction];
                
        CCMenu *menu = [CCMenu menuWithItems:itemPlay,nil];
        [menu alignItemsVerticallyWithPadding:winSize.height*0.04];
        [menu setPosition:ccp(winSize.width/2,winSize.height*0.365)];
        [self addChild:menu z:10 tag:10];
        
        //小選單
        CCMenuItemImage *itemGoldrock = [CCMenuItemImage itemWithNormalImage:@"btn_opening_goldrock.png" selectedImage:@"btn_opening_goldrock_sel.png" target:self selector:@selector(pressGoldrock)];

        CCMenuItemImage *itemSetting = [CCMenuItemImage itemWithNormalImage:@"btn_opening_setting.png" selectedImage:@"btn_opening_setting_sel.png" target:self selector:@selector(pressSetting)];
        
        CCMenuItemImage *itemHelp = [CCMenuItemImage itemWithNormalImage:@"btn_opening_help.png" selectedImage:@"btn_opening_help_sel.png" target:self selector:@selector(pressHelp)];

        CCMenu *smallMenu = [CCMenu menuWithItems:itemGoldrock,itemSetting,itemHelp,nil];
        [smallMenu alignItemsHorizontallyWithPadding:0];
        [smallMenu setPosition:ccp(winSize.width*0.83,winSize.height*0.078)];
        [self addChild:smallMenu];
        
        //動畫
        CGFloat t = 1000;
        
        id place = [CCPlace actionWithPosition:CGPointMake(banner.position.x, banner.position.y+t)];
        id moveBy = [CCMoveBy actionWithDuration:1.0f position:CGPointMake(0,-t)];
        [banner runAction:[CCSequence actions:place,moveBy,nil]];
        
        id delay = [CCDelayTime actionWithDuration:1.0f];
        id scaleTo0 = [CCScaleTo actionWithDuration:0.0f scale:0.0f];
        id scaleTo1 = [CCScaleTo actionWithDuration:0.15f scale:1.2f];
        id scaleTo2 = [CCScaleTo actionWithDuration:0.15f scale:0.8f];
        id scaleTo3 = [CCScaleTo actionWithDuration:0.15f scale:1.1f];
        id scaleTo4 = [CCScaleTo actionWithDuration:0.15f scale:0.9f];
        id scaleTo5 = [CCScaleTo actionWithDuration:0.15f scale:1.0f];
        [title runAction:[CCSequence actions:scaleTo0,delay,scaleTo1,scaleTo2,scaleTo3,scaleTo4,scaleTo5,nil]];
        
        id place2 = [CCPlace actionWithPosition:CGPointMake(magnifier.position.x+t,magnifier.position.y)];
        id delay2 = [CCDelayTime actionWithDuration:1.8f];
        id moveBy2 = [CCMoveBy actionWithDuration:0.6f position:CGPointMake(-t,0)];
        id rotateBy = [CCRotateBy actionWithDuration:0.6f angle:720];
        id spawn = [CCSpawn actions:rotateBy,moveBy2,nil];
        [magnifier runAction:[CCSequence actions:place2,delay2,spawn,nil]];
        
        id delay3 = [CCDelayTime actionWithDuration:2.5f];
        id place3 = [CCPlace actionWithPosition:CGPointMake(menu.position.x+t,menu.position.y)];
        id moveBy3 = [CCMoveBy actionWithDuration:0.5f position:CGPointMake(-t,0)];
        [menu runAction:[CCSequence actions:place3,delay3,moveBy3,nil]];

        id delay4 = [CCDelayTime actionWithDuration:3.0f];
        id place4 = [CCPlace actionWithPosition:CGPointMake(smallMenu.position.x-t,smallMenu.position.y)];
        id moveBy4 = [CCMoveBy actionWithDuration:0.5f position:CGPointMake(t,0)];
        [smallMenu runAction:[CCSequence actions:place4,delay4,moveBy4,nil]];

    }
    return self;
}

-(void)pressPlay
{
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[OpeningLayer1 scene] withColor:ccBLACK]];
}

-(void)pressHelp
{
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelpLayer scene] withColor:ccBLACK]];
}

-(void)pressSetting
{
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameSettingLayer scene] withColor:ccBLACK]];
}

-(void)pressGoldrock
{
    [self playSound:@"SoundEffect2.mp3"];
    
    NSURL *url = [NSURL URLWithString:kUrlMore];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark -
#pragma mark payment delegate method
/*
-(void)paymentDidStart
{
    [ibIndicator startAnimating];
    
    CCMenu *aMenu = (CCMenu*)[self getChildByTag:10];
    [[[aMenu children] objectAtIndex:1] setIsEnabled:NO];
    [[[aMenu children] objectAtIndex:2] setIsEnabled:NO];
}

-(void)paymentDidStop
{
    [ibIndicator stopAnimating];
    
    CCMenu *aMenu = (CCMenu*)[self getChildByTag:10];
    [[[aMenu children] objectAtIndex:1] setIsEnabled:YES];
    [[[aMenu children] objectAtIndex:2] setIsEnabled:YES];
}

-(void)transactionDidCompleted
{
    //disable buttons
    CCMenu *aMenu = (CCMenu*)[self getChildByTag:10];
    [[[aMenu children] objectAtIndex:1] setIsEnabled:NO];
    [[[aMenu children] objectAtIndex:2] setIsEnabled:NO];
    
    //save records
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"kFullVersionPurchased"];
    [userDefaults synchronize];
}

-(void)onExit
{
    if (myPayment != nil ) {
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:myPayment];
    }
    
    [ibIndicator removeFromSuperview];
    
    [super onExit];
}
*/

-(void) dealloc
{
    [[CCDirector sharedDirector] purgeCachedData];
    
    [super dealloc];
}


@end
