//Cube insert template

include <gears.scad>

// INSERT PARAMS
/* [Hiden] */
a = 49.8;
b = 33.6;
c = 6.28;
d = 53.8;
h = 5; //holder height
IM_offset = 0.2;

servo_w = 12.4;
servo_l = 18.7;
servo_h = 7.8;

// GEAR PARAMS
width = 3.0; // 0.01
teeth = 25;
bore = 3.8; // 0.01
straight = false;

/* [Advanced Parameters] */
hub = false;
hub_diameter = 6; // 0.01
hub_thickness = 5; // 0.01
// (Weight optimization if applicable)
optimized = true;
pressure_angle = 20; // 0.01
helix_angle = 30; // 0.01
clearance = 0.05; // 0.01

/* [Rack parameters] */
rack_length = 100; // 0.01
rack_height = 4; // 0.01

/* [Multi-gear configurations] */
idler_teeth = 36;
idler_bore = 3; // 0.01
assembled = false;

// rack rail params
rail_width = 10;
platform_side = 20;
sample_s = 11.85;
sample_h = 5;


module CubeInsert () {
    translate([0, 0, h/2])
    difference(){
        union() {   //basic insert design
            cube([a,b+2*IM_offset,h], center=true);
            cube([b+2*IM_offset,a,h], center=true);
            rotate(a=[0,0,45]){
                cube([c,d+2*IM_offset,h], center=true);
            }
            rotate(a=[0,0,-45]){
                cube([c,d+2*IM_offset,h], center=true);
            }
        }
    }
}

module RackRail () {
    translate([0,40,0])
    
    union() {
        translate([-rack_length/2,-width,0])
        cube([rack_length, rail_width, 3]);
        
        difference() {
        translate([rack_length/2+6,
                   2,
                   0])
        cylinder(3+sample_h, d=platform_side);
        
        translate([rack_length/2+6,
                   2,
                   3+sample_h/2])
        cube([sample_s+2*IM_offset,
              sample_s+2*IM_offset,
              sample_h], center=true);
        }
        
        translate([0,0,rack_height])
        rotate([90,0,0])

        zahnstange(
            modul=Module, 
            laenge=rack_length-1.5, 
            hoehe=rack_height, 
            breite=width,
            eingriffswinkel=pressure_angle,
            schraegungswinkel=finalHelixAngle);
        
        }
    }
    
module ServoGear() {
    translate([0,70,0])
    
    stirnrad (
        modul=Module,
        zahnzahl=teeth,
        breite=width,
        bohrung=bore,
        nabendurchmesser=final_hub_diameter,
        nabendicke=final_hub_thickness,
        eingriffswinkel=pressure_angle,
        schraegungswinkel=-finalHelixAngle, 
        optimiert=optimized);
    }


module ServoInsert() {
    union(){
      CubeInsert();
      translate([-47/2,rail_width/2+2*IM_offset,h])
      cube([47,2,5]);
        
      translate([-47/2,-(rail_width/2+2*IM_offset+2),h])
      cube([47,2,5]);
      
      translate([-17,
                 -(servo_w+rail_width/2+IM_offset+5),
                 h])
//      translate([0,0,0])
      union(){  
        translate([0,
                   0,
                   0])
        cube([18.7+2*IM_offset+3,
              servo_w,
              (teeth/2)-(servo_h/2)+2*IM_offset]);
        
        translate([servo_l+2*IM_offset+3,
                   0,
                   0])
        cube([3,
              servo_w,
              (teeth/2)-(servo_h/2)+IM_offset+servo_h]);
          
        translate([0,
                   0,
                   0])
        cube([3,
              servo_w,
              (teeth/2)-(servo_h/2)+IM_offset+servo_h]);        
        } 
      }
    }

ServoInsert();

RackRail();

ServoGear();


//
//zahnstange_und_rad (
//    modul=Module,
//    laenge_stange=rack_length,
//    zahnzahl_rad=teeth,
//    hoehe_stange=rack_height,
//    bohrung_rad=bore, breite=width,
//    nabendicke=final_hub_thickness,
//    nabendurchmesser=final_hub_diameter,
//    eingriffswinkel=pressure_angle,
//    schraegungswinkel=finalHelixAngle,
//    zusammen_gebaut=assembled,
//    optimiert=optimized);