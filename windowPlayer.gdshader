shader_type canvas_item;
const float downscaling = 0.111;
const int size = 997;
const float speed = 20.0;

void fragment() {
	int fCol = int((UV.x/float(downscaling)))+int(UV.y/float(downscaling))+int(TIME*speed);
    int col = fCol % size;
    
    if(sin(float(col)) < float((int(fract(UV).x*999.0)^int(fract(UV).y*999.0))%100)/100.0)
    {
        COLOR += vec4(0,0.1,0,1);
    }
	else{
		COLOR*=vec4(0.5,0.7,1,1);
	}
}