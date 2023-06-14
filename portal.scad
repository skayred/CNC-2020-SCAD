include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/pillow_blocks.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/shaft_couplings.scad>
include <openscad-openbuilds/hardware/acme_lead_screw_nut.scad>;

include <params.scad>
include <spindel.scad>

// 4 x V-SLOT 2020 Aluminium Extrusion - Black Anodized 340mm - 2
// 4 x V-SLOT 2020 Aluminium Extrusion - Black Anodized 303mm - 2
// 4 x V-SLOT 2020 Aluminium Extrusion - Black Anodized 350mm - 4
// 2 x V-SLOT 2020 Aluminium Extrusion - Black Anodized 285mm
// 1 x V-SLOT 2020 Aluminium Extrusion - Black Anodized 135mm

portal_carriage_height = 2 * carriage_width(MGN12H_carriage) + rails_distance;
dist_to_surface = profile_size / 2 + carriage_height(MGN12H_carriage);

module block_holes() {
    cylinder(30, 1.5, 1.5);
}

// 303 x 2
module side()
{
    rotate([ 0, 0, 0 ])
    {
        translate([ 0, bottom_profile_width / 2 - profile_size / 2, portal_profile_height/2 + profile_size/2 ])
        {
            extrusion(E2020t, portal_profile_height);
            translate([ profile_size + sides_distance, 0, 0 ]) extrusion(E2020t, portal_profile_height);
        }
    }
}

// 350 x 2
module top()
{
    rotate([ 90, 0, 0 ])
    {
        translate([ 0, portal_profile_height + 20, 0 ])
        {
            extrusion(E2020t, portal_profile_width);
            translate([ profile_size + sides_distance, 0, 0 ]) extrusion(E2020t, portal_profile_width);
        }
    }
}

// 350 x 2
module portal_rails()
{
    rotate([ 90, 0, 0 ])
    {
        translate([acme_thickness + kp_base_height(KP08_15), 0, 0]) {
            translate([0, (rails_distance + carriage_width(MGN12H_carriage)) / 2, (bottom_y_length - profile_size) / 2]) rotate([0, 0, -90]) kp_pillow_block(KP08_15);
            translate([0, (rails_distance + carriage_width(MGN12H_carriage)) / 2, -1 * (bottom_y_length - profile_size) / 2]) rotate([0, 0, -90]) kp_pillow_block(KP08_15);

            translate([0, (rails_distance + carriage_width(MGN12H_carriage)) / 2, -1 * (bottom_y_length - profile_size) / 2 - 40 ]) NEMA(NEMA17_40);
            translate([0, (rails_distance + carriage_width(MGN12H_carriage)) / 2, -1 * bottom_y_length / 2 + profile_size/2 - 21]) shaft_coupling(SC_6x8_flex);
            translate([0, (rails_distance + carriage_width(MGN12H_carriage)) / 2, profile_size/2 + kp_hole_offset(KP08_15)]) leadscrew(8, 400, 8, 4);

            translate([0, (rails_distance + carriage_width(MGN12H_carriage)) / 2, -1 * (bottom_y_length - profile_size) / 2 - 40 ]) x_stepper_mount();
        }

        translate([-10, (rails_distance + carriage_width(MGN12H_carriage)) / 2, -1 * profile_size + (bottom_y_length) / 2]) rotate([0, 0, -90]) x_bearing_support();
            // translate([0, (rails_distance + carriage_width(MGN12H_carriage)) / 2, -1 * (bottom_y_length - profile_size) / 2]) rotate([0, 0, -90]) x_bearing_support();

        translate([0, (rails_distance + carriage_width(MGN12H_carriage)), 0]) {
            extrusion(E2020t, portal_profile_width);
            translate([ 10, 0, 0 ]) rotate([ 0, 90, 0 ])
            {
                rail(MGN12, 400);
                translate([ -1 * (carriage_length(MGN12H_carriage) + 1) / 2, 0, 0 ]) carriage(MGN12H_carriage);
                translate([ (carriage_length(MGN12H_carriage) + 1) / 2, 0, 0 ]) carriage(MGN12H_carriage);
            }
        }

        rotate([-90, 0, 0]) translate([0,0,10]) spacer_mid_z();

        translate([ 0, 0, 0 ])
        {
            extrusion(E2020t, portal_profile_width);
            translate([ 10, 0, 0 ]) rotate([ 0, 90, 0 ])
            {
                rail(MGN12, 400);
                carriage(MGN12H_carriage);
            }
        }

        translate([0, (rails_distance + carriage_width(MGN12H_carriage)) / 2, 0]) {
            translate([dist_to_surface - acme_thickness, 0, y_nut_offset]) rotate([90, 0, 90]) acme_lead_screw_nut_block_anti_backlash();

            x_axis_carriage();
        }
    }
}

module x_axis_carriage() {
    difference() {
        translate([dist_to_surface, -1 * portal_carriage_height / 2, -1 * carriage_length(MGN12H_carriage) - rail_width(MGN12) - 1]) cube([portal_carriage_thickness, portal_carriage_height, 2 * carriage_length(MGN12H_carriage) + 2 * rail_width(MGN12) + 1]);

        translate([ 10, (rails_distance + carriage_width(MGN12H_carriage)) / 2, 0 ]) rotate([ 0, 90, 0 ])
        {
            translate([-1 * (carriage_length(MGN12H_carriage) + 1) / 2, 0, 0]) carriage_hole_positions(MGN12H_carriage) block_holes();
            translate([(carriage_length(MGN12H_carriage) + 1) / 2, 0, 0]) carriage_hole_positions(MGN12H_carriage) block_holes();
        }

        translate([ 10, -1 * (rails_distance + carriage_width(MGN12H_carriage)) / 2, 0 ]) rotate([ 0, 90, 0 ]) carriage_hole_positions(MGN12H_carriage) block_holes();

        translate([dist_to_surface - acme_thickness, 0, y_nut_offset]) rotate([90, 0, 90]) { 
            translate([acme_hole_distance/2, acme_length/2 - acme_holes_top_margin, 0]) cylinder(30, 2.5, 2.5);
            translate([-1 * acme_hole_distance/2, acme_length/2 - acme_holes_top_margin, 0]) cylinder(30, 2.5, 2.5);
        }
    }
}

module z_rail() {
    translate([0, z_carriage_rail_dist/2, 0])
    rotate([90, 90, 90]) {
        rail(MGN12, portal_carriage_height);
    }
}

module z_axis_carriage() {
    rotate([90, 90, 90]) {
        translate([0, z_carriage_rail_dist / 2, 0]) {
            translate([ (carriage_length(MGN12H_carriage) + 1) / 2, 0, 0 ]) {
                carriage(MGN12H_carriage);
            }
            translate([ -1 * (carriage_length(MGN12H_carriage) + 1) / 2, 0, 0 ]) {
                carriage(MGN12H_carriage);
            }
        }
        translate([0, -1 * z_carriage_rail_dist / 2, 0]) {
            carriage(MGN12H_carriage);
        }
        translate([0, 0, carriage_height(MGN12H_carriage) - acme_thickness]) rotate([0, 0, 90]) acme_lead_screw_nut_block_anti_backlash();
    }

    translate([carriage_height(MGN12H_carriage) + portal_carriage_thickness, 0, -1 * z_carriage_height / 2 + mount_height / 2]) {
        spindel_mount();
        spindel();
    }

    difference() {
        rotate([0, 90, 0]) translate([-1 * z_carriage_height / 2, -1 * z_carriage_width / 2, carriage_height(MGN12H_carriage)]) cube([z_carriage_height, z_carriage_width, portal_carriage_thickness]);
        translate([carriage_height(MGN12H_carriage), 0, -1 * z_carriage_height / 2 + mount_height / 2])
        screw_holes() {
            nut(M6_nut);
            cylinder(30, 3, 3);
        }
        rotate([90, 90, 90]) {
            translate([0, z_carriage_rail_dist / 2, 0]) {
                translate([ (carriage_length(MGN12H_carriage) + 1) / 2, 0, 0 ]) {
                    carriage_hole_positions(MGN12H_carriage) block_holes();
                }
                translate([ -1 * (carriage_length(MGN12H_carriage) + 1) / 2, 0, 0 ]) {
                    carriage_hole_positions(MGN12H_carriage) block_holes();
                }
            }
            translate([0, -1 * z_carriage_rail_dist / 2, 0]) {
                carriage_hole_positions(MGN12H_carriage) block_holes();
            }
        }
    }
}

module nut_in_plastic() {
    difference() {
        translate([-10, -10, 0]) cube([20, 20, 10]);
        nut(M6_nut);
        cylinder(30, 3, 3);
    }
}

module portal()
{
    side();
    mirror([ 0, 180, 0 ]) side();
    top();
    translate([2 * profile_size + sides_distance, 0, rails_height]) {
        portal_rails();
        translate([dist_to_surface + portal_carriage_thickness, 0, (rails_distance + carriage_width(MGN12H_carriage)) / 2]) {
            z_rail();
            mirror([0, 180, 0]) z_rail();
        }

        translate([dist_to_surface + portal_carriage_thickness, 0, 33 + z_axis_offest]) z_axis_carriage();
    }
    
    translate([20, -100, 10]) spacer_bot_z();
}