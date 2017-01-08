//
//  GameLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "PixelSudokuGameLayer.h"
#import "ScenesLayer.h"
#import "HiddenObjectGameLayer.h"
#import "PauseLayer.h"

@implementation PixelSudokuGameLayer

@synthesize arrObjects;
@synthesize delegate;

-(id)initWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId
{
	if( (self=[super init]) ) {

        [[CCDirector sharedDirector] purgeCachedData];

        suspectId = aSuspectId;
        sceneId = aSceneId;
        
        //背景
        CCSprite *spriteBackground = [CCSprite spriteWithFile:@"background_puzzle.png"];
        [spriteBackground setPosition:kScreenCenter];
        [self addChild:spriteBackground];

        [self showGrids];
        [self showNumbers];
        [self loadPanel];
        [self loadTouch];
        
        isCanInteraction = NO;
        [itemGameRule setIsEnabled:NO];
        [itemHint setIsEnabled:NO];
        [itemPause setIsEnabled:NO];
        
        [self scheduleOnce:@selector(helpSlideIn) delay:1];
        [self scheduleOnce:@selector(enableInteraction) delay:6];
	}
	return self;
}

#pragma mark -
#pragma mark loading method

-(void)loadPanel
{    
    //按鈕
    itemHint = [CCMenuItemImage itemWithNormalImage:@"btn_hint.png" selectedImage:@"btn_hint_sel.png" disabledImage:@"btn_hint_dis.png" target:self selector:@selector(pressHint)];
    [itemHint setPosition:kGameHintButtonPosition];
    
    itemPause = [CCMenuItemImage itemWithNormalImage:@"btn_pause.png" selectedImage:@"btn_pause_sel.png" disabledImage:@"btn_pause_dis.png" target:self selector:@selector(pressPause)];
    [itemPause setPosition:kGamePauseButtonPosition];

    //遊戲說明按鈕
    itemGameRule = [CCMenuItemImage itemWithNormalImage:@"btn_gamerule.png" selectedImage:@"btn_gamerule_sel.png" target:self selector:@selector(pressGameRule)];
    [itemGameRule setPosition:kGameRuleButtonPosition];
    
    CCMenu *menu = [CCMenu menuWithItems:itemHint,itemPause,itemGameRule,nil];
    [menu setPosition:CGPointZero];
    [self addChild:menu];
}

-(void)showGrids
{    
    //數字圖層
    numbersLayer = [CCLayerColor layerWithColor:ccc4(250,220,180,255)];
    [numbersLayer setContentSize:kPixelPuzzleSize];
    [numbersLayer setPosition:kPixelPuzzlePosition];
    [self addChild:numbersLayer];
    
    //橫線
    for (int i=0; i<11; i++) {
        CCSprite *line = [CCSprite spriteWithFile:@"line.png"];
        [line setPosition:ccp(kPixelPuzzleSize.width/2,i*kPixelPieceSize.height)];
        [line setScaleX:kPixelPuzzleSize.width];
        [numbersLayer addChild:line];
    }
    //直線
    for (int i=0; i<11; i++) {
        CCSprite *line = [CCSprite spriteWithFile:@"line.png"];
        [line setPosition:ccp(5*kPixelPieceSize.width/2+i*kPixelPieceSize.width,kPixelPuzzleSize.height/2)];
        [line setScaleY:kPixelPuzzleSize.height];
        [numbersLayer addChild:line];
    }
    
    //像素圖層
    pixelsLayer = [CCLayerColor layerWithColor:ccc4(180,180,180,60)];
    [pixelsLayer setContentSize:CGSizeMake(10*kPixelPieceSize.width,10*kPixelPieceSize.height)];
    [pixelsLayer setPosition:ccp(2.5*kPixelPieceSize.width,0)];
    [numbersLayer addChild:pixelsLayer];
    
    batchSquare = [CCSpriteBatchNode batchNodeWithFile:@"icon_square.png"];
    [pixelsLayer addChild:batchSquare];
    
    for (int i=0; i<10; i++) {
        for (int j=0; j<10; j++) {
            CCSprite *square = [CCSprite spriteWithFile:@"icon_square.png"];
            [square setPosition:ccp((i+0.5)*kPixelPieceSize.width,(j+0.5)*kPixelPieceSize.height)];
            [square setTag:0];
            [square setOpacity:0];
            [batchSquare addChild:square];
        }
    }
}

-(void)showNumbers
{
    //讀取script資料
	NSString *filename = [[NSString alloc] initWithFormat:@"puzzle_%d_%d",suspectId,sceneId];
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"txt"];
    NSError *error = nil;
    NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSArray *arrLines = [str componentsSeparatedByString:@"\n"];
    for (int i=0; i<15; i++) {
        NSString *line = [arrLines objectAtIndex:i];
        NSArray *arrCells = [line componentsSeparatedByString:@" "];
        for (int j=0; j<15; j++) {
            NSString *s1 = [arrCells objectAtIndex:j];
            if ([s1 isEqualToString:@"*"]) {
                arrAll[j][i] = 1;
            }
            else {
                arrAll[j][i] = [s1 intValue];
            }
        }
    }
    
    //上方數字
    for (int x=5; x<15; x++) {
        for (int y=0; y<5; y++) {
            arrTopNumbers[x-5][y] = arrAll[x][y];
        }
    }
    
    //左方數字
    for (int x=0; x<5; x++) {
        for (int y=5; y<15; y++) {
            arrLeftNumbers[x][y-5] = arrAll[x][y];
        }
    }
    
    //像素格子
    for (int x=5; x<15; x++) {
        for (int y=5; y<15; y++) {
            arrPixels[x-5][y-5] = arrAll[x][y];
        }
    }
    
    //-----
    //上方數字
    for(int y=0; y<5; y++) {
        for (int x=0; x<10; x++) {
            NSString *aString = nil;
            if (arrTopNumbers[x][y]>0) {
                aString = [NSString stringWithFormat:@"%d",arrTopNumbers[x][y]];
            }
            else {
                aString = @"";
            }
            CCLabelTTF *label = [CCLabelTTF labelWithString:aString fontName:kFontName fontSize:kFontSize-2];
            [label setColor:ccBLACK];
            [label setDimensions:CGSizeMake(kPixelPieceSize.width,kPixelPieceSize.height/2)];
            [label setHorizontalAlignment:UITextAlignmentCenter];
            [label setAnchorPoint:CGPointZero];
            [label setPosition:ccp((2.5+x)*kPixelPieceSize.width,kPixelPuzzleSize.height-(y+1)*kPixelPieceSize.height/2)];
            [numbersLayer addChild:label];
        }
    }
    
    //左方數字
    for (int y=0; y<10; y++) {
        for (int x=0; x<5; x++) {
            NSString *aString = nil;
            if (arrLeftNumbers[x][y]>0) {
                aString = [NSString stringWithFormat:@"%d",arrLeftNumbers[x][y]];
            }
            else {
                aString = @"";
            }
            CCLabelTTF *label = [CCLabelTTF labelWithString:aString fontName:kFontName fontSize:kFontSize-2];
            [label setColor:ccBLACK];
            [label setDimensions:CGSizeMake(kPixelPieceSize.width/2,kPixelPieceSize.height)];
            [label setVerticalAlignment:UITextAlignmentCenter];
            [label setAnchorPoint:CGPointZero];
            [label setPosition:ccp(x*kPixelPieceSize.width/2,(10-(y+1))*kPixelPieceSize.height)];
            [numbersLayer addChild:label];
        }
    }    
}

-(void)helpSlideIn
{
    //說明
    helpLayer = [CCLayerColor layerWithColor:ccc4(110,40,0,255)];
    [helpLayer setContentSize:CGSizeMake(kPixelPuzzleSize.width,50)];
    [helpLayer setPosition:ccpAdd(kPixelHelpPosition,ccp(0,-500))];
    [self addChild:helpLayer];
    
    CCLabelTTF *aLabel = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kAlertSudoku",@"ui_labels",nil)
                                            fontName:kFontName
                                            fontSize:kFontSize
                                          dimensions:CGSizeMake(kPixelPuzzleSize.width*0.9,kPixelPuzzleSize.height*0.2)
                                          hAlignment:kCCTextAlignmentCenter
                                          vAlignment:kCCVerticalTextAlignmentCenter];
    [aLabel setColor:ccWHITE];
    [aLabel setPosition:ccp(helpLayer.contentSize.width/2,helpLayer.contentSize.height/2)];
    [helpLayer addChild:aLabel];
    
    id moveTo1 = [CCMoveTo actionWithDuration:1 position:kPixelHelpPosition];
    id moveTo2 = [CCMoveTo actionWithDuration:1 position:ccpAdd(kPixelHelpPosition,ccp(0,-500))];
    id delay = [CCDelayTime actionWithDuration:3.0f];
    [helpLayer runAction:[CCSequence actions:moveTo1,delay,moveTo2,nil]];
    
    [self scheduleOnce:@selector(removeHelpLayer) delay:6];
}

-(void)removeHelpLayer
{
    [helpLayer removeFromParentAndCleanup:YES];
}

-(void)enableInteraction
{
    isCanInteraction = YES;
    [itemGameRule setIsEnabled:YES];
    [itemHint setIsEnabled:YES];
    [itemPause setIsEnabled:YES];
}

#pragma mark -
#pragma mark touch method

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {

}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [pixelsLayer convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    
    //是否集滿像素
    if([self checkIfPass] == YES) {
        [self scheduleOnce:@selector(levelCompleted) delay:0.5];
    }
}

#pragma mark -
#pragma mark found object method

- (void)selectSpriteForTouch:(CGPoint)touchLocation
{
    CCSprite *aSquare = nil;
    
    for (CCSprite *sprite in batchSquare.children) {
        
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            aSquare = sprite;
            break;
        }
    }
    
    if (aSquare != nil) {
        int newTag = (aSquare.tag + 1) % 2;
        [aSquare setTag:newTag];
        
        if (newTag == 0) {
            [aSquare setScale:1];
            [aSquare setOpacity:0];
        }
        else if (newTag == 1) {
            [aSquare setScale:1];
            [aSquare setOpacity:255];
        }
        
        //求出位置
        int x = floorf((aSquare.position.x/kPixelPieceSize.width));
        int y = floorf(((10*kPixelPieceSize.width-aSquare.position.y)/kPixelPieceSize.height));
        arrTags[x][y] = newTag;
    }
}

#pragma mark -
#pragma mark game completed method

-(bool)checkIfPass
{
	//return YES;
    /* 1的必須為1, 0的可以是0或2 */
    for (int i=0; i<10; i++) {
        for (int j=0; j<10; j++) {
            if( arrPixels[i][j] != arrTags[i][j]) {
                //NSLog(@"%d,%d,%d",i,j,arrTags[i][j]);
                return NO;
            }
        }
    }
    return YES;
}

-(void)levelCompleted
{
    [self playSound:@"SoundEffect6.mp3"];
    
    [self scheduleOnce:@selector(scaleDown) delay:1];
    [self scheduleOnce:@selector(callDelegateMethod) delay:2];
    [self scheduleOnce:@selector(removeSelf) delay:2];
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
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self removeFromParentAndCleanup:YES];
}

#pragma mark -
#pragma mark pause method

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
    
    for (CCSprite *aSquare in batchSquare.children) {
        int x = floorf((aSquare.position.x/kPixelPieceSize.width));
        int y = floorf(((10*kPixelPieceSize.height-aSquare.position.y)/kPixelPieceSize.height));
        int flag = arrPixels[x][y];
        if (flag == 1) {
            [aSquare setOpacity:255];
        }
        else {
            [aSquare setOpacity:0];
        }
    }
    
    [self levelCompleted];
}

-(void)pressGameRule
{
    if (isGameRuleShowed == YES) {
        return;
    }
    
    isGameRuleShowed = YES;
    
    gameRuleLayer = [CCLayer node];
    [gameRuleLayer setContentSize:kGameRuleLayerSize];
    [gameRuleLayer setPosition:ccp(kGameRuleLayerPosition.x,kGameRuleLayerPosition.y-1000)];
    [self addChild:gameRuleLayer];
    
    CCSprite *spriteGameRule = [CCSprite spriteWithFile:@"gamerule.png"];
    [spriteGameRule setAnchorPoint:ccp(0,0)];
    [spriteGameRule setPosition:ccp(0,0)];
    [gameRuleLayer addChild:spriteGameRule];
    
    CCMenuItemImage *anItem = [CCMenuItemImage itemWithNormalImage:@"btn_close.png" selectedImage:@"btn_close_sel.png" target:self selector:@selector(pressCloseGameRule)];
    CCMenu *aMenu = [CCMenu menuWithItems:anItem,nil];
    [aMenu setPosition:ccp(kGameRuleLayerSize.width-anItem.contentSize.width,kGameRuleLayerSize.height-anItem.contentSize.height)];
    [spriteGameRule addChild:aMenu];
    
    [gameRuleLayer runAction:[CCMoveTo actionWithDuration:0.5f position:kGameRuleLayerPosition]];
}

-(void)pressCloseGameRule
{
    isGameRuleShowed = NO;
    
    [gameRuleLayer removeFromParentAndCleanup:YES];
}

-(void)pressCloseHelp
{
    [helpLayer removeFromParentAndCleanup:YES];
}

#pragma mark -

-(void) dealloc
{
    [[CCDirector sharedDirector] purgeCachedData];
    
    [super dealloc];
}

@end
