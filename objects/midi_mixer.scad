module fader() {
    translate([160/2,16/2,7/2])
    difference() {
        union(){
            // Body
            cube([160, 16, 7], center=true);
            // Slider slot
            translate([12.5,0,6.5])
            cube([100, 1, 5], center=true);
        }
        union() {
            // Mounting holes
            translate([77.15,0,-5])
            #cylinder(r=1.5, h=20);
            translate([-77.15,0,-5])
            #cylinder(r=1.5, h=20);   
        }
    };
}

module box() {
    wall = 2;
    difference() {
        cube([170, 100, 35]);
        
        translate([wall/2, wall/2, wall+0.1])
        cube([170-wall, 100-wall, 35-wall]);
    }
    translate([6,6,0])
    cylinder(r=6, h=35-wall);
    
    translate([0+6,100-6,0])
    cylinder(r=6, h=35-wall);
    
    translate([170-6,6,0])
    difference() {
        cylinder(r=6, h=35-wall);
        translate([0,0,25])
        cylinder(r=3,h=10);
    }
    translate([170-6,100-6,0])
    cylinder(r=6, h=35-wall);
}

// Parameters


module frontPanel() {
    difference() {
        cube([175,120,2]);
        translate([5, 0, -8]) {
            for (i = [0:3]) {
                translate([0, i * 20, 0])
                fader();
            }   
        }
    }

}



frontPanel();

// ArduinoMount
// FaderMount


//sbox();