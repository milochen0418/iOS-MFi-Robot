//
//  GlobalVar.m
//  Qee Bear
//
//  Created by Milo Chen on 6/18/14.
//
//

#import "GlobalVars.h"



@implementation GlobalVars

@synthesize mMusicPlayer,mMovieChoicedItem,mMoviePlayer,mMusicChoicedCollection,mMusicChoicedItem,mMusicChoicedQuery;


static GlobalVars* staticGlobalVars = nil;
+ (GlobalVars*) sharedInstance {
    if(staticGlobalVars == nil) {
        staticGlobalVars = [[GlobalVars alloc]init];
        /*
#ifdef REDIRECT_LOG_FILE
        [staticGlobalVars redirectNSLogToDocumentFolder];
#endif
        */
    }
    return staticGlobalVars;
}

@end
