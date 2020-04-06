/** Parametric no-touch tool
  * 
  * Designed to open doors, push buttons, pick up bags etc.
  * without touching them, and without touching the surfaces
  * that do touch them ("no-touch").
  *
  * Consists of four parts:
  * - tool body (with hook and tip),
  * - tool sleeve (with slot for sliding it in and out),
  * - end cap (for closing it at the bottom, possibly attaching
  *   the tool body to the sleeve with a rubber band to let it
  *   snap back;
  * - knob to move it in and out, optionally with sleeve bolt to 
  *   hold it together.
  *
  * Shape and dimensions are parametric and widely customizable. 
  * In fact, maybe *too* customizable - some of the options generate
  * strange behaviour in OpenSCAD (see comments)
  * 
  * Original non-parametric design by Elwin Alvarado,
  * https://www.prusaprinters.org/prints/27210-truly-touchless-no-touching-multi-toolhook
  *
  * (C) 2020 Philipp Reichmuth, CC-BY-SA 4.0
  */

/* [Model generation settings] */

// Chamfer most edges.
// This gives a great improvement in appearance, and some
// in functionality (e.g. added stability for concave edges
// and rubber band slots), but adds LOTS of little polygons. 
// It may break F5 preview in OpenSCAD. 
// F6 rendering and F7 export should be fine, even if OpenSCAD
// occasionally throws assertions.
CHAMFER_EDGES = true;
CHAMFER = CHAMFER_EDGES ? 0.5 : 0; 

// Round off all circles. Warning: $fn values over ~20 get 
// expensive, especially with chamfering enabled. F5 preview 
// will be slow or may break due to the number of polygons.
// F6 rendering and F7 export will be fine.
ROUND_CIRCLES = true;
$fn=(ROUND_CIRCLES) ? 50 : $fn;

// Which models to generate
GENERATE_BODY   = false;
GENERATE_SLEEVE = false; 
GENERATE_ENDCAP = false;
GENERATE_BOLTS  = true;

// Debugging of basic forms
GENERATE_BODY_FORM = false;
GENERATE_SLOT_FORM = false;

/* [Tool shape] */

// Basic shape
BODY_WIDTH    = 30;
BODY_DEPTH    = 5;
BODY_LENGTH   = 80;
MIN_BODY_WALL = 1;      

// Hook at the end of the tool
HOOK_RADIUS        = 15;
// Move inward slightly, to give a <90% angle at the edge 
// for gripping
HOOK_CENTER_OFFSET = 4;
// Hook position measured from the *end* of the tool
HOOK_POS           = 25;
// How far the bottom edge of the hook should "stick out" 
// of the sleeve when fully extended
HOOK_STICKOUT      = 5;
// Hook blade shape: BODY_DEPTH/2 gives a sharp 45° edge,
// lower values leave a flat portion in the inner part of 
// the hook, and setting it to CHAMFER gives a flat edge with 
// the same amount of chamfering as anywhere else.
// Rationale: the sharper the edge, the smaller the contact
// surface - but an overly sharp edge may make it difficult 
// to use the tool to pick up heavier things; e.g. plastic 
// bags may tear).
HOOK_CHAMFER = BODY_DEPTH * 0.4;

// Angle of the top and rear edge
EDGE_ANGLE  = 11.25;
// Extend back edge if the hook ends up too thin at larger angles
// Values <1 make it slimmer, values >1 extend it to the back
EDGE_EXTEND = 0.98; 
// Tool back blade shape: BODY_DEPTH/2 gives a sharp edge,
// lower values leave a flat portion at the back of the blade,
// and setting it to CHAMFER gives a flat edge with the same 
// amount of chamfering as anywhere else.
// Rationale: the sharper the edge, the smaller the contact
// surface.
EDGE_CHAMFER = BODY_DEPTH/2;

// Diameter of the central bolt hole
HOLE_DIA = 6;
// Bolt hole position, measured from the bottom of the tool
HOLE_POS = 20;

/* [End cap] */

// Fixed chamfer at the bottom. 1/3 width gives a nice form.
CHAMFER_CAP   = BODY_DEPTH/3; 

// Slot through end cap: width
CAP_SLOT_WIDTH = 10;
CAP_SLOT_THICKNESS = 3;

// Fixing the end cap. Either rely on the rubber band,
// glue the end cap in, or add a screw.
CAP_SCREW = true; 
// Screw diameter - around 3.5 for M3
CAP_SCREW_DIA = 3.5;
// Diameter and depth of the groove for the cap screw
CAP_HEAD_DIA = 6;
CAP_HEAD_DEPTH = 3; // Leads to a very thin inner part, but better than nothing
CAP_HEAD_FACES = 50; // for a round hole
// Diameter and depth for the groove for the cap nut
CAP_NUT_DIA = 6.75;
CAP_NUT_DEPTH = 2;
CAP_NUT_FACES = 6; // for a hex nut
// Minimal thickness of material around the cap, nut and screws
CAP_SCREW_STANDOFF = 1;

// Height of the part of the end cap that slots into the sleeve
// If the cap is screwed in, this needs to be high enough to leave
// room for the screw.
// If the cap is glued in, this can be small (e.g. 3).
CAP_INSET     = CAP_SCREW 
                  ? 2*CAP_SCREW_STANDOFF+(CAP_HEAD_DIA)/2+CAP_SCREW_DIA/2
                  : 3; 
// Height of the actual end cap
CAP_THICKNESS = 6;
// Minimal wall strength around cut-out slots
CAP_MIN_WALL  = 1; 
// Gap between end cap and sleeve for a snug fit
CAP_GAP       = 0.1;


// Calculated depth of screw blocks, needed for shaping the sleeve
// and endcap. Using the same calculated values here helps avoid errors
FRONT_SCREW_BLOCK=CAP_HEAD_DEPTH+CAP_SCREW_STANDOFF;
BACK_SCREW_BLOCK=CAP_NUT_DEPTH+CAP_SCREW_STANDOFF;

// Width of the rubber band slots in the sleeve and endcap
RUBBER_SLOT   = 3;
// Width of rubber fixtures inside the body part
RUBBER_GROOVE = 2;
// Height offset of rubber band posts inside the body, to lower them
// and protect them from slidingagainst the sleeve when opening/closing
RUBBER_STANDOFF = 0.5;

/* [Sleeve] */

// Extra sleeve length at the top, to avoid touching
// the tool when retracted
SLEEVE_OVERHANG  = 3;
// Sleeve should fit the tool body after the cap is inserted
SLEEVE_LENGTH    = BODY_LENGTH+SLEEVE_OVERHANG+CAP_INSET;
// Material thickness of the sleeve
SLEEVE_THICKNESS = 1.5;
// Gap between sleeve and tool: should move, but not wobble
SLEEVE_GAP       = 0.5;

// Put little triangles on the sides to point to the front
PLACE_TRIANGLES = true;
// How far the triangles should stand out
TRIANGLE_DEPTH = SLEEVE_THICKNESS/3;

// Slot length and position are calculated:
// Let X be the distance between slot end and the sleeve edge
// at the top.
// Then the distance between the top of the bolt hole in the 
// tool and the bottom of the hook must be greater than X, 
// otherwise the tool will stand out.
SLOT_TOP_EDGE = BODY_LENGTH-HOOK_POS-HOOK_RADIUS-HOOK_STICKOUT;
// Slot width and position match the bolt hole in the tool
SLOT_WIDTH  = HOLE_DIA;
SLOT_POS    = HOLE_POS-HOLE_DIA/2+CAP_INSET;
// The slot length determines how much the tool extends
SLOT_LENGTH = SLEEVE_LENGTH-SLOT_TOP_EDGE;
// was: SLOT_LENGTH = 40;
// echo(SLOT_LENGTH);

// Sideways extensions of the slot to allow locking
// Expressed in slot width
SLOT_RIGHT_FACTOR = 0.8;
SLOT_BACK_FACTOR  = 0.5;
// Generate a diagonal slot, as opposed to an L-shaped one
// Depending on the angle, this might be easier to print (no support)
SLOT_DIAG = true;
// SLOT_LEFT_FACTOR    = 0.0; // Currently doesn't work well


// Serrated back edge for easier grip and asymmetry
// Spacing between grooves
GROOVE_SPACING = 1.5;
// Depth of grooves
GROOVE_DEPTH = 0.5;
// Fraction of tool width to be grooved
GROOVE_WIDTH_FACTOR = 3; 

/* [Knobs and bolts] */

// The basic shape is a sleeve bolt (Chicago bolt, "sex bolt")
// with a through hole (for a screw) and holes for screw head and
// nut in both knobs. By customizing this, we can account for the
// following situations:
//
// - Printed bolts, glued together: set SCREW_DIA to 0.  
// - Printed bolts, screwed together: set SCREW_DIA to fit the screw.
// - Knobs only - e.g. if we want to use only a screw, or already 
//   have a sleeve bolt: set SCREW_DIA to the diameter of 
//   the central tool hole and sleeve slot (HOLE_DIA). The script then
//   generates only the knobs. 
//
// Customize the holes in the knobs to match the heads of your bolt,
// e.g. six sides on one end for a hex nut, 50 sides for a round hole
// for a bolt head on the other end.
//
// Choice and placement of bolts
// - "chicago": generates a pair of sleeve bolts standing vertically
// - "halves": generates a pair of sleeve bolts split in half,
//             lying flat, meant to be glued together. This allows
//             printing the bolt with longitudinal layer
//             direction, for more stability - less shearing.
// - "pair": generates a pair of short hollow sheath bolts that meet in
//           the middle. These can be used either as sheath for a 
//           screw (with SCREW_DIA set accordingly), or as a thin
//           printed bolt that is suitable for gluing into the body
//           (with SCREW_DIA set to 0).
// - "knob": generate only the knobs (presumably with a hole), but
//           no bolt. This is useful if you already have a bolt.
//
// TODO: come up with a combination of "halves" and "pair": a
//       pair of thin bolts that are split lengthwise, ideally with 
//       asymmetrical halves so that the pair can be glued together not only
//       at the tips.
BOLT_TYPE = "pair";

// Diameter of the knob
KNOB_DIA       = 15;
// Thickness of the knob
KNOB_THICKNESS = 4;
// Gap between knob and sleeve
KNOB_GAP       = 0.8;
// Gap between hole and bolt
HOLE_GAP       = 0.5;
// Gap between inner and outer bolt
BOLT_GAP       = 0.3;
// Screw diameter through inner bolt.
// Or 0 for no screw hole (which means you need to glue the bolt)
SCREW_DIA      = 3.4;
// Screw head diameter in inner knob, only if there is a screw
SCREW_HEAD_DIA = (SCREW_DIA != 0) ? 6 : 0;
// Number of faces of the screw head: 6 or ~50
SCREW_HEAD_FACES = 50;
// Screw head diameter in inner knob
SCREW_HEAD_DEPTH = (SCREW_DIA != 0) ? 3 : 0;
// Screw head (nut) diameter in outer knob
SCREW_NUT_DIA  = (SCREW_DIA != 0) ? 6.75 : 0;
// Number of faces of the screw nut: 6 or ~50
SCREW_NUT_FACES  = (SCREW_DIA != 0) ? 6 : 0;
// Depth of nut slot in the outer knob
SCREW_NUT_DEPTH  = (SCREW_DIA != 0) ? 3 : 0;

/* [Hidden */

/* Generate and place the actual parts */

if (GENERATE_BOLTS) placeBolts();
if (GENERATE_ENDCAP)
  translate([-KNOB_DIA/2,-BODY_WIDTH-1.5*BODY_DEPTH,0])
    endcap();
if (GENERATE_BODY)
  translate([BODY_WIDTH*1.5,0,0])
    rotate([-90,0,0])
      body();
if (GENERATE_SLEEVE)
  translate([0,BODY_WIDTH+BODY_DEPTH,0])
    sleeve();

// Debggging
if (GENERATE_BODY_FORM)
  bodyForm(BODY_DEPTH, BODY_WIDTH, BODY_LENGTH, c=CHAMFER);
if (GENERATE_SLOT_FORM)
  slotForm(SLEEVE_THICKNESS, SLOT_WIDTH, SLOT_LENGTH, 
    // xl=SLOT_LEFT_FACTOR, // currently no left slots
    xr=SLOT_RIGHT_FACTOR, sbf=SLOT_BACK_FACTOR, c1=CHAMFER, c2=CHAMFER);

/* Modules */

// body standing up
module body() {
  //shorthand
  c=CHAMFER;

  intersection() {
    difference() {
      bodyForm(BODY_DEPTH, BODY_WIDTH, BODY_LENGTH,c=c);
      // cut out center hole
      translate([BODY_WIDTH/2-BODY_DEPTH/2, 0, HOLE_POS]) 
        rotate([-90,0,0]) {
          chamferCylinder(d=HOLE_DIA, h=BODY_DEPTH, o=c);
          // Right extension
          translate([0,-HOLE_DIA/2,0])
            chamferCube([HOLE_DIA*SLOT_RIGHT_FACTOR,HOLE_DIA,BODY_DEPTH],
                         oz1=c,oz2=c);
          translate([HOLE_DIA*SLOT_RIGHT_FACTOR,0,0])
            chamferCylinder(d=HOLE_DIA, h=BODY_DEPTH, o=c);
          // Left extension / currently does not work
          // translate([-HOLE_DIA*SLOT_LEFT_FACTOR,-HOLE_DIA/2,0])
          // chamferCube([HOLE_DIA*SLOT_LEFT_FACTOR, HOLE_DIA, 
          //              BODY_DEPTH], oy2=0.5);
          // translate([-HOLE_DIA*SLOT_LEFT_FACTOR,0,0])
          //   chamferCylinder(d=HOLE_DIA, h=BODY_DEPTH, 
          //                   o=c);
        };
      
      // cut out hook
      translate([HOOK_CENTER_OFFSET-BODY_DEPTH/2, 0, 
                 BODY_LENGTH-HOOK_POS])
        rotate([-90,0,0])
          chamferCylinder(r=HOOK_RADIUS, h=BODY_DEPTH, o=HOOK_CHAMFER);

      // Rubber design 4.0: two rows of inside posts 
      // for attaching rubber bands with different tension.
      // Slightly shorter than the body width to avoid sliding
      // against the sleeve when opening/closing.
      count = floor((HOLE_POS-HOLE_DIA/2-
                     3*MIN_BODY_WALL)/(2*RUBBER_GROOVE));

      // cut out inner core
      translate([MIN_BODY_WALL,0,0])
        difference() {
          chamferCube([BODY_WIDTH-BODY_DEPTH-2*MIN_BODY_WALL,
                       BODY_DEPTH-MIN_BODY_WALL, 
                       HOLE_POS-HOLE_DIA/2-MIN_BODY_WALL],
                       cz=c,cx3=c,cx4=c);
          // N rows of 2 posts each for hanging a rubberband
          for(i=[1:count])
            translate([(BODY_WIDTH-BODY_DEPTH-
                        RUBBER_GROOVE)/2,
                        0,i*2*RUBBER_GROOVE])
              mirror_copy()
                translate([(BODY_WIDTH/2-BODY_DEPTH-
                            RUBBER_GROOVE/2), RUBBER_STANDOFF,
                            0]) // -2*RUBBER_STANDOFF])
                  rotate([-90,0,0])
                    chamferCylinder(d=RUBBER_GROOVE, 
                                    h=BODY_DEPTH
                                      -MIN_BODY_WALL
                                      -RUBBER_STANDOFF,
                                    o=RUBBER_GROOVE/4,$fn=16);
          translate([(BODY_WIDTH-BODY_DEPTH)/2-MIN_BODY_WALL,
                     0,HOLE_POS-HOLE_DIA/2-MIN_BODY_WALL])
          {
            rotate([-90,0,0])
              chamferCylinder(d=HOLE_DIA,
                              h=BODY_DEPTH-MIN_BODY_WALL,o=c);
//            translate([-HOLE_DIA/2,0,0])
//              chamferCube([HOLE_DIA,BODY_DEPTH-MIN_BODY_WALL,
//                           1000]);
          };
        };
    }; // difference
    
    // The tip is formed by cutting out diagonal pieces at top.
    // We do this by overlaying a slightly rotated rectangle; the
    // andle and width of the rectangle determine the form of the tip
    cb = EDGE_CHAMFER;
    translate([-BODY_DEPTH/2,0,-BODY_WIDTH*sin(EDGE_ANGLE)])  
      rotate([0,-EDGE_ANGLE,0])  
        chamferCube(size=[BODY_WIDTH*((sin(EDGE_ANGLE)+1)*
                                      EDGE_EXTEND)+BODY_DEPTH/2,
                           BODY_DEPTH,BODY_LENGTH],
                           c=c,cx3=cb,cx4=cb,cz3=cb,cz4=cb);
  }; // was: cz3 cz4
};

// sleeve
module sleeve() {
  //shorthand
  c=CHAMFER;

  hole_thickness = BODY_DEPTH + 2*SLEEVE_GAP;
  hole_width = BODY_WIDTH + 2*SLEEVE_GAP;
  
  overall_thickness = hole_thickness + 2*SLEEVE_THICKNESS;
  overall_width = hole_width + 2*SLEEVE_THICKNESS;
    
  difference() {
    // body form chamfered only at the top
    bodyForm(overall_thickness, overall_width, 
             SLEEVE_LENGTH, c2=c);
    // cut out channel, chamfered only at the top
    translate([0, SLEEVE_THICKNESS, 0])
      difference() {
        bodyForm(hole_thickness, hole_width, 
                 SLEEVE_LENGTH, o2=c);
        if (CAP_SCREW) {
          // When cutting out the interior of the sleeve, leave two blocks 
          // where we will pass a screw though the sleeve and endcap.
          translate([overall_width-overall_thickness-CAP_HEAD_DIA- 
                     CAP_SCREW_STANDOFF,-SLEEVE_THICKNESS,0])
            {
              // "Dront" block will hold a screw head
              // Width needs to be at least CAP_NUT_DIA+2*CAP_SCREW_STANDOFF,
              // But we can go all the way to the end here.
              cube([1000, // all the way to end
                    FRONT_SCREW_BLOCK,
                    CAP_HEAD_DIA+CAP_SCREW_STANDOFF]);
              // "Back" block will hold screw nut
              translate([0,
                         overall_thickness-BACK_SCREW_BLOCK,
                         0])
                cube([1000, // all the way to the end
                      BACK_SCREW_BLOCK,
                      CAP_NUT_DIA+CAP_SCREW_STANDOFF]);
            };          
        }
      }
    // cut out slot
    translate([(overall_width-overall_thickness-SLOT_WIDTH)/2, 0, SLOT_POS])
      rotate([0,-90,-90])
        union() {
          slotForm(SLEEVE_THICKNESS, SLOT_WIDTH, SLOT_LENGTH, 
                   // xl=SLOT_LEFT_FACTOR, // currently no left slots
                   xr=SLOT_RIGHT_FACTOR, sbf=SLOT_BACK_FACTOR, o1=c);
          translate([0,0,overall_thickness-SLEEVE_THICKNESS]) 
            slotForm(SLEEVE_THICKNESS, SLOT_WIDTH, SLOT_LENGTH, 
                     // xl=SLOT_LEFT_FACTOR, // currently no left slots
                     xr=SLOT_RIGHT_FACTOR, sbf=SLOT_BACK_FACTOR, o2=c);
        };
    // cut out slot for passing the rubber band to the endcap
    // Extended to the top a little bit to compensate for the thickness of the material.
    // This could be angled if we want it really elegang
    translate([(overall_width-RUBBER_SLOT-overall_thickness)/2,0,0])
        chamferCube(size=[RUBBER_SLOT, overall_thickness, 
                          RUBBER_SLOT+SLEEVE_THICKNESS/2],cy2=c, cy3=c);
    // cut out hole and heads for endcap screw
    if (CAP_SCREW) {
      translate([overall_width-overall_thickness-CAP_HEAD_DIA/2, 0, 
                 CAP_HEAD_DIA/2+CAP_SCREW_STANDOFF])
        rotate([-90,0,0])
        {
          // screw hole - needs $fn
          cylinder(d=CAP_SCREW_DIA,h=overall_thickness, $fn=50);
          // screw head
          cylinder(d=CAP_HEAD_DIA, h=CAP_HEAD_DEPTH, $fn=50);
          // screw nut
          translate([0,0,overall_thickness-CAP_NUT_DEPTH])
            cylinder(d=CAP_NUT_DIA, h=CAP_NUT_DEPTH, $fn=6);        
        };
    };
  };
  
  // insert block for endcap screw
  
  
  // Serrated front edge of the tool
  groove_width=overall_thickness/GROOVE_WIDTH_FACTOR;
  groove_offset=overall_thickness*(1-1/GROOVE_WIDTH_FACTOR)/2;
  groove_length = SLOT_POS+SLOT_LENGTH-CAP_INSET; 
                  // was. SLEEVE_LENGTH-2*CAP_INSET;
  groove_count=floor(groove_length)/GROOVE_SPACING;
  actual_spacing=groove_length/groove_count;
  translate([-overall_thickness/2, groove_offset, 
             ,CAP_INSET])
    for(i=[1:groove_count])
      translate([0,0,i*actual_spacing])  
        rotate([-90,0,0])
          chamferCylinder(r=GROOVE_DEPTH,h=groove_width,
                          $fn=8,c=0.5);
  //put a single dot also on the side where the tool comes out
  translate([-overall_thickness/2, groove_offset, 
             SLOT_LENGTH/2+SLEEVE_LENGTH/2+SLOT_POS/2])
    rotate([-90,0,0])
      chamferCylinder(r=GROOVE_DEPTH,h=groove_width,
                          $fn=8,c=0.5);
  
  
  // Add triangles to identify front side
  // Center on the middle of the slot
  translate([(overall_width-overall_thickness)/2,
              overall_thickness/2,SLOT_POS+SLOT_LENGTH/2])
    // mirror above and below the slot 
    mirror_copy([0,0,1])
      // mirror on front and back
      mirror_copy([0,1,0])
        // draw reference triangle above the slot
        translate([0,-overall_thickness/2,
                   SLEEVE_LENGTH/2-SLOT_POS/2])
          rotate([90,180,0])
            // triangle prism = cylinder with 3 faces
            chamferCylinder(d=SLOT_WIDTH*sqrt(2),
                            h=TRIANGLE_DEPTH,c2=c,$fn=3);
};

// end cap

module endcap() {
  // shorthand
  c=CHAMFER;

  // dimensions for lower, "outside" half of cap
  cap_depth = BODY_DEPTH + 2*(SLEEVE_GAP+SLEEVE_THICKNESS);
  cap_width = BODY_WIDTH + 2*(SLEEVE_GAP+SLEEVE_THICKNESS);
  // dimensions for part of cap that goes into the sleeve
  inset_depth = BODY_DEPTH-2*CAP_GAP;
  inset_width = BODY_WIDTH-2*CAP_GAP;
  // center slot for saving material
  slot_depth  = inset_depth - 2*CAP_MIN_WALL;
  slot_width  = (cap_width-cap_depth-HOLE_DIA)/2 - CAP_MIN_WALL;
  slot_height  = CAP_THICKNESS+CAP_INSET-CAP_MIN_WALL;
  slot_z2      = CHAMFER_CAP+CAP_SLOT_THICKNESS+CAP_MIN_WALL+c;
  slot_height2 = CAP_THICKNESS+CAP_INSET-slot_z2;
    
  difference() {
    union() {
      // lower half of cap
      translate([cap_depth/2,cap_depth/2,0])
        chamferCylinder(d=cap_depth, h=CAP_THICKNESS, c1=CHAMFER_CAP);
      translate([cap_depth/2,0,0])
        chamferCube(size=[cap_width-cap_depth, cap_depth, 
          CAP_THICKNESS], cx1=CHAMFER_CAP, cx2=CHAMFER_CAP);
      translate([cap_width-cap_depth/2,cap_depth/2,0])
        chamferCylinder(d=cap_depth, h=CAP_THICKNESS, c1=CHAMFER_CAP);
      // upper half of cap (inset)
      translate([(cap_width-inset_width)/2,
                 (cap_depth-inset_depth)/2,
                 CAP_THICKNESS]) {
        translate([inset_depth/2, inset_depth/2, 0])
          chamferCylinder(d=inset_depth, h=CAP_INSET, c2=CHAMFER);
        if (CAP_SCREW) {
          translate([inset_depth/2, 0, 0])
          chamferCube(size=[inset_width/2-inset_depth/2,inset_depth,
                      CAP_INSET], cx3=CHAMFER, cx4=CHAMFER);
        }
        else {
          translate([inset_depth/2, 0, 0])
            chamferCube(size=[inset_width-inset_depth,inset_depth,
                        CAP_INSET], cx3=CHAMFER, cx4=CHAMFER);
          translate([inset_width-inset_depth/2, inset_depth/2, 0])
            chamferCylinder(d=inset_depth, h=CAP_INSET, c2=CHAMFER);
          };
      };
      if (CAP_SCREW) {
      translate([inset_width-inset_depth/2-CAP_HEAD_DIA+2*CAP_SCREW_STANDOFF,
                 FRONT_SCREW_BLOCK+CAP_GAP,
                 CAP_THICKNESS])
        chamferCube(size=[CAP_HEAD_DIA,
                   cap_depth-FRONT_SCREW_BLOCK-BACK_SCREW_BLOCK-2*CAP_GAP,
                   CAP_HEAD_DIA/2+CAP_SCREW_DIA/2+2*CAP_SCREW_STANDOFF],
                   cx3=c, cx4=c, cy2=c, cy3=c, cz=c); 
                   // this must leave room for the screwhole
      }
    };
    // cut out rubber band block from inset
    translate([(cap_width-HOLE_DIA)/2,0, 
               CAP_THICKNESS])
      cube(size=[HOLE_DIA, cap_depth, CAP_INSET]);
    // cut out rubber band slot around cap
    translate([(cap_width-RUBBER_SLOT)/2,0,0]) {
      chamferCube(size=[RUBBER_SLOT,RUBBER_SLOT,     
        CAP_THICKNESS], o2=c);
      chamferCube(size=[RUBBER_SLOT, cap_depth, RUBBER_SLOT]);
      translate([0,cap_depth-RUBBER_SLOT,0])
        chamferCube(size=[RUBBER_SLOT, RUBBER_SLOT, 
           CAP_THICKNESS], o2=c);
    }
    // cut sideways slot for attaching a lanyard
    translate([cap_width-cap_depth/2-CAP_SLOT_WIDTH,0,CHAMFER_CAP])
      chamferCube(size=[CAP_SLOT_WIDTH,cap_depth,
                   CAP_SLOT_THICKNESS],oy1=c,oy2=c);
    // cut slots into the inset to save some material
    translate([cap_depth/2, cap_depth/2, CAP_MIN_WALL])
      chamferCylinder(d=slot_depth, h=slot_height, o2=c);
    translate([cap_depth/2, (cap_depth-slot_depth)/2, CAP_MIN_WALL])
      chamferCube([slot_width, slot_depth, slot_height], oz2=c);
    if (CAP_SCREW) {
      // Cut screw hole into block
      translate([cap_width-cap_depth/2-CAP_HEAD_DIA/2,0,
                 CAP_THICKNESS+CAP_HEAD_DIA/2+CAP_SCREW_STANDOFF]) 
        rotate([-90,0,0])
          cylinder(d=CAP_SCREW_DIA,h=cap_depth,$fn=50);  
    } else {
      // cut slot into the back inset - needs to be lower
      translate([(cap_width+HOLE_DIA)/2+CAP_MIN_WALL,
                 (cap_depth-slot_depth)/2, slot_z2])
        chamferCube([slot_width, slot_depth, slot_height2], oz2=c);
      translate([cap_width-cap_depth/2, cap_depth/2, slot_z2])
        chamferCylinder(d=slot_depth, h=slot_height2, o2=c);
    };
  }; 
};

// Bolt placement that allows cutting bolts in half and 
// laying them flat
module placeBolts() 
{
  bolt_len = BODY_DEPTH+2*(SLEEVE_GAP+SLEEVE_THICKNESS+KNOB_GAP);
    
  if ((BOLT_TYPE == "chicago") ||
      (BOLT_TYPE == "pair") ||
      (BOLT_TYPE == "knob")
     )
  {
    bolts();
  }
  else { if (BOLT_TYPE == "halves") {
    translate([0, -KNOB_DIA/4, 0])
    rotate([90,0,0])
    // Bolt halves: cut away the other half with a cube. 
    // "Left" half
    intersection() {
        bolts(); 
        translate([-1.5*KNOB_DIA,0,0])
            cube([4*KNOB_DIA,KNOB_DIA,
                 KNOB_THICKNESS+bolt_len]);
    };       
    // "Right" half
    translate([0, KNOB_DIA/4, 0])
    rotate([-90,0,0])
    intersection() {
        bolts(); 
        translate([-1.5*KNOB_DIA,-KNOB_DIA,0])
            cube([4*KNOB_DIA,KNOB_DIA,
                 KNOB_DIA+bolt_len]);
      }; // intersection       
    }; // if
  }; //else
}; 

// Place an inner and an outer bolt next to each other.
module bolts()
{
    // Calculate various bolt diameters
    outer_dia = HOLE_DIA-HOLE_GAP;
    inner_dia = (outer_dia+SCREW_DIA)/2;
    outer_len = BODY_DEPTH+2*(SLEEVE_GAP+SLEEVE_THICKNESS+KNOB_GAP);
    inner_len = (BOLT_TYPE == "pair") ? outer_len :
                                        outer_len-BOLT_GAP;

    if (BOLT_TYPE == "pair") {
    inner_bolt(cap_dia  = KNOB_DIA,
               cap_thck = KNOB_THICKNESS,
               bolt_dia = outer_dia,
               bolt_gap = BOLT_GAP,
               bolt_len = inner_len/2,
               hole_dia = SCREW_DIA,
               nut_dia  = SCREW_NUT_DIA,
               nut_edge = SCREW_NUT_FACES,
               nut_dpth = SCREW_NUT_DEPTH,
               chamfer    = CHAMFER,
               cap_chm  = KNOB_THICKNESS/2);
    } else {
    outer_bolt(cap_dia  = KNOB_DIA,
               cap_thck = KNOB_THICKNESS,
               bolt_dia = (BOLT_TYPE != "knob") ? outer_dia : 0,
               bolt_gap = BOLT_GAP,
               bolt_len = outer_len,
               innr_dia = (BOLT_TYPE != "knob") ? inner_dia : 0,
               hole_dia = SCREW_DIA,
               nut_dia  = SCREW_NUT_DIA,
               nut_edge = SCREW_NUT_FACES,
               nut_dpth = SCREW_NUT_DEPTH,
               chamfer    = CHAMFER,
               cap_chm  = KNOB_THICKNESS/2);
    };
    
    translate([KNOB_DIA*1.5, 0, 0])
      inner_bolt(cap_dia  = KNOB_DIA,
                 cap_thck = KNOB_THICKNESS,
                 bolt_dia = (BOLT_TYPE=="pair")? outer_dia : 
                            (BOLT_TYPE!="knob")? inner_dia : 0,
                 bolt_gap = BOLT_GAP,
                 bolt_len = (BOLT_TYPE=="pair")? inner_len/2 
                                               : inner_len,
                 hole_dia = SCREW_DIA,
                 nut_dia  = SCREW_HEAD_DIA,
                 nut_edge = SCREW_HEAD_FACES,
                 nut_dpth = SCREW_HEAD_DEPTH,
                 chamfer    = CHAMFER,
                 cap_chm  = KNOB_THICKNESS/2);
}; 
  
// Outer bolt
module outer_bolt(cap_dia, cap_thck, bolt_dia, 
                  innr_dia, bolt_gap, bolt_len, 
                  hole_dia, nut_dia, nut_edge,
                  nut_dpth, chamfer, cap_chm) 
{
  difference() {
    // Main body
    union() {
      chamferCylinder(d=cap_dia, h=cap_thck, c1=cap_chm, c2=chamfer);
      translate([0,0,cap_thck])
        cylinder(d=bolt_dia,
                 h=bolt_len);
    };
  // Hole for inner bolt
  translate([0,0,cap_thck])
    chamferCylinder(d=innr_dia+bolt_gap,
                   h=bolt_len, 
                   o2=chamfer);
  // Through hole for screw
  if (hole_dia != 0)
      chamferCylinder(d=hole_dia,
                     h=cap_thck,
                     o1=chamfer);
  // Screw nut head
  if (nut_dia != 0)
      chamferCylinder(d=nut_dia,
                     h=nut_dpth,
                     $fn=nut_edge,
                     o1=chamfer);
  };
};

// Inner bolt
module inner_bolt(cap_dia, cap_thck, bolt_dia, 
                  bolt_gap, bolt_len, hole_dia,  
                  nut_dia, nut_edge, nut_dpth, 
                  chamfer, cap_chm) 
{
  // Bolt body
  difference() {
    union() {
      chamferCylinder(d=cap_dia, h=cap_thck, c1=cap_chm, c2=chamfer);
      translate([0,0,cap_thck])
        chamferCylinder(d=bolt_dia-bolt_gap,
                       h=bolt_len,
                       c2=chamfer);
    };
    // Remove through hole
    if (hole_dia != 0)
        chamferCylinder(d=hole_dia,
                       h=bolt_len+cap_thck,
                       o=chamfer);
    // Remove screw head
    if (nut_dia != 0)
        chamferCylinder(d=nut_dia,
                         h=nut_dpth,
                         $fn=nut_edge,
                         o1=chamfer);
  };
};

// Form elements that repeat 

// Basic slot form with chamfers and/or overhangs
module slotForm(d, w, l, xl=0, xr=0, sbf=0.5, o1, o2, c1, c2)
{
  translate([w/2,w/2,0])
  chamferCylinder(d=w, h=d, o1=o1, o2=o2, c1=c1, c2=c2);
  translate([w/2,0,0])
    chamferCube([l-w, w, d], o1=o1, o2=o2, cx1=c1, cx2=c1, cx3=c2, cx4=c2);
  translate([l-w/2,w/2,0])
    chamferCylinder(d=w, h=d, o1=o1, o2=o2, c1=c1, c2=c2);
    
  // Locking slot pointing sideways to the right
  // Check if we are generating an L-shaped or a diagonal slot
  if (SLOT_DIAG) {     
    // right and downwards deflection are described in terms of the
    // slot width already, easy to calculate the angle   
    angle = atan(sbf/xr); 
    echo(angle);
    translate([l-w/2,w/2,0])
      rotate([0,0,angle]) {
        translate([-w/2,0,0])
            chamferCube([w,sqrt(w*w*(xr*xr+sbf*sbf)),d],
                         o1=o1, o2=o2, 
                         cy1=c1,cy2=c1,cy3=c2,cy4=c2); // Pythagoras
        translate([0,sqrt(w*w*(xr*xr+sbf*sbf)),0])
          chamferCylinder(d=w, h=d, o1=o1, o2=o2, c1=c1, c2=c2);
      };
  }
  else {
    // sideways locking slot - straight and 90° angle
    translate([l-w,w/2,0])
      // Perpendicular slot section with chamfer:
      chamferCube([w, w*xr, d], 
                   o1=o1, o2=o2, 
                   cx1=c1,cx2=c1,cx3=c2,cx4=c2);
      // Note that chamfering here will break on more
      // recent versions of OpenSCAD for some reason.
      // Tested with 19.01 in the Ubuntu repositories; later 
      // versions need this instead:
      // chamferCube([w, w*xr, d]);
    translate([l-w/2,w*(xr+1/2),0])
      chamferCylinder(d=w, h=d, o1=o1, o2=o2, c1=c1, c2=c2);    
    // add notch to the back for more robust locking
    if (xr > 1.2) {
      translate([l-w*(sbf+1/2),w*xr,0])
        // Longitudinal slot section without chamfer:
        chamferCube([w*sbf, w, d]);
        // Chamfering here may break the model or generate
        // assertions in SCAD. The chamfer is not critical
        // here, because the longitudinal part of this 
        // section of the slot is very short. The version 
        // with chamfer looks like this:
        // chamferCube([w*sbf, w, d],
        //              o1=o1, o2=o2, 
        //              cx1=c1,cx2=c1,cx3=c2,cx4=c2);
      translate([l-w*(sbf+1/2),w*(1/2+xr),0])
        chamferCylinder(d=w, h=d, o1=o1, o2=o2, c1=c1, c2=c2);
    };
  };
};

// Basic body form of the device (used for body and sleeve)
// Chamfering supported separately at top and bottom
// Overhangs get too complex
module bodyForm(d, w, l, c, c1, c2, o, o1, o2)
{
      translate([0, d/2, 0])
        chamferCylinder(d=d, h=l, 
                        c=c, c1=c1, c2=c2, 
                        o=o, o1=o1, o2=o2);
      chamferCube([w-d, d, l], 
                   cx1 = firstOf(c1,c,0),
                   cx2 = firstOf(c1,c,0),
                   cx3 = firstOf(c2,c,0),
                   cx4 = firstOf(c2,c,0),    
                   oz1 = firstOf(o1, o, 0), oz2 = firstOf(o2, o, 0));
      translate([w-d, d/2, 0])
        chamferCylinder(d=d, h=l, 
                        c=c, c1=c1, c2=c2, 
                        o=o, o1=o1, o2=o2);
};

// Auxiliary modules

// Cylinder with chamfered or overhanging edges.
// This also works for cones if they are straight-ish,
// but you might get strange results if the sides are highly
// inclined.
module chamferCylinder(r, r1, r2, 
                      d, d1, d2, 
                      h, 
                      c, c1, c2,
                      o, o1, o2) {
     
    // calculate bottom diameter                     
    D1 = d1 != undef ? d1   :
         r1 != undef ? r1*2 :
         d  != undef ? d    :
         r  != undef ? r*2  : 0;
    // calculate top diameter                     
    D2 = d2 != undef ? d2   :
         r2 != undef ? r2*2 :
         d  != undef ? d    :
         r  != undef ? r*2  : 0;
    // calculate diameter of extended edges
    X1 = o1 != undef ? D1+2*o1 :
         o  != undef ? D1+2*o  : 0;
    X2 = o2 != undef ? D2+2*o2 :
         o  != undef ? D2+2*o  : 0;
    // calculate amount of chamfer
    C1 = c1 != undef ? c1 :
         c  != undef ? c  : 0;
    C2 = c2 != undef ? c2 :
         c  != undef ? c  : 0;

    difference(){
        union() {
            // base cylinder
            cylinder(r=r, r1=r1, r2=r2, 
                     d=d, d1=d1, d2=d2, h=h);
            // top overhanging edge
            translate([0,0,h]) mirror([0,0,1])
                intersection() {
                    cylinder(d1 = X2, d2 = 0, h = X2/2);
                    cylinder(d1 = X2, d2 = X2,
                             h  = X2-D2);
//                             h = (X2-D2)*2);
                };
            // bottom overhanging edge
            intersection() {
                cylinder(d1 = X1, d2 = 0, h = X1/2);
                cylinder(d1 = X1, d2 = X1,
                         h  = X1-D1);
//                         h = (X1-D1)*2);
            };
       };
       // top chamfer
       translate([0,0,h-2*C2])
           anticone(D2+2*C2, (D2+2*C2)/2, "bottom");
       // bottom chamfer
       translate([0,0,-(D1-2*C1)/2])
           anticone(D1+2*C1, (D1+2*C1)/2, "top");      
   };
};

// a cylinder with 45° cones cut out 
module anticone(d, h, where="top")
{
    difference() {
        cylinder(d=d, h=h);
        // cut out top cone
        if ((where=="top") || (where=="both"))
            translate([0,0,h])
            mirror([0,0,1])
            cylinder(d1=d, d2=0, h=d/2);        
        // cut out bottom cone
        if ((where=="bottom") || (where=="both")) 
            cylinder(d1=d, d2=0, h=d/2);        
    }
}

// Cube with chamfered edges and overhangs at 45° angles.
//   
// Chamfers can be specified:
// - in general (parameter `c`), 
// - by axis (parameters cx, cy, cz), 
// - or for each edge individully. Edges cx1, cy1, cz1 are the 
//   edges from the origin, the other edges are counted 
//   clockwise looking in the respective directions.
//
// Overhangs can be specified:
// - in general (parameter o),
// - by face, where face ox1 is the face adjacent to the origin
//   facing in X direction, and ox2 is the opposite face;
// - with parameters o1 and o2 for the top and bottom face for
//   convenience.
// Note that if you combine too many overhangs, they look 
// weird.
module chamferCube(size = [1,1,1],
                    c,
                    cx, cy, cz,
                    cx1, cx2, cx3, cx4,
                    cy1, cy2, cy3, cy4,
                    cz1, cz2, cz3, cz4,
                    o,
                    o1, o2,
                    ox1, ox2, oy1, oy2, oz1, oz2
) 
{
  // Base dimensions
  X = size[0]; Y = size[1]; Z = size[2];

  difference() {
    cube(size);    
    // Chamfer off each edge individually, using either
    // specific parameters (if available) or general ones
    for (i = [
      [ firstOf(cx1, cx, c, 0), X, [90,0,90],   [0,0,0]], 
      [ firstOf(cx2, cx, c, 0), X, [0,-90,180], [0,Y,0]], 
      [ firstOf(cx3, cx, c, 0), X, [0,90,180],  [X,Y,Z]], 
      [ firstOf(cx4, cx, c, 0), X, [0,90,0],    [0,0,Z]], 
      [ firstOf(cy1, cy, c, 0), Y, [90,0,0],    [0,Y,0]],
      [ firstOf(cy2, cy, c, 0), Y, [-90,0,0],   [0,0,Z]],
      [ firstOf(cy3, cy, c, 0), Y, [90,180,0],  [X,Y,Z]],
      [ firstOf(cy4, cy, c, 0), Y, [-90,180,0], [X,0,0]],
      [ firstOf(cz1, cz, c, 0), Z, [0,0,0],   [0,0,0]],
      [ firstOf(cz2, cz, c, 0), Z, [0,0,-90], [0,Y,0]],
      [ firstOf(cz3, cz, c, 0), Z, [0,0,180], [X,Y,0]],
      [ firstOf(cz4, cz, c, 0), Z, [0,0,90],  [X,0,0]]]) 
      chamfer_edge(i[0], i[1], i[2], i[3]);
  };
  
  // Overhangs

  // Overhangs are identified by their normal vector x/y/z, 
  // where ox1 is the face adjacent to the origin that has 
  // [1,0,0] as its normal vector, and ox2 is the opposite face.
 
  // Quick access to top/bottom face with o1/o2 
  // parameter. 
  OZ1 = o1!=undef ? o1 : oz1;
  OZ2 = o2!=undef ? o2 : oz2;
  
  for (i=[
      [X, Y, OZ1, [0,0,0],   [0,0,0]],
      [X, Y, OZ2, [180,0,0], [0,Y,Z]],
      [Z, Y, ox1, [0,90,0],  [0,0,Z]],
      [Z, Y, ox2, [0,-90,0], [X,0,0]],
      [X, Z, oy2, [90,0,0],  [0,Y,0]],
      [X, Z, oy2, [-90,0,0], [0,0,Z]]])
      cube_overhang(i[0], i[1], firstOf(i[2],o,0), i[3], i[4]);  
};

// Edge of a chamfered cube:
// A 45° prism with short edges e, height h, 
// rotated around vector r and translated by t.
module chamfer_edge(e, h, r=[0,0,0], t=[0,0,0])
{
  translate(t)
    rotate(r)
      linear_extrude(height=h)
        polygon(points=[[0,0], [e,0], [0,e]]);
}

// Overhanging face for a cube:
// A pyramid stump over area x*y, extending
// outwards by o, height o, rotated around
// vector r and translated by t
module cube_overhang(x, y, o, r=[0,0,0], t=[0,0,0]) {
  translate(t)
    rotate(r)
      translate([-o, -o])
        pyramidStump45(x+2*o, y+2*o, o);
}

// Truncated 45° pyramid
module pyramidStump45 (l, w, h){
    intersection() {
        pyramid45(l,w);
        cube(size=[l,w,h]);
    };
};

// 45° pyramid over a rectangle
module pyramid45(l, w, d=0){
    polyhedron(
       points = [ [d  ,d  ,d], [l-d,d,  d], 
                  [l-d,w-d,d], [d,  w-d,d], // 0,1,2,3: base
                  [w/2-d/2,   w/2, w/2-d/2], 
                  [l-w/2-d/2, w/2, w/2-d/2] // 4,5: top
                ],
       faces =  [ [0,1,2,3],  // base
                  [4,5,1,0],  // right
                  [5,2,1],    // back
                  [5,4,3,2],  // left
                  [3,4,0] ],  // front
       convexity = 2
    );
}

// A custom mirror module that retains the original
// object in addition to the mirrored one.
// From OpenSCAD tips & tricks.
module mirror_copy(v = [1, 0, 0]) {
    children();
    mirror(v) children();
}

// a function to return the first parameter that is not "undef".
// This could be a much more elegant recursive function over a list,
// and a function literal for the test, but that wouldn't work in the
// old version of OpenSCAD available in Ubuntu.
function firstOf(a, b, c, d) =
    a!=undef ? a : 
    b!=undef ? b : 
    c!=undef ? c : 
    d!=undef ? d : 0;