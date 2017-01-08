//
//  GameCommon.h
//  bella
//
//  Created by Alexis Lin on 13/7/26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

//共用
#define kUrlMore @"itms-apps://itunes.com/apps/goldrockinc"

#define kFontName @"Times New Roman"
#define kFontNameButton @"Georgia-Bold"
#define kFontColor ccc3(120,31,26)

#define kScreenCenter ccp([[CCDirector sharedDirector] winSize].width/2,[[CCDirector sharedDirector] winSize].height/2)
#define k4InchWidthDiff ([CCDirector sharedDirector].winSize.width-480)/2

#define INTERVAL_REFRESH_UNIT 1
#define INTERVAL_LABEL_FADE_IN 0.8f
#define INTERVAL_DISABLE_HINT 60.0f //提示功能間隔時間 60

#define NUM_OBJECTS_NEED_TO_FIND 15
#define NUM_DIFFERENCES_NEED_TO_FIND 8

//------兩個版--------

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//main menu
#define kBannerPosition (IS_IPAD ? ccp(512,633) : ccp(240+k4InchWidthDiff,winSize.height*0.8))
#define kBackMenuItemPosition (IS_IPAD ? ccp(96,730) : ccp(52,299))

//dialogue
#define kDialogueLeftArrowPosition (IS_IPAD ? ccp(224,237) : ccp(86+k4InchWidthDiff,100))
#define kDialogueRightArrowPosition (IS_IPAD ? ccp(800,237) : ccp(396+k4InchWidthDiff,100))
#define kDialogueCenterArrowPosition (IS_IPAD ? ccp(512,237) : ccp(240+k4InchWidthDiff,100))
#define kLeftDetectivePosition (IS_IPAD ? ccp(204,225) : ccp(86+k4InchWidthDiff,70))
#define kRightDetectivePosition (IS_IPAD ? ccp(820,225) : ccp(396+k4InchWidthDiff,70))
#define kMirrorPosition (IS_IPAD ? ccp(winSize.width/2,495) : ccp(winSize.width/2,210))
#define kSuspectPosition (IS_IPAD ? ccp(winSize.width/2,278) : ccp(winSize.width/2,120))
#define kSmokePosition (IS_IPAD ? ccp(winSize.width/2,400) : ccp(winSize.width/2,165))
#define kDialogueMenuPosition (IS_IPAD ? ccp(winSize.width/2,50) : ccp(winSize.width/2,25))

//hidden objects games
#define kGameHintButtonPosition (IS_IPAD ? ccp(48,48) : ccp(20,20))
#define kGamePauseButtonPosition (IS_IPAD ? ccp(984,44) : ccp(winSize.width-20,20))
#define kObjectsPanelSize (IS_IPAD ? CGSizeMake(1024,97) : CGSizeMake(460,45))
#define kEvidenceAlertLayerSize (IS_IPAD ? CGSizeMake(0,0) : CGSizeMake(270,270))
#define kEvidenceAlertLayerPosition (IS_IPAD ? ccp(360,485) : ccp(105+k4InchWidthDiff,45))
#define kGameResultSceneLabelPosition (IS_IPAD ? ccp(224,237) : ccp(236+k4InchWidthDiff,290))
#define kGameResultTitlePosition (IS_IPAD ? ccp(224,237) : ccp(236+k4InchWidthDiff,230))
#define kGameResultStampPosition (IS_IPAD ? ccp(224,237) : ccp(96+k4InchWidthDiff,120))
#define kGameResultMenuPosition (IS_IPAD ? ccp(224,237) : ccp(236+k4InchWidthDiff,100))
#define kEvidenceLabelPosition (IS_IPAD ? ccp(360,485) : ccp(206+k4InchWidthDiff,170))
#define kEvidenceImagePosition (IS_IPAD ? ccp(360,485) : ccp(326+k4InchWidthDiff,170))
#define kEvidencePanelPosition (IS_IPAD ? ccp(360,485) : ccp(236+k4InchWidthDiff,170))

//puzzle games
#define kPuzzleGameRadomScope (IS_IPAD ? 600 : 250)
#define kPuzzleGameTolerance (IS_IPAD ? 20 : 10)

#define kConnectPuzzleSize (IS_IPAD ? CGSizeMake(600,600) : CGSizeMake(270,270))
#define kConnectPuzzlePosition (IS_IPAD ? ccp(212,130) : ccp(105+k4InchWidthDiff,45))
#define kConnectPuzzlePieceSize (IS_IPAD ? CGSizeMake(200,200) : CGSizeMake(90,90))
#define kConnectPuzzleFirstPiecePosition (IS_IPAD ? ccp(0,400) : ccp(0,180))

#define kJigsawPuzzleSize (IS_IPAD ? CGSizeMake(470,584) : CGSizeMake(212,263))
#define kJigsawPuzzlePosition (IS_IPAD ? ccp(280,140) : ccp(140+k4InchWidthDiff,50))

#define kPixelPuzzleSize (IS_IPAD ? CGSizeMake(600,600) : CGSizeMake(300,300))
#define kPixelPuzzlePosition (IS_IPAD ? ccp(212,130) : ccp(90+k4InchWidthDiff,10))
#define kPixelPieceSize (IS_IPAD ? CGSizeMake(40,40) : CGSizeMake(24,24))
#define kPixelHelpPosition (IS_IPAD ? ccp(0,0) : ccp(90+k4InchWidthDiff,135))

#define kGameRuleLayerSize (IS_IPAD ? CGSizeMake(650,650) : CGSizeMake(300,300))
#define kGameRuleLayerPosition (IS_IPAD ? ccp(187,104) : ccp(90+k4InchWidthDiff,10))
#define kGameRuleButtonPosition (IS_IPAD ? ccp(890,680) : ccp(440+k4InchWidthDiff,292))

//game setting
#define kMusicLabelPosition (IS_IPAD ? ccp(450,475) : ccp(192+k4InchWidthDiff,205))
#define kSoundLabelPosition (IS_IPAD ? ccp(450,345) : ccp(192+k4InchWidthDiff,145))
#define kMusicMenuItemPosition (IS_IPAD ? ccp(600,475) : ccp(248+k4InchWidthDiff,205))
#define kSoundMenuItemPosition (IS_IPAD ? ccp(600,345) : ccp(248+k4InchWidthDiff,145))

//suspect list
#define kSuspectListTitlePosition (IS_IPAD ? ccp(532,630) : ccp(winSize.width/2,260))
#define kSuspectListLeftArrowPosition (IS_IPAD ? ccp(102,302) : ccp(20+k4InchWidthDiff,150))
#define kSuspectListRightArrowPosition (IS_IPAD ? ccp(952,302) : ccp(460+k4InchWidthDiff,150))
#define kSuspectListPhotoPosition (IS_IPAD ? ccp(373,312) : ccp(156+k4InchWidthDiff,132))
#define kSuspectListNamePosition (IS_IPAD ? ccp(373,154) : ccp(156+k4InchWidthDiff,52))
#define kSuspectListMenuPosition (IS_IPAD ? ccp(702,304) : ccp(326+k4InchWidthDiff,134))
#define klockMenuItemPosition (IS_IPAD ? ccp(120,640) : ccp(65,250))

//suspect profile
#define kSuspectSubMenuLabelPosition (IS_IPAD ? ccp(720,724) : ccp(350+k4InchWidthDiff,296))
#define kSuspectNamePosition (IS_IPAD ? ccp(224,324) : ccp(82+k4InchWidthDiff,116))
#define kSuspectPhotoPosition (IS_IPAD ? ccp(224,454) : ccp(82+k4InchWidthDiff,182))
#define kSuspectMenuPosition (IS_IPAD ? ccp(220,190) : ccp(86+k4InchWidthDiff,60))
#define kSuspectProfileTextViewSize (IS_IPAD ? CGRectMake(0,0,520,540) : CGRectMake(0,0,260,220))
#define kSuspectProfileTextViewPosition (IS_IPAD ? ccp(690,410) : ccp(314+k4InchWidthDiff,172))

//suspect evidences
#define kSuspectEvidenceImageSize (IS_IPAD ? 154 : 64)
#define kSuspectEvidenceImagePosition (IS_IPAD ? ccp(840,536-200*i) : ccp(410+k4InchWidthDiff,227-85*i))
#define kSuspectEvidenceLabelSize (IS_IPAD ? CGSizeMake(320,85) : CGSizeMake(190,50))
#define kSuspectEvidenceLabelPosition (IS_IPAD ? ccp(600,548-205*i) : ccp(290+k4InchWidthDiff,224-85*i))

//suspect scenes
#define kSuspectSceneImage1Position (IS_IPAD ? ccp(516,484) : ccp(234+k4InchWidthDiff,202))
#define kSuspectSceneImage2Position (IS_IPAD ? ccp(840,484) : ccp(390+k4InchWidthDiff,202))
#define kSuspectSceneImage3Position (IS_IPAD ? ccp(516,222) : ccp(234+k4InchWidthDiff,81))
#define kSuspectSceneImage4Position (IS_IPAD ? ccp(840,222) : ccp(390+k4InchWidthDiff,81))

//help
//#define kHelpBackMenuItemPosition (IS_IPAD ? ccp(106,680) : ccp(44,299))

//iap
#define kPurchaseLoadingPosition (IS_IPAD ? ccp(360,485) : ccp(174+k4InchWidthDiff,204))

//font
#define kFontSize (IS_IPAD ? 26 : 13)
#define kFontSizeHeading (IS_IPAD ? 36 : 18)
#define kFontSizeButton (IS_IPAD ? 28 : 14)
#define kFontSizeRoundButton (IS_IPAD ? 22 : 11)
#define kFontSizeMainMenuButton (IS_IPAD ? 32 : 20)

#define SIZE_OBJECT_LABEL (IS_IPAD ? CGSizeMake(160,80) : CGSizeMake(80,30))
#define SIZE_OBJECTS_PANEL (IS_IPAD ? CGSizeMake(1024,97) : CGSizeMake(460,34))
#define SIZE_PANEL_MARGIN (IS_IPAD ? 110 : 44)

#define SIZE_GAME_SCENE CGSizeMake(800,600)
#define SIZE_SCREEN CGSizeMake(480+2*k4InchWidthDiff,275)
#define SIZE_SCROLLVIEW CGSizeMake(800,600)

#define POINT_LARGE_BUTTON_LABEL_CENTER (IS_IPAD ? CGPointMake(182,43) : CGPointMake(106,24))
#define POINT_MEDIUM_BUTTON_LABEL_CENTER (IS_IPAD ? CGPointMake(110,32) : CGPointMake(56,16))
#define POINT_SMALL_BUTTON_LABEL_CENTER (IS_IPAD ? CGPointMake(70,28) : CGPointMake(38,14))
#define POINT_ROUND_BUTTON_LABEL_CENTER (IS_IPAD ? CGPointMake(84,34) : CGPointMake(42,17))


#define MIN_SCALE 1.0f
#define MAX_SCALE 1.5f

//---------------------------------------------

@interface GameCommonLayer : CCLayer {
    CGSize winSize;
    BOOL isCanInteraction;
}

-(void)loadTouch;
-(void)unloadTouch;
-(void)playMusic:(NSString*)audioFileName;
-(void)playSound:(NSString*)audioFileName;

@end
