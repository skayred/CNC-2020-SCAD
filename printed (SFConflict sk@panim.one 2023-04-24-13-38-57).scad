include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/rod.scad>

include <params.scad>

mount_width = 30;
mount_height = 30;
base_height = 7;

module carriage_to_2020() {
    difference() {
        translate([-1 * mount_width / 2, -1 * mount_height / 2, 0]) cube([mount_width, mount_height, 6 + base_height + profile_size / 2]);
        translate([0, 0, -10]) carriage_hole_positions(MGN12H_carriage) cylinder(30, 1.5, 1.5);
        translate([-1 * mount_width / 2 - 1, -1 * profile_size / 2, base_height]) cube([mount_height + 2, profile_size, 6 + profile_size / 2 + 1]);

        translate([profile_size / 2, 20, base_height + profile_size / 2]) {
            rotate([90, 0, 0]) cylinder(10, profile_screw_dia/2, profile_screw_dia/2);
            translate([0, -30, 0]) rotate([90, 0, 0]) cylinder(10, profile_screw_dia/2, profile_screw_dia/2);

            translate([-1 * profile_size, 0, 0]) rotate([90, 0, 0]) cylinder(10, profile_screw_dia/2, profile_screw_dia/2);            
            translate([-1 * profile_size, -30, 0]) rotate([90, 0, 0]) cylinder(10, profile_screw_dia/2, profile_screw_dia/2);
        }
    }
}
