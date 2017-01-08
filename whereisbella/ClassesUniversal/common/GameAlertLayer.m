//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameAlertLayer.h"
#import "SuspectListLayer.h"
#import "EndingLayer1.h"


@implementation GameAlertLayer


+(CCScene *)sceneWithAlertId:(int)anId
{
    CCScene * scene = [CCScene node];
    GameAlertLayer *layer = [[[GameAlertLayer alloc] initWithAlertId:anId] autorelease];
    [scene addChild: layer];
    return scene;
}

-(id)initWithAlertId:(int)anId
{
	if( (self=[super init]) ) {

        alertId = anId;
        
        //背景
        CCSprite *background = [CCSprite spriteWithFile:@"background_opening_2.png"];
        [background setAnchorPoint:CGPointZero];
        [self addChild:background];
                
        CCSprite *panel = [CCSprite spriteWithFile:@"bkg_alert_panel.png"];
        [panel setPosition:kScreenCenter];
        [self addChild:panel];
        
        //按鈕
        CCMenuItemSprite *itemOK = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_round.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_round_sel.png"] target:self selector:@selector(pressOK)];
        [itemOK setPosition:ccp(winSize.width/2,winSize.height*0.3)];
        CCLabelTTF *labOK = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kOK",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labOK setPosition:ccp(POINT_ROUND_BUTTON_LABEL_CENTER.x,POINT_ROUND_BUTTON_LABEL_CENTER.y)];
        [itemOK addChild:labOK];

        CCMenu *aMenu = [CCMenu menuWithItems:itemOK,nil];
        [aMenu setPosition:ccp(0,0)];
        [self addChild:aMenu];
        
        //文字
        NSString *aString = nil;
        if (alertId == 1) {
            aString = NSLocalizedStringFromTable(@"kAlertAccuse",@"ui_labels",nil);
        }
        else if (alertId == 2) {
            aString = NSLocalizedStringFromTable(@"kAlertAnswer",@"ui_labels",nil);
        }
        
        CCLabelTTF *aLabel = [CCLabelTTF labelWithString:aString
                                                fontName:kFontName
                                                fontSize:kFontSize
                                              dimensions:CGSizeMake(panel.contentSize.width*0.7,panel.contentSize.height*0.7)
                                              hAlignment:UITextAlignmentCenter];
        [aLabel setColor:ccBLACK];
        [aLabel setPosition:ccp(kScreenCenter.x,kScreenCenter.y*0.8)];
        [self addChild:aLabel];
    }
    return self;
}

-(void)pressOK
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"SoundEffect2.mp3"];
    
    if (alertId == 1) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SuspectListLayer scene] withColor:ccBLACK]];
    }
    else if (alertId == 2) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[EndingLayer1 scene] withColor:ccBLACK]];
    }
}

@end
