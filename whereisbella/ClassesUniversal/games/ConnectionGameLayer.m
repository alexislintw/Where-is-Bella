//
//  GameLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ConnectionGameLayer.h"
#import "HiddenObjectGameLayer.h"
#import "ScenesLayer.h"
#import "PauseLayer.h"

@implementation ConnectionGameLayer

@synthesize delegate;

-(id)initWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId
{
	if( (self=[super init]) ) {

        [[CCDirector sharedDirector] purgeCachedData];

        suspectId = aSuspectId;
        sceneId = aSceneId;
        
        [self loadScripts];
        [self loadSceneImages];
        [self loadPanel];
        [self loadTouch];
	}
	return self;
}

#pragma mark -
#pragma mark loading method

-(void)loadScripts
{
    //讀取資料
    NSString *aKey = [[NSString alloc] initWithFormat:@"k-%d-%d",suspectId,sceneId];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"puzzles" ofType:@"plist"];
    NSDictionary *dicPuzzleData = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
    arrPieces = [[NSMutableArray alloc] initWithArray:[dicPuzzleData objectForKey:aKey]];
    [aKey release];
}

-(void)loadSceneImages
{
    //背景
    CCSprite *spriteBackground = [CCSprite spriteWithFile:@"background_puzzle.png"];
    [spriteBackground setPosition:kScreenCenter];
    [self addChild:spriteBackground];
    
    puzzleLayer = [CCLayerColor layerWithColor:ccc4(83, 127, 193, 255)];
    [puzzleLayer setContentSize:kConnectPuzzleSize];
    [puzzleLayer setPosition:kConnectPuzzlePosition];
    [self addChild:puzzleLayer];
    
    //物件圖
    NSString *puzzlePlistName = [[NSString alloc] initWithFormat:@"puzzle_atlas_%d_%d.plist",suspectId,sceneId];
    NSString *puzzlePngName = [[NSString alloc] initWithFormat:@"puzzle_atlas_%d_%d.png",suspectId,sceneId];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:puzzlePlistName];
    spritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:puzzlePngName];
    [puzzleLayer addChild:spritesBatchNode];

    for(int i=0; i<[arrPieces count]; i++) {
        NSDictionary *dic = [arrPieces objectAtIndex:i];
        NSString *name = [dic objectForKey:@"kImageName"];
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:name];
        [sprite setTag:[[dic objectForKey:@"kTag"] intValue]];
        
        //先排好第一塊
        CGPoint radomPoint;
        if (sprite.tag == 1) {
            radomPoint = kConnectPuzzleFirstPiecePosition;
            [sprite setAnchorPoint:CGPointZero];
            [sprite setPosition:radomPoint];
            [sprite setOpacity:150];
            [puzzleLayer addChild:sprite];
        }
        else {
            radomPoint = ccp(rand()%kPuzzleGameRadomScope,rand()%kPuzzleGameRadomScope);
            [sprite setAnchorPoint:CGPointZero];
            [sprite setPosition:radomPoint];
            [spritesBatchNode addChild:sprite];
        }
    }
    [puzzlePlistName release];
    [puzzlePngName release];
}

-(void)loadPanel
{
    //背景圖
    CCSprite *spritePanel = [CCSprite spriteWithFile:@"bkg_object_list.png"];
    [spritePanel setAnchorPoint:ccp(0,0)];
    [spritePanel setPosition:ccp(0,0)];
    [self addChild:spritePanel];
    
    //按鈕
    itemHint = [CCMenuItemImage itemWithNormalImage:@"btn_hint.png" selectedImage:@"btn_hint_sel.png" disabledImage:@"btn_hint_dis.png" target:self selector:@selector(pressHint)];
    [itemHint setPosition:kGameHintButtonPosition];
    
    itemPause = [CCMenuItemImage itemWithNormalImage:@"btn_pause.png" selectedImage:@"btn_pause_sel.png" disabledImage:@"btn_pause_dis.png" target:self selector:@selector(pressPause)];
    [itemPause setPosition:kGamePauseButtonPosition];
    
    CCMenu *menu = [CCMenu menuWithItems:itemHint,itemPause,nil];
    [menu setPosition:CGPointZero];
    [self addChild:menu];
    
    //清單
    NSString *aString = NSLocalizedStringFromTable(@"kAlertPuzzle",@"ui_labels",nil);
    CCLabelTTF *aLabel = [CCLabelTTF labelWithString:aString
                                            fontName:kFontName
                                            fontSize:kFontSize
                                          dimensions:CGSizeMake(kObjectsPanelSize.width,kObjectsPanelSize.height)
                                          hAlignment:kCCTextAlignmentCenter
                                          vAlignment:kCCVerticalTextAlignmentCenter];
    [aLabel setColor:ccc3(0,0,0)];
    [aLabel setPosition:ccp(winSize.width/2,kObjectsPanelSize.height/2)];
    [self addChild:aLabel];
}

#pragma mark -
#pragma mark touch method

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [puzzleLayer convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [puzzleLayer convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [puzzleLayer convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self fixPosition];
}

- (void)selectSpriteForTouch:(CGPoint)touchLocation
{
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in spritesBatchNode.children) {
        if (sprite.tag>0 && CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            newSprite = sprite;
            break;
        }
    }
    if (newSprite != selSprite) {
        selSprite = newSprite;
        
        //點到的拉到最前面
        for (int i=0; i<spritesBatchNode.children.count; i++) {
            CCSprite *theSprite = [spritesBatchNode.children objectAtIndex:i];
            if (selSprite == theSprite) {
                [spritesBatchNode reorderChild:theSprite z:1];
            }
            else {
                [spritesBatchNode reorderChild:theSprite z:0];
            }
        }
    }
}

- (void)panForTranslation:(CGPoint)translation
{
    if (selSprite) {
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
    }
}

-(void)fixPosition
{
    CGPoint p1 = CGPointMake(roundf(selSprite.position.x/kConnectPuzzlePieceSize.width)*kConnectPuzzlePieceSize.width,roundf(selSprite.position.y/kConnectPuzzlePieceSize.height)*kConnectPuzzlePieceSize.height);
    if ( abs(selSprite.position.x-p1.x)<kPuzzleGameTolerance  && abs(selSprite.position.y-p1.y)<kPuzzleGameTolerance ) {
        [selSprite setPosition:p1];
        
        if ([self checkIfPass] == YES) {
            [self levelCompleted];
        };
    }
    else {
        [selSprite setOpacity:255];
    }
}

#pragma mark -

-(BOOL)checkIfPass
{
    //return YES;
    for (int i=1; i<[arrPieces count]; i++) {
        int theTag = [[[arrPieces objectAtIndex:i] objectForKey:@"kTag"]intValue];
        NSString *strAnchorPosition = [[arrPieces objectAtIndex:i] objectForKey:@"kAnchorPosition"];
        CGPoint p1 = CGPointFromString(strAnchorPosition);
        
        CCNode *theSpritePuzzle = [spritesBatchNode getChildByTag:theTag];
        CGPoint p2 = theSpritePuzzle.position;
        
        if (p1.x!=p2.x || p1.y!=p2.y) {
            return NO;
        }
    }
    return YES;
}

-(void)levelCompleted
{
    [self playSound:@"SoundEffect6.mp3"];
    
    //呈現原圖
    NSString *imageName = [[NSString alloc] initWithFormat:@"puzzle_whole_%d_%d.png",suspectId,sceneId];
    CCSprite *spritePuzzle = [CCSprite spriteWithFile:imageName];
    [spritePuzzle setAnchorPoint:CGPointZero];
    [spritePuzzle setPosition:kConnectPuzzlePosition];
    [spritePuzzle setOpacity:0];
    [self addChild:spritePuzzle];
    [imageName release];
    
    id fadeIn = [CCFadeIn actionWithDuration:1];
    [spritePuzzle runAction:fadeIn];
    
    //取消其他互動
    if (isCanInteraction == YES) {
        [itemPause setIsEnabled:NO];
        [itemHint setIsEnabled:NO];
        [self unloadTouch];
    }

    [self scheduleOnce:@selector(scaleDown) delay:4];
    [self scheduleOnce:@selector(callDelegateMethod) delay:5];
    [self scheduleOnce:@selector(removeSelf) delay:5];
}

-(void)scaleDown
{
    id scaleDown = [CCScaleTo actionWithDuration:0.5 scale:0];
    [self runAction:scaleDown];
}

-(void)callDelegateMethod
{
    [[self delegate] puzzleGameDidFinished];
}

-(void)removeSelf
{
    //主要目的為移除delegate
    if (isCanInteraction == YES) {
        [self unloadTouch];
    }
    
    [self removeFromParentAndCleanup:YES];
}

#pragma mark -

-(void)pressPause
{
    [self playSound:@"SoundEffect2.mp3"];

    //暫停選單
    PauseLayer *aLayer = [[PauseLayer alloc] init];
    [aLayer setDelegate:self];
    [self addChild:aLayer];
    
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
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ScenesLayer sceneWithSuspectId:suspectId] withColor:ccBLACK]];
}

-(void)pressHint
{
    [self playSound:@"SoundEffect6.mp3"];
    
    //取消其他互動
    if (isCanInteraction == YES) {
        [itemPause setIsEnabled:NO];
        [itemHint setIsEnabled:NO];
        [self unloadTouch];
    }
    
    [puzzleLayer removeFromParentAndCleanup:YES];
    [self levelCompleted];
}

#pragma mark -

-(void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCDirector sharedDirector] purgeCachedData];
    
    [super dealloc];
}

@end
