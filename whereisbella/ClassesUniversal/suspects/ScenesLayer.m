//
//  ScenesLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/20.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ScenesLayer.h"
#import "HiddenObjectGameLayer.h"
#import "FindDifferenceGameLayer.h"
#import "MainMenuLayer.h"
#import "SuspectListLayer.h"


@implementation ScenesLayer


+(CCScene *)sceneWithSuspectId:(int)anId
{
    CCScene * scene = [CCScene node];
    ScenesLayer *layer = [[[ScenesLayer alloc] initWithSuspectId:anId] autorelease];
    [scene addChild: layer];
    return scene;
}

-(id)initWithSuspectId:(int)anId
{
	if( (self=[super init]) ) {

        suspectId = anId;

        //載入資料
        NSString *aKey = [[NSString alloc] initWithFormat:@"k-%d",suspectId];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"suspects" ofType:@"plist"];
        NSDictionary *dicSuspects = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSDictionary *aSuspect = [dicSuspects objectForKey:aKey];
        NSString *imageName = [aSuspect objectForKey:@"kImageForSuspectList"];
        NSString *suspectNameKey = [aSuspect objectForKey:@"kSuspectName"];
        NSString *suspectName = NSLocalizedStringFromTable(suspectNameKey,@"suspects_setting",nil);

        //背景
        CCSprite *background = [CCSprite spriteWithFile:@"background_scene.png"];
        [background setPosition:kScreenCenter];
        [self addChild:background];

        //標籤字
        NSString *aString = NSLocalizedStringFromTable(@"kScenes",@"ui_labels",nil);
        CCLabelTTF *label = [CCLabelTTF labelWithString:aString fontName:kFontName fontSize:kFontSizeHeading];
        [label setColor:kFontColor];
        [label setPosition:kSuspectSubMenuLabelPosition];
        [self addChild:label];
                        
        //人像
        CCSprite *photo = [CCSprite spriteWithFile:imageName];
        [photo setScale:0.82];
        [photo setPosition:kSuspectPhotoPosition];
        [self addChild:photo];
        
        //人名
        CCLabelTTF *labName = [CCLabelTTF labelWithString:suspectName fontName:kFontName fontSize:kFontSize];
        [labName setColor:kFontColor];
        [labName setPosition:kSuspectNamePosition];
        [self addChild:labName];
        
        //選單
        CCMenuItemSprite *itemBack = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_small.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_small_sel.png"] target:self selector:@selector(pressBack)];
        CCLabelTTF *labBack = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kBack",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labBack setPosition:ccp(POINT_SMALL_BUTTON_LABEL_CENTER.x,POINT_SMALL_BUTTON_LABEL_CENTER.y)];
        [itemBack addChild:labBack];
        
        CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_small.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_small_sel.png"] target:self selector:@selector(pressMenu)];
        CCLabelTTF *labMenu = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kMenu",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labMenu setPosition:ccp(POINT_SMALL_BUTTON_LABEL_CENTER.x,POINT_SMALL_BUTTON_LABEL_CENTER.y)];
        [itemMenu addChild:labMenu];
        
        CCMenu *menuButtons = [CCMenu menuWithItems:itemBack,itemMenu,nil];
        [menuButtons alignItemsVerticallyWithPadding:8];
        [menuButtons setPosition:kSuspectMenuPosition];
        [self addChild:menuButtons];

        //遊戲記錄
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        //場景小圖
        NSMutableArray *arrItems = [[NSMutableArray alloc] initWithCapacity:4];

        NSArray *arrPoints = [[NSArray alloc] initWithObjects:
                              [NSValue valueWithCGPoint:kSuspectSceneImage1Position],
                              [NSValue valueWithCGPoint:kSuspectSceneImage2Position],
                              [NSValue valueWithCGPoint:kSuspectSceneImage3Position],
                              [NSValue valueWithCGPoint:kSuspectSceneImage4Position],nil];
        
        //場景縮圖
        for (int i=0; i<4; i++) {
            int sceneId = i+1;
            NSString *fileName = [[NSString alloc] initWithFormat:@"btn_scene_%d_%d.png",anId,sceneId];
            CCMenuItemImage *itemScene = [CCMenuItemImage itemWithNormalImage:fileName selectedImage:nil];
            [itemScene setPosition:[[arrPoints objectAtIndex:i] CGPointValue]];
            [itemScene setTag:sceneId];
            [arrItems addObject:itemScene];
            
            if (sceneId == 1) { //第1個場景一定可以玩
                [itemScene setTarget:self selector:@selector(pressScene:)];
            }
            else { //之後的場景要看上一關是否已經完成
                NSString *aSceneKey = [[NSString alloc] initWithFormat:@"k-%d-%d",suspectId,sceneId-1];
                BOOL aBool = [userDefaults boolForKey:aSceneKey];
                if (aBool == YES) {
                    [itemScene setTarget:self selector:@selector(pressScene:)];
                }
                else {
                    [itemScene setOpacity:100];
                }
            }
        }
        
        CCMenu *menuScenes = [CCMenu menuWithArray:arrItems];
        [menuScenes setPosition:CGPointZero];
        [self addChild:menuScenes];
        
        //標章小圖
        for (int i=0; i<4; i++) {
            int sceneId = i+1;
            NSString *aKey = [[NSString alloc] initWithFormat:@"k-%d-%d",suspectId,sceneId];
            BOOL aBool = [userDefaults boolForKey:aKey];
            if (aBool == YES) {
                CCSprite *spriteStamp = [CCSprite spriteWithFile:@"icon_complete.png"];
                [spriteStamp setScale:0.75];
                [spriteStamp setOpacity:210];
                [spriteStamp setPosition:[[arrPoints objectAtIndex:i] CGPointValue]];
                [self addChild:spriteStamp];
            }
        }
	}
	return self;
}

-(void)pressScene:(id)sender
{
    [self playSound:@"SoundEffect2.mp3"];
    
    int sceneId = [sender tag];
    
    NSLog(@"suspect id: %d",suspectId);
    NSLog(@"scene id: %d",sceneId);
    
    //載入資料
    NSString *aKey = [[NSString alloc] initWithFormat:@"k-%d-%d",suspectId,sceneId];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scenes" ofType:@"plist"];
    NSDictionary *dicScenes = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSDictionary *aScene = [dicScenes objectForKey:aKey];
    NSString *mainGame = [aScene objectForKey:@"kMainGame"];
    
    if ([mainGame isEqualToString:@"hidden_object_game"]) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HiddenObjectGameLayer sceneWithSuspectId:suspectId AndSceneId:sceneId] withColor:ccBLACK]];
    }
    else if ([mainGame isEqualToString:@"find_difference_game"]) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[FindDifferenceGameLayer sceneWithSuspectId:suspectId AndSceneId:sceneId] withColor:ccBLACK]];
    }
    else {
        NSLog(@"error");
    }
    
    [aKey release];
    [dicScenes release];
}

-(void)pressBack
{
    [self playSound:@"SoundEffect2.mp3"];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SuspectListLayer sceneWithSuspectId:suspectId] withColor:ccBLACK]];
}

-(void)pressMenu
{
    [self playSound:@"SoundEffect2.mp3"];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] withColor:ccBLACK]];
}

@end
