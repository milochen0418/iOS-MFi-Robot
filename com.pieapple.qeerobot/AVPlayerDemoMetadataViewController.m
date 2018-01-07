

#import "AVPlayerDemoMetadataViewController.h"
#import "AVPlayerDemoPlaybackView.h"

#import <AVFoundation/AVFoundation.h>

@interface AVPlayerDemoMetadataViewController()
- (void)setMetadata:(NSArray*)metadata;
- (void)goAway:(id)sender;
@end

@implementation AVPlayerDemoMetadataViewController

- (id)init
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        return [self initWithNibName:@"AVPlayerDemoMetadataView-iPad" bundle:nil];
	} 
    else 
    {
        return [self initWithNibName:@"AVPlayerDemoMetadataView" bundle:nil];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

/* Display the asset 'title' and 'copyright' metadata. */
- (void)syncLabels
{
	/* Assume no metadata was found. */
	[mTitleLabel setText:@"<Title metadata not found>"];
	[mCopyrightLabel setText:@"<Copyright metadata not found>"];
	
	for (AVMetadataItem* item in self->mMetadata)
	{
		NSString* commonKey = [item commonKey];
		
		if ([commonKey isEqualToString:AVMetadataCommonKeyTitle])
		{
			[mTitleLabel setText:[item stringValue]];
			[mTitleLabel setHidden:NO];
		}
		if ([commonKey isEqualToString:AVMetadataCommonKeyCopyrights])
		{
			[mCopyrightLabel setText:[item stringValue]];
			[mCopyrightLabel setHidden:NO];
		}
	}
}

- (void)viewDidLoad
{
	[self syncLabels];

	[super viewDidLoad];	   
}

- (void)dealloc 
{
	[self->mMetadata release];
	[mTitleLabel release];
	[mCopyrightLabel release];

    [super dealloc];
}

- (NSArray*)metadata
{
	return self->mMetadata;
}

- (void)setMetadata:(NSArray*)metadata
{
	[self->mMetadata release];
	self->mMetadata = [metadata copy];
	
	[self syncLabels];
}

- (void)goAway:(id)sender
{
    if ([self respondsToSelector:@selector(presentingViewController)])
    {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        [[self parentViewController] dismissViewControllerAnimated:YES completion:NULL];
    }

}

@end
