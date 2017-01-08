//
//  GameLayer.h
//  bella
//
//  Created by Alexis Lin on 13/5/21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCommonLayer.h"

#define SIZE_SCENE CGSizeMake(1536,1152)
#define WIDTH_MARGIN_PANEL 140
#define WIDTH_PANEL 160
#define POINT_MARGIN CGPointMake(280,140)

@protocol JigsawPuzzleGameDelegate <NSObject>

@required
-(void)puzzleGameDidFinished;
-(void)pressPause;

@end

@interface JigsawPuzzleGameLayer : GameCommonLayer {
    int suspectId;
    int sceneId;
    NSMutableArray *arrPieces;
    NSMutableArray *arrTouchableSprites;
    CCSprite * selSprite;
    id <JigsawPuzzleGameDelegate> delegate;
    CCLayer *puzzleLayer;
    
    CCMenuItemImage *itemHint;
    CCMenuItemImage *itemPause;
}

@property(assign) id delegate;

+(CCScene *)sceneWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId;
-(id)initWithSuspectId:(int)aSuspect AndSceneId:(int)aSceneId;

@end
