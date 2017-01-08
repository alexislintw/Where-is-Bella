//
//  OpeningLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "OpeningLayer1.h"
#import "OpeningLayer2.h"

@implementation OpeningLayer1

+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	OpeningLayer1 *layer = [OpeningLayer1 node];
	[scene addChild: layer];
    
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //背景
        CCSprite *spriteBackground = [CCSprite spriteWithFile:@"background_big_scene.png"];
        [spriteBackground setPosition:ccp(size.width/2,size.height/2)];
        [spriteBackground setScale:0.8];
        [self addChild:spriteBackground z:1 tag:101];
        
        //角色
        CCSprite *spriteBella = [CCSprite spriteWithFile:@"char_bella_side_1.png"];
        [spriteBella setAnchorPoint:ccp(0.5,0.3)];
        [spriteBella setPosition:ccp(size.width*0.64,size.height*0.32)];
        [spriteBella setScale:0.8];
        [self addChild:spriteBella z:2 tag:102];

        //對話盒
        NSString *dialogueText = NSLocalizedStringFromTable(@"a0s1d1",@"dialogues",nil);
        NSArray *arrDialogues = [[NSArray alloc] initWithObjects:dialogueText,nil];
        GRDialogueLayer *dialogueLayer = [[[GRDialogueLayer alloc] initWithDialogue:arrDialogues] autorelease];
        [dialogueLayer setDelegate:self];
        [self addChild:dialogueLayer z:3 tag:103];
        
        [arrDialogues release];
        
        //腳本控制
        [self scheduleOnce:@selector(playDialogues) delay:1];
        [self scheduleOnce:@selector(zoomIn) delay:1];
    }
    return self;
}

-(void)zoomIn
{
    [[self getChildByTag:101] runAction:[CCScaleTo actionWithDuration:5.5 scale:0.9]];
    [[self getChildByTag:102] runAction:[CCScaleTo actionWithDuration:5.5 scale:1]];
}

-(void)playDialogues
{
    [(GRDialogueLayer*)[self getChildByTag:103] startPlayDialogue];
}

-(void)dialogueDidEnd
{
    [self unscheduleAllSelectors];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[OpeningLayer2 scene] withColor:ccBLACK]];
}

- (void)dealloc
{
    NSLog(@"dealloc opening1");
	
    // don't forget to call "super dealloc"
	[super dealloc];
}

@end
