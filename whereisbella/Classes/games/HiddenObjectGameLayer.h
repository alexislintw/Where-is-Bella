//
//  GameLayer.h
//  bella
//
//  Created by Alexis Lin on 13/5/21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JigsawPuzzleGameLayer.h"
#import "PixelSudokuGameLayer.h"
#import "ConnectionGameLayer.h"
#import "GameCommonLayer.h"
#import "PauseLayer.h"

enum LayerTag {
    kLayerScene = 1,
    kLayerObjects = 2,
    kLayerPanel = 3,
    kLayerPanelButtons = 4,
    kLayerVanish = 5,
    kLayerHint = 6,
    kLayerGui = 7,
    kLayerEvidenceAni = 8,
    kLayerEvidenceAlert = 9,
    kLayerPuzzleGame = 10,
    kLayerPause = 11,
    kLayerResult = 12
};

@interface HiddenObjectGameLayer : GameCommonLayer <JigsawPuzzleGameDelegate,PixelSudokuGameDelegate,ConnectionGameDelegate,PauseLayerDelegate> {
    NSMutableArray *arrObjects;
    NSMutableArray *arrTouchableSprites;    //記錄有顯示在清單上的物件
    NSMutableArray *needToFindObjects;      //記錄本次遊戲要找的，含物件名稱
    NSDictionary *dicTheSceneData;
    id puzzleGame;
    
    int suspectId;
    int sceneId;
	
    int itemCounter;
    
    CCParticleSystemQuad *vanishSparkle;
    CCLayerColor *_sceneLayer;
    CCLayerColor *_panelLayer;
    CCLayer *alertLayer;
    CCMenuItemImage *itemPause;
    CCMenuItemImage *itemHint;
    
    BOOL isHintEnable;
    BOOL isTapEnable;
    
    CGPoint lastPositon;
    CGPoint beginPosition;
    float lastScale;
    UIPanGestureRecognizer *panGestureRecognizer;
    UIPinchGestureRecognizer *pinchGestureRecognizer;
}

@property(nonatomic,retain) NSMutableArray *arrObjects;
@property CGFloat prevScale;

+(CCScene *)sceneWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId;

@end
