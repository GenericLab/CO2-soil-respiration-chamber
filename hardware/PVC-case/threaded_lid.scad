// 
// PVC piping threaded Lid for ROSA CO2 monitoring case
//
// This work is released with CC0 into the public domain.
// https://creativecommons.org/publicdomain/zero/1.0/
// based on work by  Ryan A. Colyer.
// https://www.thingiverse.com/thing:1686322
//

$fn=128;
wallThickness = 1.6;
engravingDepth = 0.6;
height = 2;

difference(){
union(){
minkowski(){    
cylinder(wallThickness-1.59, d = 100-1.6, center = true, $fn=16);
    sphere(d=1.6);
}
    
}
    translate([20,14,0]) rotate([0,0,0]) cylinder(h=100,d=12.4,center=true);
    translate([20,-14,0]) rotate([0,0,0]) cylinder(h=100,d=12.4,center=true);
    translate([-0,-24,0]) rotate([0,0,0]) cylinder(h=100,d=5,center=true);
    translate([-0,0,0.5*wallThickness+0.1]) rotate([0,180,0]) roundedRect2([14,24,1*wallThickness+0.2,1.2],1);
    translate([-1.5,0,1*wallThickness+0.7]) rotate([0,180,0]) roundedRect2([27,27,1*wallThickness+0.2,1],1);
    translate([-0,27,0]) rotate([0,0,0]) cylinder(h=100,d=13.8,center=true);
    translate([-16,27,0]) rotate([0,0,0]) cylinder(h=100,d=5,center=true);
    #translate([0,0,-1.5*wallThickness+engravingDepth]) linear_extrude(height =wallThickness, center = false, convexity = 10) import(file = "Logo_engravings.dxf", layer = "coconut");
    #translate([0,0,-1.5*wallThickness+engravingDepth]) linear_extrude(height =wallThickness, center = false, convexity = 10) import(file = "Logo_engravings.dxf", layer = "ROSA");
    
    
}


difference(){
    union(){
  translate([0,0,2]) ScrewThread(outer_diam=80, height=12, pitch=2.3, tooth_angle=40, tolerance=0.4, tip_height=0.5, tooth_height=2, tip_min_fract=0);
    translate([0,0,2.5+0.5*wallThickness]) cylinder(5, d = 80.5, center = true);
    
    translate([0,0,1.4+0.0*wallThickness]) cylinder(3, d = 100, center = true,$fn=16);
    translate([0,0,2.5+0.5*wallThickness]) cylinder(1, d = 100, center = true,$fn=16);
    translate([0,0,8]) cylinder(12, d = 76, center = true);
    }
    translate([0,0,0]) cylinder(50, d = 80-6, center = true);
}

difference(){
    translate([0,-7.5,-1]) rotate([0,0,180]) featherS2();
        translate([-1.5,0,1*wallThickness+10]) rotate([0,180,0]) roundedRect2([27,27,1*wallThickness+20,1],1);
}
 
module featherS2(){

    translate([8.89,22.86,6+0.5*wallThickness-0.1]) screwRod();
    translate([-8.89,22.86,6+0.5*wallThickness-0.1]) screwRod();
    translate([8.89,-22.86,6+0.5*wallThickness-0.1]) screwRod();

//linear_extrude(height = wallThickness, center = false, convexity = 10) import(file = "CO2_featherCase.dxf", layer = "base");
//linear_extrude(height =0, center = false, convexity = 10) import(file = "CO2_featherCase.dxf", layer = "border");
//linear_extrude(height = wallThickness + 1, center = false, convexity = 30) import(file = "CO2_featherCase.dxf", layer = "screws");
}

module screwRod (){
  difference(){
    union(){
     translate([0,0,1.3]) cylinder(12, d1 = 8, d2 = 4, center = true, $fn=30);
     translate([0,0,-1]) cylinder(8, d1 = 10, d2 = 3, center = true, $fn=30);
     translate([0,0,-4]) cylinder(2, d1 = 12, d2 = 6, center = true, $fn=30);
    }
    minkowski(){
    translate([0,0,3]) cylinder(10, d1 = 0.6, d2 = 0.8, center = true, $fn=3);
        sphere(r=0.8);
    }
  }
  translate([0,0,8])cylinder(2.5, d1 = 2.2, d2 = 2.5, center = true, $fn=30);
}





// Created 2016-2017 by Ryan A. Colyer.
// This work is released with CC0 into the public domain.
// https://creativecommons.org/publicdomain/zero/1.0/
//
// https://www.thingiverse.com/thing:1686322
//
// v2.1


screw_resolution = 0.2;  // in mm

// This generates a closed polyhedron from an array of arrays of points,
// with each inner array tracing out one loop outlining the polyhedron.
// pointarrays should contain an array of N arrays each of size P outlining a
// closed manifold.  The points must obey the right-hand rule.  For example,
// looking down, the P points in the inner arrays are counter-clockwise in a
// loop, while the N point arrays increase in height.  Points in each inner
// array do not need to be equal height, but they usually should not meet or
// cross the line segments from the adjacent points in the other arrays.
// (N>=2, P>=3)
// Core triangles:
//   [j][i], [j+1][i], [j+1][(i+1)%P]
//   [j][i], [j+1][(i+1)%P], [j][(i+1)%P]
//   Then triangles are formed in a loop with the middle point of the first
//   and last array.
module ClosePoints(pointarrays) {
  function recurse_avg(arr, n=0, p=[0,0,0]) = (n>=len(arr)) ? p :
    recurse_avg(arr, n+1, p+(arr[n]-p)/(n+1));

  N = len(pointarrays);
  P = len(pointarrays[0]);
  NP = N*P;
  lastarr = pointarrays[N-1];
  midbot = recurse_avg(pointarrays[0]);
  midtop = recurse_avg(pointarrays[N-1]);

  faces_bot = [
    for (i=[0:P-1])
      [0,i+1,1+(i+1)%len(pointarrays[0])]
  ];

  loop_offset = 1;
  bot_len = loop_offset + P;

  faces_loop = [
    for (j=[0:N-2], i=[0:P-1], t=[0:1])
      [loop_offset, loop_offset, loop_offset] + (t==0 ?
      [j*P+i, (j+1)*P+i, (j+1)*P+(i+1)%P] :
      [j*P+i, (j+1)*P+(i+1)%P, j*P+(i+1)%P])
  ];

  top_offset = loop_offset + NP - P;
  midtop_offset = top_offset + P;

  faces_top = [
    for (i=[0:P-1])
      [midtop_offset,top_offset+(i+1)%P,top_offset+i]
  ];

  points = [
    for (i=[-1:NP])
      (i<0) ? midbot :
      ((i==NP) ? midtop :
      pointarrays[floor(i/P)][i%P])
  ];
  faces = concat(faces_bot, faces_loop, faces_top);

  polyhedron(points=points, faces=faces);
}



// This creates a vertical rod at the origin with external threads.  It uses
// metric standards by default.
module ScrewThread(outer_diam, height, pitch=0, tooth_angle=30, tolerance=0.4, tip_height=0, tooth_height=0, tip_min_fract=0) {

  pitch = (pitch==0) ? ThreadPitch(outer_diam) : pitch;
  tooth_height = (tooth_height==0) ? pitch : tooth_height;
  tip_min_fract = (tip_min_fract<0) ? 0 :
    ((tip_min_fract>0.9999) ? 0.9999 : tip_min_fract);

  outer_diam_cor = outer_diam + 0.25*tolerance; // Plastic shrinkage correction
  inner_diam = outer_diam - tooth_height/tan(tooth_angle);
  or = (outer_diam_cor < screw_resolution) ?
    screw_resolution/2 : outer_diam_cor / 2;
  ir = (inner_diam < screw_resolution) ? screw_resolution/2 : inner_diam / 2;
  height = (height < screw_resolution) ? screw_resolution : height;

  steps_per_loop_try = ceil(2*3.14159265359*or / screw_resolution);
  steps_per_loop = (steps_per_loop_try < 4) ? 4 : steps_per_loop_try;
  hs_ext = 3;
  hsteps = ceil(3 * height / pitch) + 2*hs_ext;

  extent = or - ir;

  tip_start = height-tip_height;
  tip_height_sc = tip_height / (1-tip_min_fract);

  tip_height_ir = (tip_height_sc > tooth_height/2) ?
    tip_height_sc - tooth_height/2 : tip_height_sc;

  tip_height_w = (tip_height_sc > tooth_height) ? tooth_height : tip_height_sc;
  tip_wstart = height + tip_height_sc - tip_height - tip_height_w;


  function tooth_width(a, h, pitch, tooth_height, extent) =
    let(
      ang_full = h*360.0/pitch-a,
      ang_pn = atan2(sin(ang_full), cos(ang_full)),
      ang = ang_pn < 0 ? ang_pn+360 : ang_pn,
      frac = ang/360,
      tfrac_half = tooth_height / (2*pitch),
      tfrac_cut = 2*tfrac_half
    )
    (frac > tfrac_cut) ? 0 : (
      (frac <= tfrac_half) ?
        ((frac / tfrac_half) * extent) :
        ((1 - (frac - tfrac_half)/tfrac_half) * extent)
    );


  pointarrays = [
    for (hs=[0:hsteps])
      [
        for (s=[0:steps_per_loop-1])
          let(
            ang_full = s*360.0/steps_per_loop,
            ang_pn = atan2(sin(ang_full), cos(ang_full)),
            ang = ang_pn < 0 ? ang_pn+360 : ang_pn,

            h_fudge = pitch*0.001,

            h_mod =
              (hs%3 == 2) ?
                ((s == steps_per_loop-1) ? tooth_height - h_fudge : (
                 (s == steps_per_loop-2) ? tooth_height/2 : 0)) : (
              (hs%3 == 0) ?
                ((s == steps_per_loop-1) ? pitch-tooth_height/2 : (
                 (s == steps_per_loop-2) ? pitch-tooth_height + h_fudge : 0)) :
                ((s == steps_per_loop-1) ? pitch-tooth_height/2 + h_fudge : (
                 (s == steps_per_loop-2) ? tooth_height/2 : 0))
              ),

            h_level =
              (hs%3 == 2) ? tooth_height - h_fudge : (
              (hs%3 == 0) ? 0 : tooth_height/2),

            h_ub = floor((hs-hs_ext)/3) * pitch
              + h_level + ang*pitch/360.0 - h_mod,
            h_max = height - (hsteps-hs) * h_fudge,
            h_min = hs * h_fudge,
            h = (h_ub < h_min) ? h_min : ((h_ub > h_max) ? h_max : h_ub),

            ht = h - tip_start,
            hf_ir = ht/tip_height_ir,
            ht_w = h - tip_wstart,
            hf_w_t = ht_w/tip_height_w,
            hf_w = (hf_w_t < 0) ? 0 : ((hf_w_t > 1) ? 1 : hf_w_t),

            ext_tip = (h <= tip_wstart) ? extent : (1-hf_w) * extent,
            wnormal = tooth_width(ang, h, pitch, tooth_height, ext_tip),
            w = (h <= tip_wstart) ? wnormal :
              (1-hf_w) * wnormal +
              hf_w * (0.1*screw_resolution + (wnormal * wnormal * wnormal /
                (ext_tip*ext_tip+0.1*screw_resolution))),
            r = (ht <= 0) ? ir + w :
              ( (ht < tip_height_ir ? ((2/(1+(hf_ir*hf_ir))-1) * ir) : 0) + w)
          )
          [r*cos(ang), r*sin(ang), h]
      ]
  ];


  ClosePoints(pointarrays);
}


// This creates a threaded hole in its children using metric standards by
// default.
module ScrewHole(outer_diam, height, position=[0,0,0], rotation=[0,0,0], pitch=0, tooth_angle=30, tolerance=0.4, tooth_height=0) {
  extra_height = 0.001 * height;

  difference() {
    children();
    translate(position)
      rotate(rotation)
      translate([0, 0, -extra_height/2])
      ScrewThread(1.01*outer_diam + 1.25*tolerance, height + extra_height,
        pitch, tooth_angle, tolerance, tooth_height=tooth_height);
  }
}

// radius - radius of corners
module roundedRect2(size, radius)
{
	x = size[0];
	y = size[1];
	z = size[2];
    angle = size[3];
    
	translate([0,0,0])
	//linear_extrude(height=z)
    linear_extrude(height=z,scale=angle)
	hull()
	{
		// place 4 circles in the corners, with the given radius
		translate([(-x/2)+(radius), (-y/2)+(radius), 0])
		circle(r=radius, $fn=100);
	
		translate([(x/2)-(radius), (-y/2)+(radius), 0])
		circle(r=radius, $fn=100);
	
		translate([(-x/2)+(radius), (y/2)-(radius), 0])
		circle(r=radius, $fn=100);
	
		translate([(x/2)-(radius), (y/2)-(radius), 0])
		circle(r=radius, $fn=100);
	}
}


