//
//  ReadVertexData.m
//
//  Created by Jim Love on 5/26/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//

#import "ReadVertexData.h"

@implementation ReadVertexData

@synthesize vertCount;

- (id)initWithVertexCount:(int)vertexCount
{
    self=[super init];
    
    if(self)
    {
        vertCount = vertexCount;
    }
    
    return self;
}


- (void)readVertexData:(NSData *)vertexBuffer withDestinationArray:(NSMutableArray *)vertexArray
{
    // Load vertex data into vertexArray - an array where each element is a vector of 3 floats
    NSMutableArray * positionVectors = [[NSMutableArray alloc]init];
    NSRange byteRange;
    byteRange.length = sizeof(GLfloat);
    byteRange.location = 0;
    GLfloat tempFloat;
    GLfloat flippedFloat;
    
    
    for (int i = 0; i < vertCount; i++) {
        [positionVectors removeAllObjects]; //empty the array
        for (int j = 0; j < 3; j++) {
            [vertexBuffer getBytes:&tempFloat range:byteRange];
            flippedFloat = ReverseFloat(tempFloat);
            [positionVectors addObject:[NSNumber numberWithFloat:flippedFloat]];
            byteRange.location += byteRange.length;
        }
        [vertexArray addObject:[NSMutableArray arrayWithArray:positionVectors]];
        //NSLog(@"%@", vertexArray[i]);
        byteRange.location += sizeof(GLfloat);//skip 4 bytes
    }
}



@end