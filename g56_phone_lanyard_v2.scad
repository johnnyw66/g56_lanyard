$fn = 60;

// --- Dimensions ---
// Internal Anchor Plate
plate_w   = 56.0; // 56 mm wide for the ~76 mm phone (leaves 10 mm margin each side)
plate_h   = 25.0; // Sits neatly in the bottom of the case
plate_t   = 0.50; // Ultra-thin anchor (approx. 2-3 layers at 0.2 mm)
corner_r  = 4.0;  // Rounded corners so it won't scratch the phone back

// Neck (Pass-Through via USB-C Cutout)
neck_w    = 10.5; // Must pass entirely through the case cutout (<= port width)
neck_l    = 19.0; // Reach through the case bottom wall before thickening

// External Hanging Tail & Clasp Eyelet
tail_t    = 2.80; // Thickened for tensile strength and wear resistance
hole_d    = 5.0;  // Standard 5 mm lanyard clasp hole
ramp_l    = 3.0;  // Chamfer transition length from 0.5 mm to 2.8 mm

// Straight tail segment with rounded end (radius = neck_w / 2 = 5.25 mm)
tail_tip_r = neck_w / 2; 

module rounded_rect(w, h, r, t) {
    hull() {
        translate([-w/2 + r, -h/2 + r, 0]) cylinder(r=r, h=t);
        translate([ w/2 - r, -h/2 + r, 0]) cylinder(r=r, h=t);
        translate([-w/2 + r,  h/2 - r, 0]) cylinder(r=r, h=t);
        translate([ w/2 - r,  h/2 - r, 0]) cylinder(r=r, h=t);
    }
}

union() {
    // 1. Inside Anchor Plate (Centered horizontally at X = 0)
    translate([0, plate_h/2, 0])
        rounded_rect(plate_w, plate_h, corner_r, plate_t);

    // 2. Ultra-Thin Neck (passes through port hole from the inside)
    translate([-neck_w/2, -neck_l, 0])
        cube([neck_w, neck_l, plate_t]);

    // 3. Smooth Thickness Transition
    translate([0, -neck_l, 0]) {
        hull() {
            translate([-neck_w/2, 0, 0]) 
                cube([neck_w, 0.1, plate_t]);
            translate([-neck_w/2, -ramp_l, 0]) 
                cube([neck_w, 0.1, tail_t]);
        }
    }

    // 4. Straight In-Line External Eyelet (Width constrained to neck_w)
    translate([0, -neck_l - ramp_l, 0]) {
        difference() {
            hull() {
                // Base at the end of the ramp
                translate([-neck_w/2, -0.1, 0]) 
                    cube([neck_w, 0.1, tail_t]);
                // Rounded bullnose tip
                translate([0, -tail_tip_r, 0]) 
                    cylinder(r=tail_tip_r, h=tail_t);
            }
            // Clasp Hole centered inside the bullnose
            translate([0, -tail_tip_r, -1])
                cylinder(d=hole_d, h=tail_t + 2);
        }
    }
}