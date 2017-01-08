//
//  EvidencesLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/20.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "EvidencesLayer.h"
#import "MainMenuLayer.h"
#import "SuspectListLayer.h"


@implementation EvidencesLayer


+(CCScene *)sceneWithSuspectId:(int)anId
{
    CCScene * scene = [CCScene node];
    EvidencesLayer *layer = [[[EvidencesLayer alloc] initWithSuspectId:anId] autorelease];
    [scene addChild: layer];
    return scene;
}

-(id)initWithSuspectId:(int)anId
{
	if( (self=[super init]) ) {
        
        suspectId = anId;
        
        //載入資料
        NSString *aKey = [[NSString alloc] initWithFormat:@"k-%d",anId];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"suspects" ofType:@"plist"];
        NSDictionary *dicSuspects = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
        NSDictionary *aSuspect = [dicSuspects objectForKey:aKey];
        NSString *suspectImageName = [aSuspect objectForKey:@"kImageForSuspectList"];
        NSString *suspectNameKey = [aSuspect objectForKey:@"kSuspectName"];
        NSString *suspectName = NSLocalizedStringFromTable(suspectNameKey,@"suspects_setting",nil);
        NSArray *arrEvidenceKeys = [aSuspect objectForKey:@"kEvidenceKeys"];
        NSArray *arrEvidenceImages = [aSuspect objectForKey:@"kEvidenceImages"];
        [aKey release];
        
        //背景
        CCSprite *background = [CCSprite spriteWithFile:@"background_evidence.png"];
        [background setPosition:kScreenCenter];
        [self addChild:background];
        
        //標籤字
        NSString *aString = NSLocalizedStringFromTable(@"kEvidences",@"ui_labels",nil);
        CCLabelTTF *label = [CCLabelTTF labelWithString:aString fontName:kFontName fontSize:kFontSizeHeading];
        [label setColor:kFontColor];
        [label setPosition:kSuspectSubMenuLabelPosition];
        [self addChild:label];
        
        //人像
        CCSprite *photo = [CCSprite spriteWithFile:suspectImageName];
        [photo setScale:0.82];
        [photo setPosition:kSuspectPhotoPosition];
        [self addChild:photo];
        
        //人名
        CCLabelTTF *labName = [CCLabelTTF labelWithString:suspectName fontName:kFontName fontSize:kFontSize];
        [labName setColor:kFontColor];
        [labName setPosition:kSuspectNamePosition];
        [self addChild:labName];
        
        //選單
        CCMenuItemSprite *itemBack = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_small.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_small_sel.png"] target:self selector:@selector(pressBack)];
        CCLabelTTF *labBack = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kBack",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labBack setPosition:ccp(POINT_SMALL_BUTTON_LABEL_CENTER.x,POINT_SMALL_BUTTON_LABEL_CENTER.y)];
        [itemBack addChild:labBack];
        
        CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_tag_small.png"] selectedSprite:[CCSprite spriteWithFile:@"btn_tag_small_sel.png"] target:self selector:@selector(pressMenu)];
        CCLabelTTF *labMenu = [CCLabelTTF labelWithString:NSLocalizedStringFromTable(@"kMenu",@"ui_labels",nil) fontName:kFontNameButton fontSize:kFontSizeButton];
        [labMenu setPosition:ccp(POINT_SMALL_BUTTON_LABEL_CENTER.x,POINT_SMALL_BUTTON_LABEL_CENTER.y)];
        [itemMenu addChild:labMenu];

        CCMenu *menuButtons = [CCMenu menuWithItems:itemBack,itemMenu,nil];
        [menuButtons alignItemsVerticallyWithPadding:8];
        [menuButtons setPosition:kSuspectMenuPosition];
        [self addChild:menuButtons];
        
        //證據文字
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        for (int i=0; i<3; i++) {
            NSString *evidenceTextKey = [arrEvidenceKeys objectAtIndex:i];
            if ([userDefaults objectForKey:evidenceTextKey] != nil) {
                
                //圖片
                NSString *evidenceImageName = [arrEvidenceImages objectAtIndex:i];
                CCSprite *evidenceSprite = [CCSprite spriteWithFile:evidenceImageName];
                [evidenceSprite setScale:(kSuspectEvidenceImageSize/evidenceSprite.contentSize.width)];
                [evidenceSprite setPosition:kSuspectEvidenceImagePosition];
                [self addChild:evidenceSprite];

                //文字
                NSString *evidenceText = NSLocalizedStringFromTable(evidenceTextKey,@"suspects_setting",nil);
                CCLabelTTF *evidenceLabel = [CCLabelTTF labelWithString:evidenceText
                                                               fontName:kFontName
                                                               fontSize:kFontSize
                                                      dimensions:kSuspectEvidenceLabelSize
                                                      hAlignment:UITextAlignmentLeft
                                                             vAlignment:UITextAlignmentCenter];
                [evidenceLabel setColor:kFontColor];
                [evidenceLabel setPosition:kSuspectEvidenceLabelPosition];
                [self addChild:evidenceLabel];
            }
        }
	}
	return self;
}

-(void)pressBack
{
    [self playSound:@"SoundEffect2.mp3"];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SuspectListLayer sceneWithSuspectId:suspectId] withColor:ccBLACK]];
    
}

-(void)pressMenu
{
    [self playSound:@"SoundEffect2.mp3"];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] withColor:ccBLACK]];
}

@end
