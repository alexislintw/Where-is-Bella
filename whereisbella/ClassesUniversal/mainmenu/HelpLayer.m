//
//  SuspectListLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/15.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "HelpLayer.h"
#import "MainMenuLayer.h"


@implementation HelpLayer


+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	HelpLayer *layer = [HelpLayer node];
	[scene addChild: layer];
    
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {
        currectPage = 1;
        [self showLayer];
	}
	return self;
}

-(void)showLayer
{    
    //scroll view
    NSMutableArray *arrLayers = [NSMutableArray arrayWithCapacity:3];
    
    for (int i=0; i<3; i++) {
        CCLayer *aLayer = [CCLayer node];
        [arrLayers addObject:aLayer];
        
        NSString *imageName = [[NSString alloc] initWithFormat:@"instruction_%d.png",i+1];
        CCSprite *page = [CCSprite spriteWithFile:imageName];
        [page setPosition:kScreenCenter];
        [aLayer addChild:page];
        [imageName release];
    }
    
    scroll = [[ScrollLayer alloc] initWithLayers:arrLayers AndCurrectScreen:1];
    [scroll setDelegate:self];
    [self addChild:scroll];
    
    
    //左右按鈕
    CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_small.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_small_sel.png"] target:self selector:@selector(pressMenu)];
    CCLabelTTF *labMenu = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kMenu",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
    [labMenu setPosition:ccp(POINT_SMALL_BUTTON_LABEL_CENTER.x,POINT_SMALL_BUTTON_LABEL_CENTER.y)];
    [itemMenu addChild:labMenu];
    
    itemLeft = [CCMenuItemImage itemWithNormalImage:@"btn_arrow_left.png" selectedImage:@"btn_arrow_left_sel.png" target:self selector:@selector(pressLeft)];
    itemRight = [CCMenuItemImage itemWithNormalImage:@"btn_arrow_right.png" selectedImage:@"btn_arrow_right_sel.png" target:self selector:@selector(pressRight)];
    [itemMenu setPosition:kBackMenuItemPosition];
    [itemLeft setPosition:kSuspectListLeftArrowPosition];
    [itemRight setPosition:kSuspectListRightArrowPosition];
    
    CCMenu *menuArrow = [CCMenu menuWithItems:itemMenu,itemLeft,itemRight,nil];
    [menuArrow setPosition:CGPointZero];
    [self addChild:menuArrow];
    
    [self scrollDidDoneWithCurrentScreen:currectPage];
}

-(void)scrollDidDoneWithCurrentScreen:(int)aScreen
{
    currectPage = aScreen;
    
    //左按鈕
    if (aScreen == 1) {
        [itemLeft setVisible:NO];
    }
    else {
        [itemLeft setVisible:YES];
        
    }
    //右按鈕
    if (aScreen == 3) {
        [itemRight setVisible:NO];
    }
    else {
        [itemRight setVisible:YES];
    }
}

#pragma mark -

-(void)pressMenu
{
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] withColor:ccBLACK]];
}

-(void)pressLeft
{
    [self playSound:@"SoundEffect2.mp3"];
    
    int n = currectPage - 1;
    [self scrollDidDoneWithCurrentScreen:n];
    scroll.currentScreen = n;
    [scroll move];
}

-(void)pressRight
{
    [self playSound:@"SoundEffect2.mp3"];
    
    int n = currectPage + 1;
    [self scrollDidDoneWithCurrentScreen:n];
    scroll.currentScreen = n;
    [scroll move];
}

@end
