//
//  GameLayer.m
//  bella
//
//  Created by Alexis Lin on 13/8/12.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "HiddenObjectGameLayer.h"
#import "SuspectListLayer.h"
#import "ScenesLayer.h"
#import "DialogueLayer.h"
#import "JigsawPuzzleGameLayer.h"
#import "PixelSudokuGameLayer.h"
#import "ConnectionGameLayer.h"
#import "PauseLayer.h"

@implementation HiddenObjectGameLayer

@synthesize arrObjects;

+(CCScene *)sceneWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId
{
    CCScene * scene = [CCScene node];
    HiddenObjectGameLayer *layer = [[[HiddenObjectGameLayer alloc] initWithSuspectId:aSuspectId AndSceneId:aSceneId] autorelease];
    [scene addChild: layer];
    return scene;
}

-(id)initWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId
{
	if( (self=[super init]) ) {

        suspectId = aSuspectId;
        sceneId = aSceneId;
        
        isHintEnable = YES;
        isTapEnable = YES;
        
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

-(void)loadTouch
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)] autorelease];
    pinchGestureRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchFrom:)] autorelease];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:panGestureRecognizer];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:pinchGestureRecognizer];
    self.prevScale = 1.0;
    
    isCanInteraction = YES;
}

-(void)unloadTouch
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:panGestureRecognizer];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:pinchGestureRecognizer];
    
    isCanInteraction = NO;
}

-(void)loadParticle
{
    vanishSparkle = [CCParticleSystemQuad particleWithFile:@"particle_stars.plist"];
    [vanishSparkle stopSystem];
    [self addChild:vanishSparkle z:kLayerVanish];
}

-(void)loadScripts
{
    //讀取資料
    NSString *aKey = [[NSString alloc] initWithFormat:@"k-%d-%d",suspectId,sceneId];
	
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hidden_objects" ofType:@"plist"];
    NSDictionary *dicObjectsData = [[NSDictionary alloc] initWithContentsOfFile:path];
    arrObjects = [[NSMutableArray alloc] initWithArray:[dicObjectsData objectForKey:aKey]];
    
	NSString *path2 = [[NSBundle mainBundle] pathForResource:@"scenes" ofType:@"plist"];
    NSDictionary *dicScenesData = [[NSDictionary alloc] initWithContentsOfFile:path2];
    dicTheSceneData = [[NSDictionary alloc] initWithDictionary:[dicScenesData objectForKey:aKey]];
    
    [aKey release];
    [dicObjectsData release];
    [dicScenesData release];
}

-(void)loadSceneImages
{
    /* 所有原圖都是1.25倍，必須先縮小為0.8，放大時才能保持清晰 */
    
    //layer
    CGPoint scenePosition = CGPointFromString([dicTheSceneData objectForKey:@"kScenePosition"]);
    CGFloat scenePosY = scenePosition.y + SIZE_OBJECTS_PANEL.height;
    _sceneLayer = [CCLayerColor layerWithColor:ccc4(255,0,0,255)];
    [_sceneLayer setContentSize:CGSizeMake(SIZE_GAME_SCENE.width,SIZE_GAME_SCENE.height)];
    [_sceneLayer setAnchorPoint:ccp(0,0)];
    [_sceneLayer setPosition:ccp(0,scenePosY)];
    [_sceneLayer setScale:0.8];
    [self addChild:_sceneLayer z:kLayerScene];

    //背景圖
    NSString *bgImageName = [[NSString alloc] initWithFormat:@"background_%d_%d.png",suspectId,sceneId];
    CCSprite *background = [CCSprite spriteWithFile:bgImageName];
    [background setAnchorPoint:ccp(0,0)];
    [background setPosition:ccp(0,0)];
    [_sceneLayer addChild:background];
    [bgImageName release];
    
    //物件圖
    int blinkTag = [[dicTheSceneData objectForKey:@"kBlinkObjectTag"] intValue];
    
    NSString *plistName = [[NSString alloc] initWithFormat:@"object_atlas_%d_%d.plist",suspectId,sceneId];
    NSString *pngName = [[NSString alloc] initWithFormat:@"object_atlas_%d_%d.png",suspectId,sceneId];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistName];
    CCSpriteBatchNode *spritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:pngName];
    [_sceneLayer addChild:spritesBatchNode z:1 tag:kLayerObjects];
    [plistName release];
    [pngName release];
    
    for(int i=0; i<[arrObjects count]; i++) {
        NSDictionary *dict = [arrObjects objectAtIndex:i];
        NSString *name = [dict objectForKey:@"kImageName"];
        NSString *tag = [dict objectForKey:@"kTag"];
        
        //目前plist裡的資料是ipad版的,所以坐標要縮小 800/1024=0.78125
        float s = 0.78125;
        CGPoint center = CGPointFromString([dict objectForKey:@"kCenterPosition"]);
        center = ccp(center.x*s,center.y*s);

        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:name];
        [sprite setTag:[tag intValue]];
        [spritesBatchNode addChild:sprite];
        
        //擴大點選範圍
        CGFloat w1 = (sprite.contentSize.width<37)?37:sprite.contentSize.width;
        CGFloat h1 = (sprite.contentSize.height<37)?37:sprite.contentSize.height;
        center = ccpAdd(center,ccp((w1-sprite.contentSize.width)/2,(h1-sprite.contentSize.height)/2));
        [sprite setContentSize:CGSizeMake(w1,h1)];
        [sprite setPosition:center];
        
        //閃光圈
        if (blinkTag == [tag intValue]) {
            [sprite setOpacity:0];
            [sprite runAction:[CCRepeatForever actionWithAction:
                               [CCSequence actions:
                                [CCDelayTime actionWithDuration:3],
                                [CCFadeIn actionWithDuration:2.8],
                                [CCFadeOut actionWithDuration:2.8],
                                [CCDelayTime actionWithDuration:3],
                                nil]]];
        }
    }

    //本關要找的物件(隨機取物)
	needToFindObjects = [[NSMutableArray alloc] initWithCapacity:NUM_OBJECTS_NEED_TO_FIND];
    
    //第20個是證據，一定要放入
    NSDictionary *the20thObject = [arrObjects objectAtIndex:19];
    [needToFindObjects addObject:the20thObject];
    [arrObjects removeObject:the20thObject];
    
    //scene3-3有兩個證據
    if (suspectId==3 && sceneId==3) {
        NSDictionary *the19thObject = [arrObjects objectAtIndex:18];
        [needToFindObjects addObject:the19thObject];
        [arrObjects removeObject:the19thObject];
    }
    
    //取其他19/18個
    int evidenceNum = needToFindObjects.count;
	for (int i=0; i<NUM_OBJECTS_NEED_TO_FIND-evidenceNum; i++) {
        int rand = arc4random() % [arrObjects count];
        NSDictionary *anObject = [arrObjects objectAtIndex:rand];
        [needToFindObjects addObject:anObject];
        [arrObjects removeObject:anObject];
    }
    
    //證據物品取隨機位置
    int rand = arc4random() % 5;
    [needToFindObjects exchangeObjectAtIndex:rand withObjectAtIndex:0];
    
    //證據動畫圖
    NSString *evidenceAniName = [dicTheSceneData objectForKey:@"kEvidenceAniImage"];
    if (evidenceAniName.length>0) {
        CGPoint pos = CGPointFromString([dicTheSceneData objectForKey:@"kEvidenceAniPosition"]);
        NSLog(@"%f,%f",pos.x,pos.y);
        CCSprite *ani = [CCSprite spriteWithFile:evidenceAniName];
        [ani setAnchorPoint:CGPointZero];
        [ani setPosition:pos];
        [ani setOpacity:0];
        [_sceneLayer addChild:ani z:kLayerEvidenceAni tag:kLayerEvidenceAni];
    }
}

-(void)loadPanel
{
    //圖層
    _panelLayer = [CCLayer node];
    [self addChild:_panelLayer z:kLayerPanelButtons];

    //背景圖
    CCSprite *spritePanel = [CCSprite spriteWithFile:@"bkg_object_list.png"];
    [spritePanel setAnchorPoint:ccp(0,0)];
    [spritePanel setPosition:ccp(0,0)];
    [self addChild:spritePanel z:kLayerPanel];
    
    //按鈕
    itemHint = [CCMenuItemImage itemWithNormalImage:@"btn_hint.png" selectedImage:@"btn_hint_sel.png" disabledImage:@"btn_hint_dis.png" target:self selector:@selector(pressHint)];
    [itemHint setPosition:kGameHintButtonPosition];
    
    itemPause = [CCMenuItemImage itemWithNormalImage:@"btn_pause.png" selectedImage:@"btn_pause_sel.png" target:self selector:@selector(pressPause)];
    [itemPause setPosition:kGamePauseButtonPosition];
    
    CCMenu *menu = [CCMenu menuWithItems:itemHint,itemPause,nil];
    [menu setPosition:CGPointZero];
    [self addChild:menu z:kLayerPanelButtons];
    
    //清單
    int totalLabels = 5;
    arrTouchableSprites = [[NSMutableArray alloc] initWithCapacity:totalLabels];
    
    for (int i=0; i<totalLabels; i++) {
        CCLabelTTF *aLabel = [CCLabelTTF labelWithString:@""
                                                fontName:kFontName
                                                fontSize:kFontSize
                                              dimensions:CGSizeMake(SIZE_OBJECT_LABEL.width,SIZE_OBJECT_LABEL.height)
                                              hAlignment:UITextAlignmentCenter
                                              vAlignment:UITextAlignmentCenter];
        [aLabel setColor:ccc3(0,0,0)];
        [aLabel setAnchorPoint:CGPointZero];
        [aLabel setPosition:ccp(k4InchWidthDiff + SIZE_PANEL_MARGIN + SIZE_OBJECT_LABEL.width*i,5)];
        [_panelLayer addChild:aLabel];
		[self putAnObjectIntoPanel:aLabel];
    }
}

-(void)putAnObjectIntoPanel:(CCLabelTTF*)label
{
	[label setOpacity:0];
    
    if ([needToFindObjects count] > 0) {
		NSDictionary *dict = [needToFindObjects objectAtIndex:0];
        int tag = [[dict objectForKey:@"kTag"] intValue];
        [label setString:NSLocalizedStringFromTable([dict objectForKey:@"kObjectNameTextKey"],@"hidden_objects", nil)];
		[label setTag:tag];
        [needToFindObjects removeObjectAtIndex:0];
        
        CCSprite *s = (CCSprite*)[[_sceneLayer getChildByTag:kLayerObjects] getChildByTag:tag];
        [arrTouchableSprites addObject:s];
        
        //物件名稱淡出
        CCAction *fadeIn = [CCFadeTo actionWithDuration:1 opacity:225];
        [label runAction:fadeIn];
	}
	else {
        [label setString:@""];
        [label setTag:0];
	}
    
}

#pragma mark -
#pragma mark zoom/pan method

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        lastPositon = _sceneLayer.position;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation.y = -1 * translation.y;
        [self moveLayer:translation from:lastPositon];
    }
}

- (void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer
{
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        CGFloat scale = 1.0 - (lastScale - recognizer.scale);
        scale = MIN(scale,MAX_SCALE);//设置缩放上限
        scale = MAX(scale,MIN_SCALE);//设置缩放下限
        _sceneLayer.scale = scale;
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        [self moveLayer:ccp(1,1) from:_sceneLayer.position];
    }
}

- (void)moveLayer:(CGPoint)translation from:(CGPoint)lastLocation
{
    CGPoint target_position = ccpAdd(translation, lastLocation);
    _sceneLayer.position = [self boundLayerWithPos:target_position AndLayer:_sceneLayer];
}

- (CGPoint)boundLayerWithPos:(CGPoint)newPos AndLayer:(CCLayerColor*)aLayer
{
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0); //設最大值
    retval.x = MAX(retval.x, winSize.width - SIZE_GAME_SCENE.width*aLayer.scale); //設最小值
    retval.y = MIN(retval.y, SIZE_OBJECTS_PANEL.height);
    retval.y = MAX(retval.y, winSize.height - SIZE_GAME_SCENE.height*aLayer.scale);
    
    return retval;
}

#pragma mark -
#pragma mark touch method

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    beginPosition = [_sceneLayer convertTouchToNodeSpace:touch];
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [_sceneLayer convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
}

#pragma mark -
#pragma mark found object method

- (void)selectSpriteForTouch:(CGPoint)touchLocation
{
    CCSprite *anObject = nil;
    
    for (CCSprite *sprite in arrTouchableSprites) {
        
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            anObject = sprite;
            break;
        }
    }
    
    if (anObject != nil) {
        
        //音效
        [self playSound:@"SoundEffect3.mp3"];

        //分數
        itemCounter ++;

        //移除
        [anObject stopAllActions];
        [anObject setVisible:NO];
        [arrTouchableSprites removeObject:anObject];
        
        //遞補
        CCLabelTTF *label = (CCLabelTTF*)[_panelLayer getChildByTag:anObject.tag];
        [self putAnObjectIntoPanel:label];

        //消失效果
        [vanishSparkle setPosition:[_sceneLayer convertToWorldSpace:anObject.position]];
        [vanishSparkle resetSystem];
        [self scheduleOnce:@selector(stopVanishEffect) delay:1];

        //證據物件(一定是出現在第一輪)
        if (suspectId==3 && sceneId==3 && ([anObject tag]>18)) {
            [self showEvidence:([anObject tag]-18)];
        }
        else if ([anObject tag] == 20) {
            //小動畫
            if ([[dicTheSceneData objectForKey:@"kEvidenceAniImage"] length]>0) {
                [(CCSprite*)[_sceneLayer getChildByTag:kLayerEvidenceAni] setOpacity:255];
            }
            
            //顯示找到證據或小遊戲
            NSString *puzzleGameName = [dicTheSceneData objectForKey:@"kPuzzleGame"];
            if (puzzleGameName.length > 0) {
                
                //取消其他互動
                if (isCanInteraction == YES) {
                    [itemPause setIsEnabled:NO];
                    [itemHint setIsEnabled:NO];
                    [self unloadTouch];
                }
                
                if ([puzzleGameName isEqualToString:@"jigsaw_puzzle_game"]) {
                    puzzleGame = [[JigsawPuzzleGameLayer alloc] initWithSuspectId:suspectId AndSceneId:sceneId];
                    [puzzleGame setDelegate:self];
                    [self addChild:puzzleGame z:kLayerPuzzleGame tag:kLayerPuzzleGame];
                    [self attachPopUpAnimation:puzzleGame];
                }
                else if ([puzzleGameName isEqualToString:@"pixel_sudoku_game"]) {
                    puzzleGame = [[PixelSudokuGameLayer alloc] initWithSuspectId:suspectId AndSceneId:sceneId];
                    [puzzleGame setDelegate:self];
                    [self addChild:puzzleGame z:kLayerPuzzleGame tag:kLayerPuzzleGame];
                    [self attachPopUpAnimation:puzzleGame];
                }
                else if ([puzzleGameName isEqualToString:@"connecting_puzzle_game"]) {
                    puzzleGame = [[ConnectionGameLayer alloc] initWithSuspectId:suspectId AndSceneId:sceneId];
                    [puzzleGame setDelegate:self];
                    [self addChild:puzzleGame z:kLayerPuzzleGame tag:kLayerPuzzleGame];
                    [self attachPopUpAnimation:puzzleGame];
                }
            }
            else {
                [self showEvidence:0];
            }
        }
        else {
            //是否集滿物件
            if([self checkIfPass] == YES) {
                [self levelCompleted];
            }
        }
    }
    else {
        if (isTapEnable == YES) {
            
            //音效
            [self playSound:@"SoundEffect4.mp3"];

            CCSprite *spriteX = [CCSprite spriteWithFile:@"icon_x.png"];
            [spriteX setPosition:touchLocation];
            [_sceneLayer addChild:spriteX z:99 tag:99];
            [self scheduleOnce:@selector(removeTheX) delay:0.2];
            
            isTapEnable = NO;
        }
    }
}

-(void)removeTheX
{
    [_sceneLayer removeChildByTag:99 cleanup:YES];
    isTapEnable = YES;
}

-(void)stopVanishEffect
{
    [vanishSparkle stopSystem];
}

-(void)showEvidence:(int)anId
{
    //音效
    [self playSound:@"SoundEffect5.mp3"];

    alertLayer = [CCLayer node];
    [alertLayer setContentSize:kEvidenceAlertLayerSize];
    [alertLayer setPosition:ccp(kEvidenceAlertLayerPosition.x,kEvidenceAlertLayerPosition.y-500)];
    [self addChild:alertLayer z:kLayerEvidenceAlert];
    
    CCSprite *spriteBkg = [CCSprite spriteWithFile:@"bkg_evidence.png"];
    [spriteBkg setAnchorPoint:ccp(0,0)];
    [spriteBkg setPosition:ccp(0,0)];
    [alertLayer addChild:spriteBkg];
    
    CCMenuItemImage *anItem = [CCMenuItemImage itemWithNormalImage:@"btn_close.png" selectedImage:@"btn_close_sel.png" target:self selector:@selector(pressCloseEvidenceAlert)];
    CCMenu *aMenu = [CCMenu menuWithItems:anItem,nil];
    [aMenu setPosition:ccp(kEvidenceAlertLayerSize.width-anItem.contentSize.width,kEvidenceAlertLayerSize.height-anItem.contentSize.height)];
    [alertLayer addChild:aMenu];
    
    NSString *key = nil;
    if (anId > 0) {
        key = [[NSString alloc] initWithFormat:@"kEvidenceImage%d",anId];
    }
    else {
        key = @"kEvidenceImage";
    }
    NSString *imageName = [dicTheSceneData objectForKey:key];
    CCSprite *spriteEvidence = [CCSprite spriteWithFile:imageName];
    [spriteEvidence setPosition:ccp(alertLayer.contentSize.width/2,alertLayer.contentSize.height/2)];
    [alertLayer addChild:spriteEvidence];
    [key release];
    
    CCLabelTTF *labelEvidenceFound = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kEvidenceFound",@"ui_labels",nil) fontName:kFontName fontSize:12];
    [labelEvidenceFound setPosition:CGPointMake(alertLayer.contentSize.width/2,15)];
    [labelEvidenceFound setColor:kFontColor];
    [alertLayer addChild:labelEvidenceFound];    
    [alertLayer runAction:[CCMoveTo actionWithDuration:0.5f position:kEvidenceAlertLayerPosition]];
    
    //取消其他互動
    if (isCanInteraction == YES) {
        [itemPause setIsEnabled:NO];
        [itemHint setIsEnabled:NO];
        [self unloadTouch];
    }
}

-(void)pressCloseEvidenceAlert
{
    //音效
    [self playSound:@"SoundEffect2.mp3"];
    
    [alertLayer runAction:[CCMoveTo actionWithDuration:0.5f position:CGPointMake(kEvidenceAlertLayerPosition.x,kEvidenceAlertLayerPosition.y-500)]];
    
    //是否集滿物件
    if([self checkIfPass] == YES) {
        [self levelCompleted];
    }
    else {
        //恢復其他互動
        if (isCanInteraction == NO) {
            [itemPause setIsEnabled:YES];
            [itemHint setIsEnabled:YES];
            [self loadTouch];
        }
    }
}

#pragma mark -
#pragma mark game completed method

-(bool)checkIfPass
{
	//return YES;

	if (itemCounter == NUM_OBJECTS_NEED_TO_FIND) {
		return YES;
	}
	else {
		return NO;
	}
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
	[self scheduleOnce:@selector(showResultPage) delay:1.0f];
}

//儲存資料
-(void)saveRecord
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *aSceneKey = [[NSString alloc] initWithFormat:@"k-%d-%d",suspectId,sceneId];
    NSString *aEvidenceKey = [dicTheSceneData objectForKey:@"kEvidenceTextKey"];
    
    [userDefaults setBool:YES forKey:aSceneKey];
    [userDefaults setBool:YES forKey:aEvidenceKey];
    
    [userDefaults synchronize];
    
    [aSceneKey release];
}

-(void)showResultPage
{
    //音效
    [self playSound:@"Victory.mp3"];
	
    CCLayerColor *resultLayer = [CCLayerColor layerWithColor:ccc4(0,0,0,127)];
    [resultLayer setPosition:ccp(0,500)];
    [self addChild:resultLayer z:kLayerResult tag:kLayerResult];
    
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
    CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kEvidenceFound",@"ui_labels",nil) fontName:kFontName fontSize:kFontSizeHeading];
    [titleLabel setColor:ccc3(100, 50, 50)];
    [titleLabel setPosition:kGameResultTitlePosition];
    [resultLayer addChild:titleLabel z:10];
    
    //證據背板
    NSString *panelImageName = [dicTheSceneData objectForKey:@"kEvidencePanelImage"];
    CCSprite *panelSprite = [CCSprite spriteWithFile:panelImageName];
    [panelSprite setPosition:kEvidencePanelPosition];
    [resultLayer addChild:panelSprite];
    
    //文字
    NSString *evidenceTextKey = [dicTheSceneData objectForKey:@"kEvidenceTextKey"];
    NSString *evidenceText = NSLocalizedStringFromTable(evidenceTextKey,@"suspects_setting",nil);
    CCLabelTTF *evidenceLabel = [CCLabelTTF labelWithString:evidenceText
                                                   fontName:kFontName
                                                   fontSize:kFontSize
                                                 dimensions:CGSizeMake(160,45)
                                                 hAlignment:UITextAlignmentLeft];
    [evidenceLabel setColor:ccc3(120,31,26)];
    [evidenceLabel setPosition:kEvidenceLabelPosition];
    [resultLayer addChild:evidenceLabel];
    
    //證據圖片
    NSString *evidenceImageName = [dicTheSceneData objectForKey:@"kEvidenceImage"];
    CCSprite *evidenceSprite = [CCSprite spriteWithFile:evidenceImageName];
    [evidenceSprite setScale:(75/evidenceSprite.contentSize.width)];
    [evidenceSprite setPosition:kEvidenceImagePosition];
    [resultLayer addChild:evidenceSprite];
    
    //戳章
    CCSprite *stampSprite = [CCSprite spriteWithFile:@"icon_complete.png"];
    [stampSprite setPosition:kGameResultStampPosition];
    [stampSprite setScale:0];
    [resultLayer addChild:stampSprite z:99 tag:99];
    
    //選單
    CCMenuItemImage *itemRetry = [CCMenuItemImage itemWithNormalImage:@"btn_retry.png" selectedImage:@"btn_retry_sel.png" target:self selector:@selector(pressRetry)];
    CCMenuItemImage *itemNext = [CCMenuItemImage itemWithNormalImage:@"btn_next.png" selectedImage:@"btn_next_sel.png" target:self selector:@selector(pressNext)];
    CCMenu *menu = [CCMenu menuWithItems:itemRetry,itemNext,nil];
    [menu alignItemsHorizontallyWithPadding:40];
    [menu setPosition:kGameResultMenuPosition];
    [resultLayer addChild:menu];
    
    //animation
    id moveBy = [CCMoveBy actionWithDuration:0.3 position:CGPointMake(0,-500)];
    [resultLayer runAction:moveBy];
    
    [self scheduleOnce:@selector(showStamp) delay:0.5f];
}

-(void)showStamp
{
    CCNode *spriteStamp = [[self getChildByTag:kLayerResult] getChildByTag:99];
    [self attachPopUpAnimation:spriteStamp];
}

-(void)attachPopUpAnimation:(CCNode*)aNode
{
    //音效
    [self playSound:@"SoundEffect1.mp3"];
    
    id scaleTo0 = [CCScaleTo actionWithDuration:0.0f scale:0.0f];
    id scaleTo1 = [CCScaleTo actionWithDuration:0.15f scale:1.2f];
    id scaleTo2 = [CCScaleTo actionWithDuration:0.15f scale:0.8f];
    id scaleTo3 = [CCScaleTo actionWithDuration:0.15f scale:1.1f];
    id scaleTo4 = [CCScaleTo actionWithDuration:0.15f scale:0.9f];
    id scaleTo5 = [CCScaleTo actionWithDuration:0.15f scale:1.0f];
    [aNode runAction:[CCSequence actions:scaleTo0,scaleTo1,scaleTo2,scaleTo3,scaleTo4,scaleTo5,nil]];
}

#pragma mark -
#pragma mark pause method and delegate method

-(void)pressPause
{
    //音效
    [self playSound:@"SoundEffect2.mp3"];
    
    //暫停選單
    PauseLayer *aLayer = [[PauseLayer alloc] init];
    [aLayer setDelegate:self];
    [self addChild:aLayer z:kLayerPause tag:kLayerPause];

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
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HiddenObjectGameLayer sceneWithSuspectId:suspectId AndSceneId:sceneId] withColor:ccBLACK]];
}

-(void)endGame
{
    //音效
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ScenesLayer sceneWithSuspectId:suspectId] withColor:ccBLACK]];
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
    
    int tag = 0;
    for (int i=0; i<_panelLayer.children.count; i++) {
        tag = [[_panelLayer.children objectAtIndex:i] tag];
        if (tag > 0) {
            break;
        }
    }
    
    if (tag > 0) {

        CGPoint pos = [[[_sceneLayer getChildByTag:kLayerObjects] getChildByTag:tag] position];

        //移動到畫面中心
        //先找出scene上目前在螢幕中心點的坐標
        CGPoint currentCenter = ccp(winSize.width/2 - _sceneLayer.position.x,winSize.height/2 + kObjectsPanelSize.height/2 - _sceneLayer.position.y);
        CGPoint t1 = ccp(currentCenter.x - pos.x, currentCenter.y - pos.y);
        [self moveLayer:t1 from:_sceneLayer.position];
        
        //動畫
        CCSprite *spriteHint = [CCSprite spriteWithFile:@"icon_hint.png"];
        [spriteHint setPosition:pos];
        [_sceneLayer addChild:spriteHint z:kLayerHint tag:kLayerHint];
        
        CCRotateBy* rotateBy = [CCRotateBy actionWithDuration:1 angle:360];
        CCRepeatForever* repeat = [CCRepeatForever actionWithAction:rotateBy];
        [spriteHint runAction:repeat];
        
        [self scheduleOnce:@selector(hideHintCircle) delay:2.5f];
        
        //限制使用本功能
        [itemHint setIsEnabled:NO];
        [self scheduleOnce:@selector(recoverHint) delay:INTERVAL_DISABLE_HINT];
    }
}

-(void)recoverHint
{
    [itemHint setIsEnabled:YES];
}

-(void)hideHintCircle
{
    [_sceneLayer removeChildByTag:kLayerHint cleanup:YES];
}

#pragma mark -
#pragma mark result menu method

-(void)pressRetry
{
    //音效
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[HiddenObjectGameLayer sceneWithSuspectId:suspectId AndSceneId:sceneId] withColor:ccBLACK]];
}

-(void)pressNext
{
    //音效
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[DialogueLayer sceneWithSuspectId:suspectId AndSceneId:sceneId] withColor:ccBLACK]];
}

#pragma mark -
#pragma mark delegate

-(void)puzzleGameDidFinished
{
    [self showEvidence:0];
    
    [puzzleGame setDelegate:nil];
}

-(void) dealloc
{
    NSLog(@"hiddenobjects dealloc");
    
    [CCTextureCache purgeSharedTextureCache];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
    
    [super dealloc];
}

@end
