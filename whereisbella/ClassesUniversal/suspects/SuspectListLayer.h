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
#import "GRPayment.h"

@interface SuspectListLayer : GameCommonLayer <ScrollLayerDelegate,GRPaymentDelegate,UIAlertViewDelegate> {
    NSDictionary *dicSuspects;
    CCMenuItemImage *itemLeft;
    CCMenuItemImage *itemRight;
    int currectSuspect;
    ScrollLayer *scroll;
    BOOL isAccuseEnabled;
    
    GRPayment *myPaymnet;
    UIActivityIndicatorView *ibIndicator;
}

@property(nonatomic,retain) GRPayment *myPayment;
@property(nonatomic,retain) UIActivityIndicatorView *ibIndicator;

+(CCScene *)scene;
+(CCScene *)sceneWithSuspectId:(int)anId;

@end
