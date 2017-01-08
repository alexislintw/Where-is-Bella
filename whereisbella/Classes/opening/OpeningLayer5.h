//
//  OpeningLayer.h
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCommonLayer.h"
#import "GRDialogueLayer.h"

@interface OpeningLayer5 : GameCommonLayer <GRDialogueLayerDelegate> {
    CCSprite *spriteDoll;
    CCSprite *spriteRobot;
    CCSprite *spriteDoll2;
    CCSprite *spriteRobot2;
    GRDialogueLayer *dialogueLayer;
}

+(CCScene *) scene;

@end
