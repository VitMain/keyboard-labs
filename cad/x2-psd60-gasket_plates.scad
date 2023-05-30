// top:
// gap 40, tab 20.5, gap 36.5, tab, gap 50 middle, tab, gap 36.5, tab, gap 40
// (sums to 285)
//
// side:
// gap 12, tab, gap 30, tab, gap 12
// (sums to 95)
//
// tabs stick out 4mm;
// tab corner r = 2mm;
// plate corner r = 2.5
//
// albeit, I measured
//   - the plate to be 286.5 x 96.5,
// vs
//   - the original    285   x 94.2
// i.e. a difference of 1.5 x 2.3(?!)
//
// (and I'm not sure how to account for that error of 1.5mm vs the measured parts)

// In this document, (0, 0) is the PCB's top-left.

pcb_height = 94.2;
pcb_width = 285;
pcb_dim = [pcb_width, pcb_height];

full_plate_width = 286.5;
full_plate_height = 96.5;
full_plate_dim = [full_plate_width, full_plate_height];

corner_r = 2.25;
tab_corner_r = 2.5;
plate_corner_r = 2.5;

tab_width = 20.5;
tab_depth = 4;

top_edge_gap_0 = 40;
top_edge_gap_1 = 36.5;
top_edge_gap_2 = 50;

top_edge_tab_0_offset = top_edge_gap_0;
top_edge_tab_1_offset = top_edge_gap_0 + tab_width + top_edge_gap_1;

side_edge_gap_0 = 12;
side_edge_gap_1 = 30;

side_edge_tab_0_offset = side_edge_gap_0;
side_edge_tab_1_offset = side_edge_gap_0 + tab_width + side_edge_gap_1;

switch_unit = 19.05;
switch_cutout_size = 14;

plate_width_total_margin = full_plate_width - pcb_width;
plate_width_margin = plate_width_total_margin / 2;
plate_height_total_margin = full_plate_height - pcb_height;
plate_height_margin = plate_height_total_margin / 2;

total_num_switch_columns = 15;
total_num_switch_rows = 5;
total_num_switch_grid = [total_num_switch_columns, total_num_switch_rows];

// pcb margin = extra width around the switches
pcb_width_total_margin = pcb_width - ((total_num_switch_columns - 1) * switch_unit) - switch_cutout_size;
pcb_width_margin = pcb_width_total_margin / 2;
pcb_height_total_margin = pcb_height - ((total_num_switch_rows - 1) * switch_unit) - switch_cutout_size;
pcb_height_margin = pcb_height_total_margin / 2;

plate_origin_x = -plate_width_margin;
plate_origin_y = -plate_height_margin;
plate_origin = [plate_origin_x, plate_origin_y];

// relative to (0, 0)
// TODO: just make it relative to the plate.
full_plate_midpoint_x = (full_plate_width / 2) + plate_origin_x;
full_plate_midpoint_y = (full_plate_height / 2) + plate_origin_y;
full_plate_midpoint = [full_plate_midpoint_x, full_plate_midpoint_y];

// TODO: derive 7, 2 from X-2's grid size of 15, 5
sw_1_1_x = full_plate_midpoint_x - (7 * switch_unit);
sw_1_1_y = full_plate_midpoint_y - (2 * switch_unit);
sw_1_1_point = [sw_1_1_x, sw_1_1_y];

halfplate_num_switch_columns = 6;
halfplate_num_switch_rows = total_num_switch_rows;

// TODO: halfplate height
halfplate_width = ((halfplate_num_switch_columns - 1) * switch_unit) + switch_cutout_size + pcb_width_total_margin + plate_width_total_margin;

top_edge_tab_1_width = halfplate_width - (top_edge_tab_1_offset);

module corner(r) {
    difference() {
        square(r, center = false);
        translate([r, r]) {
            circle(r);
        }
    }
}

module switch_cutout() {
    translate([-switch_cutout_size / 2, -switch_cutout_size / 2]) {
        square(switch_cutout_size);
    }
}

// starting from centre of sw_1_1
module switch_cutout_grid(cols = 15, rows = 5) {
    for (c = [0:(cols - 1)], r = [0:(rows - 1)]) {
        translate([c * switch_unit, r * switch_unit]) {
            switch_cutout();
        }
    }
}

module plate_tab(tab_width = 20.5) {
    translate([0, -tab_depth]) {
        difference() {
            square([tab_width, tab_depth], center = false);

            translate([0, 0]) {
                corner(r = tab_corner_r);
            }
            translate([tab_width, 0]) {
                rotate([0, 0, 90]) {
                    corner(r = tab_corner_r);
                }
            }
        }
    }
}

$fn = 60;

module half_plate() {
    difference() {
        translate(plate_origin) {
            union() {
                square([halfplate_width, full_plate_height], center = false);

                translate([top_edge_tab_0_offset, 0]) {
                    plate_tab();
                }
                translate([top_edge_tab_1_offset, 0]) {
                    plate_tab(tab_width = top_edge_tab_1_width);
                }

                mirror([1, 0, 0]) {
                    rotate(90) {
                        translate([side_edge_tab_0_offset, 0]) {
                            plate_tab();
                        }
                        translate([side_edge_tab_1_offset, 0]) {
                            plate_tab();
                        }
                    }
                }

                translate([0, full_plate_height]) {
                    mirror([0, 1, 0]) {
                        translate([top_edge_tab_0_offset, 0]) {
                            plate_tab();
                        }
                        translate([top_edge_tab_1_offset, 0]) {
                            plate_tab(tab_width = top_edge_tab_1_width);
                        }
                    }
                }
            }
        }

        translate(plate_origin) {
            corner(r = plate_corner_r);
        }
        translate(plate_origin + [0, full_plate_height]) {
            rotate([0, 0, 270]) {
                corner(r = plate_corner_r);
            }
        }

        translate(sw_1_1_point) {
            switch_cutout_grid(cols = halfplate_num_switch_columns, rows = halfplate_num_switch_rows);
        }
    }
}

module x2_psd60_switch_plates() {
    half_plate();
    translate([2 * (halfplate_width), 0]) {
        mirror([1, 0]) {
            half_plate();
        }
    }
}

scale([1, -1, 1]) {
    x2_psd60_switch_plates();
}
