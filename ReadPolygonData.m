//
//  ReadPolygonData.m
//
//  Created by Jim Love on 5/26/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//

#import "ReadPolygonData.h"

@implementation ReadPolygonData


@synthesize polygonCount, UVBuffer, polygonBuffer;

- (id)initWithPolygonCount:(int)polyCount :(NSData *)UVsBuffer :(NSData *)polyBuffer
{
    self=[super init];
    
    if(self)
    {
        polygonCount = polyCount;
        UVBuffer = UVsBuffer;
        polygonBuffer = polyBuffer;
    }
    
    return self;
}

    //This method supports loading quads and triangles in a mixed model. A capped cylinder, for example,
    //contains both triangles and quads.
- (void)buildPolygonsAndUVsWithDestArray:(NSMutableArray *)polygonArray destUVs0:(NSMutableArray *)UVArray0 destUVs1:(NSMutableArray *)UVArray1{
    NSMutableArray *vertexIndexArray = [[NSMutableArray alloc]init];
    NSMutableArray *tempUVs = [[NSMutableArray alloc]init];
    NSMutableArray *tempUVsV1 = [[NSMutableArray alloc]init];
    NSMutableArray *tempUVsV3 = [[NSMutableArray alloc]init];
    NSMutableArray *tempUVsV1b = [[NSMutableArray alloc]init];
    NSMutableArray *tempUVsV3b = [[NSMutableArray alloc]init];
    NSRange byteRange;
    NSRange UVbyteRange;
    byteRange.length = sizeof(int);
    UVbyteRange.length = sizeof(GLfloat);
    byteRange.location = 0;
    UVbyteRange.location = 0;
    int tempInt = 0;
    int v1, v2, v3, v4;
    GLfloat tempFloat;
    GLfloat flippedFloat;
    
    byteRange.location += sizeof(GLfloat);//skip first 4 bytes which are fffffffd, a separator between sets of vertex indexes.
    
    for (int i = 0; i < polygonCount; i++) {
        
        [polygonBuffer getBytes:&tempInt range:byteRange];
        v1 = CFSwapInt32(tempInt);
        byteRange.location += byteRange.length;

        [polygonBuffer getBytes:&tempInt range:byteRange];
        v2 = CFSwapInt32(tempInt);
        byteRange.location += byteRange.length;
        
        [polygonBuffer getBytes:&tempInt range:byteRange];
        v3 = CFSwapInt32(tempInt);
        byteRange.location += byteRange.length;
        
        if (byteRange.location < polygonBuffer.length) {
            [polygonBuffer getBytes:&tempInt range:byteRange];
            v4 = CFSwapInt32(tempInt);
            byteRange.location += byteRange.length;
        }
        
        if (v4 < 0) { //The last 4 bytes read is not a real vertex index but a separator, so this is a triangle
            //Add this triangle
            [vertexIndexArray removeAllObjects]; //empty the array
            [vertexIndexArray addObject:[NSNumber numberWithInt:v1]];
            [vertexIndexArray addObject:[NSNumber numberWithInt:v2]];
            [vertexIndexArray addObject:[NSNumber numberWithInt:v3]];
            [polygonArray addObject:[NSMutableArray arrayWithArray:vertexIndexArray]];
            
            //Add the next 3 UVs to their UVArrays
            
            for (int p = 0; p < 3; p++) {
                [tempUVs removeAllObjects];
                for (int j = 0; j < 2; j++) {
                    [UVBuffer getBytes:&tempFloat range:UVbyteRange];
                    if (j==1) {
                        flippedFloat = 1-ReverseFloat(tempFloat);
                    }else{
                        flippedFloat = ReverseFloat(tempFloat);
                    }
                    [tempUVs addObject:[NSNumber numberWithFloat:flippedFloat]];
                    UVbyteRange.location += UVbyteRange.length;//advance 4 bytes
                }
                [UVArray0 addObject:[NSMutableArray arrayWithArray:tempUVs]];
     
                [tempUVs removeAllObjects];
                for (int j = 0; j < 2; j++) {
                    [UVBuffer getBytes:&tempFloat range:UVbyteRange];
                    if (j==1) {
                        flippedFloat = 1-ReverseFloat(tempFloat);
                    }else{
                        flippedFloat = ReverseFloat(tempFloat);
                    }
                    [tempUVs addObject:[NSNumber numberWithFloat:flippedFloat]];
                    UVbyteRange.location += UVbyteRange.length;//advance 4 bytes
                }
                [UVArray1 addObject:[NSMutableArray arrayWithArray:tempUVs]];
            }
            
        } else {
            //We must have 4 vertices in this poly, so we need to tesselate it.
            //This is how we break a quad into 2 triangles. Using 4 vertices, we add
            //2 triangles to our polygon array:
            
            //Add first triangle
            [vertexIndexArray removeAllObjects]; //empty the array
            [vertexIndexArray addObject:[NSNumber numberWithInt:v1]];
            [vertexIndexArray addObject:[NSNumber numberWithInt:v2]];
            [vertexIndexArray addObject:[NSNumber numberWithInt:v3]];
            [polygonArray addObject:[NSMutableArray arrayWithArray:vertexIndexArray]];
            
            //Add the next 3 UVs to UVArray
            //...and while we're looping, stash the 1st and 3rd to use later
            [tempUVsV1 removeAllObjects];
            [tempUVsV3 removeAllObjects];
            [tempUVsV1b removeAllObjects];
            [tempUVsV3b removeAllObjects];

            for (int p = 0; p < 3; p++) {
                [tempUVs removeAllObjects];
                for (int j = 0; j < 2; j++) {
                    [UVBuffer getBytes:&tempFloat range:UVbyteRange];
                    if (j==1) {
                        flippedFloat = 1-ReverseFloat(tempFloat);
                    }else{
                        flippedFloat = ReverseFloat(tempFloat);
                    }
                    [tempUVs addObject:[NSNumber numberWithFloat:flippedFloat]];
                    if (p==0) {//stash 1
                        [tempUVsV1 addObject:[NSNumber numberWithFloat:flippedFloat]];
                    }
                    if (p==2) {//stash 3
                        [tempUVsV3 addObject:[NSNumber numberWithFloat:flippedFloat]];
                    }
                    UVbyteRange.location += UVbyteRange.length;//advance 4 bytes
                }
                [UVArray0 addObject:[NSMutableArray arrayWithArray:tempUVs]];
                
                
                [tempUVs removeAllObjects];
                for (int j = 0; j < 2; j++) {
                    [UVBuffer getBytes:&tempFloat range:UVbyteRange];
                    if (j==1) {
                        flippedFloat = 1-ReverseFloat(tempFloat);
                    }else{
                        flippedFloat = ReverseFloat(tempFloat);
                    }
                    [tempUVs addObject:[NSNumber numberWithFloat:flippedFloat]];
                    if (p==0) {//stash 1
                        [tempUVsV1b addObject:[NSNumber numberWithFloat:flippedFloat]];
                    }
                    if (p==2) {//stash 3
                        [tempUVsV3b addObject:[NSNumber numberWithFloat:flippedFloat]];
                    }
                    UVbyteRange.location += UVbyteRange.length;//advance 4 bytes
                }
                [UVArray1 addObject:[NSMutableArray arrayWithArray:tempUVs]];
            }
            
            //Add second triangle
            [vertexIndexArray removeAllObjects]; //empty the array
            [vertexIndexArray addObject:[NSNumber numberWithInt:v3]];
            [vertexIndexArray addObject:[NSNumber numberWithInt:v4]];
            [vertexIndexArray addObject:[NSNumber numberWithInt:v1]];
            [polygonArray addObject:[NSMutableArray arrayWithArray:vertexIndexArray]];
            if (byteRange.location < polygonBuffer.length) { //check for the end of the buffer before skipping forward
                byteRange.location += sizeof(GLfloat);//skip 4 separator bytes
            }
            
            //Now read the next UV and combine it with 3 and 1 stashed from above and add to UVArrays in 3,4,1 order
            [tempUVs removeAllObjects];
            for (int j = 0; j < 2; j++) {
                [UVBuffer getBytes:&tempFloat range:UVbyteRange];
                if (j==1) {
                    flippedFloat = 1-ReverseFloat(tempFloat);
                }else{
                    flippedFloat = ReverseFloat(tempFloat);
                }
                [tempUVs addObject:[NSNumber numberWithFloat:flippedFloat]];
                UVbyteRange.location += UVbyteRange.length;//advance 4 bytes
            }
            [UVArray0 addObject:[NSMutableArray arrayWithArray:tempUVsV3]];
            [UVArray0 addObject:[NSMutableArray arrayWithArray:tempUVs]];
            [UVArray0 addObject:[NSMutableArray arrayWithArray:tempUVsV1]];
            
            [tempUVs removeAllObjects];
            for (int j = 0; j < 2; j++) {
                [UVBuffer getBytes:&tempFloat range:UVbyteRange];
                if (j==1) {
                    flippedFloat = 1-ReverseFloat(tempFloat);
                }else{
                    flippedFloat = ReverseFloat(tempFloat);
                }
                [tempUVs addObject:[NSNumber numberWithFloat:flippedFloat]];
                UVbyteRange.location += UVbyteRange.length;//advance 4 bytes
            }
            [UVArray1 addObject:[NSMutableArray arrayWithArray:tempUVsV3b]];
            [UVArray1 addObject:[NSMutableArray arrayWithArray:tempUVs]];
            [UVArray1 addObject:[NSMutableArray arrayWithArray:tempUVsV1b]];

            
        }//end else
        
    }//end loop i
}

@end
