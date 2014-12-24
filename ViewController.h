//
//  ViewController.h
//  Created by Jim Love on 2/7/14.
//  Copyright (c) 2014 Jim Love. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "Cheetah3DLoader.h"
#import "Camera.h"
#import "Model.h"
#import "ShaderManager.h"
#import "TouchMatrix.h"

#define MODEL_COUNT 2


@interface ViewController : GLKViewController
{
    //Cheetah3DLoader *myModel;
    NSMutableArray  *models;
    Camera          *myCamera;
    //GLKTextureInfo  *texture;
    ShaderManager   *lineShader;
    ShaderManager   *textureShader;
}

@end
