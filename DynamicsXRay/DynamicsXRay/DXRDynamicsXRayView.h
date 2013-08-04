//
//  DXRDynamicsXRayView.h
//  DynamicsXRay
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import UIKit;

@interface DXRDynamicsXRayView : UIView

- (void)drawAttachmentFromAnchor:(CGPoint)anchorPoint toPoint:(CGPoint)attachmentPoint isSpring:(BOOL)isSpring;

@end