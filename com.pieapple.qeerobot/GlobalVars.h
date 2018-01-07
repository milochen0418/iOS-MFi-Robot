//
//  GlobalVar.h
//  Qee Bear
//
//  Created by Milo Chen on 6/18/14.
//
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>


@interface GlobalVars : NSObject {

    MPMusicPlayerController *mMusicPlayer;
    MPMediaQuery *mMusicChoicedQuery;
    MPMediaItemCollection *mMusicChoicedCollection;
    MPMediaItem *mMusicChoicedItem;
    BOOL mIsMusicUseQuery; //yes to use ChoicedQuery ,and ChoicedCollection otherwise,
    MPMoviePlayerController *mMoviePlayer;
    MPMediaItem* mMovieChoicedItem;
}

@property (nonatomic,strong) MPMusicPlayerController *mMusicPlayer;
@property (nonatomic,strong) MPMediaQuery *mMusicChoicedQuery;
@property (nonatomic,strong) MPMediaItemCollection *mMusicChoicedCollection;
@property (nonatomic,strong) MPMediaItem *mMusicChoicedItem;
@property (nonatomic,strong) MPMoviePlayerController *mMoviePlayer;
@property (nonatomic,strong) MPMediaItem* mMovieChoicedItem;


+ (GlobalVars*) sharedInstance;


@end
