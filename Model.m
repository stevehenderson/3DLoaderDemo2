//
//  Model.m
//  LabTest3
//
//  Created by Steve Henderson on 12/21/14.
//  Copyright (c) 2014 Jim Love. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize projectionMatrix;
@synthesize viewMatrix;
@synthesize modelMatrix;
@synthesize normalMatrix;
@synthesize model;
@synthesize texture;


- (id)initModel:(NSString *)modelFilename withMesh:(NSString *)meshName withTexture:(NSString *)modelTextureFilename
{
    self=[super init];
    
    if(self)
    {
        NSError *error;
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft];

        
        //Drop in CheetahLoader stuff here
        model = [[Cheetah3DLoader new] initWithJASFileName:modelFilename];
        [model LoadCheetah3DModel:meshName];
        //TODO:  This is hard coded to png..fix to allow other types?
        NSString* filePath = [[NSBundle mainBundle] pathForResource:modelTextureFilename ofType:@"png"];
        texture = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:&error];
        if(error) {
            NSLog(@"Error loading texture from image: %@", error);
            exit(1);
        }
        
    }
    
    return self;
}

@end
