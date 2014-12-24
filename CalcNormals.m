//
//  CalcNormals.m
//
//  Created by Jim Love on 5/26/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//

#import "CalcNormals.h"
#import "common.h"

@implementation CalcNormals


- (id)initWithPolygonArray:(NSMutableArray*)polygonArray
{
    self=[super init];
    
    if(self)
    {
        polyArray = polygonArray;
    }
    
    return self;
}


- (void)buildNormalsWithVertexArray:(NSMutableArray *)vArray destVertexNorms:(NSMutableArray *)vnArray destFaceNorms:(NSMutableArray *)fnArray
{
    NSLog(@"Face Normal IN:");
    
    // Calculate a face normal array so we can calculate vertex normals later
    NSMutableArray *faceNormal = [[NSMutableArray alloc] init];
    GLuint vertNumber1, vertNumber2, vertNumber3;
    Triangle3D polygon;
    NSUInteger k = [polyArray count];
    NSUInteger z = [vArray count];
    
    
    NSLog(@"Poly Array Count %lu, vArray count %lu:", (unsigned long)k, (unsigned long)z);
    for (int i = 0; i < k; i++) {
        [faceNormal removeAllObjects]; //make sure to empty the array with each pass
        
        vertNumber1 = (GLuint)[[[polyArray objectAtIndex:i] objectAtIndex:0]integerValue];
        vertNumber2 = (GLuint)[[[polyArray objectAtIndex:i] objectAtIndex:1]integerValue];
        vertNumber3 = (GLuint)[[[polyArray objectAtIndex:i] objectAtIndex:2]integerValue];
        
        if((vertNumber1 < z) && (vertNumber2 < z) && (vertNumber3 < z)){
            
            //NSLog(@"vert numbers: %u, %u, %u", vertNumber1, vertNumber2, vertNumber3);
            
            //NSLog(@"45");
            polygon.v1.x = [[[vArray objectAtIndex:vertNumber1] objectAtIndex:0] floatValue];
            polygon.v1.y = [[[vArray objectAtIndex:vertNumber1] objectAtIndex:1] floatValue];
            polygon.v1.z = [[[vArray objectAtIndex:vertNumber1] objectAtIndex:2] floatValue];
            //NSLog(@"50");
            polygon.v2.x = [[[vArray objectAtIndex:vertNumber2] objectAtIndex:0] floatValue];
            polygon.v2.y = [[[vArray objectAtIndex:vertNumber2] objectAtIndex:1] floatValue];
            polygon.v2.z = [[[vArray objectAtIndex:vertNumber2] objectAtIndex:2] floatValue];
            
            //NSLog(@"55");
            polygon.v3.x = [[[vArray objectAtIndex:vertNumber3] objectAtIndex:0] floatValue];
            polygon.v3.y = [[[vArray objectAtIndex:vertNumber3] objectAtIndex:1] floatValue];
            polygon.v3.z = [[[vArray objectAtIndex:vertNumber3] objectAtIndex:2] floatValue];
            
            //NSLog(@"60");
            //normalize AND for some reason, this normal needs flipping
            normalVector newNormal = flipNormal(calculateTriangleSurfaceNormal(polygon));
            //normalVector newNormal = calculateTriangleSurfaceNormal(polygon);
            [faceNormal addObject:[NSNumber numberWithFloat:newNormal.x]];
            [faceNormal addObject:[NSNumber numberWithFloat:newNormal.y]];
            [faceNormal addObject:[NSNumber numberWithFloat:newNormal.z]];
            
            [fnArray addObject:[NSMutableArray arrayWithArray:faceNormal]];
            //NSLog(@"Face normal %i:", i);
            //NSLog(@"Face Normal %i:%@", i, [faceNormalsArray objectAtIndex:i]);
        }
    }
    
    // Calculate a vertex normal array
    NSMutableArray *vertexNormal = [[NSMutableArray alloc] init];
    normalVector tempNormal;
    NSLog(@"Face Normal HALF:");
    for (int i = 0; i < [vArray count]; i++) {//loop through vertices
        [vertexNormal removeAllObjects];
        tempNormal.x = 0;
        tempNormal.y = 0;
        tempNormal.z = 0;

        for (int j=0; j < [polyArray count]; j++) {//loop through polys' verts
            for (int k = 0; k < 3; k++) {
                
                if(j< [fnArray count]) {
                    if ([[[polyArray objectAtIndex:j] objectAtIndex:k]integerValue] == i){
                        tempNormal.x += [[[fnArray objectAtIndex:j] objectAtIndex:0] floatValue];
                        tempNormal.y += [[[fnArray objectAtIndex:j] objectAtIndex:1] floatValue];
                        tempNormal.z += [[[fnArray objectAtIndex:j] objectAtIndex:2] floatValue];
                    }
                }
            }
        }
        
        normalVector normalizedNormal = normalizeVector(tempNormal);
        [vertexNormal addObject:[NSNumber numberWithFloat:normalizedNormal.x]];
        [vertexNormal addObject:[NSNumber numberWithFloat:normalizedNormal.y]];
        [vertexNormal addObject:[NSNumber numberWithFloat:normalizedNormal.z]];
        
        //store it
        [vnArray addObject:[NSMutableArray arrayWithArray:vertexNormal]];
        //NSLog(@"Vertex Normal %i:%@", i, [vertexNormalsArray objectAtIndex:i]);
        
    }
    NSLog(@"Face Normal OUT:");
    
    
}


- (void)buildFlatNormalsWithVertexArray:(NSMutableArray *)vArray destVertexNorms:(NSMutableArray *)vnArray destFaceNorms:(NSMutableArray *)fnArray
{
    
    // Calculate a face normal array so we can calculate vertex normals later
    NSMutableArray *faceNormal = [[NSMutableArray alloc] init];
    [faceNormal removeAllObjects];
    normalVector newNormal;
    newNormal.x = -0.0;
    newNormal.y = 1.0;
    newNormal.z = -0.0;
    
    //normalVector newNormal = calculateTriangleSurfaceNormal(polygon);
    [faceNormal addObject:[NSNumber numberWithFloat:newNormal.x]];
    [faceNormal addObject:[NSNumber numberWithFloat:newNormal.y]];
    [faceNormal addObject:[NSNumber numberWithFloat:newNormal.z]];
    
    for (int i = 0; i < [polyArray count]; i++) {
        if(i< [fnArray count]) {
            [fnArray addObject:[NSMutableArray arrayWithArray:faceNormal]];
            //NSLog(@"Face Normal %i:%@", i, [faceNormalsArray objectAtIndex:i]);
        }
    }
    
    // Calculate a vertex normal array
    NSMutableArray *vertexNormal = [[NSMutableArray alloc] init];
    [vertexNormal removeAllObjects];
    normalVector normalizedNormal;
    normalizedNormal.x = -0.0;
    normalizedNormal.y = 1.0;
    normalizedNormal.z = -0.0;

    for (int i = 0; i < [vArray count]; i++) {//loop through vertices
        [vertexNormal addObject:[NSNumber numberWithFloat:normalizedNormal.x]];
        [vertexNormal addObject:[NSNumber numberWithFloat:normalizedNormal.y]];
        [vertexNormal addObject:[NSNumber numberWithFloat:normalizedNormal.z]];
        
        //store it
        [vnArray addObject:[NSMutableArray arrayWithArray:vertexNormal]];
        //NSLog(@"Vertex Normal %i:%@", i, [vertexNormalsArray objectAtIndex:i]);
    }
    
}



@end
