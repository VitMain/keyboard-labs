include <../keyboard_plates/keyboard-pykey40/jj40_constants.scad>;

SWITCH_PLATE_PCB_POSITION = -PCB_SWITCH_PLATE_POSITION;
CASE_SWITCH_PLATE_MARGIN = 0.25;

echo(SWITCH_PLATE_PCB_POSITION = SWITCH_PLATE_PCB_POSITION);

CASE_LOW_PROFILE_MX_UPPER_CAVITY_HEIGHT = 6; // 6.5?
CASE_LOWER_CAVITY_HEIGHT = 4; // 3.5?

CASE_WALL_THICKNESS = 4;
CASE_BOTTOM_HEIGHT = 2;

CASE_BUMPON_GUIDE_POSITIONS = [[35, 15], [10, -10]];