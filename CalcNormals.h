//
//  CalcNormals.h
//
//  Created by Jim Love on 5/26/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcNormals : NSObject{
    NSMutableArray *polyArray;
}

- (id)initWithPolygonArray:(NSMutableArray*)polygonArray;
- (void)buildNormalsWithVertexArray:(NSMutableArray *)vArray destVertexNorms:(NSMutableArray *)vnArray destFaceNorms:(NSMutableArray *)fnArray;
- (void)buildFlatNormalsWithVertexArray:(NSMutableArray *)vArray destVertexNorms:(NSMutableArray *)vnArray destFaceNorms:(NSMutableArray *)fnArray;

@end
