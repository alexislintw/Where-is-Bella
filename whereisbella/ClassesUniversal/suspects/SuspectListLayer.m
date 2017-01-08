//
//  SuspectListLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/15.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "SuspectListLayer.h"
#import "ProfileLayer.h"
#import "ScenesLayer.h"
#import "EvidencesLayer.h"
#import "MainMenuLayer.h"
#import "SuspectListLayer.h"
#import "GameAlertLayer.h"

@implementation SuspectListLayer

@synthesize myPayment;
@synthesize ibIndicator;

+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	SuspectListLayer *layer = [SuspectListLayer node];
	[scene addChild: layer];
    
	return scene;
}

+(CCScene *)sceneWithSuspectId:(int)anId
{
    CCScene * scene = [CCScene node];
    SuspectListLayer *layer = [[[SuspectListLayer alloc] initWithSuspectId:anId] autorelease];
    [scene addChild: layer];
    return scene;
}

-(id)initWithSuspectId:(int)anId
{
    if( (self=[super init]) ) {
        
        [[CCDirector sharedDirector] purgeCachedData];
        
        currectSuspect = anId;
        [self showLayer];
        
	}
	return self;
}

-(id)init
{
	if( (self=[super init]) ) {
        
        [[CCDirector sharedDirector] purgeCachedData];
        
        currectSuspect = 1;
        [self showLayer];
	}
	return self;
}

-(void)showLayer
{
    //載入資料
    NSString *path = [[NSBundle mainBundle] pathForResource:@"suspects" ofType:@"plist"];
    dicSuspects = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    //背景
    CCSprite *background = [CCSprite spriteWithFile:@"background_common.png"];
    [background setPosition:kScreenCenter];
    [self addChild:background];
    
    //標題
    NSString *aString = NSLocalizedStringFromTable(@"kSuspectList",@"ui_labels",nil);
    CCLabelTTF *labelSuspectList = [CCLabelTTF labelWithString:aString fontName:kFontName fontSize:kFontSize*2];
    [labelSuspectList setPosition:kSuspectListTitlePosition];
    [labelSuspectList setColor:kFontColor];
    [self addChild:labelSuspectList];
    
    //左右按鈕
    CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_small.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_small_sel.png"] target:self selector:@selector(pressMenu)];
    CCLabelTTF *labMenu = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kMenu",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
    [labMenu setPosition:POINT_SMALL_BUTTON_LABEL_CENTER];
    [itemMenu addChild:labMenu];

    itemLeft = [CCMenuItemImage itemWithNormalImage:@"btn_arrow_left.png" selectedImage:@"btn_arrow_left_sel.png" target:self selector:@selector(pressLeft)];
    itemRight = [CCMenuItemImage itemWithNormalImage:@"btn_arrow_right.png" selectedImage:@"btn_arrow_right_sel.png" target:self selector:@selector(pressRight)];
    [itemMenu setPosition:kBackMenuItemPosition];
    [itemLeft setPosition:kSuspectListLeftArrowPosition];
    [itemRight setPosition:kSuspectListRightArrowPosition];
    
    CCMenu *menuArrow = [CCMenu menuWithItems:itemMenu,itemLeft,itemRight,nil];
    [menuArrow setPosition:ccp(0,0)];
    [self addChild:menuArrow];
    
    //[itemLeft setVisible:NO];
    [self scrollDidDoneWithCurrentScreen:currectSuspect];
    
    //scroll view
    NSMutableArray *arrLayers = [NSMutableArray arrayWithCapacity:7];
    
    /*
     ---------------------------------
     profile    要上一個嫌疑犯4個場景都完成,
     play       要上一個嫌疑犯4個場景都完成,
     evidence   看play是否可用,
     accuse     所有嫌疑犯都完成
     */

    //遊戲記錄
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //IAP
    if ([userDefaults boolForKey:@"kFullVersionPurchased"] == NO) {
        [self loadPayment];
    }
    
    NSString *aKeyForSuspectImage;
    ccColor3B aColorSuspectName;

    isAccuseEnabled = [self checkAccuseIsEnabled];

    for (int i=0; i<7; i++) {
        
        int suspectId = i+1;
        NSString *aSuspectKey = [[NSString alloc] initWithFormat:@"k-%d",suspectId];
        NSDictionary *aSuspect = [dicSuspects objectForKey:aSuspectKey];
        [aSuspectKey release];
        
        //檢查上一位最後一個場景是否已經完成
        int lastSuspectId = suspectId - 1;
        NSString *theLastSuspect4thSceneKey = [[NSString alloc] initWithFormat:@"k-%d-4",lastSuspectId];
        BOOL aBoolIfPass = [userDefaults boolForKey:theLastSuspect4thSceneKey];
        [theLastSuspect4thSceneKey release];
        
        //-------- template ------------------
        CCLayer *aLayer = [CCLayer node];
        
        //背板
        CCSprite *panel = [CCSprite spriteWithFile:@"bkg_suspect_panel.png"];
        [panel setPosition:kScreenCenter];
        [aLayer addChild:panel];

        //人像
        if ( suspectId == 1 || (suspectId>1 && aBoolIfPass==YES) ) {
            aColorSuspectName = kFontColor;
            aKeyForSuspectImage = @"kImageForSuspectList";
        }
        else {
            aColorSuspectName = ccGRAY;
            aKeyForSuspectImage = @"kImageForDisable";
        }
        NSString *imageName = [aSuspect objectForKey:aKeyForSuspectImage];
        CCSprite *photo = [CCSprite spriteWithFile:imageName];
        [photo setPosition:kSuspectListPhotoPosition];
        [aLayer addChild:photo];
        
        //人名
        NSString *suspectNameKey = [aSuspect objectForKey:@"kSuspectName"];
        NSString *suspectName = NSLocalizedStringFromTable(suspectNameKey,@"suspects_setting",nil);
        CCLabelTTF *label = [CCLabelTTF labelWithString:suspectName
                                               fontName:kFontName
                                               fontSize:kFontSize];
        [label setColor:aColorSuspectName];
        [label setPosition:kSuspectListNamePosition];
        [aLayer addChild:label];
        [arrLayers addObject:aLayer];

        //選單
        CCMenuItemSprite *itemProfile = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_medium.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_medium_sel.png"] disabledSprite:[CCSprite spriteWithFile:@"btn_tag_medium_dis.png"] target:self selector:@selector(pressProfile)];
        CCLabelTTF *labProfile = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kProfile",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labProfile setPosition:POINT_MEDIUM_BUTTON_LABEL_CENTER];
        [itemProfile addChild:labProfile];

        CCMenuItemSprite *itemPlay = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_medium.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_medium_sel.png"] disabledSprite:[CCSprite spriteWithFile:@"btn_tag_medium_dis.png"] target:self selector:@selector(pressPlay)];
        CCLabelTTF *labPlay = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kPlay",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labPlay setPosition:POINT_MEDIUM_BUTTON_LABEL_CENTER];
        [itemPlay addChild:labPlay];
        
        CCMenuItemSprite *itemEvidences = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_medium.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_medium_sel.png"] disabledSprite:[CCSprite spriteWithFile:@"btn_tag_medium_dis.png"] target:self selector:@selector(pressEvidences)];
        CCLabelTTF *labEvidences = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kEvidences",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labEvidences setPosition:POINT_MEDIUM_BUTTON_LABEL_CENTER];
        [itemEvidences addChild:labEvidences];
        
        CCMenuItemSprite *itemAccuse = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_medium.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_medium_sel.png"] disabledSprite:[CCSprite spriteWithFile:@"btn_tag_medium_dis.png"] target:self selector:@selector(pressAccuse)];
        CCLabelTTF *labAccuse = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kAccuse",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labAccuse setPosition:POINT_MEDIUM_BUTTON_LABEL_CENTER];
        [itemAccuse addChild:labAccuse];
        
        CCMenu *menu = [CCMenu menuWithItems:itemProfile,itemPlay,itemEvidences,itemAccuse,nil];
        [menu alignItemsVerticallyWithPadding:winSize.height*0.025];
        [menu setPosition:kSuspectListMenuPosition];
        [aLayer addChild:menu z:10 tag:10];

        //判斷IAP是否已購買
        if (suspectId > 1 && [userDefaults boolForKey:@"kFullVersionPurchased"] == NO) {
            //上鎖
            CCLayerColor *lockLayer = [CCLayerColor layerWithColor:ccc4(60,60,60,150)];
            CCMenuItemImage *itemLock = [CCMenuItemImage itemWithNormalImage:@"btn_lock.png" selectedImage:nil target:self selector:@selector(pressLock)];
            [itemLock setPosition:klockMenuItemPosition];
            CCMenu *menu2 = [CCMenu menuWithItems:itemLock,nil];
            [menu2 setPosition:ccp(0,0)];
            [lockLayer addChild:menu2 z:1 tag:1];
            [aLayer addChild:lockLayer z:100 tag:100];
            
            //設按鈕狀態
            [itemProfile setIsEnabled:NO];
            [itemPlay setIsEnabled:NO];
            [itemEvidences setIsEnabled:NO];
            [itemAccuse setIsEnabled:NO];
        }
        else {
            //設按鈕狀態
            if ( suspectId == 1 || (suspectId>1 && aBoolIfPass==YES) ) {
                [itemProfile setIsEnabled:YES];
                [itemPlay setIsEnabled:YES];
            }
            else {
                [itemProfile setIsEnabled:NO];
                [itemPlay setIsEnabled:NO];
            }
            
            //找到第一個證據
            NSString *aEvidenceKey = [[NSString alloc] initWithFormat:@"s%de1",suspectId];
            BOOL aBoolEvidence = [userDefaults boolForKey:aEvidenceKey];
            if (aBoolEvidence == YES) {
                [itemEvidences setIsEnabled:YES];
            }
            else {
                [itemEvidences setIsEnabled:NO];
            }
            
            //全部嫌疑犯完成
            NSString *aKeyAccused = [[NSString alloc] initWithFormat:@"kAccused-%d",suspectId];
            BOOL aBoolAccused = [userDefaults boolForKey:aKeyAccused];
            [aKeyAccused release];
            if ([self checkAccuseIsEnabled] == YES) {
                if (aBoolAccused == YES) {
                    [itemAccuse setIsEnabled:NO];
                }
                else {
                    [itemAccuse setIsEnabled:YES];
                }
            }
            else {
                [itemAccuse setIsEnabled:NO];
            }
            
            //guilty stamp
            if (aBoolAccused == YES) {
                NSString *stampImageName;
                if (suspectId == 3) {
                    stampImageName = @"icon_guilty.png";
                }
                else {
                    stampImageName = @"icon_not_guilty.png";
                }
                CCSprite *spriteStamp = [CCSprite spriteWithFile:stampImageName];
                [spriteStamp setPosition:kScreenCenter];
                [aLayer addChild:spriteStamp z:20];
            }
        }
    }
    
    scroll = [[ScrollLayer alloc] initWithLayers:arrLayers AndCurrectScreen:currectSuspect];
    [scroll setDelegate:self];
    [self addChild:scroll];
}

-(BOOL)checkAccuseIsEnabled
{
    //return YES;
    
    //全部的suspects都完成
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    int passNum = 0;
    for (int i=0; i<7; i++) {
        NSString *aKey = [[NSString alloc] initWithFormat:@"k-%d-4",i+1];
        if ([userDefaults boolForKey:aKey] == YES) {
            passNum ++;
        }
        [aKey release];
    }
    
    if (passNum == 7) {
        return YES;
    }
    
    return NO;
}

-(void)scrollDidDoneWithCurrentScreen:(int)aScreen
{
    currectSuspect = aScreen;
    
    //音效
    NSString *bgmName = [[NSString alloc] initWithFormat:@"suspect_%d.mp3",currectSuspect];
    [self playMusic:bgmName];

    //左按鈕
    if (aScreen == 1) {
        [itemLeft setVisible:NO];
    }
    else {
        [itemLeft setVisible:YES];
        
    }
    //右按鈕
    if (aScreen == 7) {
        [itemRight setVisible:NO];
    }
    else {
        [itemRight setVisible:YES];
    }
    [bgmName release];
}

-(void)loadPayment
{
    GRPayment *aPayment = [[GRPayment alloc] init];
    [aPayment setMyDelegate:self];
    self.myPayment = aPayment;
    [aPayment release];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:myPayment];
    
    //loading
    UIActivityIndicatorView *aIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.ibIndicator = aIndicator;
    [aIndicator release];
    
    [ibIndicator setHidesWhenStopped:YES];
    [ibIndicator setCenter:kScreenCenter];
    [[[CCDirector sharedDirector] view] addSubview:ibIndicator];
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
    
    int n = currectSuspect - 1;
    [self scrollDidDoneWithCurrentScreen:n];
    scroll.currentScreen = n;
    [scroll move];
}

-(void)pressRight
{
    [self playSound:@"SoundEffect2.mp3"];
    
    int n = currectSuspect + 1;
    [self scrollDidDoneWithCurrentScreen:n];
    scroll.currentScreen = n;
    [scroll move];
}

-(void)pressProfile
{
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ProfileLayer sceneWithSuspectId:currectSuspect] withColor:ccBLACK]];
}

-(void)pressPlay
{
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ScenesLayer sceneWithSuspectId:currectSuspect] withColor:ccBLACK]];
}

-(void)pressEvidences
{
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[EvidencesLayer sceneWithSuspectId:currectSuspect] withColor:ccBLACK]];
}

-(void)pressAccuse
{
    [self playSound:@"SoundEffect2.mp3"];
    
    //儲存記錄
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *aKey = [[NSString alloc] initWithFormat:@"kAccused-%d",currectSuspect];
    [userDefaults setBool:YES forKey:aKey];
    [aKey release];
    
    CCLayer *aLayer = (CCLayer*)[scroll getChildByTag:currectSuspect];
    
    //guilty stamp
    NSString *imageName;
    if (currectSuspect == 3) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"Victory.mp3"];
        imageName = @"icon_guilty.png";
    }
    else {
        [[SimpleAudioEngine sharedEngine] playEffect:@"ding.mp3"];
        imageName = @"icon_not_guilty.png";
    }
    CCSprite *spriteStamp = [CCSprite spriteWithFile:imageName];
    [spriteStamp setPosition:kScreenCenter];
    [spriteStamp setScale:2];
    [aLayer addChild:spriteStamp z:20 tag:20];
    [spriteStamp runAction:[CCScaleTo actionWithDuration:0.2 scale:1]];
    
    //disable accuse
    CCMenu *aMenu = (CCMenu*)[aLayer getChildByTag:10];
    CCMenuItem *aItem = [aMenu.children objectAtIndex:3];
    [aItem setIsEnabled:NO];
    
    //結尾畫面
    if (currectSuspect == 3) {
        [self scheduleOnce:@selector(showAnswer) delay:1.5];
    }
}

-(void)pressLock
{
    if (ibIndicator.isAnimating == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"kFullVersion",@"ui_labels",nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"kCancel",@"ui_labels",nil) otherButtonTitles:NSLocalizedStringFromTable(@"kPurchase",@"ui_labels",nil),NSLocalizedStringFromTable(@"kRestore",@"ui_labels",nil),nil];
        [alertView show];
        [alertView release];
    }
}

#pragma mark -
#pragma mark alert delegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self playSound:@"SoundEffect2.mp3"];
    
    //取消
    if (buttonIndex == 0) {
        [ibIndicator stopAnimating];
    }
    else if (buttonIndex == 1) {
        int idx = 0;
        NSString *productId = [[myPayment arrProducts] objectAtIndex:idx];
        [myPayment buyProduct:productId];
    }
    else if (buttonIndex == 2) {
        [myPayment restoreProduct];
    }

    NSLog(@"%d",buttonIndex);
}

-(void)showAnswer
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameAlertLayer sceneWithAlertId:2] withColor:ccBLACK]];
}

#pragma mark -
#pragma mark payment delegate method

-(void)paymentDidStart
{
    [scroll disableLockButton];
    [ibIndicator startAnimating];
}

-(void)paymentDidStop
{
    [scroll enableLockButton];
    [ibIndicator stopAnimating];
}

-(void)transactionDidCompleted
{
    [scroll unlock];
    
    //save
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"kFullVersionPurchased"];
    [userDefaults synchronize];
}

-(void)onExit
{
    [scroll setDelegate:nil];
    
    if (myPayment != nil ) {
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:myPayment];
    }
    
    [ibIndicator removeFromSuperview];
    
    [super onExit];
}

-(void) dealloc
{
    [[CCDirector sharedDirector] purgeCachedData];
    
    [super dealloc];
}

@end
