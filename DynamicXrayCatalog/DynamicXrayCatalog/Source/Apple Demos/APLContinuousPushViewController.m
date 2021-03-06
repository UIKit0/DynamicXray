/*
     File: APLContinuousPushViewController.m
 Abstract: 
 A view controller to demonstrate a continuous push.
 Tapping in the view changes the angle and magnitude of the force. To visually show the force vector on screen, a red line is drawn representing the angle and magnitude of this vector. The force is continuously applied while the behavior is active, so we keep the vector line visible and just update its size and rotation to represent the vector.

 
  Version: 1.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 
 Copyright © 2013 Apple Inc. All rights reserved.
 WWDC 2013 License
 
 NOTE: This Apple Software was supplied by Apple as part of a WWDC 2013
 Session. Please refer to the applicable WWDC 2013 Session for further
 information.
 
 IMPORTANT: This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and
 your use, installation, modification or redistribution of this Apple
 software constitutes acceptance of these terms. If you do not agree with
 these terms, please do not use, install, modify or redistribute this
 Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple
 Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple. Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis. APPLE MAKES
 NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
 IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 EA1002
 5/3/2013
 */

#import "APLContinuousPushViewController.h"
#import <DynamicXray/DynamicXray.h>

@interface APLContinuousPushViewController ()

@property (nonatomic, weak) IBOutlet UIView *square1;
@property (nonatomic, weak) IBOutlet UIView *vectorView;
@property (nonatomic) UIDynamicAnimator* animator;
@property (nonatomic) UIPushBehavior* pushBehavior;

@end


@implementation APLContinuousPushViewController


- (void)viewDidLoad
{
    UIDynamicAnimator* animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.square1]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [animator addBehavior:collisionBehavior];

    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.square1] mode:UIPushBehaviorModeContinuous];
    pushBehavior.angle = 0.0;
    pushBehavior.magnitude = 0.0;
    [animator addBehavior:pushBehavior];
    self.pushBehavior = pushBehavior;
    
    DynamicXray *xray = [[DynamicXray alloc] init];
    [animator addBehavior:xray];

    self.animator = animator;

    self.vectorView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.vectorView.layer.anchorPoint = CGPointMake(0.0,0.5);
}


-(IBAction)handlePushContinousGesture:(UITapGestureRecognizer*)gesture
{
    /*
     Tapping in the view changes the angle and magnitude of the force. To visually show the force vector on screen, a red line is drawn representing the angle and magnitude of this vector. The force is continuously applied while the behavior is active, so we keep the vector line visible and just update its size and rotation to represent the vector.
     */
    CGPoint p = [gesture locationInView:self.view];
    CGPoint o = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    CGFloat distance = sqrtf(powf(p.x-o.x, 2.0)+powf(p.y-o.y, 2.0));
    CGFloat angle = atan2(p.y-o.y,p.x-o.x);
    distance = MIN(distance, 200.0);

    self.vectorView.bounds = CGRectMake(0.0, 0.0, distance, 5.0);
    self.vectorView.transform = CGAffineTransformMakeRotation(angle);

    // These two lignes change the actual force vector
    [self.pushBehavior setMagnitude:distance / 100.0];
    [self.pushBehavior setAngle:angle];
}


@end
