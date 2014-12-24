//
//  ShaderManager.m
//  Created by Jim Love on 8/9/13.
//  Copyright (c) 2013 Jim Love. All rights reserved.
//

#import "ShaderManager.h"

enum
{
    UNIFORM_PROJECTION_MATRIX,
    UNIFORM_MODEL_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];


@interface ShaderManager()
{
    GLuint program;
    GLuint vertShader;
    GLuint fragShader;
}

@end
#pragma mark -

@implementation ShaderManager

- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename fragmentShaderFilename:(NSString *)fShaderFilename
{
    if (self = [super init])
    {
        NSString *vertShaderPathname, *fragShaderPathname;
        program = glCreateProgram();
        
        vertShaderPathname = [[NSBundle mainBundle] pathForResource:vShaderFilename ofType:@"vsh"];
        assert(vertShaderPathname);
        if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
            NSLog(@"Failed to compile vertex shader");
        
        // Create and compile fragment shader
        fragShaderPathname = [[NSBundle mainBundle] pathForResource:fShaderFilename ofType:@"fsh"];
        assert(fragShaderPathname);
        if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
            NSLog(@"Failed to compile fragment shader");
        }
        
        glAttachShader(program, vertShader);
        glAttachShader(program, fragShader);
        
        // Bind attribute locations.
        // This needs to be done prior to linking.
        glBindAttribLocation(program, GLKVertexAttribPosition, "position");
        glBindAttribLocation(program, GLKVertexAttribNormal, "normal");
        glBindAttribLocation(program, GLKVertexAttribTexCoord0, "texture0");
        //glBindAttribLocation(program, GLKVertexAttribTexCoord1, "texture1");
        
        // Link program.
        if (![self linkProgram:program]) {
            NSLog(@"Failed to link program: %d", program);
            
            if (vertShader) {
                glDeleteShader(vertShader);
                vertShader = 0;
            }
            if (fragShader) {
                glDeleteShader(fragShader);
                fragShader = 0;
            }
            if (program) {
                glDeleteProgram(program);
                program = 0;
            }
            
        }
        
        // Get uniform locations.
        uniforms[UNIFORM_PROJECTION_MATRIX] = glGetUniformLocation(program, "projectionMatrix");
        uniforms[UNIFORM_MODEL_MATRIX] = glGetUniformLocation(program, "modelMatrix");
        uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(program, "normalMatrix");
        
        // Release vertex and fragment shaders.
        if (vertShader) {
            glDetachShader(program, vertShader);
            glDeleteShader(vertShader);
        }
        if (fragShader) {
            glDetachShader(program, fragShader);
            glDeleteShader(fragShader);
        }

    }
    
    return self;
}

- (void)use
{
    glUseProgram(program);
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark -

- (void)dealloc
{
    if (vertShader)
        glDeleteShader(vertShader);
    
    if (fragShader)
        glDeleteShader(fragShader);
    
    if (program)
        glDeleteProgram(program);
}

@end
