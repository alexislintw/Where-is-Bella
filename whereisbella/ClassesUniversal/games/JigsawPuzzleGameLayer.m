//
//  GameLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "JigsawPuzzleGameLayer.h"
#import "ScenesLayer.h"
#import "HiddenObjectGameLayer.h"
#import "PauseLayer.h"

@implementation JigsawPuzzleGameLayer

@synthesize delegate;

+(CCScene *)sceneWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId
{
    CCScene * scene = [CCScene node];
    JigsawPuzzleGameLayer *layer = [[[JigsawPuzzleGameLayer alloc] initWithSuspectId:aSuspectId AndSceneId:aSceneId] autorelease];
    [scene addChild: layer];
    return scene;
}

-(id)initWithSuspectId:(int)aSuspect AndSceneId:(int)aSceneId
{
	if( (self=[super init]) ) {

        [[CCDirector sharedDirector] purgeCachedData];

        suspectId = aSuspect;
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
    NSDictionary *dicPuzzleData = [[NSDictionary alloc] initWithContentsOfFile:path];
    arrPieces = [[NSMutableArray alloc] initWithArray:[dicPuzzleData objectForKey:aKey]];
    
    [aKey release];
    [dicPuzzleData release];
}

-(void)loadSceneImages
{
    //背景
    CCSprite *spriteBackground = [CCSprite spriteWithFile:@"background_puzzle.png"];
    [spriteBackground setPosition:kScreenCenter];
    [self addChild:spriteBackground];
    
    NSString *shadowImageName = [[NSString alloc] initWithFormat:@"puzzle_shadow_%d_%d.png",suspectId,sceneId];
    CCSprite *spriteShadow = [CCSprite spriteWithFile:shadowImageName];
    [spriteShadow setAnchorPoint:CGPointZero];
    [spriteShadow setPosition:kJigsawPuzzlePosition];
    [self addChild:spriteShadow];
    
    //物件圖
    puzzleLayer = [CCLayer node];
    [self addChild:puzzleLayer z:100];
    
    NSString *wholePuzzleImageName = [[NSString alloc] initWithFormat:@"puzzle_whole_%d_%d.png",suspectId,sceneId];
    CCSprite *spriteWholePuzzle = [CCSprite spriteWithFile:wholePuzzleImageName];
    CGImageRef wholePuzzleRef = [[self imageFromSprite:spriteWholePuzzle] CGImage];
    NSString *puzzleMaskPlistName = [[NSString alloc] initWithFormat:@"puzzle_atlas_%d_%d.plist",suspectId,sceneId];
    NSString *puzzleMaskPngName = [[NSString alloc] initWithFormat:@"puzzle_atlas_%d_%d.png",suspectId,sceneId];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:puzzleMaskPlistName];
    CCSpriteBatchNode *spritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:puzzleMaskPngName];
    [self addChild:spritesBatchNode];
    
    for(int i=0; i<arrPieces.count; i++) {
        //mask
        NSString *maskImageName = [[NSString alloc] initWithFormat:@"puzzle_%d_%d_%d.png",suspectId,sceneId,i+1];
        CCSprite *spriteMask = [CCSprite spriteWithSpriteFrameName:maskImageName];
        CGImageRef maskRef = [[self imageFromSprite:spriteMask] CGImage];
        [maskImageName release];
        
        //sub puzzle
        CGPoint subPuzzlePos = CGPointFromString([[arrPieces objectAtIndex:i] objectForKey:@"kAnchorPosition"]);
        CGFloat x = subPuzzlePos.x;
        CGFloat y = kJigsawPuzzleSize.height - subPuzzlePos.y-spriteMask.contentSize.height;
        
        if (CGImageGetHeight(wholePuzzleRef) == 2*kJigsawPuzzleSize.height) {
            NSLog(@"yes");
            x = 2*x;
            y = 2*y;
        }
        subPuzzlePos = CGPointMake(x,y);
        
        CGImageRef subPuzzleRef = CGImageCreateWithImageInRect(wholePuzzleRef,CGRectMake(subPuzzlePos.x,subPuzzlePos.y,CGImageGetWidth(maskRef),CGImageGetHeight(maskRef)));
        
        //piece
        NSString *aKey = [[NSString alloc] initWithFormat:@"piece_%d_%d_%d.png",suspectId,sceneId,i];
        CGImageRef pieceRef = [self maskImage:subPuzzleRef withMask:maskRef];
        CCSprite *sprite = [CCSprite spriteWithCGImage:pieceRef key:aKey];
        [sprite setTag:i+1];
        CGPoint radomPoint = CGPointMake(rand()%kPuzzleGameRadomScope,rand()%kPuzzleGameRadomScope);
        [sprite setAnchorPoint:CGPointZero];
        [sprite setPosition:radomPoint];
        
        [puzzleLayer addChild:sprite];
                
        //CGImageRelease(maskRef);
        //CGImageRelease(subPuzzleRef);
        //CGImageRelease(pieceRef);
        
        [aKey release];
    }
    
    [shadowImageName release];
    [wholePuzzleImageName release];
    [puzzleMaskPlistName release];
    [puzzleMaskPngName release];
}

- (UIImage *)imageFromSprite:(CCSprite *)sprite
{
    int tx = sprite.contentSize.width;
    int ty = sprite.contentSize.height;
    
    CCRenderTexture *renderer = [CCRenderTexture renderTextureWithWidth:tx height:ty];
    
    sprite.anchorPoint = CGPointZero;
    
    [renderer begin];
    [sprite visit];
    [renderer end];
    
    return [renderer getUIImage];
}

- (CGImageRef)maskImage:(CGImageRef)imageReference withMask:(CGImageRef)maskReference
{
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    
    //CGImageRelease(imageReference);
    //CGImageRelease(maskedReference);
    //CGImageRelease(imageMask);
    
    return maskedReference;
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
    CCLabelTTF *aLabel = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kAlertPuzzle",@"ui_labels",nil)
                                            fontName:kFontName
                                            fontSize:kFontSize
                                          dimensions:CGSizeMake(SIZE_OBJECTS_PANEL.width,SIZE_OBJECTS_PANEL.height)
                                          hAlignment:kCCTextAlignmentCenter
                                          vAlignment:kCCVerticalTextAlignmentCenter];
    [aLabel setColor:ccc3(0,0,0)];
    [aLabel setPosition:ccp(winSize.width/2,kObjectsPanelSize.height/2)];
    [self addChild:aLabel];
}

#pragma mark -
#pragma mark touch method

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
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
    for (CCSprite *sprite in puzzleLayer.children) {
        if (sprite.tag>0 && CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            newSprite = sprite;
            break;
        }
    }
    if (newSprite != selSprite) {
        selSprite = newSprite;
        //點到的拉到最前面
        for (int i=0; i<puzzleLayer.children.count; i++) {
            CCSprite *theSprite = [puzzleLayer.children objectAtIndex:i];
            if (selSprite == theSprite) {
                [puzzleLayer reorderChild:theSprite z:1];
            }
            else {
                [puzzleLayer reorderChild:theSprite z:0];
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
    for (int i=0; i<[arrPieces count]; i++) {
        
        int theTag = [[[arrPieces objectAtIndex:i] objectForKey:@"kTag"] intValue];
        
        if (selSprite.tag == theTag) {
            
            NSString *strAnchorPosition = [[arrPieces objectAtIndex:i] objectForKey:@"kAnchorPosition"];
            CGPoint p1 = CGPointFromString(strAnchorPosition);
            CGPoint p2 = CGPointMake(p1.x+kJigsawPuzzlePosition.x,p1.y+kJigsawPuzzlePosition.y);
            
            if ( abs(p2.x-selSprite.position.x)<kPuzzleGameTolerance && abs(p2.y-selSprite.position.y)<kPuzzleGameTolerance ) {
                [selSprite setPosition:p2];
                [selSprite setTag:0];
                [selSprite setOpacity:200];
                
                if ([self checkIfPass] == YES) {
                    [self levelCompleted];
                };
            }
            
            break;
        }
    }
}

#pragma mark -

-(bool)checkIfPass
{
	//return YES;
    
    for (int i=0; i<puzzleLayer.children.count; i++) {
        if ([[puzzleLayer.children objectAtIndex:i] tag] != 0) {
            return NO;
        }
    }
    return YES;
}

-(void)levelCompleted
{
    [self playSound:@"SoundEffect6.mp3"];
    
    NSString *imageName = [[NSString alloc] initWithFormat:@"puzzle_whole_%d_%d.png",suspectId,sceneId];
    CCSprite *spritePuzzle = [CCSprite spriteWithFile:imageName];
    [spritePuzzle setAnchorPoint:CGPointZero];
    [spritePuzzle setPosition:kJigsawPuzzlePosition];
    [spritePuzzle setOpacity:0];
    [self addChild:spritePuzzle];
    [imageName release];
    
    id fadeIn = [CCFadeIn actionWithDuration:1];
    [spritePuzzle runAction:fadeIn];
    
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
    [self unloadTouch];
    
    [self removeFromParentAndCleanup:YES];
}

#pragma mark -

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

-(void)pressPause
{
    [self playSound:@"SoundEffect2.mp3"];

    //暫停選單
    PauseLayer *aLayer = [[PauseLayer alloc] init];
    [aLayer setDelegate:self];
    [self addChild:aLayer z:100];
    
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

#pragma mark -

-(void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCDirector sharedDirector] purgeCachedData];

    [super dealloc];
}

@end
