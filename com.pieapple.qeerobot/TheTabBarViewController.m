//
//  UITabBarViewController.m
//  Qee Bear
//
//  Created by Milo Chen on 6/18/14.
//
//

#import "TheTabBarViewController.h"
#import "FirstViewController.h"
#import "RootViewController.h"

#import "DialViewController.h"

#import "MediaViewController.h"



#pragma mark - UIImage resize
@interface UIImage (Resize)
- (UIImage*)scaleToSize:(CGSize)size;
@end
@implementation UIImage (Resize)

- (UIImage*)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end



@interface TheTabBarViewController()
    
@property (nonatomic,strong) UINavigationController* mQeeNavigationController;
@property (nonatomic,strong) FirstViewController * mFirstViewController;
@property (nonatomic,strong) UINavigationController * mFirstNavigationController;
@property (nonatomic,strong) UITabBarController * mTabBarController;

@property (nonatomic,strong) UINavigationController * mDialNavigationController;
@property (nonatomic,strong) UIViewController * mDialViewController;

@property (nonatomic,strong) UINavigationController * mMediaNavigationController;
@property (nonatomic,strong) UIViewController * mMediaViewController;



@end

@implementation TheTabBarViewController
@synthesize mFirstViewController;
@synthesize mFirstNavigationController;
@synthesize mQeeNavigationController;
@synthesize mDialNavigationController;
@synthesize mDialViewController;
@synthesize mTabBarController;

@synthesize mMediaNavigationController;
@synthesize mMediaViewController;



-(UIImage*) getTabBarImageByNamed:(NSString*)imageName {
    UIImage * image = [UIImage imageNamed:imageName];
    UIImage* scaledImage = [image scaleToSize:CGSizeMake(80.0f, 50.0f)];
    return scaledImage;
}


-(void) loadView {
    [super loadView];
    FirstViewController * firstVC = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    mFirstNavigationController = [[UINavigationController alloc] initWithRootViewController:firstVC];
    mFirstNavigationController.title = @"First";
    mFirstNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"1stTab" image:[UIImage imageNamed:@"patrickstar"] tag:1];

    RootViewController * qeeVC = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    [qeeVC setTitle:@"Qee Robot"];
    mQeeNavigationController = [[UINavigationController alloc] initWithRootViewController:qeeVC];
        mQeeNavigationController.title = @"Qee Robot";

  
  
//    [mQeeNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"QeeRobotSmallIcon"]  withFinishedUnselectedImage:[UIImage imageNamed:@"QeeRobotSmallIcon"]];
    
    UIImage *qeeRobotSelectedImg = [UIImage imageNamed:@"QeeRobotSmallIcon"];
    UIImage *qeeRobotUnselectedImg = [qeeRobotSelectedImg scaleToSize:qeeRobotSelectedImg.size];
    mQeeNavigationController.navigationBar.hidden = YES;
    [mQeeNavigationController.tabBarItem setFinishedSelectedImage:qeeRobotSelectedImg withFinishedUnselectedImage:qeeRobotUnselectedImg];
    [mQeeNavigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [mQeeNavigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [mQeeNavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0f, -5.0f)];

    

    UIImage * dialSelectedImg = [UIImage imageNamed:@"DialSmallIcon"];
    UIImage * dialUnselectedImg = [dialSelectedImg scaleToSize:dialSelectedImg.size];
    DialViewController * dialVC = [[DialViewController alloc] initWithNibName:@"DialViewController" bundle:nil];
    dialVC.title = @"Dial";
    mDialNavigationController = [[UINavigationController alloc] initWithRootViewController:dialVC];
    mDialNavigationController.title = @"Dial";
    mDialNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Dial" image:nil tag:1];
//    [mDialNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"DialSmallIcon"] withFinishedUnselectedImage:[UIImage imageNamed:@"DialSmallIcon"]];
    [mDialNavigationController.tabBarItem setFinishedSelectedImage:dialSelectedImg withFinishedUnselectedImage:dialUnselectedImg];
    [mDialNavigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [mDialNavigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [mDialNavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0f, -5.0f)];
    mDialNavigationController.navigationBar.hidden = YES;
    
    
    
    UIImage * mediaSelectedImg = [UIImage imageNamed:@"MusicSmallIcon"];
    UIImage * mediaUnselectedImg = [mediaSelectedImg scaleToSize:mediaSelectedImg.size];
    
    MediaViewController * mediaVC = [[MediaViewController alloc] initWithNibName:@"MediaViewController" bundle:nil];

    mMediaNavigationController = [[UINavigationController alloc] initWithRootViewController:mediaVC];
    mMediaNavigationController.title = @"Music";
    mediaVC.title = @"Music";
    //mMediaNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Music" image:[UIImage imageNamed:@"MusicSmallIcon"] tag:1];
//    [mMediaNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"MusicSmallIcon"]  withFinishedUnselectedImage:[UIImage imageNamed:@"MusicSmallIcon"]];
    [mMediaNavigationController.tabBarItem setFinishedSelectedImage:mediaSelectedImg withFinishedUnselectedImage:mediaUnselectedImg];
    [mMediaNavigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [mMediaNavigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [mMediaNavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0f, -5.0f)];
    mMediaNavigationController.navigationBar.hidden = YES;

    //preload iPod Library
    dispatch_async(dispatch_get_main_queue(),^{
        [mediaVC buildSourceLibrary];
    });
    
    
    mTabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    mTabBarController.viewControllers = [[NSArray alloc] initWithObjects:mQeeNavigationController,  mDialNavigationController, mMediaNavigationController,nil] ;
    mTabBarController.delegate = self;

    
    UIImage * tabBarUnselectedImage = [[UIImage imageNamed:@"TabBarUnselected"] scaleToSize:CGSizeMake(80.0f, 49.0f)];
    [[mTabBarController tabBar] setBackgroundImage:tabBarUnselectedImage];
    
//    UIImage * tabBarSelectedImage = [[UIImage imageNamed:@"TabBarSelected"] scaleToSize:CGSizeMake(80.0f, 49.0f)];
//    [[mTabBarController tabBar] setSelectionIndicatorImage:tabBarSelectedImage];
    UIImage * tabBarSelectedImage = [[UIImage imageNamed:@"TabBarSelected"] scaleToSize:CGSizeMake(107.0f, 49.0f)];
    [[mTabBarController tabBar] setSelectionIndicatorImage:tabBarSelectedImage];
    

    
    

    [self.view addSubview:[mTabBarController view]];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"didSelectViewController");
    UIImage * tabBarSelectedImage = [[UIImage imageNamed:@"TabBarSelected"] scaleToSize:CGSizeMake(107.0f, 49.0f)];
    [[mTabBarController tabBar] setSelectionIndicatorImage:tabBarSelectedImage];
  
    if(viewController == mQeeNavigationController) {
        NSLog(@"mQeeNavigationController TAB is click");
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        
    } else if (viewController == mDialNavigationController) {
        NSLog(@"mDialNavigationController TAB is click");
//        dispatch_async(dispatch_get_main_queue(),^{
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        });
        
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];

        
        
    } else if (viewController == mMediaNavigationController) {
        NSLog(@"mMediaNavigationController TAB is click");
    }
/*
    @property (nonatomic,strong) UINavigationController* mQeeNavigationController;
    @property (nonatomic,strong) FirstViewController * mFirstViewController;
    @property (nonatomic,strong) UINavigationController * mFirstNavigationController;
    @property (nonatomic,strong) UITabBarController * mTabBarController;
    
    @property (nonatomic,strong) UINavigationController * mDialNavigationController;
    @property (nonatomic,strong) UIViewController * mDialViewController;
    
    @property (nonatomic,strong) UINavigationController * mMediaNavigationController;
    @property (nonatomic,strong) UIViewController * mMediaViewController;
*/
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSLog(@"shouldSelectViewController");
    if(viewController == mQeeNavigationController && [tabBarController selectedViewController] == mQeeNavigationController) {return NO;}
    return YES;
}


@end
