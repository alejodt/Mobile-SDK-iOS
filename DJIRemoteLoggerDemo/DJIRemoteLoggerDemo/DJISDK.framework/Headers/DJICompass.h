/*
 *  DJI iOS Mobile SDK Framework
 *  DJICompass.h
 *
 *  Copyright (c) 2015, DJI.
 *  All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <DJISDK/DJIBaseComponent.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DJICompassCalibrationStatus)
{
    /**
     *  Compass horizontal calibration. User should hold the aircraft horizontally and rotate it 360 degree.
     */
    DJICompassCalibrationStatusHorizontal,
    /**
     *  Compass vertical calibration. User should hold the aircraft vertically, with the nose pointed towards the ground, and rotate aircraft 360 degrees.
     */
    DJICompassCalibrationStatusVertical,
    /**
     *  Compass calibration succeeded.
     */
    DJICompassCalibrationStatusSucceeded,
    /**
     *  Compass calibration failed. Make sure there are no magnets or metal objects near the compass and retry.
     */
    DJICompassCalibrationStatusFailed,
    /**
     *  Compass calibration status unknown.
     */
    DJICompassCalibrationStatusUnknown,
};

/**
 *  Compass of the aircraft.
 */
@interface DJICompass : NSObject

/**
 *  Represents the heading in degrees. True North is 0 degrees heading, positive heading is East of North, negative heading is West of North and heading bounds are [-180, 180].
 */
@property(nonatomic, readonly) double heading;

/**
 *  Whether or not the compass has error. If YES, the compass needs calibration.
 */
@property(nonatomic, readonly) BOOL hasError;

/**
 *  Whether or not the compass is currently calibrating.
 */
@property(nonatomic, readonly) BOOL isCalibrating;

/**
 *  Shows the calibration status.
 */
@property(nonatomic, readonly) DJICompassCalibrationStatus calibrationStatus;

/**
 *  Starts compass calibration. Make sure there are no magnets or metal objects near the compass.
 *
 */
-(void) startCalibrationWithCompletion:(DJICompletionBlock)completion;

/**
 *  Stops compass calibration.
 *
 */
-(void) stopCalibrationWithCompletion:(DJICompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
