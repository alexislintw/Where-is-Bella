//
//  DialogueLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/17.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "DialogueLayer.h"
#import "GRSuspect.h"
#import "GRDetective.h"
#import "SuspectListLayer.h"
#import "ScenesLayer.h"
#import "GameAlertLayer.h"

@implementation DialogueLayer

+(CCScene *)sceneWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId
{
	CCScene *scene = [CCScene node];
	DialogueLayer *layer = [[[DialogueLayer alloc] initWithSuspectId:aSuspectId AndSceneId:aSceneId] autorelease];
	[scene addChild: layer];
    
	return scene;
}

-(id)initWithSuspectId:(int)aSuspectId AndSceneId:(int)aSceneId
{
	if( (self=[super init]) ) {
        
        [[CCDirector sharedDirector] purgeCachedData];
        
        suspectId = aSuspectId;
        sceneId = aSceneId;
        
        timeCounter = 0;
        dialogueIndex = 0;
        
        //對白
        NSString *path = [[NSBundle mainBundle] pathForResource:@"dialogues" ofType:@"plist"];
        NSDictionary *dicAllScenes = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *key = [[NSString alloc] initWithFormat:@"k-%d-%d",suspectId,sceneId];
        arrDetectiveDialogues = [[NSArray alloc] initWithArray:[dicAllScenes objectForKey:key]];
        [dicAllScenes release];
        [key release];
        
        //背景
        int backgroundSceneId;
        if (sceneId > 4) {
            backgroundSceneId = sceneId - 1;
        }
        else {
            backgroundSceneId = sceneId;
        }
        NSString *bkgName = [[NSString alloc] initWithFormat:@"background_%d_%d.png",suspectId,backgroundSceneId];
        CCSprite *background = [CCSprite spriteWithFile:bkgName];
        [background setPosition:kScreenCenter];
        [background setOpacity:120];
        [self addChild:background];
        [bkgName release];
        
        //角色
        detectiveLeft = [[GRDetective alloc] initWithDetectiveId:1];
        [detectiveLeft setAnchorPoint:ccp(0.5,0)];
        [detectiveLeft setPosition:kLeftDetectivePosition];
        [self addChild:detectiveLeft]; //2留給煙霧 4留給魔鏡
        
        detectiveRight = [[GRDetective alloc] initWithDetectiveId:2];
        [detectiveRight setAnchorPoint:ccp(0.5,0)];
        [detectiveRight setPosition:kRightDetectivePosition];
        [self addChild:detectiveRight];
        
        if (sceneId == 5) {
            //嫌疑犯資料
            NSString *path = [[NSBundle mainBundle] pathForResource:@"suspects" ofType:@"plist"];
            NSDictionary *dicAllSuspects = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *key = [[NSString alloc] initWithFormat:@"k-%d",suspectId];
            dicTheSuspectData = [[NSDictionary alloc] initWithDictionary:[dicAllSuspects objectForKey:key]];
            [dicAllSuspects release];
            [key release];
            
            //證詞
            arrSuspectDialogues = [[NSArray alloc] initWithArray:[dicTheSuspectData objectForKey:@"kTestimonyKeys"]];

            //回魂鏡底
            CCSprite *spriteMirrorBg = [CCSprite spriteWithFile:@"icon_mirror_bg.png"];
            [spriteMirrorBg setPosition:kMirrorPosition];
            [self addChild:spriteMirrorBg];
            
            //人像
            NSString *suspectImageName = [dicTheSuspectData objectForKey:@"kImageForDialogue"];
            spriteSuspect = [CCSprite spriteWithFile:suspectImageName];
            [spriteSuspect setAnchorPoint:ccp(0.5,0)];
            [spriteSuspect setPosition:kSuspectPosition];
            [self addChild:spriteSuspect];
            
            //煙霧效果
            CCParticleSystemQuad *smoke = [CCParticleSystemQuad particleWithFile:@"particle_smoke.plist"];
            [smoke setPosition:kSmokePosition];
            [self addChild:smoke];
            
            //回魂鏡
            CCSprite *spriteMirror = [CCSprite spriteWithFile:@"icon_mirror.png"];
            [spriteMirror setPosition:kMirrorPosition];
            [self addChild:spriteMirror];
        }
        
        //對話框
        spriteDialogueBox = [CCSprite spriteWithFile:@"bkg_dialogue_box.png"];
        [spriteDialogueBox setPosition:ccp(winSize.width/2,spriteDialogueBox.contentSize.height/2)];
        [self addChild:spriteDialogueBox];
        
        //對白文字
        labDialogue = [CCLabelTTF labelWithString:@""
                                         fontName:kFontName
                                         fontSize:kFontSize
                                       dimensions:CGSizeMake(spriteDialogueBox.contentSize.width*0.9,spriteDialogueBox.contentSize.height/2)
                                       hAlignment:UITextAlignmentCenter
                                       ];
        [labDialogue setColor:ccBLACK];
        [labDialogue setPosition:ccp(winSize.width/2,spriteDialogueBox.contentSize.height/2)];
        [spriteDialogueBox addChild:labDialogue];
        
        //選單        
        CCMenuItemSprite *itemSkip = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_round.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_round_sel.png"] target:self selector:@selector(pressSkip)];
        CCLabelTTF *labSkip = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kSkip",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeRoundButton];
        [labSkip setPosition:ccp(POINT_ROUND_BUTTON_LABEL_CENTER.x,POINT_ROUND_BUTTON_LABEL_CENTER.y)];
        [itemSkip addChild:labSkip];
        
        CCMenuItemSprite *itemNext = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_round.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_round_sel.png"] target:self selector:@selector(pressNext)];
        CCLabelTTF *labNext = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kNext",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeRoundButton];
        [labNext setPosition:ccp(POINT_ROUND_BUTTON_LABEL_CENTER.x,POINT_ROUND_BUTTON_LABEL_CENTER.y)];
        [itemNext addChild:labNext];

        CCMenu *menu = [CCMenu menuWithItems:itemSkip,itemNext,nil];
        [menu alignItemsHorizontallyWithPadding:winSize.width*0.55];
        [menu setPosition:kDialogueMenuPosition];
        [self addChild:menu];
        
        //箭頭
        spriteDialogueArrow = [CCSprite spriteWithFile:@"icon_dialogue_arrow.png"];
        [spriteDialogueArrow setPosition:kDialogueCenterArrowPosition];
        [self addChild:spriteDialogueArrow];
        
        //開始自動播放
        //dialogueType 1:嫌犯 2:偵探
        if (sceneId == 5) {
            dialogueType = 1;
            [self suspectDialogue];
            [self schedule:@selector(rolling) interval:0.1 repeat:6000 delay:1];
        }
        else {
            dialogueType = 2;
            [self detectiveDialogue];
            [self schedule:@selector(rolling) interval:0.1 repeat:6000 delay:1];
        }
	}
	return self;
}

-(void)rolling
{
	timeCounter ++;
	if (timeCounter >= 40) {
        if (dialogueType == 1) {
            [self suspectDialogue];
        }
        else if (dialogueType == 2) {
            [self detectiveDialogue];
        }
	}
}

-(void)suspectDialogue
{
	if (dialogueIndex < [arrSuspectDialogues count]) {
		
        //對白文字
		NSString *dialogueKey = [arrSuspectDialogues objectAtIndex:dialogueIndex];
        NSString *dialogueText = NSLocalizedStringFromTable(dialogueKey,@"suspects_setting",nil);
        [labDialogue setOpacity:0];
        [labDialogue setString:dialogueText];
        
        id fadeIn = [CCFadeIn actionWithDuration:1.0f];
        [labDialogue runAction:fadeIn];
        
        //箭頭和角色
        if (dialogueIndex == 0) {
            [spriteDialogueArrow setPosition:kDialogueCenterArrowPosition];
            [detectiveLeft stepdown];
            [detectiveRight stepdown];
        }
        
        timeCounter = 0;
        dialogueIndex ++;
	}
	else {
		[self suspectDialogueDidEnd];
	}
}

-(void)detectiveDialogue
{
	if (dialogueIndex < [arrDetectiveDialogues count]) {
		
        //對白文字
		NSDictionary *aDialogue = [arrDetectiveDialogues objectAtIndex:dialogueIndex];
		NSString *dialogueKey = [aDialogue objectForKey:@"kDialogueId"];
        NSString *dialogueText = NSLocalizedStringFromTable(dialogueKey,@"dialogues",nil);
        [labDialogue setOpacity:0];
        [labDialogue setString:dialogueText];
        
        id fadeIn = [CCFadeIn actionWithDuration:1.0f];
        [labDialogue runAction:fadeIn];
        
        int aDetectiveId = [[aDialogue objectForKey:@"kDetectiveId"] intValue];
        
        if (previousDetectiveId == 0) {
            //箭頭和角色
            if (aDetectiveId == 1) {
                [spriteDialogueArrow setPosition:kDialogueLeftArrowPosition];
                [detectiveLeft stepup];
            }
            else if (aDetectiveId == 2) {
                [spriteDialogueArrow setPosition:kDialogueRightArrowPosition];
                [detectiveRight stepup];
            }
            previousDetectiveId = aDetectiveId;
        }
        else {
            if (aDetectiveId != previousDetectiveId) {
                //箭頭和角色
                if (aDetectiveId == 1) {
                    [spriteDialogueArrow setPosition:kDialogueLeftArrowPosition];
                    [detectiveLeft stepup];
                    [detectiveRight stepdown];
                }
                else if (aDetectiveId == 2) {
                    [spriteDialogueArrow setPosition:kDialogueRightArrowPosition];
                    [detectiveRight stepup];
                    [detectiveLeft stepdown];
                }
                previousDetectiveId = aDetectiveId;
            }
        }
        timeCounter = 0;
        dialogueIndex ++;
	}
	else {
		[self detectiveDialogueDidEnd];
	}
}

-(void)suspectDialogueDidEnd
{
    dialogueIndex = 0;
    dialogueType = 2;
    timeCounter = 20;
}

-(void)detectiveDialogueDidEnd
{
	[self unscheduleAllSelectors];
    
    //accuse功能提示
    if (suspectId == 7 && sceneId == 5) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameAlertLayer sceneWithAlertId:1] withColor:ccBLACK]];
        return;
    }
    
    if (suspectId == 0) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SuspectListLayer sceneWithSuspectId:1] withColor:ccBLACK]];
    }
    else {
        if (sceneId == 4) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[DialogueLayer sceneWithSuspectId:suspectId AndSceneId:sceneId+1] withColor:ccBLACK]];
        }
        else if (sceneId == 5) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SuspectListLayer sceneWithSuspectId:suspectId] withColor:ccBLACK]];
        }
        else {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ScenesLayer sceneWithSuspectId:suspectId] withColor:ccBLACK]];
        }
    }
}

#pragma mark -
#pragma mark menu method

-(void)pressNext
{
    [self playSound:@"SoundEffect2.mp3"];
    
    if(dialogueType == 1) {
        [self suspectDialogue];
    }
    else if (dialogueType == 2) {
        [self detectiveDialogue];
    }
}

-(void)pressSkip
{
    [self playSound:@"SoundEffect2.mp3"];

    [self detectiveDialogueDidEnd];
}
/*
-(void)onExit
{
    [super onExit];
    
    [self removeAllChildrenWithCleanup:YES];
}
*/

-(void) dealloc
{
    [[CCDirector sharedDirector] purgeCachedData];
    
    [super dealloc];
}

@end
