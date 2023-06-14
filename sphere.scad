difference() {
sphere(30);
translate([-40,-40,-90]) cube(80);
    translate([0,0,-1]) {
difference() {
cylinder(h = 20, r = 4, center = true);
translate([1.5,-10,-15]) cube(30);  
  translate([-30 - 1.5,-10,-15]) cube(30);  
}
}
}

