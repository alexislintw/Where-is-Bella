//
//  ProfileLayer.m
//  bella
//
//  Created by Alexis Lin on 13/5/20.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ProfileLayer.h"
#import "MainMenuLayer.h"
#import "SuspectListLayer.h"


@implementation ProfileLayer


+(CCScene *)sceneWithSuspectId:(int)anId
{
    CCScene * scene = [CCScene node];
    ProfileLayer *layer = [[[ProfileLayer alloc] initWithSuspectId:anId] autorelease];
    [scene addChild: layer];
    return scene;
}

-(id)initWithSuspectId:(int)anId
{
	if( (self=[super init]) ) {
        
        suspectId = anId;

        NSMutableString *strProfile = [[NSMutableString alloc] init];

        //載入資料
        NSString *aKey = [[NSString alloc] initWithFormat:@"k-%d",anId];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"suspects" ofType:@"plist"];
        NSDictionary *dicSuspects = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSDictionary *aSuspect = [dicSuspects objectForKey:aKey];
        NSString *imageName = [aSuspect objectForKey:@"kImageForSuspectList"];
        NSString *suspectNameKey = [aSuspect objectForKey:@"kSuspectName"];
        NSString *suspectName = NSLocalizedStringFromTable(suspectNameKey,@"suspects_setting",nil);
        NSString *profileKey = [aSuspect objectForKey:@"kFileKey"];
        
        [strProfile appendFormat:@"[%@]\n\n",NSLocalizedStringFromTable(@"kBackground",@"ui_labels",nil)];
        [strProfile appendFormat:@"%@\n\n",NSLocalizedStringFromTable(profileKey,@"suspects_setting",nil)];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *the4thSceneKey = [[NSString alloc] initWithFormat:@"k-%d-4",suspectId];
        BOOL aBoolIfPass = [userDefaults boolForKey:the4thSceneKey];
        [the4thSceneKey release];
        
        if ( aBoolIfPass == YES ) {
            [strProfile appendFormat:@"[%@]\n\n",NSLocalizedStringFromTable(@"kMotivations",@"ui_labels",nil)];
            for (int i=0; i<[[aSuspect objectForKey:@"kMotivationKeys"] count]; i++) {
                NSString *aKey = [[aSuspect objectForKey:@"kMotivationKeys"] objectAtIndex:i];
                [strProfile appendFormat:@"%d.%@\n\n",i+1,NSLocalizedStringFromTable(aKey,@"suspects_setting",nil)];
            }
            
            [strProfile appendString:@"\n"];
            
            [strProfile appendFormat:@"[%@]\n\n",NSLocalizedStringFromTable(@"kTestimony",@"ui_labels",nil)];
            for (int i=0; i<[[aSuspect objectForKey:@"kTestimonyKeys"] count]; i++) {
                NSString *aKey = [[aSuspect objectForKey:@"kTestimonyKeys"] objectAtIndex:i];
                [strProfile appendFormat:@"%@\n\n",NSLocalizedStringFromTable(aKey,@"suspects_setting",nil)];
            }
        }
        
        textView = [[UITextView alloc] initWithFrame:kSuspectProfileTextViewSize];
        [textView setEditable:NO];
        [textView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
        [textView setText:strProfile];
        [textView setFont:[UIFont fontWithName:kFontName size:kFontSize]];
        [textView setCenter:kSuspectProfileTextViewPosition];
                
        //背景圖
        CCSprite *background = [CCSprite spriteWithFile:@"background_profile.png"];
        [background setPosition:kScreenCenter];
        [self addChild:background];
        
        //標籤字
        NSString *aString = NSLocalizedStringFromTable(@"kProfile",@"ui_labels",nil);
        CCLabelTTF *label = [CCLabelTTF labelWithString:aString fontName:kFontName fontSize:kFontSizeHeading];
        [label setColor:kFontColor];
        [label setPosition:kSuspectSubMenuLabelPosition];
        [self addChild:label];
        
        //人像
        CCSprite *photo = [CCSprite spriteWithFile:imageName];
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
        
        [aKey release];
        [dicSuspects release];
        [strProfile release];
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

-(void)onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
    [[[CCDirector sharedDirector] view] addSubview:textView];
}

-(void)onExitTransitionDidStart
{
    [textView removeFromSuperview];
    [super onExitTransitionDidStart];
}

@end
