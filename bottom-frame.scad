include <openscad-openbuilds/hardware/acme_lead_screw_nut.scad>;
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/pillow_blocks.scad>
include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/shaft_couplings.scad>

include <params.scad>
include <printed.scad>

// 4 x V-SLOT 2020 Aluminium Extrusion - Black Anodized 340mm
// 4 x V-SLOT 2020 Aluminium Extrusion - Black Anodized 303mm
// 4 x V-SLOT 2020 Aluminium Extrusion - Black Anodized 350mm
// 2 x V-SLOT 2020 Aluminium Extrusion - Black Anodized 285mm
// 1 x V-SLOT 2020 Aluminium Extrusion - Black Anodized 135mm
// 4 x 400mm v
// 2 x 330mm v

coupling_depth = 11;

module bottomAlong()
{
    rotate([ 0, 90, 0 ])
    {
        translate([ 0, bottom_rails_distance / 2 + profile_size / 2, bottom_x_length / 2 ])
        {
            extrusion(E2020t, bottom_x_length);
        }
        translate([ 0, bottom_y_length / 2 - profile_size / 2, bottom_x_length / 2 ])
        {
            extrusion(E2020t, bottom_x_length);
        }
    }
}

module bottomAcross()
{
    beam_length = 63;
    rotate([ 0, 90, 90 ])
    {
        translate([ 0, profile_size / 2, 0])
        {
            extrusion(E2020t, bottom_y_length);
            translate([20, -40, 170 - profile_size - beam_length]) beam(beam_length);
        }
        translate([ 0, -1 * bottom_x_length - profile_size/2, 0])
        {
            extrusion(E2020t, bottom_y_length);
            translate([ 0, profile_size, 0])
            {
                extrusion(E2020t, 100); // Approximate, as this needs to be cut manually
                translate([-1 * profile_size - kp_base_height(KP08_15), 0, 0]) rotate([90, -90, 0]) kp_pillow_block(KP08_15);
                translate([20, 0, 0]) profile_connector();
            }
        }
        translate([ 0, -50, 0])
        {
            extrusion(E2020t, bottom_rails_distance);
            translate([-1 * profile_size - kp_base_height(KP08_15), 0, 0]) rotate([90, -90, 0]) kp_pillow_block(KP08_15);
        }
    }
}

module drivetrain()
{
    screw_offset = -6;
    stepper_offset = -23;
    // translate([ stepper_offset + screw_offset, 0, profile_size + kp_base_height(KP08_15) ]) rotate([ 0, 90, 0 ]) rotate([0, 0, 45]) NEMA(NEMA17_40);
    translate([ stepper_offset + screw_offset, 0, 10 + 15 ]) rotate([ 0, 90, 0 ]) rotate([0, 0, 45]) NEMA(NEMA17_40);
    translate([200 + screw_offset, 0, profile_size/2 + kp_hole_offset(KP08_15)]) rotate([90, 0, 90]) leadscrew(8, 400, 8, 4);
    color("#0f01") translate([stepper_offset + sc_length(SC_6x8_flex) / 2 + NEMA_shaft_length(NEMA17_40) - coupling_depth + screw_offset, 0, profile_size/2 + kp_hole_offset(KP08_15)]) rotate([0, 90, 0]) shaft_coupling(SC_6x8_flex);

    translate([ stepper_offset + screw_offset, 0, profile_size + kp_base_height(KP08_15) ]) rotate([ 0, 90, 0 ]) rotate([0, 0, 45]) bottom_stepper_mount();
}

module bed() {
    translate([bed_offset + bed_length / 2 + profile_size, 0, profile_size/2 + kp_hole_offset(KP08_15) - acme_thickness / 2]) rotate([0, 0, 90]) acme_lead_screw_nut_block_anti_backlash();
    translate([ bed_offset + profile_size, bottom_rails_distance / 2 + profile_size / 2, profile_size / 2 ])
    {
        translate([bed_y_length / 2 - 15, 0, profile_size / 2 + carriage_height(MGN12H_carriage) + base_height]) rotate([0, 90, 0]) extrusion(E2020t, bed_y_length);
        carriage(MGN12H_carriage);
        translate([0, 0, carriage_height(MGN12H_carriage)]) carriage_to_2020();

        translate([bed_length / 2 - 6 - 50, -1 * bottom_rails_distance / 2 - profile_size / 2, profile_size / 2 + carriage_height(MGN12H_carriage) + base_height]) rotate([90, 0, 0]) extrusion(E2020t, bottom_rails_distance);
        translate([bed_length / 2 - 6, -1 * bottom_rails_distance / 2 - profile_size / 2, profile_size / 2 + carriage_height(MGN12H_carriage) + base_height]) rotate([90, 0, 0]) extrusion(E2020t, bottom_rails_distance);
        translate([bed_length / 2 - 6 + 60, -1 * bottom_rails_distance / 2 - profile_size / 2, profile_size / 2 + carriage_height(MGN12H_carriage) + base_height]) rotate([90, 0, 0]) extrusion(E2020t, bottom_rails_distance);

        translate([ bed_length, 0, 0 ]) {
            carriage(MGN12H_carriage);
            translate([0, 0, carriage_height(MGN12H_carriage)]) carriage_to_2020();
        }

        translate([ 0, -1 * bottom_rails_distance - profile_size, 0 ])
        {
            translate([bed_y_length / 2 - 15, 0, profile_size / 2 + carriage_height(MGN12H_carriage) + base_height]) rotate([0, 90, 0]) extrusion(E2020t, bed_y_length);
            carriage(MGN12H_carriage);
            translate([0, 0, carriage_height(MGN12H_carriage)]) carriage_to_2020();

            translate([ bed_length, 0, 0 ]) {
                carriage(MGN12H_carriage);
                translate([0, 0, carriage_height(MGN12H_carriage)]) carriage_to_2020();
            }
        }
    }
    // Wooden bed
    translate([bed_offset + profile_size, -1 * bed_wood_width / 2, carriage_height(MGN12H_carriage) + base_height + 1.5 * profile_size]) color("#CAA472") cube([bed_wood_length, bed_wood_width, 9]);
}

module bottomFrame()
{
    bed();
    drivetrain();
    translate([-1 * profile_size / 2, bottom_rails_distance / 2 + pcb_width(RAMPSEndstop), profile_size / 2]) rotate([180, 180, 90]) {
        translate([0, 0, 7]) pcb(RAMPSEndstop);
        endstop_base();
    }
    {
        bottomAlong();
        mirror([ 0, 180, 0 ]) bottomAlong();
        bottomAcross();
    }
    translate([ bottom_x_length / 2, bottom_rails_distance / 2 + profile_size / 2, profile_size / 2 ])
    {
        rail(MGN12, 400);
    }
    translate([ bottom_x_length / 2, -1 * bottom_rails_distance / 2 - profile_size / 2, profile_size / 2 ])
    {
        rail(MGN12, 400);
        translate([-1 * bottom_x_length / 2 - profile_size / 2 - profile_size, -15, -10,]) limiter();

        translate([-1 * bottom_x_length / 2 + 40, -15, 0,]) bottom_aligner();
    }
}