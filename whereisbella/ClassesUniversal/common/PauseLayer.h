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

//---------
@protocol PauseLayerDelegate <NSObject>

@required
-(void)resumeGame;
-(void)restartGame;
-(void)endGame;

@end
//---------

@interface PauseLayer : GameCommonLayer {
    id <PauseLayerDelegate> delegate;
}

@property(assign) id delegate;

-(id)init;

@end
