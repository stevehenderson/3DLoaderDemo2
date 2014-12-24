//
//  Shader.vsh
//  Created by Jim Love on 2/7/14.
//  Copyright (c) 2014 Jim Love. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 texture0;
//attribute vec2 texture1;

varying lowp vec4 vColor;
varying lowp vec2 texcoord0;
//varying lowp vec2 texcoord1;

mat4 modelViewProjectionMatrix;
uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;
uniform mat3 normalMatrix;

void main(void)
{
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 2.0);
    vec4 diffuseColor = vec4(1.2, 1.2, 1.2, 1.0);
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    
    vColor = vec4((diffuseColor * nDotVP).xyz, diffuseColor.a);
    texcoord0 = texture0.st;
    //texcoord1 = texture1.st;
    
    modelViewProjectionMatrix = projectionMatrix * modelMatrix;
    gl_Position = modelViewProjectionMatrix * position;
}
