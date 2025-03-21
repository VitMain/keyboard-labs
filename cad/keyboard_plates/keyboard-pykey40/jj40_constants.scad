// Constants used across OpenScad files
// for JJ40/BM40, PyKey40,
// for the switch plate(s) and bottom plate(s).
//
// Variables in CAPS are used in other files.

// Measurement of interior of low profile anodyzed aluminium case:
case_inner_width = 231;
case_inner_length = 78;
case_inner_dim = [case_inner_width, case_inner_length];

// Measured from BM40 PCB
pcb_length = 75;
pcb_width = 227;
PCB_DIM = [pcb_width, pcb_length];

// measured
// relative to PCB origin (top-left of PCB)
PCB_SW_1_1_POSITION = [7.5, 8.5];

SWITCH_GRID_UNIT = 19.05;

PCB_USB_CONNECTOR_MID_X = PCB_SW_1_1_POSITION[0] + 1.5 * SWITCH_GRID_UNIT;

switch_grid_cols = 12;
switch_grid_rows = 4;
switch_grid_dim = [switch_grid_cols, switch_grid_rows];

// measured from BM40 PCB
pcb_mounting_hole_grid_coords = [
    [0.5, 0.5],
    [switch_grid_cols - 1 - 0.5, 0.5],
    [switch_grid_cols - 1 - 0.5, switch_grid_rows - 1 - 0.5],
    [0.5, switch_grid_rows - 1 - 0.5],
    [(switch_grid_cols - 1) / 2, (switch_grid_rows - 1) / 2],
];
// relative to SW_1_1
PCB_MOUNTING_HOLE_OFFSETS = [
    for (coord = pcb_mounting_hole_grid_coords) SWITCH_GRID_UNIT * coord
];
PCB_MOUNTING_HOLE_DIA = 2.2;

CORNER_R = 2.25;

FOOT_DIA = 22;
FOOT_HOLE_DIA = 4.1;

// plate cutout
SW_CUTOUT_HALFWIDTH = 7;

// margin between the pcb's left edge, and the left hand edge of switch cutout
pcb_sw_1_1_margin = PCB_SW_1_1_POSITION - [SW_CUTOUT_HALFWIDTH, SW_CUTOUT_HALFWIDTH];

// c.f. case_inner_width; 0.5 smaller
switch_plate_width = 230.5;
switch_plate_length = 77.5;
SWITCH_PLATE_DIM = [switch_plate_width, switch_plate_length];

function switch_grid_halfdim_mm(cols, rows, switch_grid_unit = SWITCH_GRID_UNIT) =
    ([cols, rows] - [1, 1]) / 2 * SWITCH_GRID_UNIT;

function calculate_pcb_switch_plate_position(
    pcb_sw_1_1_position = PCB_SW_1_1_POSITION,
    switch_grid_cols = switch_grid_cols,
    switch_grid_rows = switch_grid_rows,
    switch_grid_unit = SWITCH_GRID_UNIT,
    switch_plate_dim = SWITCH_PLATE_DIM
) =
    let (
        // Middle of the grid of switches on the PCB
        // relative to pcb origin (top-left).
        pcb_switch_grid_center = pcb_sw_1_1_position + switch_grid_halfdim_mm(switch_grid_cols, switch_grid_rows),

        // Middle of the switch plate
        // relative to switch plate's (top-left).
        switch_plate_switch_grid_center = switch_plate_dim / 2
    )
    pcb_switch_grid_center - switch_plate_switch_grid_center;

// Hence, the switch plate's origin relative to the PCB's origin
PCB_SWITCH_PLATE_POSITION = calculate_pcb_switch_plate_position(
    pcb_sw_1_1_position = PCB_SW_1_1_POSITION,
    switch_grid_cols = switch_grid_cols,
    switch_grid_rows = switch_grid_rows,
    switch_grid_unit = SWITCH_GRID_UNIT,
    switch_plate_dim = SWITCH_PLATE_DIM
);

echo("switch plate position (relative to pcb origin)", PCB_SWITCH_PLATE_POSITION);

// margin between the pcb's right edge, and the right hand edge of switch cutout
// (used for assertions)
pcb_sw_12_4_margin_width  = PCB_DIM[0] - pcb_sw_1_1_margin[0] - (12 - 1) * SWITCH_GRID_UNIT - 2 * SW_CUTOUT_HALFWIDTH;
pcb_sw_12_4_margin_length = PCB_DIM[1] - pcb_sw_1_1_margin[1] - (4 - 1) * SWITCH_GRID_UNIT - 2 * SW_CUTOUT_HALFWIDTH;

// The 'extra' dimensions of the switch plate, relative to the PCB
// (used for assertions)
switch_plate_pcb_margin_left = -PCB_SWITCH_PLATE_POSITION[0];
switch_plate_pcb_margin_top  = -PCB_SWITCH_PLATE_POSITION[1];
switch_plate_pcb_margin_right  = SWITCH_PLATE_DIM[0] - PCB_DIM[0] - switch_plate_pcb_margin_left;
switch_plate_pcb_margin_bottom = SWITCH_PLATE_DIM[1] - PCB_DIM[1] - switch_plate_pcb_margin_top;

echo("margin between pcb and switch plate edge: left:", switch_plate_pcb_margin_left, "right:", switch_plate_pcb_margin_right);
echo("margin between pcb and switch plate edge: top:", switch_plate_pcb_margin_top, "bottom:", switch_plate_pcb_margin_bottom);

// The dimensions of the switch plate's edges
// (distance between the edge of the case, and switch cutout).
// (used for assertions)
switch_plate_lhs_edge = switch_plate_pcb_margin_left + pcb_sw_1_1_margin[0];
switch_plate_top_edge = switch_plate_pcb_margin_top + pcb_sw_1_1_margin[1];
switch_plate_rhs_edge = switch_plate_pcb_margin_right + pcb_sw_12_4_margin_width;
switch_plate_btm_edge = switch_plate_pcb_margin_bottom + pcb_sw_12_4_margin_length;

echo("switch plate edges: left:", switch_plate_lhs_edge, "right:", switch_plate_rhs_edge);
echo("switch plate edges: top:", switch_plate_top_edge, "bottom:", switch_plate_btm_edge);

assert(SWITCH_PLATE_DIM[0] < case_inner_dim[0], "inner width");
assert(SWITCH_PLATE_DIM[1] < case_inner_dim[1], "inner length");
assert(switch_plate_lhs_edge == switch_plate_rhs_edge);
assert(switch_plate_top_edge == switch_plate_btm_edge);
