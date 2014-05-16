//
//  ALViewController.m
//  DynamicsSample
//
//  Created by えいる on 2014/05/16.
//  Copyright (c) 2014年 Tomohiko Himura. All rights reserved.
//

#import "ALViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ALViewController ()
{
    UIDynamicAnimator* _animator;
    UIGravityBehavior* _gravity;
    CMMotionManager* _motionManager;
}

@end

@implementation ALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _motionManager = [CMMotionManager new];
    _motionManager.accelerometerUpdateInterval = 0.01;  // 100Hz
    
    // ハンドラを指定
    CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error) {
        double x = data.acceleration.x;
        double y = data.acceleration.y;
        double z = data.acceleration.z;
        NSLog(@"x: %f, y: %f, z: %f", x, y, z);
        if (x != 0) {
            _gravity.angle = atan2(-y, x);
            _gravity.magnitude = sqrt(y*y + x*x);
            NSLog(@"angle: %f, magnitude: %f", _gravity.angle, _gravity.magnitude);
        }
    };
    
    // センサーの利用開始
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    
    // (不必要になったら)センサーの停止
    if (_motionManager.accelerometerActive) {
        [_motionManager stopAccelerometerUpdates];
    }
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];

    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[view]];
    [_animator addBehavior:_gravity];
    
    UICollisionBehavior* collison = [[UICollisionBehavior alloc] initWithItems:@[view]];
    collison.translatesReferenceBoundsIntoBoundary = true;
    [_animator addBehavior:collison];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
