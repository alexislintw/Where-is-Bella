//
//  DialogueLayer.h
//  bella
//
//  Created by Alexis Lin on 13/5/17.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCommonLayer.h"

@class GRDetective;

@interface DialogueLayer : GameCommonLayer {
    int suspectId;
    int sceneId;
    int dialogueType;
    CCSprite *spriteDialogueArrow;
    CCSprite *spriteDialogueBox;
    GRDetective *detectiveLeft;
    GRDetective *detectiveRight;
    CCLabelTTF *labDialogue;
    NSArray *arrDetectiveDialogues;
    NSArray *arrSuspectDialogues;
    int timeCounter;
    int dialogueIndex;
    int previousDetectiveId;
    
    CCSprite *spriteSuspect;
    NSDictionary *dicTheSuspectData;
}

+(CCScene *)sceneWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId;

@end
