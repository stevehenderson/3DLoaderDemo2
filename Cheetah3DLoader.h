//
//  Cheetah3DLoader.h
//
//  Created by Jim Love on 5/12/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "common.h"
#import "ReadVertexData.h"
#import "ReadPolygonData.h"
#import "CalcNormals.h"


@interface Cheetah3DLoader : NSObject {
    NSString    *JASfileName;
}

@property GLuint triangleVertCount;
@property GLuint vertexArrayBuffer;
@property GLuint vertexArray;
@property GLKVector3 scale;
@property GLKVector3 rotation;
@property GLKVector3 position;


- (id)initWithJASFileName:(NSString *)filename;
- (void)LoadCheetah3DModel:(NSString *)objectName;

@end
