//
//  Camera.m
//  Created by Jim Love on 8/9/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//

/*
 This class reads the camera information from the specified Cheetah 3D .jas file and
 creates a viewMatrix to be used by shaders. Further, changing the camera position,
 rotation, target, and viewAngle (the field of view) mimic the typical things you do
 with a real-world camera like pan, dolly, zoom, etc.
*/

#import "Camera.h"

@implementation Camera

@synthesize cameraTransformMatrix;
@synthesize FOVangle;
@synthesize screenWidth;
@synthesize clipNear;
@synthesize clipFar;
@synthesize cameraPosition;
@synthesize cameraRotation;
@synthesize target;
@synthesize up;


// Designated initializer
- (id)initAsLandscape:(BOOL)orientation
{
    self=[super init];
    
    if(self)
    {
        FOVangle = 65.0f;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        if (orientation == YES) {
            aspectRatio = fabsf(screenHeight/screenWidth);// h/w for landscape mode
        }else{
            aspectRatio = fabsf(screenWidth/screenHeight);// w/h for portrait mode
        }
        
        clipNear = 0.1f;
        clipFar = 1000.0f;
        cameraPosition = (GLKVector3){0.0f, 0.0f, 0.0f};
        cameraRotation = (GLKVector3){0.0f, 0.0f, 0.0f};
        cameraTransformMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(cameraRotation.y), 0.0f, 1.0f, 0.0f);
        cameraTransformMatrix = GLKMatrix4RotateX(cameraTransformMatrix, GLKMathDegreesToRadians(cameraRotation.x));
        cameraTransformMatrix = GLKMatrix4RotateZ(cameraTransformMatrix, GLKMathDegreesToRadians(cameraRotation.z));
        cameraTransformMatrix = GLKMatrix4Translate(cameraTransformMatrix, cameraPosition.x, cameraPosition.y, cameraPosition.z);
        up = (GLKVector3){0.0f, 1.0f, 0.0f};
        target = (GLKVector3){0.0f, 0.0f, 0.0f};
    }
    
    return self;
}

- (id)initWithJASFileName:(NSString *)filename isLandscape:(BOOL)orientation
{
    self=[super init];
    
    if(self)
    {
        JASfileName = [[NSBundle mainBundle] pathForResource:filename ofType:@"jas"];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        if (orientation == YES) {
            aspectRatio = fabsf(screenHeight/screenWidth);// h/w for landscape mode
        }else{
            aspectRatio = fabsf(screenWidth/screenHeight);// w/h for portrait mode
        }
        
    }
    
    return self;
}

- (void)LoadCameraNamed:(NSString *)cameraName{
    NSDictionary *cheetahFile = [NSDictionary dictionaryWithContentsOfFile:JASfileName];
    NSArray *objectArray = [cheetahFile objectForKey:@"Objects"];
    NSDictionary *camera = [NSDictionary new];
    Boolean cameraFound = false;
    
    // Find the object index by name
    for (int i = 0; i < [objectArray count]; i++) {
        camera = [objectArray objectAtIndex:i];
        NSString *testString = camera[@"name"];
        if ([testString isEqualToString:cameraName]) {
            cameraFound = true;
            break; //get out of the loop we found the right one
        }
    }
    if(cameraFound == false){
        NSLog(@"Error: No camera exists with the name: %@", cameraName);
        exit(1);
    }
    cheetahFile = nil;//free up some memory
    objectArray = nil;//free up some memory
    
    cameraPosition.x = [[[camera valueForKey:@"position"]objectAtIndex:0]floatValue];
    cameraPosition.y = [[[camera valueForKey:@"position"]objectAtIndex:1]floatValue];
    cameraPosition.z = [[[camera valueForKey:@"position"]objectAtIndex:2]floatValue];
    
    cameraRotation.y = [[[camera valueForKey:@"rotation"]objectAtIndex:0]floatValue];
    cameraRotation.x = [[[camera valueForKey:@"rotation"]objectAtIndex:1]floatValue];
    cameraRotation.z = [[[camera valueForKey:@"rotation"]objectAtIndex:2]floatValue];
    
    clipFar = [[camera valueForKey:@"cameraClipFar"]floatValue];
    clipNear = [[camera valueForKey:@"cameraClipNear"]floatValue];
    FOVangle = [[camera valueForKey:@"cameraFieldOfView"]floatValue];
    
    target = (GLKVector3){0.0f, 0.0f, 0.0f};
    
    cameraTransformMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(cameraRotation.y), 0.0f, 1.0f, 0.0f);
    cameraTransformMatrix = GLKMatrix4RotateX(cameraTransformMatrix, GLKMathDegreesToRadians(cameraRotation.x));
    cameraTransformMatrix = GLKMatrix4RotateZ(cameraTransformMatrix, GLKMathDegreesToRadians(cameraRotation.z));
    cameraTransformMatrix = GLKMatrix4Translate(cameraTransformMatrix, cameraPosition.x, cameraPosition.y, cameraPosition.z);
    
    [self CalculateCameraUp];

}

- (GLKMatrix4)getProjectionMatrix
{
    GLKMatrix4 myProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(FOVangle), aspectRatio, clipNear, clipFar);
    return myProjectionMatrix;
}

- (GLKMatrix4)LookAt:(GLKVector3)aPosition
{
    target = aPosition;
    [self CalculateCameraUp];
    GLKMatrix4 newViewMatrix = GLKMatrix4MakeLookAt(cameraPosition.x, cameraPosition.y, cameraPosition.z, target.x, target.y, target.z, up.x, up.y, up.z);
    return newViewMatrix;
}

- (void)scaleFOV:(GLfloat)scale
{
    GLfloat percentage = (1.0 - (scale * 0.1));
    if (scale > 0.5f) {
        FOVangle += percentage;
    }else{
        FOVangle -= percentage;
    }
    //FOVangle = (scale * 0.1f);
    NSLog(@"FOV: %.1f Scale: %.1f Perc: %.1f", FOVangle, scale, percentage);
}

- (void)SetCameraPosition:(GLKVector3)newPosition
{
    cameraPosition = newPosition;
}

- (void)SetCameraUpDirection:(GLKVector3)thisIsUp
{
    up = thisIsUp;
}

- (void)CalculateCameraUp
{
    up = (GLKVector3){cameraTransformMatrix.m10, cameraTransformMatrix.m11, cameraTransformMatrix.m12};
}


@end
