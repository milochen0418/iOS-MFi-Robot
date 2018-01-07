

#import "EADSessionTransferViewController.h"
#import "EADSessionController.h"

@interface EADSessionTransferViewController()
@property (nonatomic) bool mIsOnForward;
@property (nonatomic) bool mIsOnBackward;
@property (nonatomic) bool mIsOnTurnRight;
@property (nonatomic) bool mIsOnTurnLeft;

@property (nonatomic,strong) NSTimer * mForwardTimer;
@property (nonatomic,strong) NSTimer * mBackwardTimer;
@property (nonatomic,strong) NSTimer * mTurnRightTimer;
@property (nonatomic,strong) NSTimer * mTurnLeftTimer;
@property (nonatomic) bool mIsOldestProtocol;
@end

@implementation EADSessionTransferViewController
@synthesize mIsOldestProtocol;
@synthesize mIsOnBackward,mIsOnForward;
@synthesize mIsOnTurnLeft, mIsOnTurnRight;

@synthesize mForwardTimer,mBackwardTimer;
@synthesize mTurnRightTimer, mTurnLeftTimer;

@synthesize mForwardBtn,mBackwardBtn;
@synthesize mTurnLeftBtn, mTurnRightBtn;



@synthesize
    receivedBytesLabel = _receivedBytesLabel,
    stringToSendTextField = _stringToSendTextField,
    hexToSendTextField = _hexToSendTextField;




// send test string to the accessory
- (IBAction)sendString:(id)sender;
{
    if ([_stringToSendTextField isFirstResponder]) {
        [_stringToSendTextField resignFirstResponder];
    }

    const char *buf = [[_stringToSendTextField text] UTF8String];
    if (buf)
    {
        uint32_t len = strlen(buf) + 1;
        [[EADSessionController sharedController] writeData:[NSData dataWithBytes:buf length:len]];
    }
}



-(void) sendQeeRobotMovementsWithByte1: (Byte) byte1  andByte2:(Byte)byte2{
    NSString * str = [NSString stringWithFormat:@"FFAA0530%02X%02X%02X", byte1, byte2, (0x35+byte1+byte2)];
    NSLog(@"byte str = %@",str );
    [self sendHexString:str];
}




-(void) sendQeeRobotDoHeadRight {
    [self sendQeeRobotMovementsWithByte1:0x00 andByte2:0x42];
}

-(void) sendQeeRobotDoHeadLeft {
    [self sendQeeRobotMovementsWithByte1:0x00 andByte2:0x82];
}

-(void) sendQeeRobotDoRightArmUp {
    [self sendQeeRobotMovementsWithByte1:0x40 andByte2:0x02];
}

-(void) sendQeeRobotDoRightArmDown {
    [self sendQeeRobotMovementsWithByte1:0x80 andByte2:0x02];
}

-(void) sendQeeRobotDoLeftArmUp {
    [self sendQeeRobotMovementsWithByte1:0x10 andByte2:0x02];
}

-(void) sendQeeRobotDoLeftArmDown {
    [self sendQeeRobotMovementsWithByte1:0x20 andByte2:0x02];
}

-(void) sendQeeRobotDoLeftFootForward {
    [self sendQeeRobotMovementsWithByte1:0x01 andByte2:0x02];
}

-(void) sendQeeRobotDoRightFootForward {
    [self sendQeeRobotMovementsWithByte1:0x04 andByte2:0x02];
}

-(void) sendQeeRobotDoBodyForward {
    [self sendQeeRobotMovementsWithByte1:0x05 andByte2:0x02];
}

-(void) sendQeeRobotDoBodyBackward {
    [self sendQeeRobotMovementsWithByte1:0x0A andByte2:0x02];
}





- (IBAction)clickToHeadLeft:(id)sender {
    
    if(mIsOldestProtocol) {
        [self sendHexString:@"3152"];
    }
    else {
    [self sendQeeRobotDoHeadRight];
    }
}
- (IBAction)clickToHeadRight:(id)sender {
    if(mIsOldestProtocol) {
        [self sendHexString:@"314C"];
    }
    else {
        [self sendQeeRobotDoHeadLeft];
    }
}

- (IBAction)clickToLeftHandDown:(id)sender {
    if(mIsOldestProtocol) {
        [self sendHexString:@"3244"];
    }
    else {
        [self sendQeeRobotDoRightArmDown];
    }
}
- (IBAction)clickToLeftHandUp:(id)sender {
    if(mIsOldestProtocol) {
        [self sendHexString:@"3255"];
    }
    else {
        [self sendQeeRobotDoRightArmUp];
    }
}
- (IBAction)clickToRightHandUp:(id)sender {
    if(mIsOldestProtocol) {
        [self sendHexString:@"3355"];
    }
    else {
        [self sendQeeRobotDoLeftArmUp];
    }
}
- (IBAction)clickToRightHandDown:(id)sender {
    if(mIsOldestProtocol) {
        [self sendHexString:@"3344"];
    }
    else  {
        [self sendQeeRobotDoLeftArmDown];
    }
}



-(void) requestToTurnLeft {
    if(mIsOldestProtocol){
        [self sendHexString:@"544C"];
    }
    else {
        [self sendQeeRobotDoRightFootForward];
    }
}

-(void) requestToTurnRight {
    if(mIsOldestProtocol) {
        [self sendHexString:@"5452"];
    }
    else {
        [self sendQeeRobotDoLeftFootForward];
    }
}


-(void) requestToForward {
    if(mIsOldestProtocol) {
        [self sendHexString:@"4646"];
    }
    else {
        [self sendQeeRobotDoBodyForward];
    }
}

-(void) requestToBackward {
    if(mIsOldestProtocol) {
        [self sendHexString:@"4242"];
    }
    else {
        [self sendQeeRobotDoBodyBackward];
    }
}

- (IBAction)clickToTurnLeft:(id)sender {
    [self requestToTurnLeft];
}
- (IBAction)clickToTurnRight:(id)sender {
    [self requestToTurnRight];
}


- (IBAction)clickToForward:(id)sender {
    [self requestToForward];
}

-(IBAction) clickToBackward:(id)sender {
    [self requestToBackward];
}



// Interpret a UITextField's string at a sequence of hex bytes and send those bytes to the accessory

-(void) sendHexString:(NSString*) hexStr {
    
    NSLog(@"sendHexString hexStr = %@", hexStr);
    
//    const char *buf = [[_hexToSendTextField text] UTF8String];
    const char *buf = [hexStr UTF8String];
    NSMutableData *data = [NSMutableData data];
    if (buf)
    {
        uint32_t len = strlen(buf);
        
        char singleNumberString[3] = {'\0', '\0', '\0'};
        uint32_t singleNumber = 0;
        for(uint32_t i = 0 ; i < len; i+=2)
        {
            if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) )
            {
                singleNumberString[0] = buf[i];
                singleNumberString[1] = buf[i + 1];
                sscanf(singleNumberString, "%x", &singleNumber);
                uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
                [data appendBytes:(void *)(&tmp) length:1];
            }
            else
            {
                break;
            }
        }
        
        [[EADSessionController sharedController] writeData:data];
    }

}

- (IBAction)sendHex:(id)sender;
{
    if ([_hexToSendTextField isFirstResponder]) {
        [_hexToSendTextField resignFirstResponder];
    }
    [self sendHexString:[_hexToSendTextField text]];
    
    return;
    

    const char *buf = [[_hexToSendTextField text] UTF8String];
    NSMutableData *data = [NSMutableData data];
    if (buf)
    {
        uint32_t len = strlen(buf);

        char singleNumberString[3] = {'\0', '\0', '\0'};
        uint32_t singleNumber = 0;
        for(uint32_t i = 0 ; i < len; i+=2)
        {
            if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) )
            {
                singleNumberString[0] = buf[i];
                singleNumberString[1] = buf[i + 1];
                sscanf(singleNumberString, "%x", &singleNumber);
                uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
                [data appendBytes:(void *)(&tmp) length:1];
            }
            else
            {
                break;
            }
        }

        [[EADSessionController sharedController] writeData:data];
    }
}

// send 10K of data to the accessory.
- (IBAction)send10K:(id)sender
{
#define STRESS_TEST_BYTE_COUNT 10000
    uint8_t buf[STRESS_TEST_BYTE_COUNT];
    for(int i = 0; i < STRESS_TEST_BYTE_COUNT; i++) {
        buf[i] = (i & 0xFF);  // fill buf with incrementing bytes;
    }

	[[EADSessionController sharedController] writeData:[NSData dataWithBytes:buf length:STRESS_TEST_BYTE_COUNT]];
}

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    // watch for the accessory being disconnected
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
    // watch for received data from the accessory
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_sessionDataReceived:) name:EADSessionDataReceivedNotification object:nil];

    EADSessionController *sessionController = [EADSessionController sharedController];

    _accessory = [sessionController accessory];
//    [self setTitle:[sessionController protocolString]];
    [self setTitle:@"Qee Bear 操作開始"];
    [sessionController openSession];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self backwardHoldRelease ];
    [self forwardHoldRelease ];
    [self turnLeftHoldRelease];
    [self turnRightHoldRelease];

    
    // remove the observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EADSessionDataReceivedNotification object:nil];

    EADSessionController *sessionController = [EADSessionController sharedController];

    [sessionController closeSession];
    _accessory = nil;
    
    
}

-(void) viewDidLoad {
    NSLog(@"viewDidLoad is called");
    mIsOldestProtocol = NO;
    
    [mBackwardBtn addTarget:self action:@selector(backwardHoldDown) forControlEvents:UIControlEventTouchDown];
    [mBackwardBtn addTarget:self action:@selector(backwardHoldRelease) forControlEvents:UIControlEventTouchUpInside];
    [mBackwardBtn addTarget:self action:@selector(backwardHoldRelease) forControlEvents:UIControlEventTouchUpOutside];
    
    [mForwardBtn addTarget:self action:@selector(forwardHoldDown) forControlEvents:UIControlEventTouchDown];
    [mForwardBtn addTarget:self action:@selector(forwardHoldRelease) forControlEvents:UIControlEventTouchUpInside];
    [mForwardBtn addTarget:self action:@selector(forwardHoldRelease) forControlEvents:UIControlEventTouchUpOutside];
    
    [mTurnLeftBtn addTarget:self action:@selector(turnLeftHoldDown) forControlEvents:UIControlEventTouchDown];
    [mTurnLeftBtn addTarget:self action:@selector(turnLeftHoldRelease) forControlEvents:UIControlEventTouchUpInside];
    [mTurnLeftBtn addTarget:self action:@selector(turnLeftHoldRelease) forControlEvents:UIControlEventTouchUpOutside];

    [mTurnRightBtn addTarget:self action:@selector(turnRightHoldDown) forControlEvents:UIControlEventTouchDown];
    [mTurnRightBtn addTarget:self action:@selector(turnRightHoldRelease) forControlEvents:UIControlEventTouchUpInside];
    [mTurnRightBtn addTarget:self action:@selector(turnRightHoldRelease) forControlEvents:UIControlEventTouchUpOutside];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    //[self loadCommandTestViews:self.view];
}




-(void) turnRightHoldDown {
    NSLog(@"turnRight hold down");
    mIsOnTurnRight = YES;
    mTurnRightTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(turnRightTimerCallback) userInfo:nil repeats:NO];
}
-(void) turnRightTimerCallback {
    if(mIsOnTurnRight == YES) {
        mTurnRightTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(turnRightTimerCallback) userInfo:nil repeats:NO];
        [self requestToTurnRight];
    }
    else {
        if(mTurnRightTimer!=nil) {
            [mTurnRightTimer invalidate];
            mTurnRightTimer = nil;
        }
    }
}

-(void) turnRightHoldRelease {
    NSLog(@"turnRight hold release");
    if(mTurnRightTimer!=nil ) {
        [mTurnRightTimer invalidate];
        mTurnRightTimer = nil;
    }
    mIsOnTurnRight = NO;
}



-(void) turnLeftHoldDown {
    NSLog(@"turnLeft hold down");
    mIsOnTurnLeft = YES;
    mTurnLeftTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(turnLeftTimerCallback) userInfo:nil repeats:NO];
}
-(void) turnLeftTimerCallback {
    if(mIsOnTurnLeft == YES) {
        mTurnLeftTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(turnLeftTimerCallback) userInfo:nil repeats:NO];
        [self requestToTurnLeft];
    }
    else {
        if(mTurnLeftTimer!=nil) {
            [mTurnLeftTimer invalidate];
            mTurnLeftTimer = nil;
        }
    }
}

-(void) turnLeftHoldRelease {
    NSLog(@"turnLeft hold release");
    if(mTurnLeftTimer!=nil ) {
        [mTurnLeftTimer invalidate];
        mTurnLeftTimer = nil;
    }
    mIsOnTurnLeft = NO;
}



-(void) backwardHoldDown {
    NSLog(@"backward hold down");
    mIsOnBackward = YES;
    mBackwardTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(backwardTimerCallback) userInfo:nil repeats:NO];
}
-(void) backwardTimerCallback {
    if(mIsOnBackward == YES) {
        mBackwardTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(backwardTimerCallback) userInfo:nil repeats:NO];
        [self requestToBackward];
    }
    else {
        if(mBackwardTimer!=nil) {
            [mBackwardTimer invalidate];
            mBackwardTimer = nil;
        }
    }
}

-(void) backwardHoldRelease {
    NSLog(@"backward hold release");
    if(mBackwardTimer!=nil ) {
        [mBackwardTimer invalidate];
        mBackwardTimer = nil;
    }
    mIsOnBackward = NO;
}


-(void) forwardHoldDown {
    NSLog(@"forward hold down");
    mIsOnForward = YES;
    mForwardTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(forwardTimerCallback) userInfo:nil repeats:NO];
}

-(void) forwardTimerCallback {
    if(mIsOnForward == YES) {
        mForwardTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(forwardTimerCallback) userInfo:nil repeats:NO];
        //[self sendHexString:@"4646"];
        [self requestToForward];

    }
    else {
        if(mForwardTimer!=nil) {
            [mForwardTimer invalidate];
            mForwardTimer = nil;
        }
    }
    
}

-(void) forwardHoldRelease {
    NSLog(@"forward hold release");
    if(mForwardTimer!=nil ) {
        [mForwardTimer invalidate];
        mForwardTimer = nil;
    }
    mIsOnForward = NO;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    self.receivedBytesLabel = nil;
    self.stringToSendTextField = nil;
    self.hexToSendTextField = nil;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Internal

- (void)_accessoryDidDisconnect:(NSNotification *)notification
{
    NSLog(@"EADSessionTransferViewController.m _AccessoryDidDisconnect invoked");
    if ([[self navigationController] topViewController] == self)
    {
        EAAccessory *disconnectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
        if ([disconnectedAccessory connectionID] == [_accessory connectionID])
        {
            [[self navigationController] popViewControllerAnimated:YES];

        }
    }
}

// Data was received from the accessory, real apps should do something with this data but currently:
//    1. bytes counter is incremented
//    2. bytes are read from the session controller and thrown away
- (void)_sessionDataReceived:(NSNotification *)notification
{
    NSLog(@"_sessionDataReceived is called ");
    EADSessionController *sessionController = (EADSessionController *)[notification object];
    uint32_t bytesAvailable = 0;

    NSString * str = @"";
    while ((bytesAvailable = [sessionController readBytesAvailable]) > 0) {
        NSData *data = [sessionController readData:bytesAvailable];
        if (data) {
            _totalBytesRead += bytesAvailable;
        }
        //NSString * readStr = [NSString stringWithUTF8String:data];
        NSString * readStr = [self NSDataToHexString:data withSpace:YES];
        str = [str stringByAppendingString:readStr];
    }
    
    
    
    NSString * theStr = [NSString stringWithFormat:@"Bytes Received from Session: %d \n and the hex is\n%@", _totalBytesRead, str];
    
    //[_receivedBytesLabel setText:[NSString stringWithFormat:@"Bytes Received from Session: %d", _totalBytesRead]];
    [_receivedBytesLabel setText:theStr];
    NSLog(@"%@", theStr);
    
    
//    NSString* string = [NSString stringWithUTF8String: data];
    
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Received"
                                                       message:theStr
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
    
}




#pragma mark Test Protocol



-(void) loadCommandTestViews :(UIView*) view {
    
    float posY = 100;
    
    UIButton *testCommandOfRetrievingSystemInfoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testCommandOfRetrievingSystemInfoBtn addTarget:self action:@selector(testCommandOfRetrievingSystemInfo:) forControlEvents:UIControlEventTouchUpInside];
    [testCommandOfRetrievingSystemInfoBtn setTitle:@"Test Retrieving System Info" forState:UIControlStateNormal];
    testCommandOfRetrievingSystemInfoBtn.frame = CGRectMake(20.0, posY, 250.0, 40.0);
    [view addSubview:testCommandOfRetrievingSystemInfoBtn];
    
    UIButton *testCommandOfDemoMode1Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testCommandOfDemoMode1Btn addTarget:self action:@selector(testCommandOfDemoMode1:) forControlEvents:UIControlEventTouchUpInside];
    [testCommandOfDemoMode1Btn setTitle:@"Test Demo Mode 1 (scriptID=0x00)" forState:UIControlStateNormal];
    testCommandOfDemoMode1Btn.frame = CGRectMake(20.0, posY + 30.0f, 320.0, 40.0);
    [view addSubview:testCommandOfDemoMode1Btn];
    
    UIButton *testCommandOfDemoMode2Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testCommandOfDemoMode2Btn addTarget:self action:@selector(testCommandOfDemoMode2:) forControlEvents:UIControlEventTouchUpInside];
    [testCommandOfDemoMode2Btn setTitle:@"Test Demo Mode 2 (scriptID=0x01)" forState:UIControlStateNormal];
    testCommandOfDemoMode2Btn.frame = CGRectMake(20.0, posY + 60.0f, 320.0, 40.0);
    [view addSubview:testCommandOfDemoMode2Btn];
    
    UIButton *testCommandOfDemoMode3Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testCommandOfDemoMode3Btn addTarget:self action:@selector(testCommandOfDemoMode3:) forControlEvents:UIControlEventTouchUpInside];
    [testCommandOfDemoMode3Btn setTitle:@"Test Demo Mode 3 (scriptID=0x02)" forState:UIControlStateNormal];
    testCommandOfDemoMode3Btn.frame = CGRectMake(20.0, posY + 90.0f, 320.0, 40.0);
    [view addSubview:testCommandOfDemoMode3Btn];
    

    
    
    UIButton *testCommandOfStressAutoModeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testCommandOfStressAutoModeBtn addTarget:self action:@selector(testCommandOfStressAutoMode:) forControlEvents:UIControlEventTouchUpInside];
    [testCommandOfStressAutoModeBtn setTitle:@"Test Stress Auto Mode" forState:UIControlStateNormal];
    testCommandOfStressAutoModeBtn.frame = CGRectMake(20.0, posY + 120.0f, 250.0, 40.0);
    [view addSubview:testCommandOfStressAutoModeBtn];
    
    UIButton *testCommandOfStopAutoModeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testCommandOfStopAutoModeBtn addTarget:self action:@selector(testCommandOfStopAutoMode:) forControlEvents:UIControlEventTouchUpInside];
    [testCommandOfStopAutoModeBtn setTitle:@"Stop Auto/Demo Mode" forState:UIControlStateNormal];
    testCommandOfStopAutoModeBtn.frame = CGRectMake(20.0, posY + 150.0f, 250.0, 40.0);
    [view addSubview:testCommandOfStopAutoModeBtn];
    
    
    UIButton *testCommandOfAutoMode1Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testCommandOfAutoMode1Btn addTarget:self action:@selector(testCommandOfAutoMode1:) forControlEvents:UIControlEventTouchUpInside];
    [testCommandOfAutoMode1Btn setTitle:@"Test Auto Mode 1 (doc example cmd 1)" forState:UIControlStateNormal];
    testCommandOfAutoMode1Btn.frame = CGRectMake(20.0, posY + 180.0f, 320.0, 40.0);
    [view addSubview:testCommandOfAutoMode1Btn];

    UIButton *testCommandOfAutoMode2Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testCommandOfAutoMode2Btn addTarget:self action:@selector(testCommandOfAutoMode2:) forControlEvents:UIControlEventTouchUpInside];
    [testCommandOfAutoMode2Btn setTitle:@"Test Auto Mode 2 (doc example cmd 2)" forState:UIControlStateNormal];
    testCommandOfAutoMode2Btn.frame = CGRectMake(20.0, posY + 210.0f, 320.0, 40.0);
    [view addSubview:testCommandOfAutoMode2Btn];
    
    UIButton *testCommandOfAutoMode3Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testCommandOfAutoMode3Btn addTarget:self action:@selector(testCommandOfAutoMode3:) forControlEvents:UIControlEventTouchUpInside];
    [testCommandOfAutoMode3Btn setTitle:@"Test Auto Mode 3 (example cmd 3)" forState:UIControlStateNormal];
    testCommandOfAutoMode3Btn.frame = CGRectMake(20.0, posY + 240.0f, 320.0, 40.0);
    [view addSubview:testCommandOfAutoMode3Btn];
    
    UIButton *testCommandOfAutoMode4Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testCommandOfAutoMode4Btn addTarget:self action:@selector(testCommandOfAutoMode4:) forControlEvents:UIControlEventTouchUpInside];
    [testCommandOfAutoMode4Btn setTitle:@"Test Auto Mode 4 (Mode 3 but loopCnt=0)" forState:UIControlStateNormal];
    testCommandOfAutoMode4Btn.frame = CGRectMake(5.0, posY + 270.0f, 320.0, 40.0);
    [view addSubview:testCommandOfAutoMode4Btn];
    
}


-(void) testCommandOfRetrievingSystemInfo:(id)sender  {
    NSLog(@"testCommandOfRetrievingSystemInfo");
//    [self sendQeeRobotRetrievingSystemInfo];
    [self sendQeeRobotRetrievingSystemInfoWithNoByte];
}


-(void)testCommandOfDemoMode1:(id)sender {
    NSLog(@"testCommandOfDemoMode1");
    [self sendQeeRobotDemoModeWithByte1:0x00];
}
-(void)testCommandOfDemoMode2:(id)sender {
    NSLog(@"testCommandOfDemoMode2");
    [self sendQeeRobotDemoModeWithByte1:0x01];
}
-(void)testCommandOfDemoMode3:(id)sender {
    NSLog(@"testCommandOfDemoMode3");
    [self sendQeeRobotDemoModeWithByte1:0x02];
}


-(void)testCommandOfStopAutoMode:(id)sender {
    NSLog(@"testCommandOfStopAutoMode");
    NSString * str = [NSString stringWithFormat:@"FFAA0531000036"];
    NSLog(@"byte str = %@",str );
    [self sendHexString:str];
}



-(void)testCommandOfAutoMode1:(id)sender {
    NSLog(@"testCommandOfAutoMode1");
    //
    NSString * str = [NSString stringWithFormat:@"FFAA0531000036"];
    NSLog(@"byte str = %@",str );
    [self sendHexString:str];
}

-(void)testCommandOfAutoMode2:(id)sender {
    NSLog(@"testCommandOfAutoMode2");
    //0xFF, 0xAA, 0x08, 0x31, 0x0A, 0x01, 0x60, 0x01, 0x02
    NSString * str = [NSString stringWithFormat:@"FFAA08310A01600102%02X",(0x08 + 0x31 + 0x0A + 0x01 + 0x60 + 0x01 + 0x02) ];
    NSLog(@"byte str = %@",str );
    [self sendHexString:str];
}

-(void)testCommandOfAutoMode3:(id)sender {
    NSLog(@"testCommandOfAutoMode3");
    //0xFF, 0xAA, 0x0B, 0x31, 0x06, 0x02, 0x90, 0x02, 0x01, 0x05, 0x03, 0x05
    NSString * str = [NSString stringWithFormat:@"FFAA0B310602900201050305%02X",(0x0B + 0x31 + 0x06 + 0x02 + 0x90 + 0x02 + 0x01 + 0x05 + 0x03 + 0x05) ];
    NSLog(@"byte str = %@",str );
    [self sendHexString:str];
}


-(void)testCommandOfAutoMode4:(id)sender {
    NSLog(@"testCommandOfAutoMode4 ");
    //0xFF, 0xAA, 0x0B, 0x31, 0x06, 0x02, 0x90, 0x02, 0x01, 0x05, 0x03, 0x05
    NSString * str = [NSString stringWithFormat:@"FFAA0B310002900201050305%02X",(0x0B + 0x31 + 0x00 + 0x02 + 0x90 + 0x02 + 0x01 + 0x05 + 0x03 + 0x05) ];
    NSLog(@"byte str = %@",str );
    [self sendHexString:str];
}




-(void) sendQeeRobotDemoModeWithByte1: (Byte) byte1{
    NSString * str = [NSString stringWithFormat:@"FFAA0432%02X%02X", byte1, (0x36+byte1)];
    NSLog(@"byte str = %@",str );
    [self sendHexString:str];
}

-(void) sendQeeRobotRetrievingSystemInfoWithNoByte{
    NSString * str = [NSString stringWithFormat:@"FFAA0350%02X", 0x53];
    NSLog(@"byte str = %@",str );
    [self sendHexString:str];
}


-(void) continuePlayClickToHeadRight {
    dispatch_async(dispatch_get_main_queue(),^{
        [self clickToHeadRight:nil];
        [self continuePlayClickToHeadRight];
    });
    
}



-(void) sendQeeRobotDemoMode {
    [self sendQeeRobotDemoModeWithByte1:0x02];
}







-(void)testCommandOfStressAutoMode:(id)sender {
    NSLog(@"testCommandOfStressAutoMode");
    //0xFF, 0xAA, 0x0B, 0x31, 0x06, 0x02, 0x90, 0x02, 0x01, 0x05, 0x03, 0x05
    //NSString * str = [NSString stringWithFormat:@"FFAA0B310602900201050305%02X",(0x0B + 0x31 + 0x06 + 0x02 + 0x90 + 0x02 + 0x01 + 0x05 + 0x03 + 0x05) ];
    //NSLog(@"byte str = %@",str );
    //[self sendHexString:str];
    
    
    
    
    
#define QEE_ROBOT_MOVEMENT_MAX_CNT						50
    
    typedef struct
    {
        unsigned char			ucArmLegEvent ;
        unsigned char			ucHeadEventAndMoveTime ;
        unsigned char			ucMovePauseTime ;
    }QeeRobotMovement_t ;
    
    
    typedef struct
    {
        unsigned char				ucLoopCnt ;
        unsigned char				ucMovementCnt ;
        QeeRobotMovement_t			tQeeRobotMovement[QEE_ROBOT_MOVEMENT_MAX_CNT] ;
    }QeeRobotOperation_t ;
    
    
    
    const QeeRobotOperation_t qeeRobotScriptsIDTable =
    {
        0,
        50,
//        2,
        {
            // 1~10
            // 1. head turns right for 100 ms
            {0x00, 0x81, 0x05},
            
            // 2. head turns left for 100 ms
            {0x00, 0x41, 0x05},
            

            
            // 3. head turns left for 100 ms
            {0x00, 0x41, 0x05},
            
            // 4. head turns right for 100 ms
            {0x00, 0x81, 0x05},
            
            // 5. lift both hands up for 100 ms
            {0x50, 0x01, 0x05},
            
            // 6. lift both hands down for 100 ms
            {0xA0, 0x01, 0x05},
            
            // 7. body moves forwards for 100 ms
            {0x05, 0x0A, 0x05},
            
            // 8. body moves beackwards for 100 ms
            {0x0A, 0x0A, 0x05},
            
            // 9. right foot moves forwards for 100 ms and left foot moves backwards for 100 ms
            {0x06, 0x0A, 0x05},
            
            // head
            // 10.
            {0x00, 0x41, 0x05},
            
            // 11.
            {0x00, 0x41, 0x05},
            
            // 12.
            {0x00, 0x81, 0x05},
            
            // 13
            {0x00, 0x81, 0x05},
            
            // 14.
            {0x00, 0x81, 0x05},
            
            // 15
            {0x00, 0x81, 0x05},
            
            // 16.
            {0x00, 0x41, 0x05},
            
            // 17.
            {0x00, 0x41, 0x05},
            
            // left arm
            // 18. Up
            {0x10, 0x01, 0x05},
            
            // 19. Up
            {0x10, 0x01, 0x05},
            
            // 20. Down
            {0x20, 0x01, 0x05},
            
            // 21. Down
            {0x20, 0x01, 0x05},
            
            // 22. Down
            {0x20, 0x01, 0x05},
            
            // 23. Up
            {0x10, 0x01, 0x05},
            
            // right arm
            // 24. Up
            {0x40, 0x01, 0x05},
            
            // 25. Up
            {0x40, 0x01, 0x05},
            
            // 26. Down
            {0x80, 0x01, 0x05},
            
            // 27. Down
            {0x80, 0x01, 0x05},
            
            // 28. Down
            {0x80, 0x01, 0x05},
            
            // 29. Up
            {0x40, 0x01, 0x05},
            
            // right foot
            //
            // 30. forward
            {0x04, 0x05, 0x05},
            
            // 31. backward
            {0x08, 0x05, 0x05},
            
            // 32. forward
            {0x04, 0x0A, 0x05},
            
            // 33. backward
            {0x08, 0x0A, 0x05},
            
            // left foot
            //
            // 34. forward
            {0x01, 0x05, 0x05},
            
            // 35. backward
            {0x02, 0x05, 0x05},
            
            // 36. forward
            {0x01, 0x0A, 0x05},
            
            // 37. backward
            {0x02, 0x0A, 0x05},
            
            // body
            //
            // 38. forward
            {0x05, 0x05, 0x05},
            
            // 39. backward
            {0x0A, 0x05, 0x05},
            
            // 40. right hand up, left hand down
            {0x50, 0x01, 0x05},
            
            // 41. right hand up, left hand down
            {0x50, 0x01, 0x05},
            
            // 42.
            // right hand down, left hand up
            {0x90, 0x01, 0x05},
            
            // 43. right hand up, left hand down
            {0x90, 0x01, 0x05},
            
            // 44. right hand up, left hand down
            {0x90, 0x01, 0x05},
            
            // 45. right hand up, left foot backward
            {0x42, 0x01, 0x05},
            
            // 46. right hand up, left foot backward
            {0x42, 0x01, 0x05},
            
            // 47. right hand down, left foot forward
            {0x81, 0x01, 0x05},
            
            // 48. right hand down, left foot forward
            {0x81, 0x01, 0x05},
            
            // 49. left hand down, right foot forward
            {0x24, 0x01, 0x05},
            
            // 50. left hand down, right foot forward
            {0x24, 0x02, 0x05},
 

        }
    } ;
    
    
    
    
    NSString * payloadStr = @"";
    int payloadLen = 0;
    int checkSumLen = 1;
    int commandIdLen = 1;
    int LenFieldLen = 1;
    int movementCntLen = 1; //qeeRobotScriptsIDTable.ucMovementCnt;
    int loopCntLen = 1; //qeeRobotScriptsIDTable.ucLoopCnt;
    int checkSumValue = 0 ;
 
    int row_idx = 0;
    int col_idx = 0;
    
    int row_num = (int)qeeRobotScriptsIDTable.ucMovementCnt;
    
    NSLog(@"ucMovementCnt = %d", row_num);
    
    
    
    
    
    
    
    
    for ( row_idx = 0; row_idx < row_num; row_idx++) {
        
        QeeRobotMovement_t mov = qeeRobotScriptsIDTable.tQeeRobotMovement[row_idx];
        
        int movArray[3] = {mov.ucArmLegEvent, mov.ucHeadEventAndMoveTime, mov.ucMovePauseTime};
        
        for (col_idx = 0; col_idx < 3; col_idx++) {
            int val = movArray[col_idx] % 256;
            NSString * appendStr = [NSString stringWithFormat:@"%02X",val ];
            payloadStr = [payloadStr stringByAppendingString:appendStr];
            checkSumValue += val;
            payloadLen =payloadLen+1;

        }
    }
    

    
    int LenFieldValue =  payloadLen + checkSumLen + commandIdLen + LenFieldLen + loopCntLen + movementCntLen;
//    NSString * hexStr = [NSString stringWithFormat:@"FFAA %02X 31 %02X %02X %@ %02X", LenFieldValue, qeeRobotScriptsIDTable.ucLoopCnt, qeeRobotScriptsIDTable.ucMovementCnt ,payloadStr, (checkSumValue % 256) ];
    
    //NSString * hexStr = [NSString stringWithFormat:@"FFAA%02X31%02X%02X%@%02X", LenFieldValue, qeeRobotScriptsIDTable.ucLoopCnt, qeeRobotScriptsIDTable.ucMovementCnt ,payloadStr, (checkSumValue % 256) ];
    
    //LenFieldValue = 155;
    
    
    checkSumValue += (LenFieldValue+ qeeRobotScriptsIDTable.ucLoopCnt+ qeeRobotScriptsIDTable.ucMovementCnt + 0x31);
    
    
    NSString * hexStr = [NSString stringWithFormat:@"FFAA%02X31%02X%02X%@%02X", LenFieldValue, qeeRobotScriptsIDTable.ucLoopCnt, qeeRobotScriptsIDTable.ucMovementCnt ,payloadStr, (checkSumValue % 256) ];
    
    
    
    NSLog(@"byte str = %@",hexStr );
    [self sendHexString:hexStr];
    
}



-(NSString*)NSDataToHexString :(NSData*)data withSpace:(BOOL)spaces {
    const unsigned char* bytes = (const unsigned char*)[data bytes];
    NSUInteger nbBytes = [data length];
    //If spaces is true, insert a space every this many input bytes (twice this many output characters).
    //static const NSUInteger spaceEveryThisManyBytes = 4UL;
    static const NSUInteger spaceEveryThisManyBytes = 1UL;
    //If spaces is true, insert a line-break instead of a space every this many spaces.
    static const NSUInteger lineBreakEveryThisManySpaces = 8UL;
    const NSUInteger lineBreakEveryThisManyBytes = spaceEveryThisManyBytes * lineBreakEveryThisManySpaces;
    NSUInteger strLen = 2*nbBytes + (spaces ? nbBytes/spaceEveryThisManyBytes : 0);
    
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    for(NSUInteger i=0; i<nbBytes; ) {
        [hex appendFormat:@"%02X", bytes[i]];
        //We need to increment here so that the every-n-bytes computations are right.
        ++i;
        
        if (spaces) {
            if (i % lineBreakEveryThisManyBytes == 0) [hex appendString:@"\n"];
            else if (i % spaceEveryThisManyBytes == 0) [hex appendString:@" "];
        }
    }
//    return [hex autorelease];
    return hex;
}


@end
