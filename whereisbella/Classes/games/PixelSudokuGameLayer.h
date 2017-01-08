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

@protocol PixelSudokuGameDelegate <NSObject>

@required
-(void)puzzleGameDidFinished;
-(void)pressPause;

@end

@interface PixelSudokuGameLayer : GameCommonLayer {
    int suspectId;
    int sceneId;
    
    int scores;
	int baseScores;
	int hintScores;
	int timeScores;
	int comboScores;
	int perfectScores;
	
	int tempCounter;
	int timeCounter;
	int comboCounter;
	int hintCounter;
	int scoreCounter;
	int errorCounter;
	int comboTimeCounter;
    int comboSum;
    int itemCounter;
	int totalItemsToFind;
	int starNums;
    
    CCLayerColor *numbersLayer;
    CCLayerColor *pixelsLayer;
    CCLayerColor *helpLayer;
    CCLayer *gameRuleLayer;
    CCSpriteBatchNode *batchSquare;
    
    int arrAll[15][15];
    int arrTopNumbers[10][5];
    int arrLeftNumbers[5][10];
    int arrPixels[10][10];
    int arrTags[10][10];

    id <PixelSudokuGameDelegate> delegate;
    
    CCMenuItemImage *itemHint;
    CCMenuItemImage *itemPause;
    CCMenuItemImage *itemGameRule;
    
    BOOL isGameRuleShowed;
}

@property(nonatomic,retain) NSMutableArray *arrObjects;
@property(assign) id delegate;

-(id)initWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId;

@end
