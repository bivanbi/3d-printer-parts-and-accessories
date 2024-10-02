// Useful with Creality Space PI, which does not stop the PTFE tube from sliding into the filament compartment.
// Print it with 0.2 nozzle and 0.06 high quality for best results. Enable brim for better adhesion.

// default values, override them as needed. Values are in millimeters
function ptfe_stopper_tube_outer_diameter() = 4.0;
function ptfe_stopper_tube_inner_diameter() = 2.0;
function ptfe_stopper_sleeve_outer_diameter() = 6.0;
function ptfe_stopper_sleeve_length() = 10.0;
function pfte_stopper_insert_length() = 10.0;
function pfte_stopper_sleeve_insert_overlap() = 3.0; // provide some strenght to the joint
function pfte_stopper_sleeve_skirt_length() = 2.0;
function pfte_stopper_sleeve_skirt_inner_diameter() = ptfe_stopper_tube_outer_diameter() + 1;
function pfte_stopper_sleeve_skirt_outer_diameter() = ptfe_stopper_sleeve_outer_diameter() + 1;

function ptfe_stopper_sleeve_loose_tolerance() = 0.2;
function ptfe_stopper_filament_loose_tolerance() = 0.2;

module ptfe_stopper_sleeve(
    tube_outer_d = ptfe_stopper_tube_outer_diameter(),
    tube_inner_d = ptfe_stopper_tube_inner_diameter(),
    skirt_inner_d = pfte_stopper_sleeve_skirt_inner_diameter(),
    skirt_outer_d = pfte_stopper_sleeve_skirt_outer_diameter(),
    skirt_h = pfte_stopper_sleeve_skirt_length(),
    sleeve_outer_d = ptfe_stopper_sleeve_outer_diameter(),
    sleeve_h = ptfe_stopper_sleeve_length(),
    insert_h = pfte_stopper_insert_length(),
    overlap = pfte_stopper_sleeve_insert_overlap(),
    sleeve_tolerance = ptfe_stopper_sleeve_loose_tolerance(),
    filament_tolerance = ptfe_stopper_filament_loose_tolerance()
) {
    skirt_inner_d = skirt_inner_d + ptfe_stopper_sleeve_loose_tolerance();
    skirt_outer_d = skirt_outer_d + ptfe_stopper_sleeve_loose_tolerance();

    sleeve_offset_z = skirt_h;
    overlap_offset_z = sleeve_offset_z + sleeve_h;
    insert_offset_z = overlap_offset_z + overlap;

    sleeve_outer_d = sleeve_outer_d + ptfe_stopper_sleeve_loose_tolerance();
    sleeve_inner_d = tube_outer_d + ptfe_stopper_sleeve_loose_tolerance();
    sleeve_h = sleeve_h;

    sleeve_outer_r = sleeve_outer_d / 2;
    sleeve_inner_r = sleeve_inner_d / 2;
    skirt_inner_r = skirt_inner_d / 2;
    skirt_outer_r = skirt_outer_d / 2;

    tube_inner_d = tube_inner_d + filament_tolerance;
    tube_outer_d = tube_outer_d + filament_tolerance;

    insert_inner_d = tube_inner_d;
    insert_h = insert_h + overlap;

    overlap_inner_r = sleeve_inner_d / 2;
    overlap_outer_r = sleeve_outer_d / 2;

    overlap_insert_outer_r = tube_outer_d / 2;
    overlap_insert_inner_r = tube_inner_d / 2;

    union() {
        // sleeve skirt - ease PTFE tube insertion
        rotate_extrude() {
            hull() {
                translate([skirt_inner_r, 0]) square(0.1);
                translate([sleeve_inner_r, skirt_h]) square(0.1);
                translate([sleeve_outer_r - 0.1, skirt_h]) square(0.1);
                translate([skirt_outer_r, 0]) square(0.1);
            }
        }

        // sleeve
        %translate([0, 0, sleeve_offset_z])
        linear_extrude(height = sleeve_h) {
            difference() {
                circle(d = sleeve_outer_d);
                circle(d = sleeve_inner_d);
            }
        }

        // overlap
        translate([0, 0, overlap_offset_z])
        rotate_extrude() {
            hull() {
                translate([overlap_outer_r - 0.1, 0]) square(0.1);
                translate([overlap_outer_r - 0.1, overlap]) square(0.1);
                translate([overlap_insert_inner_r, overlap]) square(0.1);
                translate([overlap_inner_r, 0]) square(0.1);
            }
        }

        // insert
        translate([0, 0, insert_offset_z])
        linear_extrude(height = insert_h) {
            difference() {
                circle(d = tube_outer_d);
                circle(d = tube_inner_d);
            }
        }
    }
}

ptfe_stopper_sleeve();