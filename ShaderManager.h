//
//  ShaderManager.h
//  Created by Jim Love on 8/9/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ShaderManager : NSObject

- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename fragmentShaderFilename:(NSString *)fShaderFilename;
- (void)use;

@end
