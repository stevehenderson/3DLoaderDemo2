//
//  TouchMatrix.h
//  LabTest3
//
//  Created by Jim Love on 2/28/14.
//  Copyright (c) 2014 Jim Love. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TouchMatrix : NSObject

typedef enum TransformationState
{
    S_NEW,
    S_SCALE,
    S_TRANSLATION,
    S_ROTATION
}
TransformationState;

@property (readwrite) TransformationState state;

- (id)initWithDepth:(float)z Scale:(float)s Translation:(GLKVector2)t Rotation:(GLKVector3)r;
- (void)start;
- (void)reset;
- (void)scale:(float)s;
- (void)translate:(GLKVector2)t withMultiplier:(float)m;
- (void)rotate:(GLKVector3)r withMultiplier:(float)m;
- (GLKMatrix4)getModelViewMatrix;

@end
