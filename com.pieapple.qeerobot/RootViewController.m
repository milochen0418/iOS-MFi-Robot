
#import "RootViewController.h"
#import "EADSessionTransferViewController.h"
#import "EADSessionController.h"
#import <ExternalAccessory/ExternalAccessory.h>


@interface RootViewController() <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *mBluetoothBtn;

@property (nonatomic,strong) IBOutlet UITableView *mTableView;
@property (nonatomic,strong) NSString * cellIdentifier;
-(UITableView*) tableView;
@end

@implementation RootViewController
@synthesize mTableView, cellIdentifier;
@synthesize mBluetoothBtn;
- (IBAction)clickToShowBar:(id)sender {
    [self showTabBar];
}
- (IBAction)clickToHideBar:(id)sender {
    [self hideTabBar];
}

-(UITableView*) tableView {
    return mTableView;
}
- (IBAction)clickToLaunch:(id)sender {
    if([self isExistQeeRobotAccessory]) {
        NSLog(@"Qee Robot Accessory is exist");
        NSLog(@"start to launch accessory");
        [self launchAccessory];
    }
    else {
        NSLog(@"Qee Robot is not exist");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"偵測方式" message:@"請確認 Qee Robot 已開機，開機後請確認 Qee Robot 已藍芽配對，或重新藍芽配對。\n\n藍芽配對方式如下：\n請至設定頁面上，才可對 Qee Robot 進行配對，配對完畢後，請確認狀態為連線，此時便可偵測到 Qee Robot" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(void) refreshBluetoothStatusSync {
    NSLog(@"refreshBluetoothStatus is invoked in dispatch_get_main_queue()");
    
    mBluetoothBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    
    
    if([self isExistQeeRobotAccessory]) {
        NSLog(@"isExistQeeRobotAccessory return true");
        //mBlueoothBtn.titleLabel.text = @"已配對的QeeRobot";
        //mBluetoothBtn.titleLabel.text = @"請進入 Qee Robot";
        [mBluetoothBtn setTitle:@"請進入 Qee Robot" forState:UIControlStateNormal];
    }
    else {
        NSLog(@"isExistQeeRobotAccessory return false");
        //mBlueoothBtn.titleLabel.text = @"QeeRobot未配對";
        //mBluetoothBtn.titleLabel.text = @"偵測不到 Qee Robot";
        [mBluetoothBtn setTitle:@"偵測不到 Qee Robot" forState:UIControlStateNormal];
    }
    
    
    
}

-(void) refreshTapBarGuiByBluetoothStatus {
    if(![self isExistQeeRobotAccessory]) {
        [self.tabBarController setSelectedIndex:0];
        [self hideTabBar];
    }
    
}
-(void) refreshBluetoothStatus {

    NSLog(@"refreshBluetoothStatus is invoked");
    [self refreshTapBarGuiByBluetoothStatus];
    
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self refreshBluetoothStatusSync];
    });
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshBluetoothStatusSync];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshBluetoothStatusSync];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshBluetoothStatusSync];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshBluetoothStatusSync];
    });
    */
    
    
}

/*
- (void)loadView
{
    NSLog(@"loadView is invoked");
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            NSLog(@"iPhone 4 resolution");
            // iPhone Classic
        }
        if(result.height > 480)
        {
            NSLog(@"iPhone 5 resolution");
            // iPhone 5
            //CGRect mainFrame = CGRectMake(0, 0, 320, 568);
            //self.view.frame = mainFrame;
        }
    }
    
}
*/
- (void)viewDidLoad {
    
    NSLog(@"viewDidLoad");
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
        }
        if(result.height > 480)
        {
            // iPhone 5
            CGRect mainFrame = CGRectMake(0, 0, 320, 568);
            self.view.frame = mainFrame;
        }
    }
    
    cellIdentifier = @"acessoryCell";
    [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.mTableView reloadData];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView setSeparatorColor:[UIColor colorWithRed:0.0f green:0.8f blue:0.5f alpha:0.5f]];
    
    
    // Create the view that gets shown when no accessories are connected
    _noExternalAccessoriesPosterView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_noExternalAccessoriesPosterView setBackgroundColor:[UIColor whiteColor]];
    
    
    _noExternalAccessoriesLabelView = [[UILabel alloc] initWithFrame:CGRectMake(60, 170, 240, 50)];
//    [_noExternalAccessoriesLabelView setText:@"No Accessories Connected"];
//    [_noExternalAccessoriesLabelView setText:@"由設定畫面配對 Qee Bear"];
    
    
//    [_noExternalAccessoriesPosterView addSubview:_noExternalAccessoriesLabelView];
    
    // The view can cover original view
//    [[self view] addSubview:_noExternalAccessoriesPosterView];
    
    
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];

    _eaSessionController = [EADSessionController sharedController];
    _accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];

    //[self setTitle:@"Accessories"];
//    [self setTitle:@"Qee Bears"];
//    [self setTitle:@"已配對的 Qee Bears"];

    if ([_accessoryList count] == 0) {
        [_noExternalAccessoriesPosterView setHidden:NO];
    } else {
        [_noExternalAccessoriesPosterView setHidden:YES];
    }

    
    
    //change by milochen

    
    /*
    dispatch_async(dispatch_get_main_queue(),^{
        mBlueoothBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        if([self isExistQeeRobotAccessory]) {
            mBlueoothBtn.titleLabel.text = @"已配對的QeeRobot";
        }
        else {
            mBlueoothBtn.titleLabel.text = @"QeeRobot未配對";
        }
    });
     */

    [super viewDidLoad];
    [self refreshBluetoothStatus];
    
    
       
}










- (void)hideTabBar {
    UITabBar *tabBar = self.tabBarController.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
    UIView *window = parent.superview;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect tabFrame = tabBar.frame;
        tabFrame.origin.y = CGRectGetMaxY(window.bounds);
        tabBar.frame = tabFrame;
        content.frame = window.bounds;
    }];
    // 1
}

- (void)showTabBar {
    UITabBar *tabBar = self.tabBarController.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
    UIView *window = parent.superview;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect tabFrame = tabBar.frame;
        tabFrame.origin.y = CGRectGetMaxY(window.bounds) - CGRectGetHeight(tabBar.frame);
        tabBar.frame = tabFrame;
        
        CGRect contentFrame = content.frame;
        contentFrame.size.height -= tabFrame.size.height;
        
    }];
    
    // 2
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidDisconnectNotification object:nil];
    _accessoryList = nil;

    _selectedAccessory = nil;

    _protocolSelectionActionSheet = nil;


    [super viewDidUnload];
}

#pragma mark clickFunction

-(BOOL) isExistQeeRobotAccessory {
    int idx;
    EAAccessory * testSelectedAccessory;
    for( idx = [_accessoryList count]-1; idx >= 0; idx--) {
        testSelectedAccessory = [_accessoryList objectAtIndex:idx];
        if (![testSelectedAccessory.name isEqualToString:@"Qee Robot"]) {
            continue;
        }
        //last added Qee Robot accessory
        NSArray *protocolStrings = [testSelectedAccessory protocolStrings];
        for(NSString *protocolString in protocolStrings) {
            NSLog(@"protocolString = %@", protocolString);
            
            if([protocolString isEqualToString:@"com.choiceonly.btprotocol1"]) {
                
                return YES;
//                [_eaSessionController setupControllerForAccessory:_selectedAccessory withProtocolString:protocolString];
//                EADSessionTransferViewController *sessionTransferViewController =
//                [[EADSessionTransferViewController alloc] initWithNibName:@"EADSessionTransfer" bundle:nil];
//                [self showTabBar];
//                [[self navigationController] pushViewController:sessionTransferViewController animated:YES];
//                _selectedAccessory = nil;
//                _protocolSelectionActionSheet = nil;
            }
        }
    }
    
    return NO;
}
-(void) launchAccessory  {
    int idx;
    for( idx = [_accessoryList count]-1; idx >= 0; idx--) {
        _selectedAccessory = [_accessoryList objectAtIndex:idx];
        if (![_selectedAccessory.name isEqualToString:@"Qee Robot"]) {
            continue;
        }
        //last added Qee Robot accessory
        NSArray *protocolStrings = [_selectedAccessory protocolStrings];
        for(NSString *protocolString in protocolStrings) {
            if([protocolString isEqualToString:@"com.choiceonly.btprotocol1"]) {
                [_eaSessionController setupControllerForAccessory:_selectedAccessory withProtocolString:protocolString];
                EADSessionTransferViewController *sessionTransferViewController =
                [[EADSessionTransferViewController alloc] initWithNibName:@"EADSessionTransfer" bundle:nil];
                [self showTabBar];
                [[self navigationController] pushViewController:sessionTransferViewController animated:YES];
                _selectedAccessory = nil;
                _protocolSelectionActionSheet = nil;
            }
        }
    }
}


#pragma mark UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex");
    if (_selectedAccessory && (buttonIndex >= 0) && (buttonIndex < [[_selectedAccessory protocolStrings] count]))
    {
        [_eaSessionController setupControllerForAccessory:_selectedAccessory
            withProtocolString:[[_selectedAccessory protocolStrings] objectAtIndex:buttonIndex]]; 
        
        EADSessionTransferViewController *sessionTransferViewController =
            [[EADSessionTransferViewController alloc] initWithNibName:@"EADSessionTransfer" bundle:nil];

        [[self navigationController] pushViewController:sessionTransferViewController animated:YES];
    }

    _selectedAccessory = nil;
    _protocolSelectionActionSheet = nil;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_accessoryList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *eaAccessoryCellIdentifier = @"eaAccessoryCellIdentifier";
    NSUInteger row = [indexPath row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eaAccessoryCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:eaAccessoryCellIdentifier];
    }

    NSString *eaAccessoryName = [[_accessoryList objectAtIndex:row] name];
    if (!eaAccessoryName || [eaAccessoryName isEqualToString:@""]) {
        eaAccessoryName = @"unknown";
    }

	[[cell textLabel] setText:eaAccessoryName];
	
    return cell;
}




#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#if 1
    NSUInteger row = [indexPath row];
    _selectedAccessory = [_accessoryList objectAtIndex:row];

    
    
    //change by milochen
//    _protocolSelectionActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Protocol" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    NSArray *protocolStrings = [_selectedAccessory protocolStrings];
    for(NSString *protocolString in protocolStrings) {
//        [_protocolSelectionActionSheet addButtonWithTitle:protocolString];
        if([protocolString isEqualToString:@"com.choiceonly.btprotocol1"]) {
            
            
            
//            if (_selectedAccessory && (buttonIndex >= 0) && (buttonIndex < [[_selectedAccessory protocolStrings] count]))
//            {
//                [_eaSessionController setupControllerForAccessory:_selectedAccessory withProtocolString:[[_selectedAccessory protocolStrings] objectAtIndex:buttonIndex]];
            
                [_eaSessionController setupControllerForAccessory:_selectedAccessory withProtocolString:protocolString];
/*
            - (void)setupControllerForAccessory:(EAAccessory *)accessory withProtocolString:(NSString *)protocolString
            {
                _accessory = accessory;
                _protocolString = [protocolString copy];
            }
  */
                EADSessionTransferViewController *sessionTransferViewController =
                [[EADSessionTransferViewController alloc] initWithNibName:@"EADSessionTransfer" bundle:nil];
            

                [self showTabBar];

            
                [[self navigationController] pushViewController:sessionTransferViewController animated:YES];
//            }
            
            _selectedAccessory = nil;
            _protocolSelectionActionSheet = nil;
            
            
            
        }
    }

//	[_protocolSelectionActionSheet setCancelButtonIndex:[_protocolSelectionActionSheet addButtonWithTitle:@"Cancel"]];
//	[_protocolSelectionActionSheet showInView:[self tableView]];

    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
#endif
}

#pragma mark Internal

- (void)_accessoryDidConnect:(NSNotification *)notification {
    EAAccessory *connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    [_accessoryList addObject:connectedAccessory];
    
    [self refreshBluetoothStatus];

    if ([_accessoryList count] == 0) {
        [_noExternalAccessoriesPosterView setHidden:NO];
    } else {
        [_noExternalAccessoriesPosterView setHidden:YES];
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([_accessoryList count] - 1) inSection:0];
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)_accessoryDidDisconnect:(NSNotification *)notification {
    EAAccessory *disconnectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];

    if (_selectedAccessory && [disconnectedAccessory connectionID] == [_selectedAccessory connectionID])
    {
        [_protocolSelectionActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    }

    int disconnectedAccessoryIndex = 0;
    for(EAAccessory *accessory in _accessoryList) {
        if ([disconnectedAccessory connectionID] == [accessory connectionID]) {
            break;
        }
        disconnectedAccessoryIndex++;
    }

    if (disconnectedAccessoryIndex < [_accessoryList count]) {
        [_accessoryList removeObjectAtIndex:disconnectedAccessoryIndex];
        [self refreshBluetoothStatus];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:disconnectedAccessoryIndex inSection:0];
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
	} else {
        NSLog(@"could not find disconnected accessory in accessory list");
    }

    if ([_accessoryList count] == 0) {
        [_noExternalAccessoriesPosterView setHidden:NO];
    } else {
        [_noExternalAccessoriesPosterView setHidden:YES];
    }
}

@end
