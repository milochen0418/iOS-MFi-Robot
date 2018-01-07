//
//  MediaViewController.m
//  Qee Bear
//
//  Created by Milo Chen on 6/18/14.
//
//

#import "MediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"

@interface TheMediaItem:NSObject {

}

@property (nonatomic,strong) NSString * mTitle;
@property (nonatomic,strong) NSURL * mUrl;
@property (nonatomic,strong) MPMediaItem * mItem;

@end

@implementation TheMediaItem
@synthesize mTitle;
@synthesize mUrl;
@synthesize mItem;

-(id) init {
    self.mTitle = @"";
    self.mUrl = nil;
    self.mItem = nil;
    return self;
}
@end




@interface MediaViewController ()<MBProgressHUDDelegate, UIAlertViewDelegate>
@property (strong,nonatomic) NSMutableArray * mMediaItems;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) IBOutlet UIButton *mOpenITunesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *mBackgroundImgView;

@property (nonatomic,strong) NSString * cellIdentifier;
@property (nonatomic) BOOL receivingIPodLibraryNotifications;
@property (nonatomic) BOOL haveBuiltSourceLibrary;


@property (nonatomic,strong) MBProgressHUD *mHud;




@end

@implementation MediaViewController
@synthesize mMediaItems;
@synthesize mTableView;
@synthesize mOpenITunesBtn;
@synthesize cellIdentifier;
@synthesize receivingIPodLibraryNotifications;
@synthesize haveBuiltSourceLibrary;
@synthesize mBackgroundImgView;
@synthesize mHud;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height <= 480)
        {
            // iPhone Classic
            CGRect mainFrame = CGRectMake(0, 0, 320, 480);
            self.view.frame = mainFrame;
            //mTableView.frame.size =CGSizeMake(mTableView.frame.size.width,mTableView.frame.size.height - 88 );
            
            CGRect tableViewFrame = mTableView.frame;
            tableViewFrame.size.height = tableViewFrame.size.height - 88;
            mTableView.frame = tableViewFrame;
            
            
            CGRect openITunesFrame = mOpenITunesBtn.frame;
            openITunesFrame.origin.y = openITunesFrame.origin.y - 88;
            mOpenITunesBtn.frame = openITunesFrame;
            
            CGRect backgroundImgFrame = mBackgroundImgView.frame;
            backgroundImgFrame.size.height = backgroundImgFrame.size.height - 88;
            mBackgroundImgView.frame = backgroundImgFrame;
            
            
            
            
            
            
            
            
        }
        if(result.height > 480)
        {
            // iPhone 5
            CGRect mainFrame = CGRectMake(0, 0, 320, 568);
            self.view.frame = mainFrame;
        }
    }

    
    
    
//    mMediaItems = [NSArray arrayWithObjects:@"Cell 1", @"Cell B", @"Cell C",nil];
    //mMediaItems = [NSMutableArray arrayWithCapacity:0];
    
    
    cellIdentifier = @"mediaCell";
    [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];

    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView setSeparatorColor:[UIColor colorWithRed:0.0f green:0.8f blue:0.5f alpha:0.5f]];

//    [self.mTableView setSeparatorColor:[UIColor blackColor]];
//    self.mTableView.backgroundView = nil;
//    self.mTableView.opaque = NO;
    
    
    self.mTableView.backgroundColor = [UIColor clearColor];
    //self.mTableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.mTableView.backgroundView = nil;

    dispatch_async(dispatch_get_main_queue(),^{
        [self buildSourceLibrary];
        [self.mTableView reloadData];
    });

    

    //add by milochen for debug MPMusicPlayerController delay issue after play
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handle_itemChanged:)
                                                 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handle_stateChanged:)
                                                //selector:@selector(handlePlaybackStateChanged:)
                                                 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                               object:nil];
    

    
    //[nc removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:player];
}



-(IBAction)handle_itemChanged:(id)sender {
    NSLog(@"_item  Changed");
}




static bool sRequestToCloseLoadingMessage = NO;


-(IBAction)handle_stateChanged:(id)sender {
    NSLog(@"_state  changed");
    GlobalVars *vars  = [GlobalVars sharedInstance];
    static bool isDetectSecondTime = NO;
    

    switch (vars.mMusicPlayer.playbackState) {
        case MPMusicPlaybackStateInterrupted :
            NSLog(@"MPMusicPlaybackStateInterrupted");
            break;
        case MPMusicPlaybackStatePlaying :
            NSLog(@"MPMusicPlaybackStatePlaying");
            break;
        case MPMusicPlaybackStateSeekingBackward :
            NSLog(@"MPMusicPlaybackStateSeekingBackward");
            break;
        case MPMusicPlaybackStateSeekingForward:
            NSLog(@"MPMusicPlaybackStateSeekingForward");
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"MPMusicPlaybackStatePaused");
            break;
        case MPMusicPlaybackStateStopped:
            NSLog(@"MPMusicPlaybackStateStopped");
            break;
        default:
            NSLog(@"MPMusicPlaybackState Unknown");
            break;
    }
    /*
    if(vars.mMusicPlayer.playbackState == MPMusicPlaybackStateInterrupted) {
        
    }
     */

    if(vars != nil && vars.mMusicPlayer != nil && vars.mMusicPlayer.playbackState == MPMusicPlaybackStatePlaying)  {
            NSLog(@"Sound play now");
        if(sRequestToCloseLoadingMessage == YES) {
            /*
            if(isDetectSecondTime == YES)  {
                NSLog(@"Second time to remove");
                sRequestToCloseLoadingMessage = NO;
                isDetectSecondTime = NO;
                [mHud show:NO];
                [mHud removeFromSuperview];
                
            }
            else {
                isDetectSecondTime = YES;
                NSLog(@"First Time to remove");
            }
            */
            
            sRequestToCloseLoadingMessage = NO;
            isDetectSecondTime = NO;
            [mHud show:NO];
            [mHud removeFromSuperview];
            NSLog(@"ABCDE");
            
        }
        else {

        }

    }

    
}
/*
- (void)handlePlaybackStateChanged:(NSNotitication*)notification
{
    NSLog(@"handlePlaybackStateChanged") ;
    
    if (self.musicPlayerController.playbackState == MPMusicPlaybackStateStopped ||
        self.musicPlayerController.playbackState == MPMusicPlaybackStateInterrupted ||
        self.musicPlayerController.playbackState == MPMusicPlaybackStatePaused) {
        // do your stuff
    }
    
}
 
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
	if (receivingIPodLibraryNotifications) {
		MPMediaLibrary *iPodLibrary = [MPMediaLibrary defaultMediaLibrary];
		[iPodLibrary endGeneratingLibraryChangeNotifications];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMediaLibraryDidChangeNotification object:nil];
	}


    
    
}
- (void)viewDidUnload {

    [super viewDidUnload];
}


- (IBAction)clickToOpenITunesMusic:(id)sender {
    NSString *stringURL = @"music:";
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}



#pragma mark - UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"number = %d", [mMediaItems count]);
    return [mMediaItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * sCellIdentifier = @"mediaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];

    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
//        cell.backgroundColor = [UIColor clearColor];
        
    }
    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    //backView.backgroundColor = [UIColor clearColor];
    //cell.backgroundView = backView;
//    cell.backgroundColor = [UIColor blackColor];
    
    
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    NSString * str = @"ABC";
    int rowIdx = indexPath.row;
    NSLog(@"rowIdx = %d", rowIdx);
    TheMediaItem * item = (TheMediaItem*)[mMediaItems objectAtIndex:indexPath.row];
    
    //NSLog(@"item title = %@", item.mTitle);
//    str = item.mTitle;
    str = [NSString stringWithFormat:@"%d. %@", rowIdx, item.mTitle];

//    cell.textLabel.text = [self.mMediaItems objectAtIndex:indexPath.row];
//    cell.textLabel.text = str;
    if(cell !=nil ){
      cell.textLabel.text = str;
    }
    else {
   
    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    


    int idx;
    int count = [mMediaItems count];
    /*
    for (idx = 0; idx < [mMediaItems count]; idx++) {
        TheMediaItem * theMediaItem = [mMediaItems objectAtIndex:idx];
        NSLog(@"title = %@, url = %@", theMediaItem.mTitle, theMediaItem.mUrl);
    }
     */
    NSLog(@"didSelect idx = %d", (int)indexPath.row);
    
    static int sPlayListItemIdx = -1 ;
    int currentPlayListItemIdx = indexPath.row;
    if(sPlayListItemIdx == currentPlayListItemIdx) {
        sReadyPlayIdx = sPlayListItemIdx;
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"歌曲重頭播放"
                                                         message:@"是否將目前的歌曲重頭播放?"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles: nil];
        [alert addButtonWithTitle:@"重頭撥放"];
        [alert show];
    }
    else {
        sPlayListItemIdx = currentPlayListItemIdx;
        //[self playSongWithIdx:(int)indexPath.row];
        [self playSongWithIdx:currentPlayListItemIdx];
    }
}

-(void) playSongWithIdx:(int) idx  {
    //TheMediaItem * theItem = (TheMediaItem*)[mMediaItems objectAtIndex:indexPath.row];
    TheMediaItem * theItem = (TheMediaItem*)[mMediaItems objectAtIndex:idx];
    MPMediaItem * item = theItem.mItem;
    
    GlobalVars * vars = [GlobalVars sharedInstance];
    vars.mMusicChoicedItem = item;

    //[self showHUDProgress];
    

    
#if NS_BLOCKS_AVAILABLE
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText = @"Loading ...";

    /*
    [vars.mMusicPlayer setQueueWithQuery:vars.mMusicChoicedQuery];
    [vars.mMusicPlayer setNowPlayingItem:vars.mMusicChoicedItem];
    [vars.mMusicPlayer play];
     */
    /*
    [hud showAnimated:YES whileExecutingBlock:^{
        
    }completionBlock:^{
        
    }];
     */
    
#if 1
    [hud showAnimated:YES whileExecutingBlock:^{
        NSLog(@"whileExecutingBlock");
        //[vars.mMusicPlayer pause];
        [vars.mMusicPlayer setQueueWithQuery:vars.mMusicChoicedQuery];
        [vars.mMusicPlayer setNowPlayingItem:vars.mMusicChoicedItem];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self refreshBluetoothStatusSync];
            NSLog(@"dispatch_after to play");
                    [vars.mMusicPlayer play];
        });
        
        
        //[vars.mMusicPlayer play];
        
    } completionBlock:^{
        
        mHud = hud;
        sRequestToCloseLoadingMessage = YES;
        mHud.labelText = @"Prepare to play";
        [mHud show:YES];
        //[hud removeFromSuperview];
        //[hud release];
    }];
#endif 
    
#endif
    //NSLog(@"Play with idx = %d",(int)indexPath.row);
    NSLog(@"Play with idx = %d",idx);
}

static int sReadyPlayIdx = -1;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",buttonIndex);
    if (buttonIndex == 0)
    {
        NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
        //NSLog(@"You have clicked GOO");
        //sReadyPlayIdx
        [self playSongWithIdx:sReadyPlayIdx];
    }
}




#pragma mark iPod Library

- (void)updateIPodLibrary
{
//	dispatch_async(enumerationQueue, ^(void) {

//    dispatch_async(dispatch_get_main_queue(),  ^(void) {
		// Grab videos from the iPod Library
    //change by milochen
		//MPMediaQuery *videoQuery = [[MPMediaQuery alloc] init];
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        GlobalVars *vars = [GlobalVars sharedInstance];
        vars.mMusicChoicedQuery = songsQuery;
		
//		NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
//		NSArray *mediaItems = [videoQuery items];
        NSArray *mediaItems = [songsQuery items];
		for (MPMediaItem *mediaItem in mediaItems) {
			NSURL *URL = (NSURL*)[mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
			
			if (URL) {
                //[mMediaItems addObject:mediaItem];
				NSString *title = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
                //NSLog(@"music title = %@", title);
                TheMediaItem * theItem = [[TheMediaItem alloc] init];
                theItem.mTitle = title;
                theItem.mUrl = URL;
                theItem.mItem = mediaItem;
                [mMediaItems addObject:theItem];
			}
		}
//		[videoQuery release];
/*
		dispatch_async(dispatch_get_main_queue(), ^(void) {
		//	[self updateBrowserItemsAndSignalDelegate:items];
            
            NSLog(@"mMediaItems count = %d", [mMediaItems count]);
            [mTableView reloadData];
		});
	});
 */
}

- (void)iPodLibraryDidChange:(NSNotification*)changeNotification
{
	//[self updateIPodLibrary];
}

- (void)buildIPodLibrary
{
    mMediaItems = [NSMutableArray arrayWithCapacity:0];
	MPMediaLibrary *iPodLibrary = [MPMediaLibrary defaultMediaLibrary];
    
    
	//receivingIPodLibraryNotifications = YES;
	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iPodLibraryDidChange:) name:MPMediaLibraryDidChangeNotification object:nil];
//	[iPodLibrary beginGeneratingLibraryChangeNotifications];
	
	[self updateIPodLibrary];
}

- (void)buildSourceLibrary
{
	if (haveBuiltSourceLibrary)
		return;
	/*
	switch (sourceType) {
            
		case AssetBrowserSourceTypeFileSharing:
			[self buildFileSharingLibrary];
			break;
		case AssetBrowserSourceTypeCameraRoll:
			[self buildAssetsLibrary];
			break;
		case AssetBrowserSourceTypeIPodLibrary:
			[self buildIPodLibrary];
			break;
		default:
			break;
	}*/
            
    [self buildIPodLibrary];
	haveBuiltSourceLibrary = YES;
}


#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [mHud removeFromSuperview];
    //[HUD release];
    //HUD = nil;
    mHud = nil;
}


@end
