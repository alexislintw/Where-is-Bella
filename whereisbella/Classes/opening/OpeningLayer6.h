//
//  OpeningLayer.h
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GRDialogueLayer.h"

@interface OpeningLayer6 : CCLayer <GRDialogueLayerDelegate> {
    CCSprite *spriteKaden;
    CCSprite *spriteBella;
    CCSprite *spriteRyan;
    CCSprite *spriteAnnie;
    GRDialogueLayer *dialogueLayer;
}

+(CCScene *) scene;

@end
