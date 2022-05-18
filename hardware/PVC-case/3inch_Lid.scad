
$fn=100;
wallThickness = 1.6;

difference(){
cylinder(wallThickness, d = 100, center = true);
    translate([18,12,0]) rotate([0,0,0]) cylinder(h=100,d=12.8,center=true);
    translate([18,-12,0]) rotate([0,0,0]) cylinder(h=100,d=12.8,center=true);
    translate([-4,-24,0]) rotate([0,0,0]) cylinder(h=100,d=5,center=true);
    #translate([-4,0,0.5*wallThickness+0.1]) rotate([0,180,0]) roundedRect2([14,24,1*wallThickness+0.2,1.2],1);
    translate([-24,0,0]) rotate([0,0,0]) cylinder(h=100,d=13.4,center=true);
}
difference(){
translate([0,0,7.5]) cylinder(15, d = 75, center = true);
    translate([0,0,0]) cylinder(50, d = 75-3*wallThickness, center = true);
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
