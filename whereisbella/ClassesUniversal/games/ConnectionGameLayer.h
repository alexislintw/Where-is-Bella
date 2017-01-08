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

@protocol ConnectionGameDelegate <NSObject>

@required
-(void)puzzleGameDidFinished;
-(void)pressPause;

@end

@interface ConnectionGameLayer : GameCommonLayer {
    int suspectId;
    int sceneId;
    NSMutableArray *arrPieces;
    NSMutableArray *arrTouchableSprites;
    CCSprite * selSprite;
    CCSpriteBatchNode *spritesBatchNode;
    CCLayerColor *puzzleLayer;
    id <ConnectionGameDelegate> delegate;
    CCMenuItemImage *itemPause;
    CCMenuItemImage *itemHint;
}

@property(assign) id delegate;

-(id)initWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId;

@end
