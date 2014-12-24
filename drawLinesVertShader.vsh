//
//  drawLinesVertShader.vsh
//  Created by Jim Love on 2/26/14.
//  Copyright (c) 2014 Jim Love. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 texture0;
//attribute vec2 texture1;

varying lowp vec4 colorVarying;
 
mat4 modelViewProjectionMatrix;
uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;
uniform mat3 normalMatrix;

 
void main()
{

    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(1.0, 0.49, 0.19, 1.0);
    
    vec2 texcoord0 = texture0.st;//dummy line - not used
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    
    colorVarying = diffuseColor * nDotVP;
    //colorVarying = diffuseColor;
    
    gl_PointSize = 4.0;
    
    modelViewProjectionMatrix = projectionMatrix * modelMatrix;
    gl_Position = modelViewProjectionMatrix * position;

}
