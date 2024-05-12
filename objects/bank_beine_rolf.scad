module rolfsDing (height, width, depth, wall) {
    difference() {
        cube([width+wall*2, depth+wall*2, height]);
        
        translate([wall, wall, 5])
        cube([width, depth, height]);
    }
}

rolfsDing(height=30, width=40.2, depth=20.2, wall=3);