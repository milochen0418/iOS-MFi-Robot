

#import <ExternalAccessory/ExternalAccessory.h>

@class EADSessionController;

@interface RootViewController : UIViewController <UIActionSheetDelegate> {
    NSMutableArray *_accessoryList;

    EAAccessory *_selectedAccessory;
    EADSessionController *_eaSessionController;

    UIActionSheet *_protocolSelectionActionSheet;

    UIView *_noExternalAccessoriesPosterView;
    UILabel *_noExternalAccessoriesLabelView;
}

// from UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
