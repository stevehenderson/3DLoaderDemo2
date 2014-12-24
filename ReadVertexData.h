//
//  ReadVertexData.h
//
//  Created by Jim Love on 5/26/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"

@interface ReadVertexData : NSObject
    

@property int vertCount;

- (id)initWithVertexCount:(int)vertexCount;
- (void)readVertexData:(NSData *)vertexBuffer withDestinationArray:(NSMutableArray *)vertexArray;

@end