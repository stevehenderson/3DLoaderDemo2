//
//  model.h
//  LabTest3
//
//  Created by Steve Henderson on 12/21/14.
//  Copyright (c) 2014 Jim Love. All rights reserved.
//

#import "Cheetah3DLoader.h"

@interface Model : NSObject
{
    
}

@property GLKMatrix4 projectionMatrix;
@property GLKMatrix4 viewMatrix;
@property GLKMatrix4 modelMatrix;
@property GLKMatrix3 normalMatrix;
@property Cheetah3DLoader *model;
@property GLKTextureInfo  *texture;


- (id)initModel:(NSString *)modelFilename withMesh:(NSString *)meshName withTexture:(NSString *)modelTextureFilename;

//- (id)initAsLandscape:(BOOL)orientation;

//- (void)LoadCameraNamed:(NSString *)cameraName;
//- (GLKMatrix4)getProjectionMatrix;
//- (GLKMatrix4)LookAt:(GLKVector3)aPosition;
//- (void)scaleFOV:(GLfloat)scale;
//- (void)SetCameraPosition:(GLKVector3)newPosition;
//- (void)SetCameraUpDirection:(GLKVector3)thisIsUp;
//- (void)CalculateCameraUp;

@end
