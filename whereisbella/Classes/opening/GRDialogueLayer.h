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

@protocol GRDialogueLayerDelegate <NSObject>
@required
-(void)dialogueDidEnd;
@end

@interface GRDialogueLayer : GameCommonLayer {
    int timeCounter;
    int dialogueIndex;
    NSArray *arrDialogues;
    CCLabelTTF *labDialogue;
    id <GRDialogueLayerDelegate> delegate;
}

@property(nonatomic,retain) NSArray *arrDialogues;
@property(nonatomic,retain) id <GRDialogueLayerDelegate> delegate;

+(CCScene *)scene;
-(id)initWithDialogue:(NSArray*)anArray;
-(void)startPlayDialogue;

@end
