//
//  ScrollLayer.h
//  testscrollview
//
//  Created by Alexis Lin on 12/12/17.
//  Copyright 2012年 Alexis Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol ScrollLayerDelegate <NSObject>
@required
-(void)scrollDidDoneWithCurrentScreen:(int)aScreen;
@end

@interface ScrollLayer : CCLayer {
    
	int scrollHeight;
	int scrollWidth;
	int startHeight;
	int startWidth;
	int currentScreen;
	int totalScreens;
	int startPos;
    int startPosX;
    id <ScrollLayerDelegate> delegate;
    CGSize winSize;
}

@property(nonatomic,retain) id <ScrollLayerDelegate> delegate;
@property(assign) int currentScreen;

-(id)initWithLayers:(NSMutableArray *)layers AndCurrectScreen:(int)aScreen;
-(void)move;
-(void)unlock;
-(void)enableLockButton;
-(void)disableLockButton;

@end