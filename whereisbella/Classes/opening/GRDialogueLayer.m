//
//  GRDialogueLayer.m
//  bella
//
//  Created by Alexis Lin on 13/7/27.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GRDialogueLayer.h"
#import "MainMenuLayer.h"
#import "SuspectListLayer.h"

@implementation GRDialogueLayer

@synthesize arrDialogues;
@synthesize delegate;

+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	GRDialogueLayer *layer = [GRDialogueLayer node];
	[scene addChild: layer];
    
	return scene;
}

-(id)initWithDialogue:(NSArray*)anArray
{
	if( (self=[super init]) ) {

        self.arrDialogues = anArray;
        //[anArray release];
        
        //對話盒
        CCSprite *dialogueBox = [CCSprite spriteWithFile:@"bkg_dialogue_box.png"];
        [dialogueBox setPosition:ccp(winSize.width/2,dialogueBox.contentSize.height/2)];
        [self addChild:dialogueBox];

        //對白文字
        labDialogue = [CCLabelTTF labelWithString:@""
                                         fontName:kFontName
                                         fontSize:kFontSize
                                       dimensions:CGSizeMake(440,120)
                                       hAlignment:UITextAlignmentCenter];
        [labDialogue setColor:ccBLACK];
        [labDialogue setPosition:ccp(winSize.width/2,winSize.height*0.04)];
        [self addChild:labDialogue];
        
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
        [menu alignItemsHorizontallyWithPadding:280];
        [menu setPosition:ccp(winSize.width/2,25)];
        [self addChild:menu];
    }
    return self;
}

-(void)startPlayDialogue
{
    [self nextDialogue];
    [self schedule:@selector(rolling) interval:0.1 repeat:6000 delay:0];
}

-(void)rolling
{
	timeCounter ++;
	if (timeCounter >= 40) {
        [self nextDialogue];
	}
}

-(void)nextDialogue
{
    if (dialogueIndex < [arrDialogues count]) {
		
        //對白文字
		NSString *dialogueKey = [arrDialogues objectAtIndex:dialogueIndex];
        NSString *dialogueText = NSLocalizedStringFromTable(dialogueKey,@"dialogues",nil);
        [labDialogue setOpacity:0];
        [labDialogue setString:dialogueText];
        
        id fadeIn = [CCFadeIn actionWithDuration:1.0f];
        [labDialogue runAction:fadeIn];
        
        timeCounter = 0;
        dialogueIndex ++;
	}
	else {
        [self dialogueDidEnd];
	}
}

-(void)dialogueDidEnd
{
	[self unscheduleAllSelectors];
    [[self delegate] dialogueDidEnd];
}

#pragma mark -

-(void)pressNext
{
    [self playSound:@"SoundEffect2.mp3"];
    
    [self nextDialogue];
}

-(void)pressSkip
{
    [self unscheduleAllSelectors];
    
    [self playSound:@"SoundEffect2.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SuspectListLayer scene] withColor:ccBLACK]];
}

@end
