

#import "EADemoAppDelegate.h"
#import "RootViewController.h"
#import "FirstViewController.h"
#import "TheTabBarViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface EADemoAppDelegate()

//@property (nonatomic,strong) UITabBarController * mTabBarController;

@property (nonatomic,strong) TheTabBarViewController * mTheTabBarViewController;

@property (nonatomic,strong) UIViewController * mTempViewController;

@property (nonatomic,strong) MPMusicPlayerController * mMusicPlayer;


@end

@implementation EADemoAppDelegate

@synthesize window;
@synthesize navigationController;
//@synthesize mTabBarController;

@synthesize mTempViewController;
@synthesize mTheTabBarViewController;
@synthesize mMusicPlayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self applicationDidFinishLaunching:application];
    return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    

    //change by milochen
	//	[window addSubview:[navigationController view]];
    /*
    
    FirstViewController * firstVC = [[FirstViewController alloc] init];
    firstVC.title = @"First";
    firstVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"1stTab" image:[UIImage imageNamed:@"AlphaQeeBear"] tag:1];
    
    navigationController.title = @"Qee";
    navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Qee Tab" image:[UIImage imageNamed:@"AlphaQeeBear"] tag:2];
    mTabBarController = [[UITabBarController alloc] init];
    mTabBarController.viewControllers = [NSArray arrayWithObjects:navigationController, firstVC, nil];
    
    [window addSubview:mTabBarController.view];
    [window makeKeyAndVisible];
     
     */
    
    
    /*
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarAnimationNone];
*/

    
    mTheTabBarViewController = [[TheTabBarViewController alloc]init];
    
    [window addSubview:mTheTabBarViewController.view];
    [window makeKeyAndVisible];
    
    
    /*
    mTempViewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    [window addSubview:mTempViewController.view];
    [window makeKeyAndVisible];
    */
    
    GlobalVars * vars = [GlobalVars sharedInstance];
    vars.mMusicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    MPMusicPlayerController * player = vars.mMusicPlayer;
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(musicPlayerDidChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object: player];
    [player beginGeneratingPlaybackNotifications];
    [self performSelector:@selector(musicPlayerDidChange:) withObject:nil];

    
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}




#pragma mark - MPMusicPlayerControllerDelegate

- (void)musicPlayerDidChange:(NSNotification *)notification {

    GlobalVars * vars = [GlobalVars sharedInstance];
    MPMusicPlayerController * player = vars.mMusicPlayer;
    if([notification.name isEqualToString:@"MPMusicPlayerControllerPlaybackStateDidChangeNotification"]) {
        switch([player playbackState] ) {
            case MPMusicPlaybackStatePlaying:
//                vars.mExterMusicPlayStatusImgView.image = [UIImage imageNamed:@"playBtnIcon"];
                break;
            case MPMusicPlaybackStatePaused:
//                vars.mExterMusicPlayStatusImgView.image = [UIImage imageNamed:@"pauseBtnIcon"];
                break;
            case MPMusicPlaybackStateSeekingBackward:
//                vars.mExterMusicPlayStatusImgView.image = [UIImage imageNamed:@"rewindBtnIcon"];
                
                break;
            case MPMusicPlaybackStateSeekingForward:
//                vars.mExterMusicPlayStatusImgView.image = [UIImage imageNamed:@"fastforwardBtnIcon"];
                break;
            default:
 //               vars.mExterMusicPlayStatusImgView.image = [UIImage imageNamed:@"stopBtnIcon"];
                break;
        }
    }
 
}





@end

