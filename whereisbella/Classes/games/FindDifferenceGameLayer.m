//
//  GameLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "FindDifferenceGameLayer.h"
#import "SuspectListLayer.h"
#import "DialogueLayer.h"
#import "ScenesLayer.h"
#import "PauseLayer.h"

@implementation FindDifferenceGameLayer

+(CCScene *)sceneWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId
{
    CCScene * scene = [CCScene node];
    FindDifferenceGameLayer *layer = [[[FindDifferenceGameLayer alloc] initWithSuspectId:aSuspectId AndSceneId:aSceneId] autorelease];
    [scene addChild: layer];
    return scene;
}

-(id)initWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId
{
	if( (self=[super init]) ) {

        suspectId = aSuspectId;
        sceneId = aSceneId;
        
        [self loadScripts];
        [self loadSceneImages];
        [self loadPanel];
        [self loadParticle];
        [self loadTouch];
	}
	return self;
}

#pragma mark -
#pragma mark loading method

-(void)loadParticle
{
    vanishSparkle = [CCParticleSystemQuad particleWithFile:@"particle_circle.plist"];
    [vanishSparkle stopSystem];
    [self addChild:vanishSparkle z:4];
}

-(void)loadScripts
{
    //讀取資料
    NSString *aKey = [[NSString alloc] initWithFormat:@"k-%d-%d",suspectId,sceneId];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"find_differences" ofType:@"plist"];
    NSDictionary *dicData = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
    arrObjects = [[NSMutableArray alloc] initWithArray:[dicData objectForKey:aKey]];
    [aKey release];
}

-(void)loadSceneImages
{
    //場景
    sceneLayer = [CCLayer node];
    [sceneLayer setPosition:ccp(0,42)];
    [self addChild:sceneLayer];

    //框
    CCSprite *spriteBackground = [CCSprite spriteWithFile:@"background_difference.png"];
    [spriteBackground setAnchorPoint:CGPointZero];
    [spriteBackground setPosition:ccp(0,0)];
    [self addChild:spriteBackground];

    //背景圖
    NSString *name = [NSString stringWithFormat:@"background_%d_%d.png",suspectId,sceneId];
    CCSprite *spriteBackgroundLeft = [CCSprite spriteWithFile:name];
    CCSprite *spriteBackgroundRight = [CCSprite spriteWithFile:name];
    [spriteBackgroundLeft setAnchorPoint:CGPointZero];
    [spriteBackgroundRight setAnchorPoint:CGPointZero];
    [spriteBackgroundLeft setPosition:ccp(10,0)];
    [spriteBackgroundRight setPosition:ccp(242+k4InchWidthDiff,0)];
    [sceneLayer addChild:spriteBackgroundLeft];
    [sceneLayer addChild:spriteBackgroundRight];

    //物件圖
    NSString *plistName = [[NSString alloc] initWithFormat:@"object_atlas_%d_%d.plist",suspectId,sceneId];
    NSString *pngName = [[NSString alloc] initWithFormat:@"object_atlas_%d_%d.png",suspectId,sceneId];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistName];
    spritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:pngName];
    [sceneLayer addChild:spritesBatchNode];

    //隨機打亂
	for (int i=0; i<[arrObjects count]; i++) {
        int rand = arc4random() % [arrObjects count];
        [arrObjects exchangeObjectAtIndex:0 withObjectAtIndex:rand];
    }

    //本關要找的物件
    for(int i=0; i<NUM_DIFFERENCES_NEED_TO_FIND; i++) {
        NSDictionary *dict = [arrObjects objectAtIndex:i];
        int tag = [[dict objectForKey:@"kTag"] intValue];
        NSString *name1 = [NSString stringWithFormat:@"%@_a.png",[dict objectForKey:@"kImageName"]];
        NSString *name2 = [NSString stringWithFormat:@"%@_b.png",[dict objectForKey:@"kImageName"]];
        CGPoint center = CGPointFromString([dict objectForKey:@"kCenterPosition"]);
        CGPoint center1 = CGPointMake(center.x+10,center.y);
        CGPoint center2 = CGPointMake(center.x+242+k4InchWidthDiff,center.y);
        CCSprite *sprite1 = [CCSprite spriteWithSpriteFrameName:name1];
        CCSprite *sprite2 = [CCSprite spriteWithSpriteFrameName:name2];
        [sprite1 setTag:tag];
        [sprite2 setTag:tag];
        [sprite1 setPosition:center1];
        [sprite2 setPosition:center2];
        [spritesBatchNode addChild:sprite1];
        [spritesBatchNode addChild:sprite2];
    }
}

-(void)loadPanel
{
    //面板
    CCLayer *panelLayer = [CCLayer node];
    [self addChild:panelLayer];
    
    CCSprite *spritePanel = [CCSprite spriteWithFile:@"bkg_object_list.png"];
    [spritePanel setAnchorPoint:CGPointZero];
    [panelLayer addChild:spritePanel];
    
    //選單
    itemHint = [CCMenuItemImage itemWithNormalImage:@"btn_hint.png" selectedImage:@"btn_hint_sel.png" disabledImage:@"btn_hint_dis.png" target:self selector:@selector(pressHint)];
    [itemHint setPosition:kGameHintButtonPosition];
    
    itemPause = [CCMenuItemImage itemWithNormalImage:@"btn_pause.png" selectedImage:@"btn_pause_sel.png" disabledImage:@"btn_pause_dis.png" target:self selector:@selector(pressPause)];
    [itemPause setPosition:kGamePauseButtonPosition];
    
    CCMenu *menu = [CCMenu menuWithItems:itemHint,itemPause,nil];
    [menu setPosition:CGPointZero];
    [panelLayer addChild:menu];
    
    //物件數量
    NSString *strFoundDifferencesNum = [[NSString alloc] initWithFormat:@"%d - %d",itemCounter,NUM_DIFFERENCES_NEED_TO_FIND];
    labelFoundDifferencesCounter = [CCLabelTTF labelWithString:strFoundDifferencesNum fontName:kFontName fontSize:kFontSize];
    CCLabelTTF *labelInstruction = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kAlertFindDifferences",@"ui_labels",nil) fontName:kFontName fontSize:kFontSize];
    [labelFoundDifferencesCounter setColor:ccBLACK];
    [labelInstruction setColor:ccBLACK];
    [labelFoundDifferencesCounter setPosition:CGPointMake(winSize.width/2,30)];
    [labelInstruction setPosition:CGPointMake(winSize.width/2,12)];
    [panelLayer addChild:labelFoundDifferencesCounter];
    [panelLayer addChild:labelInstruction];
    [strFoundDifferencesNum release];
}

#pragma mark -
#pragma mark touch method

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [sceneLayer convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{

}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)selectSpriteForTouch:(CGPoint)touchLocation
{
    CCSprite * newSprite = nil;
    
    for (CCSprite *sprite in spritesBatchNode.children) {
        if (sprite.tag >0 && CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            newSprite = sprite;
            break;
        }
    }
    
    if (newSprite != nil) {
        
        //音效
        [self playSound:@"SoundEffect3.mp3"];

        itemCounter ++;
        NSString *strFoundDifferencesNum = [[NSString alloc] initWithFormat:@"%d - %d",itemCounter,NUM_DIFFERENCES_NEED_TO_FIND];
        [labelFoundDifferencesCounter setString:strFoundDifferencesNum];
        [strFoundDifferencesNum release];
        
        //消失效果
        [vanishSparkle setPosition:[sceneLayer convertToWorldSpace:newSprite.position]];
        [vanishSparkle resetSystem];
        [self scheduleOnce:@selector(stopVanishEffect) delay:1];
        
        //標記
        int theTag = newSprite.tag;
        for (CCSprite *aSprite in spritesBatchNode.children) {
            if (aSprite.tag == theTag) {
                [aSprite setTag:0];
                CCSprite *spriteCircle = [CCSprite spriteWithFile:@"icon_circle.png"];
                [spriteCircle setPosition:aSprite.position];
                [sceneLayer addChild:spriteCircle z:10];
            }
        }
        
        //是否集滿物件
        if([self checkIfPass] == YES) {
            [self levelCompleted];
        }
    }
}

-(void)stopVanishEffect
{
    [vanishSparkle stopSystem];
}

-(bool)checkIfPass
{
	//return YES;
    
    if (itemCounter < NUM_DIFFERENCES_NEED_TO_FIND) {
        return NO;
    }
    return YES;
}

-(void)levelCompleted
{
	//計分儲存
    [self saveRecord];

    //取消其他互動
    if (isCanInteraction == YES) {
        [itemPause setIsEnabled:NO];
        [itemHint setIsEnabled:NO];
        [self unloadTouch];
    }

	//顯示分數畫面
	[self scheduleOnce:@selector(showResultPage) delay:0.5f];
}

//儲存資料
-(void)saveRecord
{
	//儲存紀錄 存每個有玩過的關卡的最高分數
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *aSceneKey = [[NSString alloc] initWithFormat:@"k-%d-%d",suspectId,sceneId];
    [userDefaults setBool:YES forKey:aSceneKey];
    [userDefaults synchronize];
    [aSceneKey release];
}

-(void)showResultPage
{
    //音效
    [self playSound:@"Victory.mp3"];

    CCLayerColor *resultLayer = [CCLayerColor layerWithColor:ccc4(0,0,0,127)];
    [resultLayer setPosition:ccp(0,500)];
    [self addChild:resultLayer z:1 tag:1];
    
    //背景
    CCSprite *bg = [CCSprite spriteWithFile:@"bkg_game_result.png"];
    [bg setPosition:ccp(winSize.width/2,winSize.height/2)];
    [resultLayer addChild:bg];

    //場景編號
    NSString *str = [[NSString alloc] initWithFormat:@"%@ %d-%d",NSLocalizedStringFromTable(@"kScene",@"ui_labels",nil),suspectId,sceneId];
    CCLabelTTF *sceneLabel = [CCLabelTTF labelWithString:str fontName:kFontName fontSize:24];
    [sceneLabel setColor:ccc3(250,250,250)];
    [sceneLabel setPosition:kGameResultSceneLabelPosition];
    [resultLayer addChild:sceneLabel];
    [str release];
    
    //標題
    CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kInvestigationFinished",@"ui_labels",nil) fontName:kFontName fontSize:kFontSizeHeading];
    [titleLabel setColor:ccc3(100, 50, 50)];
    [titleLabel setPosition:kGameResultTitlePosition];
    [resultLayer addChild:titleLabel z:10];
    
    //腳印
    CCSprite *footSprite = [CCSprite spriteWithFile:@"icon_footprint.png"];
    [footSprite setPosition:ccp(240+k4InchWidthDiff,192)];
    [resultLayer addChild:footSprite];
    
    //放大鏡
    CCSprite *magnifierSprite = [CCSprite spriteWithFile:@"icon_opening_magnifier.png"];
    [magnifierSprite setPosition:ccp(350+k4InchWidthDiff,182)];
    [resultLayer addChild:magnifierSprite];
    
    //戳章
    CCSprite *stampSprite = [CCSprite spriteWithFile:@"icon_complete.png"];
    [stampSprite setPosition:kGameResultStampPosition];
    [stampSprite setScale:0];
    [resultLayer addChild:stampSprite z:99 tag:99];
    
    //選單
    CCMenuItemImage *itemRetry = [CCMenuItemImage itemWithNormalImage:@"btn_retry.png" selectedImage:@"btn_retry_sel.png" target:self selector:@selector(pressRetry)];
    CCMenuItemImage *itemBack = [CCMenuItemImage itemWithNormalImage:@"btn_next.png" selectedImage:@"btn_next_sel.png" target:self selector:@selector(pressNext)];
    CCMenu *menu = [CCMenu menuWithItems:itemRetry,itemBack,nil];
    [menu alignItemsHorizontallyWithPadding:40];
    [menu setPosition:kGameResultMenuPosition];
    [resultLayer addChild:menu];
    
    //animation
    id moveBy = [CCMoveBy actionWithDuration:0.3 position:CGPointMake(0,-500)];
    [resultLayer runAction:moveBy];
    
    [self scheduleOnce:@selector(showStamp) delay:1.0f];
}

-(void)showStamp
{
    CCNode *spriteStamp = [[self getChildByTag:1] getChildByTag:99];
    [self attachPopUpAnimation:spriteStamp];
}

-(void)attachPopUpAnimation:(CCNode*)aNode
{
    id scaleTo0 = [CCScaleTo actionWithDuration:0.0f scale:0.0f];
    id scaleTo1 = [CCScaleTo actionWithDuration:0.15f scale:1.2f];
    id scaleTo2 = [CCScaleTo actionWithDuration:0.15f scale:0.8f];
    id scaleTo3 = [CCScaleTo actionWithDuration:0.15f scale:1.1f];
    id scaleTo4 = [CCScaleTo actionWithDuration:0.15f scale:0.9f];
    id scaleTo5 = [CCScaleTo actionWithDuration:0.15f scale:1.0f];
    [aNode runAction:[CCSequence actions:scaleTo0,scaleTo1,scaleTo2,scaleTo3,scaleTo4,scaleTo5,nil]];
}

#pragma mark -
#pragma mark hint method

-(void)pressHint
{
    //音效
    [self playSound:@"SoundEffect6.mp3"];

    if (itemHint.isEnabled == NO) {
        return;
    }
    
    int theTag = 0;
    
    for (CCSprite *aSprite in spritesBatchNode.children) {
        if (aSprite.tag > 0) {
            theTag = aSprite.tag;
            break;
        }
    }
    
    if (theTag > 0) {
        for (CCSprite *aSprite in spritesBatchNode.children) {
            if (theTag == aSprite.tag) {
                CCBlink *blink = [CCBlink actionWithDuration:1 blinks:5];
                [aSprite runAction:blink];
            }
        }
        //限制使用本功能
        [itemHint setIsEnabled:NO];
        [self scheduleOnce:@selector(recoverHint) delay:INTERVAL_DISABLE_HINT];
    }
}

-(void)recoverHint
{
    [itemHint setIsEnabled:YES];
}

#pragma mark -
#pragma mark pause method

-(void)pressPause
{
    //音效
    [self playSound:@"SoundEffect2.mp3"];

    //暫停選單
    PauseLayer *aLayer = [[PauseLayer alloc] init];
    [aLayer setDelegate:self];
    [self addChild:aLayer z:1 tag:1];
    
    //取消其他互動
    if (isCanInteraction == YES) {
        [itemPause setIsEnabled:NO];
        [itemHint setIsEnabled:NO];
        [self unloadTouch];
    }
}

-(void)resumeGame
{
    //音效
    [self playSound:@"SoundEffect2.mp3"];

    //恢復其他互動
    if (isCanInteraction == NO) {
        [itemPause setIsEnabled:YES];
        [itemHint setIsEnabled:YES];
        [self loadTouch];
    }
}

-(void)restartGame
{
    //音效
    [self playSound:@"SoundEffect2.mp3"];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[FindDifferenceGameLayer sceneWithSuspectId:suspectId AndSceneId:sceneId] withColor:ccBLACK]];
}

-(void)endGame
{
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ScenesLayer sceneWithSuspectId:suspectId] withColor:ccBLACK]];
}

#pragma mark -
#pragma mark result menu method

-(void)pressRetry
{
    [self playSound:@"SoundEffect2.mp3"];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[FindDifferenceGameLayer sceneWithSuspectId:suspectId AndSceneId:sceneId] withColor:ccBLACK]];
}

-(void)pressNext
{
    [self playSound:@"SoundEffect2.mp3"];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ScenesLayer sceneWithSuspectId:suspectId] withColor:ccBLACK]];
}

-(void) dealloc
{
    NSLog(@"findthedifference dealloc");
    
    [CCTextureCache purgeSharedTextureCache];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
    
    [super dealloc];
}

@end
