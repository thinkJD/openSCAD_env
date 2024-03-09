/*
    Clamp to hold my stove clamp on my office chair
*/

include <../libs/camfer.scad>;

module chairBracket(width=50, depth=60, height=5, wall=5, radius=5)
{
    rotate(0,0,0)
    union() {
        difference() {
            union() {
                chamferCube(
                  [ width+wall, depth+wall, height ],
                  [[1, 1, 1, 1], [1, 1, 1, 1], [1,1,1,1]]);
            }
            union() {
                translate([wall, 0, 0])
                cube([width-wall, depth, height+0.2]);
                
            }
        }
        translate([width, 0])
        cylinder(height, radius, radius);
    
    }
}

/* 
number = How many saw tooth?
height = Extrusion height
angle = value between 1 and 4 higher means steper angle
*/
module sawTooth(number, height, angle) {
    for( i= [ 0 : number ]) {
        translate([ 0, 3*i, 0 ])
        linear_extrude(height)
        polygon([[0, 0], [-3,0], [0,angle], [0, 0]]);    
    }
}


difference() {
    wall = 10;
    height = 15;
    width = 34;
    
    chairBracket(width=width, depth=50, height=height, wall=wall); 
    
    translate([wall, 0, 0])
    sawTooth(10, height, 3);
    

}