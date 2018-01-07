//
//  DialViewController.m
//  Qee Bear
//
//  Created by Milo Chen on 6/18/14.
//
//

#import "DialViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface DialViewController () <ABPeoplePickerNavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *mPhoneNumberLbl;
@property (strong, nonatomic) IBOutlet UIButton *mZeroNumberBtn;

@end

@implementation DialViewController
@synthesize mPhoneNumberLbl;
@synthesize mZeroNumberBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)clickToPress1:(id)sender {
    mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"1"];
    [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)clickToPress2:(id)sender {
    mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"2"];
    [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)clickToPress3:(id)sender {
    mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"3"];
    [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)clickToPress4:(id)sender {
        mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"4"];
        [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)clickToPress5:(id)sender {
        mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"5"];
        [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)clickToPress6:(id)sender {
        mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"6"];
        [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)clickToPress7:(id)sender {
        mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"7"];
        [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)clickToPress8:(id)sender {
        mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"8"];
        [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)clickToPress9:(id)sender {
        mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"9"];
        [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)clickToPressStar:(id)sender {
        mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"*"];
        [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)clickToPressSharp:(id)sender {
        mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"#"];
        [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}


- (IBAction)clickToPressZero:(id)sender {
    mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"0"];
    [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}


- (IBAction)clickToPressPlus:(id)sender {
    mPhoneNumberLbl.text = [NSString stringWithFormat:@"%@%@", mPhoneNumberLbl.text,@"+"];
    [mPhoneNumberLbl setBackgroundColor:[UIColor whiteColor]];
}


- (IBAction)clickToPressDial:(id)sender {
    [self dialPhoneNumber:mPhoneNumberLbl.text];
}



- (IBAction)clickToPressDel:(id)sender {

    NSString * currentPN = [NSString stringWithString:mPhoneNumberLbl.text];
    currentPN = [currentPN substringToIndex:currentPN.length-(currentPN.length>0)];
    
    //mPhoneNumberLbl.text = [NSString stringWithFormat:@""];
    mPhoneNumberLbl.text = currentPN;
    if(currentPN.length <= 0) {
        [mPhoneNumberLbl setBackgroundColor:[UIColor clearColor]];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILongPressGestureRecognizer * gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handle:)];
    [gesture setMinimumPressDuration:1.2];
    [mZeroNumberBtn addGestureRecognizer:gesture];

}

- (void)handle:(UILongPressGestureRecognizer*)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"UILongPressGestureRecognizer Begin");
        [self clickToPressPlus:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dialPhoneNumber:(NSString*) phoneNumber {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:130-032-2837"]]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]]];

    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
    
}


- (IBAction)clickToOpenContacts:(id)sender {
    /*
    NSString *stringURL = @"contacts:";
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
*/
    [self showPeoplePickerController];
}


- (void)viewDidUnload {
    [self setMPhoneNumberLbl:nil];
    [super viewDidUnload];
}


-(void)showPeoplePickerController
{
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
	
	
	picker.displayedProperties = displayedItems;
	// Show the picker
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
 	[self dismissViewControllerAnimated:YES completion:NULL];
}


@end
