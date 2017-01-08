//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameSettingLayer.h"
#import "MainMenuLayer.h"


@implementation GameSettingLayer


+(CCScene *)scene
{
    CCScene * scene = [CCScene node];
    GameSettingLayer *layer = [[[GameSettingLayer alloc] init] autorelease];
    [scene addChild: layer];
    return scene;
}

-(id)init
{
	if( (self=[super init]) ) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //背景
        CCSprite *background = [CCSprite spriteWithFile:@"background_common.png"];
        [background setPosition:kScreenCenter];
        [self addChild:background];
        
        CCLabelTTF *labMusic = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kMusic",@"ui_labels",nil) fontName:kFontName fontSize:kFontSizeHeading];
        [labMusic setColor:ccBLACK];
        [labMusic setPosition:kMusicLabelPosition];
        [self addChild:labMusic];
        
        CCLabelTTF *labSound = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kSound",@"ui_labels",nil) fontName:kFontName fontSize:kFontSizeHeading];
        [labSound setColor:ccBLACK];
        [labSound setPosition:kSoundLabelPosition];
        [self addChild:labSound];
        
        //音樂 on:0 off:1
        CCMenuItemImage *itemMusicOn = [CCMenuItemImage itemWithNormalImage:@"btn_on.png" selectedImage:nil];
        CCMenuItemImage *itemMusicOff = [CCMenuItemImage itemWithNormalImage:@"btn_off.png" selectedImage:nil];
        CCMenuItemToggle *itemMusic = [CCMenuItemToggle itemWithTarget:self selector:@selector(pressMusic:) items:itemMusicOn,itemMusicOff,nil];
        [itemMusic setSelectedIndex:[userDefaults integerForKey:@"music"]];
        [itemMusic setPosition:kMusicMenuItemPosition];
        
        //音效
        CCMenuItemImage *itemSoundOn = [CCMenuItemImage itemWithNormalImage:@"btn_on.png" selectedImage:nil];
        CCMenuItemImage *itemSoundOff = [CCMenuItemImage itemWithNormalImage:@"btn_off.png" selectedImage:nil];
        CCMenuItemToggle *itemSound = [CCMenuItemToggle itemWithTarget:self selector:@selector(pressSound:) items:itemSoundOn,itemSoundOff,nil];
        [itemSound setSelectedIndex:[userDefaults integerForKey:@"sound"]];
        [itemSound setPosition:kSoundMenuItemPosition];
        
        //回選單
        CCMenuItemSprite *itemBack = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_small.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_small_sel.png"] target:self selector:@selector(pressBack)];
        CCLabelTTF *labBack = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kMenu",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labBack setPosition:ccp(POINT_SMALL_BUTTON_LABEL_CENTER.x,POINT_SMALL_BUTTON_LABEL_CENTER.y)];
        [itemBack setPosition:kBackMenuItemPosition];
        [itemBack addChild:labBack];
        
        CCMenu *aMenu = [CCMenu menuWithItems:itemMusic,itemSound,itemBack,nil];
        [aMenu setPosition:ccp(0,0)];
        [self addChild:aMenu];
    }
    return self;
}

-(void)pressMusic:(id)sender
{
    CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:toggleItem.selectedIndex forKey:@"music"];
	[userDefaults synchronize];
    
	if (toggleItem.selectedIndex == 1) {
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	}
	else if (toggleItem.selectedIndex == 0) {
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ThemeSong1.mp3"];
	}
}

-(void)pressSound:(id)sender
{
    CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setInteger:toggleItem.selectedIndex forKey:@"sound"];
    
    [userDefaults synchronize];
}

-(void)pressBack
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] withColor:ccBLACK]];
}

@end
