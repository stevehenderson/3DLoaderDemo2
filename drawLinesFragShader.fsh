//
//  drawLinesFragShader.fsh
//  Created by Jim Love on 2/26/14.
//  Copyright (c) 2014 Jim Love. All rights reserved.
//

 varying lowp vec4 colorVarying;
 
 void main()
 {
     gl_FragColor = colorVarying;
 }
