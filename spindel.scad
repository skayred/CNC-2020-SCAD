mount_width = 90;
mount_height = 39;
mount_depth = 68;
mount_depth_thin = 54;
mount_front_wide = 55;
mount_front_thin = 27;

screw_holes_width_dist = 69;
screw_holes_height_dist = 20;

spindel_motor_length = 120;
spindel_total_length = 200;
spindel_neck_dia = 26;
spindel_fan_distance = 10;
spindel_cooler_length = 32;
spindel_tool_length = spindel_total_length - spindel_motor_length - spindel_cooler_length;
spindel_dia = 52;
spindel_margin = 8;

module screw_holes() {
    rotate([0, 90, 0])
    for(x = [-1, 1], y = [-1, 1])
        if(x < 0 || screw_holes_width_dist)
            translate([x * screw_holes_height_dist / 2, y * screw_holes_width_dist / 2, 0])
                children();
}

module cutout() {
    translate([mount_depth_thin, mount_width / 2, -1 * mount_height / 2 - 1])
    rotate([0, 0, -90])
    linear_extrude(mount_height + 2)
    polygon([
        [-1,0],
        [(mount_width - mount_front_wide) / 2, 0],
        [(mount_width - mount_front_thin) / 2, mount_depth - mount_depth_thin],
        [(mount_width - mount_front_thin) / 2, mount_depth - mount_depth_thin + 1],
        [-1, mount_depth - mount_depth_thin + 1],
    ]);
}

module spindel_mount() {
    color("#acacac") {
        difference() {
            translate([0, -1 * mount_width / 2, -1 * mount_height / 2]) {
                cube([mount_depth, mount_width, mount_height]);            
            }
            translate([spindel_dia/2 + spindel_margin, 0, -25]) cylinder(50, spindel_dia/2, spindel_dia/2);
            translate([-1, 0, 0]) screw_holes() cylinder(mount_depth + 2, 3, 3);

            cutout();
            mirror([0, 180, 0]) cutout();
        }
    }
}

module spindel() {
    translate([spindel_dia/2 + spindel_margin, 0, -1 * mount_height / 2]) {
        color("#000") {
            cylinder(spindel_motor_length, spindel_dia / 2, spindel_dia / 2);
            translate([0, 0, spindel_motor_length]) cylinder(spindel_fan_distance, spindel_neck_dia / 2, spindel_neck_dia / 2);
            translate([0, 0, spindel_motor_length + 10]) cylinder(spindel_cooler_length - spindel_fan_distance, spindel_dia / 2, spindel_dia / 2);
        }
        color("#acacac") translate([0, 0, -1 * spindel_tool_length]) cylinder(spindel_tool_length, spindel_neck_dia / 2, spindel_neck_dia / 2);
        color("#f0f0f0") translate([0, 0, -1 * spindel_tool_length - 20]) cylinder(20, 3, 3);
    }
}
