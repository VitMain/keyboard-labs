// Definition for the switch plate.

include <jj40_constants.scad>;
include <common.scad>;

use <../switch_plate.scad>;

$fn = 60;

module cutout_planck_mit(switch_grid_unit = 19.05) {
    for (row = [0:3], column = [0:11]) {
        translate([column, row] * switch_grid_unit) {
            if (row == 3 && column == 5) {
                switch_cutout(w = 2, switch_grid_unit = switch_grid_unit);
            } else if (row == 3 && column == 6) {
            } else {
                switch_cutout(switch_grid_unit = switch_grid_unit);
            }
        }
    }
}

// uses PCB's origin as the origin
module jj40_switch_plate(
    switch_plate_dim = SWITCH_PLATE_DIM,
    pcb_switch_plate_position = PCB_SWITCH_PLATE_POSITION,
    corner_r = CORNER_R,
    pcb_sw_1_1_position = PCB_SW_1_1_POSITION,
    pcb_mounting_hole_offsets = PCB_MOUNTING_HOLE_OFFSETS,
    pcb_mounting_hole_dia = 4,
    pcb_sw_1_1_position = PCB_SW_1_1_POSITION,
    switch_grid_unit = SWITCH_GRID_UNIT
) {
    difference() {
        translate(pcb_switch_plate_position) {
            square_with_rounded_corners(switch_plate_dim, r = corner_r);
        }

        translate(pcb_sw_1_1_position) {
            mounting_hole_cutouts(pcb_mounting_hole_offsets = pcb_mounting_hole_offsets);
            cutout_planck_mit(switch_grid_unit = switch_grid_unit);
        }
    }
}

scale([1, -1, 1]) {
    jj40_switch_plate();
}
