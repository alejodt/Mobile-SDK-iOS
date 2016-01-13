- (void)viewDidLoad {
    [super viewDidLoad];

    // disable the connect button by default
    [self.connectButton setEnabled:NO];

    //Register App with key
    NSString* appKey = @"Please enter your App Key here";
    [DJISDKManager registerApp:appKey withDelegate:self];

    self.sdkVersionLabel.text = [@"DJI SDK Version: " stringByAppendingString:[DJISDKManager getSDKVersion]];
}
