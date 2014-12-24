//
//  common.h
//
//  Created by Jim Love on 5/23/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//

#ifndef common_h
#define common_h

#define PI 3.141592

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
}positionVector;

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
}normalVector;

typedef struct {
    GLfloat u;
    GLfloat v;
}textureCoord;

typedef struct {
    positionVector v1;
    positionVector v2;
    positionVector v3;
} Triangle3D;

typedef struct
{
    positionVector position;
    normalVector normal;
    textureCoord texCoords0;
    textureCoord texCoords1;
} MeshVertex;


float ReverseFloat( float inFloat );
normalVector normalizeVector(normalVector vector);
normalVector calculateTriangleSurfaceNormal(Triangle3D triangle);
normalVector flipNormal(normalVector vector);

#endif

