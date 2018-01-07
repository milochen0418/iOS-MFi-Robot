

#import <ExternalAccessory/ExternalAccessory.h>

@interface EADSessionTransferViewController : UIViewController <UITextFieldDelegate> {
    EAAccessory *_accessory;
    UILabel *_receivedBytesLabel;
    UITextField *_stringToSendTextField;
    UITextField *_hexToSendTextField;

    uint32_t _totalBytesRead;
}

- (IBAction)sendString:(id)sender;
- (IBAction)sendHex:(id)sender;
- (IBAction)send10K:(id)sender;

// UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@property(nonatomic, strong) IBOutlet UILabel *receivedBytesLabel;
@property(nonatomic, strong) IBOutlet UITextField *stringToSendTextField;
@property(nonatomic, strong) IBOutlet UITextField *hexToSendTextField;
@property (strong, nonatomic) IBOutlet UIButton *mForwardBtn;
@property (strong, nonatomic) IBOutlet UIButton *mBackwardBtn;
@property (strong, nonatomic) IBOutlet UIButton *mTurnLeftBtn;
@property (strong, nonatomic) IBOutlet UIButton *mTurnRightBtn;

@end
