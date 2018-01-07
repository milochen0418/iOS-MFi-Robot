
#import <UIKit/UIKit.h>

@class AVPlayerDemoPlaybackView;
@class AVPlayer;

@interface AVPlayerDemoMetadataViewController : UIViewController
{
@private
	IBOutlet UILabel* mTitleLabel;
	IBOutlet UILabel* mCopyrightLabel;
	
	NSArray* mMetadata;
}

@property (nonatomic, copy) NSArray* metadata;

- (void)setMetadata:(NSArray*)metadata;
- (void)goAway:(id)sender;

@end
