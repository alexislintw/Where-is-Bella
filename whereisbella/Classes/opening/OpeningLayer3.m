//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "OpeningLayer3.h"
#import "OpeningLayer4.h"

@implementation OpeningLayer3

+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	OpeningLayer3 *layer = [OpeningLayer3 node];
	[scene addChild: layer];
    
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //背景
        spriteBackground = [CCSprite spriteWithFile:@"background_opening_2.png"];
        [spriteBackground setPosition:ccp(size.width/2,size.height/2)];
        [self addChild:spriteBackground];
        
        //角色
        spriteKaden = [CCSprite spriteWithFile:@"char_kaden_front_1.png"];
        [spriteKaden setAnchorPoint:ccp(0.5,0.3)];
        [spriteKaden setPosition:ccp(size.width*0.7,size.height*0.38)];
        [spriteKaden setScale:0.8];
        [self addChild:spriteKaden];

        //對話盒
        NSString *dialogueText = NSLocalizedStringFromTable(@"a0s3d1",@"dialogues",nil);
        NSArray *arrDialogues = [[NSArray alloc] initWithObjects:dialogueText,nil];
        dialogueLayer = [[GRDialogueLayer alloc] initWithDialogue:arrDialogues];
        [dialogueLayer setDelegate:self];
        [self addChild:dialogueLayer];
        
        [arrDialogues release];
        
        //腳本控制
        [self scheduleOnce:@selector(playDialogues) delay:1];
        [self scheduleOnce:@selector(zoomIn) delay:1];
    }
    return self;
}

-(void)zoomIn
{
    [spriteKaden runAction:[CCScaleTo actionWithDuration:3 scale:1]];
    [spriteBackground runAction:[CCScaleTo actionWithDuration:3 scale:1.2]];
}

-(void)playDialogues
{
    [dialogueLayer startPlayDialogue];
}

-(void)dialogueDidEnd
{
    [self unscheduleAllSelectors];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[OpeningLayer4 scene] withColor:ccBLACK]];
}

@end
