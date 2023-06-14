include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/pillow_blocks.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>
include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/nuts.scad>

include <params.scad>

mount_width = 30;
mount_height = 30;
base_height = 7;

module vslot(length) {
    linear_extrude(length) polygon([
        [0, 0],
        [9.16, 0],
        [9.16 - (9.16 - 6.25)/2, -1.8],
        [(9.16 - 6.25)/2, -1.8]
    ]);
}

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

module beam_profile() {
    width = 5;
    polygon([
        [0, 0],
        [width, 0],
        [width, profile_size / 2 - width / 2],
        [profile_size - width, profile_size / 2 - width / 2],
        [profile_size - width, 0],
        [profile_size, 0],
        [profile_size, profile_size],
        [profile_size - width, profile_size],
        [profile_size - width, profile_size / 2 + width / 2],
        [width, profile_size / 2 + width / 2],
        [width, profile_size],
        [0, profile_size]
    ]);
}

module n_beam_profile() {
    width = 5;
    polygon([
        [0, 0],
        [profile_size, 0],
        [profile_size, profile_size],
        [profile_size - width, profile_size],
        [profile_size - width, width],
        [width, width],
        [width, profile_size],
        [0, profile_size]
    ]);
}

module beam(length) {
    union() {
        linear_extrude(length) beam_profile();

        translate([15, profile_size / 2, 0]) rotate([90, 0, 0]) extrusion_corner_bracket(E20_corner_bracket);
        translate([5, profile_size / 2, 0]) rotate([90, 0, 180]) extrusion_corner_bracket(E20_corner_bracket);

        translate([0, 0, length]) {
            translate([15, profile_size / 2, 0]) rotate([-90, 0, 0]) extrusion_corner_bracket(E20_corner_bracket);
            translate([5, profile_size / 2, 0]) rotate([-90, 0, 180]) extrusion_corner_bracket(E20_corner_bracket);
        }
    }
}

module angle(under_angle_edge = 25) {
    dia = sqrt(20*20 + 20*20);
    //under_angle_edge = 25;
    
    difference() {
        union() {
            translate([0, under_angle_edge / 2, under_angle_edge / 2]) rotate([45, 0, 0]) translate([0, 0, -1.5 * dia]) linear_extrude(3 * dia) n_beam_profile();
            translate([0, 0, under_angle_edge]) cube([20, 5, dia]);
            translate([0, under_angle_edge, 0]) cube([20, dia, 5]);
        }
        translate([0, -30, 0]) cube([20, 30, 60]);
        translate([0, 0, -30]) cube([20, 60, 30]);
        
        translate([10, 8 , under_angle_edge + dia/2]) rotate([90, 0, 0]) cylinder(10, 2.5, 2.5);
        translate([10, under_angle_edge + dia/2 , -2]) rotate([0, 0, 0]) cylinder(10, 2.5, 2.5);
    }
}

module bottom_stepper_mount() {
    pitch = NEMA_hole_pitch(NEMA17_40);
    mount_width = 50;

    cap_dia = 5.5;
    cap_depth = 3.5;

    difference() {
        union() {
            linear_extrude(9) NEMA_outline(NEMA17_40);
            translate([31/2, 31/2, 0]) cylinder(11, 5, 5);
            translate([-31/2, 31/2, 0]) cylinder(11, 5, 5);
            translate([-31/2, -31/2, 0]) cylinder(11, 5, 5);
        }
        translate([0, 0, -1]) cylinder(12, NEMA_boss_radius(NEMA17_40) + 1, NEMA_boss_radius(NEMA17_40) + 1);
        NEMA_screw_positions(NEMA17_40) cylinder(15, 1.5, 1.5);
        translate([0, 0, 9 - cap_depth]) NEMA_screw_positions(NEMA17_40) cylinder(10, cap_dia / 2, cap_dia / 2);
    }

    difference() {
        rotate([0, 0, 45]) {
            translate([-1 * mount_width / 2, -1 * profile_size + kp_base_height(KP08_15), 0]) cube([mount_width, 8, 9 + 20]);
        }
        cylinder(30, NEMA_boss_radius(NEMA17_40) + 1, NEMA_boss_radius(NEMA17_40) + 1);
        rotate([0, 0, 45]) {
            translate([18, -25, 9 + profile_size / 2]) rotate([0, 90, 90]) cylinder(50, 2.5, 2.5);
            translate([-18, -25, 9 + profile_size / 2]) rotate([0, 90, 90]) cylinder(50, 2.5, 2.5);
        }
    }
}

module limiter() {
    width = 30;
    translate([10, 0, profile_size / 2]) {
        difference() {
            cube([profile_size, width, 5]);
            translate([profile_size / 2, width / 2, 0]) cylinder(10, 1.5, 1.5);
            translate([profile_size / 2 - 0.5, width / 2, 0]) cylinder(10, 1.5, 1.5);
            translate([profile_size / 2 - 1, width / 2, 0]) cylinder(10, 1.5, 1.5);
            translate([profile_size / 2 - 1.5, width / 2, 0]) cylinder(10, 1.5, 1.5);
            translate([profile_size / 2 - 2, width / 2, 0]) cylinder(10, 1.5, 1.5);
            
            translate([profile_size, width / 2, 0]) cylinder(10, 1.5, 1.5);
        }
    }
}

module kp_installer() {
    difference() {
        cube([30, 50, 20]);
        translate([5, 0, 0,]) cube([20, 50, 10]);
        translate([(30-13)/2, 10, 10]) cube([13, 40, 10]);
    }
}

module bottom_aligner() {
    aligner_length = 65;
    difference() {
        cube([20, aligner_length, 15]);
        translate([0, 15 - 12/2, 0]) cube([20, 12, 8]);
    }
}

module profile_connector() {
    rotate([90, 0, 0]) rotate([0, 90, 0]) {
        difference() {
            union() {
                cube([2 * profile_size, 10, 5]);
                translate([0,10,0]) cube([2 * profile_size, 5, 10]);
                translate([0,-5,0]) cube([2 * profile_size, 5, 10]);
                translate([-1 * 9.16 / 2 + profile_size / 2, 10, 0]) rotate([90, 0, 0]) vslot(10);
                translate([-1 * 9.16 / 2 + profile_size + profile_size / 2, 10, 0]) rotate([90, 0, 0]) vslot(10);            }
            translate([profile_size / 2, 5, -10]) cylinder(20, 2.5, 2.5);
            translate([profile_size + profile_size / 2, 5, -10]) cylinder(20, 2.5, 2.5);
        }
    }
}

module endstop_base() {
    difference() {
        translate([-1 * pcb_length(RAMPSEndstop) / 2, -1 * pcb_width(RAMPSEndstop) / 2, 0]) cube([pcb_length(RAMPSEndstop),pcb_width(RAMPSEndstop),7]);

        pcb_hole_positions(RAMPSEndstop) cylinder(10, 2, 2);
        translate([-10, 0, 0]) {
            cylinder(10, 2.5, 2.5);
            translate_z(2) cylinder(10, 5, 5);
        }
        translate([10, 0, 0]) {
            cylinder(10, 2.5, 2.5);
            translate_z(2) cylinder(10, 5, 5);
        }

        translate([-1 * pcb_length(RAMPSEndstop) / 2 + 5, -1 * pcb_width(RAMPSEndstop) / 2 - 5, 5]) cube([pcb_length(RAMPSEndstop),pcb_width(RAMPSEndstop),5]);
    }
}

module spacer_bot_z() {
    difference() {
        cube([20, 20, rails_height - profile_size]);
        translate([0, (20 - 12)/2, 0,]) cube([20, 12, 8]);
    }
}

module spacer_mid_z() {
    height = rails_distance + carriage_width(MGN12H_carriage) - profile_size;
    cube([20, 20, height]);
    translate([-9.16/2 + 10, 20, 0]) rotate([90, 0, 0]) vslot(20);
    translate([9.16/2 + 10, 20, height]) rotate([90, 180, 0]) vslot(20);
}

module cross_mount() {
    dia = sqrt(20*20 + 20*20);
    
    difference() {
        union() {
            translate([0, 0, 5]) angle(0);
            translate([0, 0, -5]) mirror([0, 0, 180]) angle(0);
            translate([0, 0, -10]) cube([5, 40, 20]);    
            translate([-9.16/2 + 10, 0, 10]) vslot(20);
            translate([-9.16/2 + 10, 0, -30]) vslot(20);
            translate([0, 40, 9.16/2]) rotate([90, 90, 0]) vslot(40);
        }
    
        translate([-5, 5 + 2.5, 0]) rotate([0, 90, 0]) cylinder(10, 2.5, 2.5);
        translate([-5, 25 + 2.5, 0]) rotate([0, 90, 0]) cylinder(10, 2.5, 2.5);
        translate([10, 8, 5 + dia/2]) rotate([90, 0, 0]) cylinder(10, 2.5, 2.5);
        translate([10, 8, - 5 - dia/2]) rotate([90, 0, 0]) cylinder(10, 2.5, 2.5);
    }
}

module plywood_corner() {
    module side() { linear_extrude(2) difference() {
        circle(r = 30);
        translate([-30, 0]) square(60);
        translate([-60, -30]) square(60);
        translate([17, -17]) circle(d = 3);
    }}
    
    side();
    rotate([90, 0, 0]) side();
    rotate([0, 90, 0]) side();
}

module x_bearing_support() {    
    length = kp_size(KP08_15)[0];
    bot_offset = (rails_distance + carriage_width(MGN12H_carriage) - length - profile_size) / 2;

    difference() {
        translate([-1 * length / 2, 0, 0]) {
            cube([length, acme_thickness, profile_size]);
        }

        translate([0, 10, 10]) kp_pillow_block_hole_positions(KP08_15) {
            cylinder(20, 2.5, 2.5);
            nut(M5_nut);
        }

        translate([0, acme_thickness, profile_size / 2]) rotate([90, 0, 0]) {
            cylinder(acme_thickness - 5, 5, 5);
            translate([0, 0, 0]) cylinder(15, 2.5, 2.5);
        }
    }

    translate([length / 2, 0, 0]) color("red") {
        difference() {
            cube([bot_offset, 5, 20]);
            translate([15, 5, 10]) rotate([90, 0, 0]) cylinder(5, 2.5, 2.5);
        }
    }

    // translate([0, acme_thickness, profile_size / 2]) rotate([90, 0, 0]) {
    //     cylinder(acme_thickness - 5, 5, 5);
    //     translate([0, 0, 0]) cylinder(10, 2.5, 2.5);
    // }
}

module x_stepper_mount() {
    pitch = NEMA_hole_pitch(NEMA17_40);
    mount_width = 50;

    cap_dia = 5.5;
    cap_depth = 3.5;

    difference() {
        union() {
            linear_extrude(9) NEMA_outline(NEMA17_40);
            translate([31/2, 31/2, 0]) cylinder(11, 5, 5);
            translate([-31/2, 31/2, 0]) cylinder(11, 5, 5);
            translate([-31/2, -31/2, 0]) cylinder(11, 5, 5);
        }
        translate([0, 0, -1]) cylinder(12, NEMA_boss_radius(NEMA17_40) + 1, NEMA_boss_radius(NEMA17_40) + 1);
        NEMA_screw_positions(NEMA17_40) cylinder(15, 1.5, 1.5);
        translate([0, 0, 9 - cap_depth]) NEMA_screw_positions(NEMA17_40) cylinder(10, cap_dia / 2, cap_dia / 2);
    }

    translate([-1 * profile_size - 6 -0.5 * NEMA_width(NEMA17_40), -1 * NEMA_width(NEMA17_40) / 2, 0]) {
        difference() {
            cube([6 + profile_size, NEMA_width(NEMA17_40), 25]);

            translate([profile_size / 2, 7, 0]) cylinder(25, 2.5, 2.5);
            translate([profile_size / 2, 7, 0]) cylinder(20, 5, 5);

            translate([profile_size / 2, NEMA_width(NEMA17_40) - 7, 0]) cylinder(25, 2.5, 2.5);
            translate([profile_size / 2, NEMA_width(NEMA17_40) - 7, 0]) cylinder(20, 5, 5);
        }
    }

    // difference() {
    //     rotate([0, 0, 45]) {
    //         translate([-1 * mount_width / 2, -1 * profile_size + kp_base_height(KP08_15), 0]) cube([mount_width, 8, 9 + 20]);
    //     }
    //     cylinder(30, NEMA_boss_radius(NEMA17_40) + 1, NEMA_boss_radius(NEMA17_40) + 1);
    //     rotate([0, 0, 45]) {
    //         translate([18, -25, 9 + profile_size / 2]) rotate([0, 90, 90]) cylinder(50, 2.5, 2.5);
    //         translate([-18, -25, 9 + profile_size / 2]) rotate([0, 90, 90]) cylinder(50, 2.5, 2.5);
    //     }
    // }
}

x_stepper_mount();
// spacer_mid_z();
