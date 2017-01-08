//
//  SuspectListLayer.h
//  bella
//
//  Created by Alexis Lin on 13/5/15.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCommonLayer.h"
#import "ScrollLayer.h"

@interface HelpLayer : GameCommonLayer <ScrollLayerDelegate> {
    CCMenuItemImage *itemLeft;
    CCMenuItemImage *itemRight;
    int currectPage;
    ScrollLayer *scroll;
}

+(CCScene *)scene;

@end
