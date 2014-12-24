//
//  common.m
//
//  Created by Jim Love on 5/26/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//
#import "common.h"


float ReverseFloat( float inFloat )
{
    float retVal;
    char *floatToConvert = ( char* ) & inFloat;
    char *returnFloat = ( char* ) & retVal;
    
    // swap the bytes into a temporary buffer
    returnFloat[0] = floatToConvert[3];
    returnFloat[1] = floatToConvert[2];
    returnFloat[2] = floatToConvert[1];
    returnFloat[3] = floatToConvert[0];
    
    return retVal;
}

normalVector normalizeVector(normalVector vector)
{
    float normLen = sqrt((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z));
    vector.x/= normLen;
    vector.y/= normLen;
    vector.z/= normLen;
    return vector;
}

normalVector calculateTriangleSurfaceNormal(Triangle3D triangle)
{
    normalVector surfaceNormal;
    
    surfaceNormal.x = (triangle.v1.z - triangle.v2.z) * (triangle.v3.y - triangle.v2.y) - (triangle.v1.y - triangle.v2.y) * (triangle.v3.z - triangle.v2.z);
    surfaceNormal.y = (triangle.v1.x - triangle.v2.x) * (triangle.v3.z - triangle.v2.z) - (triangle.v1.z - triangle.v2.z) * (triangle.v3.x - triangle.v2.x);
    surfaceNormal.z = (triangle.v1.y - triangle.v2.y) * (triangle.v3.x - triangle.v2.x) - (triangle.v1.x - triangle.v2.x) * (triangle.v3.y - triangle.v2.y);
    
    //Normalize the vector
    normalVector NormalizedNormal = normalizeVector(surfaceNormal);
    return NormalizedNormal;
}

normalVector flipNormal(normalVector vector)
{
    vector.x*= -1;
    vector.y*= -1;
    vector.z*= -1;
    return vector;
}

