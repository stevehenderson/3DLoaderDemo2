//
//  TouchMatrix.m
//  Created by Jim Love on 2/28/14.
//  Copyright (c) 2014 Jim Love. All rights reserved.
//
#import "TouchMatrix.h"

@interface TouchMatrix()

{
    float _depth;
    float _scaleStart;
    float _scaleEnd;
    GLKVector2 _translationStart;
    GLKVector2 _translationEnd;
    GLKVector3 _rotationStart;
    GLKQuaternion _rotationEnd;
    GLKVector3 _front;
    GLKVector3 _right;
    GLKVector3 _up;
}
@end

@implementation TouchMatrix

- (id)initWithDepth:(float)z Scale:(float)s Translation:(GLKVector2)t Rotation:(GLKVector3)r
{
    if(self = [super init])
    {
        _depth = z;
        _scaleEnd = s;
        _translationEnd = t;
        _front = GLKVector3Make(0.0f, 0.0f, 1.0f);
        r.z = GLKMathDegreesToRadians(r.z);
        _rotationEnd = GLKQuaternionIdentity;
        _rotationEnd = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-r.z, _front), _rotationEnd);
        _right = GLKVector3Make(1.0f, 0.0f, 0.0f);
        _up = GLKVector3Make(0.0f, 1.0f, 0.0f);
        r.x = GLKMathDegreesToRadians(r.x);
        r.y = GLKMathDegreesToRadians(r.y);
        _rotationEnd = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-r.x, _right), _rotationEnd);
        _rotationEnd = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-r.y, _up), _rotationEnd);
    }
    return self;
}

- (void)start
{
    _scaleStart = _scaleEnd;
    _translationStart = GLKVector2Make(0.0f, 0.0f);
    _rotationStart = GLKVector3Make(0.0f, 0.0f, 0.0f);
    self.state = S_NEW;
}

- (void)reset
{
    _depth = 0.0f;
    _scaleEnd = 1.0f;
    GLKVector3 r = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _translationEnd = GLKVector2Make(0.0f, 0.0f);
    _front = GLKVector3Make(0.0f, 0.0f, 1.0f);
    r.z = GLKMathDegreesToRadians(r.z);
    _rotationEnd = GLKQuaternionIdentity;
    _rotationEnd = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-r.z, _front), _rotationEnd);
    _right = GLKVector3Make(1.0f, 0.0f, 0.0f);
    _up = GLKVector3Make(0.0f, 1.0f, 0.0f);
    r.x = GLKMathDegreesToRadians(r.x);
    r.y = GLKMathDegreesToRadians(r.y);
    _rotationEnd = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-r.x, _right), _rotationEnd);
    _rotationEnd = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-r.y, _up), _rotationEnd);
}

- (void)scale:(float)s
{
    _scaleEnd = s * _scaleStart;
    self.state = S_SCALE;
}

- (void)translate:(GLKVector2)t withMultiplier:(float)m
{
    t = GLKVector2MultiplyScalar(t, m);
    float dx = _translationEnd.x + (t.x-_translationStart.x);
    float dy = _translationEnd.y - (t.y-_translationStart.y);
    _translationEnd = GLKVector2Make(dx, dy);
    _translationStart = GLKVector2Make(t.x, t.y);
    self.state = S_TRANSLATION;
}

- (void)rotate:(GLKVector3)r withMultiplier:(float)m
{
    float dx = r.x - _rotationStart.x;
    float dy = r.y - _rotationStart.y;
    float dz = r.z - _rotationStart.z;
    _rotationStart = GLKVector3Make(r.x, r.y, r.z);
    _rotationEnd = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(dx*m, _up), _rotationEnd);
    _rotationEnd = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(dy*m, _right), _rotationEnd);
    _rotationEnd = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-dz, _front), _rotationEnd);
    self.state = S_ROTATION;
}

- (GLKMatrix4)getModelViewMatrix
{
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    GLKMatrix4 quaternionMatrix = GLKMatrix4MakeWithQuaternion(_rotationEnd);
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, _translationEnd.x, _translationEnd.y, -_depth);
    modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, quaternionMatrix);
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, _scaleEnd, _scaleEnd, _scaleEnd);
    return modelViewMatrix;
}


@end
