//void main()
//{
//    vec4 color = texture2D(u_texture, v_tex_coord);
//    float gradient = 0.0;
//    
//    if (v_tex_coord.y < 0.5){
//        gradient = 0.35 - v_tex_coord.y;
//    }
//    else if (v_tex_coord.y < 0.7){
//        gradient = -0.15 - v_tex_coord.y*0.005;
//    }
//    else if ( v_tex_coord.y >= 0.7){
//        gradient = -0.15 - 0.7*0.005;
//    }
//    color = vec4(gradient + color.r, gradient + color.g, gradient + color.b, color.a);
//    color.rgb *= color.a; // set background to alpha 0
//    gl_FragColor = color;
//}
void main()
{
    vec4 color = texture2D(u_texture, v_tex_coord);
    float gradient = 0.0;
    
        if (color.a > 0.1 && color.a < 0.99){
            gl_FragColor = vec4(0,0,0,1);
        }
        else{
                if (v_tex_coord.y < 0.5){
                    gradient = 0.35 - v_tex_coord.y;
                }
                else if (v_tex_coord.y < 0.7){
                    gradient = -0.15 - v_tex_coord.y*0.005;
                }
                else if ( v_tex_coord.y >= 0.7){
                    gradient = -0.15 - 0.7*0.005;
                }
            color = vec4(gradient + color.r, gradient + color.g, gradient + color.b, color.a);
            color.rgb *= color.a; // set background to alpha 0
            gl_FragColor = color;
        }
    
}
