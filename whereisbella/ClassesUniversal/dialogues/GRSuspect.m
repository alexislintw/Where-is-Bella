//
//  GRSuspect.m
//  bella
//
//  Created by Alexis Lin on 13/5/23.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GRSuspect.h"


@implementation GRSuspect


@synthesize suspectName;
@synthesize spriteForSuspectList;
@synthesize spriteForDialogue;
@synthesize intro;
@synthesize motiveForTheCrime;

-(id)initWithSuspectId:(int)anId
{
	if( (self=[super init]) ) {

        NSString *path = [[NSBundle mainBundle] pathForResource:@"suspects" ofType:@"plist"];
        NSDictionary *dicSuspects = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSString *aKey = [[NSString alloc] initWithFormat:@"k-%d",anId];
        NSDictionary *aSuspect = [[NSDictionary alloc] initWithDictionary:[dicSuspects objectForKey:aKey]];
        [aKey release];
        [dicSuspects release];
        
        if (aSuspect != nil) {
            suspectName = [CCLabelTTF labelWithString:[aSuspect objectForKey:@"kSuspectName"] fontName:@"Times New Roman" fontSize:30];
            spriteForSuspectList = [CCSprite spriteWithFile:[aSuspect objectForKey:@"kImageForSuspectList"]];
            spriteForDialogue = [CCSprite spriteWithFile:[aSuspect objectForKey:@"kImageForDialogue"]];
            intro = [[aSuspect objectForKey:@"kIntro"] copy];
            motiveForTheCrime = [[aSuspect objectForKey:@"kMotiveForTheCrime"] copy];
            [aSuspect release];
        }
    }
    return self;
}

-(void)dealloc
{
    [suspectName release];
    [spriteForSuspectList release];
    [spriteForDialogue release];
    [intro release];
    [motiveForTheCrime release];
    
    [super dealloc];
}

@end
