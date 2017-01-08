//
//  ProfileLayer.h
//  bella
//
//  Created by Alexis Lin on 13/5/20.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCommonLayer.h"

@interface ProfileLayer : GameCommonLayer {
    int suspectId;
    CCLayerColor *panelLayer;
    CGFloat realPanelHeight;
    CGPoint startTouch;
    UITextView *textView;
}

+(CCScene *)sceneWithSuspectId:(int)anId;

@end
