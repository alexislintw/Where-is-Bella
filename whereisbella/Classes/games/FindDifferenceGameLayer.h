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
#import "PauseLayer.h"

@interface FindDifferenceGameLayer : GameCommonLayer <PauseLayerDelegate> {
    int suspectId;
    int sceneId;
    int itemCounter;
    NSMutableArray *arrObjects;
    CCSpriteBatchNode *spritesBatchNode;
    CCLayer *sceneLayer;
    CCLabelTTF *labelFoundDifferencesCounter;
    CCParticleSystemQuad *vanishSparkle;
    CCMenuItemImage *itemPause;
    CCMenuItemImage *itemHint;
}

+(CCScene *)sceneWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId;

@end
