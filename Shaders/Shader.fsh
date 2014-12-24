//
//  Shader.fsh
//  Created by Jim Love on 2/7/14.
//  Copyright (c) 2014 Jim Love. All rights reserved.
//

uniform sampler2D TextureSampler0;
uniform sampler2D TextureSampler1;
varying lowp vec4 vColor;
varying lowp vec2 texcoord0;
//varying lowp vec2 texcoord1;

void main(void)
{
    lowp vec4 color0 = texture2D(TextureSampler0, texcoord0);
    gl_FragColor = color0 * vColor;
}
