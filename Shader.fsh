//
//  Shader.fsh
//  Test3D
//
//  Created by Steve Henderson on 12/4/14.
//  Copyright (c) 2014 Steve Henderson. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
