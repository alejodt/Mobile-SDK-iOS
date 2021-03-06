//
//  CameraFPVViewController.m
//  DJISdkDemo
//
//  Copyright © 2015 DJI. All rights reserved.
//
/**
 *  This file demonstrates how to receive the video data from DJICamera and display the video using VideoPreviewer.
 */
#import "CameraFPVViewController.h"
#import "DemoUtility.h"
#import "VideoPreviewer.h"
#import <DJISDK/DJISDK.h>

@interface CameraFPVViewController () <DJICameraDelegate>

@property(nonatomic, weak) IBOutlet UIView* fpvView;

@property(nonatomic, assign) BOOL needToSetMode;

@end

@implementation CameraFPVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DJICamera* camera = [DemoComponentHelper fetchCamera];
    if (camera) {
        camera.delegate = self;
    }

    self.needToSetMode = YES;
    
    [[VideoPreviewer instance] start];
    [[VideoPreviewer instance] setDecoderDataSource:kDJIDecoderDataSoureNone];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[VideoPreviewer instance] setView:self.fpvView];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Call unSetView during exiting to release the memory.
    [[VideoPreviewer instance] unSetView];
}

/**
 *  VideoPreviewer is used to decode the video data and display the decoded frame on the view. VideoPreviewer provides both software 
 *  decoding and hardware decoding. When using hardware decoding, for different products, the decoding protocols are different.
 */
-(IBAction) onSegmentControlValueChanged:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [[VideoPreviewer instance] setDecoderDataSource:kDJIDecoderDataSoureNone];
    }
    else
    {
        DJIBaseProduct* product = [DemoComponentHelper fetchProduct];
        if (product) {
            NSString* productName = product.model;
            if ([productName isEqualToString:@"Inspire 1"] ||
                [productName isEqualToString:@"Inspire Pro"] ||
                [productName isEqualToString:@"M100"] ||
                [productName isEqualToString:@"OSMO"]) {
                [[VideoPreviewer instance] setDecoderDataSource:kDJIDecoderDataSoureInspire];
            }
            else if ([productName isEqualToString:@"Phantom3 Advanced"]
                     || [productName isEqualToString:@"Phantom3 Standard"]) {
                [[VideoPreviewer instance] setDecoderDataSource:kDJIDecoderDataSourePhantom3Advanced];
            }
            else if ([productName isEqualToString:@"Phantom3 Professional"]) {
                [[VideoPreviewer instance] setDecoderDataSource:kDJIDecoderDataSourePhantom3Professional];
            }
            else  {
                NSLog(@"ERROR: the camera type is not recognized. ");
                [[VideoPreviewer instance] setDecoderDataSource:kDJIDecoderDataSoureNone];
            }
        }
    }
}

#pragma mark - DJICameraDelegate
/**
 *  This video data is received through this method. Then the data is passed to VideoPreviewer.
 */
- (void)camera:(DJICamera *)camera didReceiveVideoData:(uint8_t *)videoBuffer length:(size_t)size
{
    uint8_t* pBuffer = (uint8_t*)malloc(size);
    memcpy(pBuffer, videoBuffer, size);
    [[[VideoPreviewer instance] dataQueue] push:pBuffer length:(int)size];
}

/**
 *  DJICamera will send the live stream only when the mode is in DJICameraModeShootPhoto or DJICameraModeRecordVideo. Therefore, in order 
 *  to demonstrate the FPV (first person view), we need to switch to mode to one of them.
 */
-(void)camera:(DJICamera *)camera didUpdateSystemState:(DJICameraSystemState *)systemState
{
    if (systemState.mode == DJICameraModePlayback ||
        systemState.mode == DJICameraModeMediaDownload) {
        if (self.needToSetMode) {
            self.needToSetMode = NO;
            WeakRef(obj);
            [camera setCameraMode:DJICameraModeShootPhoto withCompletion:^(NSError * _Nullable error) {
                if (error) {
                    WeakReturn(obj);
                    obj.needToSetMode = YES;
                }
            }];
        }
    }
}

@end
