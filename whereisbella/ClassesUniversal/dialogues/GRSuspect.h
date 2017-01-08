//
//  GRSuspect.h
//  bella
//
//  Created by Alexis Lin on 13/5/23.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GRSuspect : CCNode {
    CCLabelTTF *suspectName;
    CCSprite *spriteForSuspectList;
    CCSprite *spriteForDialogue;
    NSString *intro;
    NSString *motiveForTheCrime;
}

@property(nonatomic,readonly) CCLabelTTF *suspectName;
@property(nonatomic,readonly) CCSprite *spriteForSuspectList;
@property(nonatomic,readonly) CCSprite *spriteForDialogue;
@property(nonatomic,readonly) NSString *intro;
@property(nonatomic,readonly) NSString *motiveForTheCrime;

-(id)initWithSuspectId:(int)anId;

@end
