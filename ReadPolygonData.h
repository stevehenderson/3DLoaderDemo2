//
//  ReadPolygonData.h
//
//  Created by Jim Love on 5/26/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"

@interface ReadPolygonData : NSObject

@property   int      polygonCount;
@property   NSData*  UVBuffer;
@property   NSData*  polygonBuffer;

- (id)initWithPolygonCount:(int)polyCount :(NSData *)UVBuffer :(NSData *)polyBuffer;
- (void)buildPolygonsAndUVsWithDestArray:(NSMutableArray *)polygonArray destUVs0:(NSMutableArray *)UVArray0 destUVs1:(NSMutableArray *)UVArray0;

@end
