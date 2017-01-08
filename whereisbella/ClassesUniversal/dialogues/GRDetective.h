//
//  GRDetective.h
//  bella
//
//  Created by Alexis Lin on 13/5/23.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GRDetective : CCLayer {
    CCSprite *spriteFront;
    CCSprite *spriteSide;
}

-(id)initWithDetectiveId:(int)anId;
-(void)stepup;
-(void)stepdown;

@end
