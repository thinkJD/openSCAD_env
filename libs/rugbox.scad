//*******************************************************************************************************
//
//    Universal parametic rugged Box
//
//  2023 by Rainer Backes
//
//   based on ideas of yanew and Whity
//
//*******************************************************************************************************

RDist =  (NumLatch>1) ? ScrewLength : RibDist ;

include <BOSL2/std.scad>
include <BOSL2/hinges.scad>



/* [Hidden] */
eps = 0.001;  // small number, to keep scad happy


res= $preview ? 32 : 128;
$fn=res;


OBoxDepth=InnerBoxDepth+2*WallThickness;
OBoxWidth=InnerBoxWidth+2*WallThickness;
OCornerRadius=InnerCornerRadius+WallThickness;
OChamferSize=InnerChamferSize+WallThickness;
OBoxHeight=InnerBoxBottomHeight+WallThickness;
OLidHeight=InnerBoxLidHeight+WallThickness;


ldist=InnerBoxWidth/2-HingeLatchOffset-ScrewLength/2;  // Offset of middle of Latch and Ribs from 0 
ldepth=2*WallThickness+HingeOuterDiameter;



module rechteck(xx=20,yy=40) {
  translate([xx/2,yy/2,0]) children();  
  translate([-xx/2,yy/2,0]) children();  
  translate([xx/2,-yy/2,0]) children();  
  translate([-xx/2,-yy/2,0]) children();  
}


module Box(Depth=20,Width=30,Heigth=10,CornerRadius=1,ChamferSize=1,CAngle=45) {

hull(){
rechteck(Depth-2*CornerRadius,Width-2*CornerRadius)
   cyl(r=CornerRadius,h=Heigth,chamfer1=ChamferSize,chamfang=CAngle,anchor=BOTTOM);
}
}
module BottomHinge( ofs = 0, diaB = 2, diaS = 1.75 ) {
	
	translate([OBoxDepth/2,ofs-ScrewLength/2+HingeBottomLength,OBoxHeight]) 
		knuckle_hinge(	length=HingeBottomLength*2, 
						segs=2, 
						offset=SealThick+HingeOuterDiameter/2, 
						arm_height=1.5, 
						arm_angle=50,
						gap=0,
						pin_diam=(ofs > 0 ) ? diaB : diaS, 
						knuckle_diam=HingeOuterDiameter,
						round_bot=1.5,
						orient=RIGHT,
						spin=90);  
	translate([OBoxDepth/2,ofs+ScrewLength/2,OBoxHeight]) 
		knuckle_hinge(	length=HingeBottomLength*2, 
						segs=2, 
						offset=SealThick+HingeOuterDiameter/2, 
						arm_height=1.5, 
						arm_angle=50,
						gap=0,
						pin_diam=(ofs > 0 ) ? diaS : diaB, 
						knuckle_diam=HingeOuterDiameter,
						round_bot=1.5,
						orient=RIGHT,
						spin=90);  
}

module LidHinge ( ofs= 0 ) {
	if (InnerBoxLidHeight >= 18 ) {
		translate([OBoxDepth/2, ofs + HingeLidLength/2,OLidHeight]) 
			knuckle_hinge(	length=HingeLidLength*2, 	
							segs=2, 	
							offset=SealThick+HingeOuterDiameter/2, 
							arm_height=ScrewDiameter/2, 
							arm_angle=50,
							gap=0,
							pin_diam=ScrewDiameter+ScrewTol, 
							knuckle_diam=HingeOuterDiameter,
							round_bot=1.4,
							orient=RIGHT,
							spin=90);  
	}					
	else if (InnerBoxLidHeight >= 12) {
		translate([OBoxDepth/2, ofs + HingeLidLength/2,OLidHeight]) 
			knuckle_hinge(	length=HingeLidLength*2, 	
							segs=2, 	
							offset=SealThick+HingeOuterDiameter/2, 
							arm_height=ScrewDiameter/2, 
							arm_angle=50,
							gap=0,
							pin_diam=ScrewDiameter+ScrewTol, 
							knuckle_diam=HingeOuterDiameter,
							orient=RIGHT,
							spin=90);  
	
	} 
	else
	{
		translate([OBoxDepth/2, ofs + HingeLidLength/2,OLidHeight]) 
			knuckle_hinge(	length=HingeLidLength*2, 	
							segs=2, 	
							offset=SealThick+HingeOuterDiameter/2, 
							arm_height=ScrewDiameter/2, 
							arm_angle=60,
							gap=0,
							pin_diam=ScrewDiameter+ScrewTol, 
							knuckle_diam=HingeOuterDiameter,
							orient=RIGHT,
							spin=90);  
	}
						

}

module LatchHold ( ofs = 0, dia = 3, cham = 10, h = 20, displace = 0, isLid = false ) {
	ledges = [[0,0,0,0],
			  [1,0,1,0],
			  [0,0,0,0]];
	bedges = [[0,0,0,0],
			  [1,0,0,0],
			  [0,0,0,0]];
	bc = (cham<ldepth) ? ldepth : cham ;		  
			  
			if (isLid && InnerBoxLidHeight < 16) {
				translate([-InnerBoxDepth/2, ofs+(ScrewLength/2-HingeLatchRibWidth/2),h ]){
					difference() {
						cuboid([ldepth,HingeLatchRibWidth,HingeOuterDiameter+1],rounding=HingeOuterDiameter/2, edges=ledges, anchor=TOP+RIGHT);	
						translate([-2*WallThickness-HingeOuterDiameter/2,0,-LatchDistance/2+displace]) ycyl(d=dia, h=HingeLatchRibWidth*2); 
					}
				}
				translate([-InnerBoxDepth/2,ofs-(ScrewLength/2-HingeLatchRibWidth/2),h ]){
					difference() {
						cuboid([ldepth,HingeLatchRibWidth,HingeOuterDiameter+1],rounding=HingeOuterDiameter/2, edges=ledges, anchor=TOP+RIGHT);	
						translate([-2*WallThickness-HingeOuterDiameter/2,0,-LatchDistance/2+displace]) ycyl(d=dia, h=HingeLatchRibWidth*2); 
					}
				}
			
			}
			else {
				translate([-InnerBoxDepth/2, ofs+(ScrewLength/2-HingeLatchRibWidth/2),h ]){
					difference() {
						union() {
							cuboid([ldepth,HingeLatchRibWidth,HingeOuterDiameter+1],rounding=HingeOuterDiameter, edges=ledges, except=BOTTOM, anchor=TOP+RIGHT);	
							translate([0,0,-HingeOuterDiameter])  
								cuboid([ldepth,HingeLatchRibWidth,bc],chamfer=ldepth-eps, edges=bedges, anchor=TOP+RIGHT);	
						}	
					translate([-2*WallThickness-HingeOuterDiameter/2,0,-LatchDistance/2+displace]) ycyl(d=dia, h=HingeLatchRibWidth*2); 
					}
				}
				translate([-InnerBoxDepth/2, ofs-(ScrewLength/2-HingeLatchRibWidth/2),h ]){
					difference() {
						union() {
							cuboid([ldepth,HingeLatchRibWidth,HingeOuterDiameter+1],rounding=HingeOuterDiameter, edges=ledges, except=BOTTOM, anchor=TOP+RIGHT);	
							translate([0,0,-HingeOuterDiameter])  
								cuboid([ldepth,HingeLatchRibWidth,bc],chamfer=ldepth-eps, edges=bedges, anchor=TOP+RIGHT);	
						}	
					translate([-2*WallThickness-HingeOuterDiameter/2,0,-LatchDistance/2+displace]) ycyl(d=dia, h=HingeLatchRibWidth*2); 
					}
				}
/*				translate([-ldepth,ofs-(ScrewLength/2-HingeLatchRibWidth/2),h ]){
					difference() {
						union() {
							cuboid([InnerBoxDepth,HingeLatchRibWidth,HingeOuterDiameter+1],rounding=HingeOuterDiameter, edges="Y", except=BOTTOM, anchor=TOP);	
							translate([0,0,-HingeOuterDiameter])  
								cuboid([InnerBoxDepth,HingeLatchRibWidth,cham+1.5],chamfer=HingeOuterDiameter+3, edges="Y", except=TOP, anchor=TOP);	
						}	
					translate([+ldepth-OBoxDepth/2-2*SealThick-ScrewDiameter/2,0,-LatchDistance/2+displace]) ycyl(d=dia, h=HingeLatchRibWidth*2); 
					}
				}*/
			}
			
			
}

module LatchMask ( ofs = 0, dia = 3, cham = 10, h = 20, displace = 0, isLid = false ) {
				translate([-OBoxDepth/2-2*SealThick-ScrewDiameter/2, ofs ,h-LatchDistance/2+displace ]){
						ycyl(d=HingeOuterDiameter+ScrewTol, h=ScrewLength - 2 * HingeLatchRibWidth ); 
				}
			
			
			
			
}
module Rib ( ofs = 0, h= 10) {
			translate([0,ofs,0])  
				cuboid([OBoxDepth+2*SealThick,HingeLatchRibWidth,h ],chamfer=OChamferSize, edges="Y", except=TOP, anchor=BOTTOM);	
	
}



module SideRib ( ofs = 0, h= 10 ) {
			if ( RibDist < InnerBoxDepth/2 ) {
			translate([ofs-RibDist/2-RibWidth/2,0,0])	
				cuboid([RibWidth,OBoxWidth+2*SealThick,h],chamfer=OChamferSize, edges="X", except=TOP, anchor=BOTTOM);	

			translate([-(ofs-RibDist/2-RibWidth/2),0,0])	
				cuboid([RibWidth,OBoxWidth+2*SealThick,h],chamfer=OChamferSize, edges="X", except=TOP, anchor=BOTTOM);
			}
			else {
			translate([ofs,0,0])	
				cuboid([RibWidth,OBoxWidth+2*SealThick,h],chamfer=OChamferSize, edges="X", except=TOP, anchor=BOTTOM);	
			
			}


}

module FBRib ( ofs=0, h=10 ) {
	translate([0,ofs-ScrewLength/2+HingeLatchRibWidth/2,0])  
		cuboid([OBoxDepth+2*SealThick,HingeLatchRibWidth,h ],chamfer=OChamferSize, edges="Y", except=TOP, anchor=BOTTOM);	
	translate([0,ofs+ScrewLength/2-HingeLatchRibWidth/2,0])  
		cuboid([OBoxDepth+2*SealThick,HingeLatchRibWidth,h ],chamfer=OChamferSize, edges="Y", except=TOP, anchor=BOTTOM);	

}

module seal( h = 2, tol = 0 ) {
	swidth = OBoxWidth+2*SealThick;
	sdepth = OBoxDepth+2*SealThick;

	difference() {
	  cuboid([sdepth- 2*SealWall+tol, swidth -2*SealWall +tol , h], rounding=InnerCornerRadius+WallThickness+(SealWall+tol)/2, edges="Z", anchor=BOTTOM);
	  translate([0,0,-0.5]) cuboid([InnerBoxDepth +2*SealWall -tol , InnerBoxWidth + 2*SealWall -tol , h+1 ], rounding=InnerCornerRadius+WallThickness-(SealWall+tol)/2, edges="Z", anchor=BOTTOM);
	
	}


}

module tpuseal ( h1=1, h2=2, tol = 0, e=0 ) {

	if (h1 > TSealTol ) {
	difference() {
			cuboid([OBoxDepth+2*SealThick+e,OBoxWidth+2*SealThick+e,h1], rounding=OCornerRadius+SealThick, edges="Z", anchor=BOTTOM ); 
			translate([0,0,-1]) cuboid ([InnerBoxDepth,InnerBoxWidth,h1+3] , rounding= InnerCornerRadius, edges="Z", anchor=BOTTOM ); 
	}
	}
    seal( h1+h2, tol );
}

module Bottom() {
	difference() {
		union() {
// Main Body		
			Box(OBoxDepth,OBoxWidth,OBoxHeight,OCornerRadius,OChamferSize);
			translate([0,0,OBoxHeight-SealBHeigh])
				Box(OBoxDepth+2*SealThick,OBoxWidth+2*SealThick,SealBHeigh,OCornerRadius+SealThick,SealThick,SealCAng);

// large Ribs
			if (NumRibs == 1 ) {
				SideRib (0,OBoxHeight);
			} else if (NumRibs == 2 ) {
				SideRib(OBoxDepth/4,OBoxHeight);
				SideRib(-OBoxDepth/4,OBoxHeight);
			} else {
				SideRib (0,OBoxHeight);
				SideRib(OBoxDepth/3,OBoxHeight);
				SideRib(-OBoxDepth/3,OBoxHeight);
	
			}

// small Ribs for Hinges and Latch
			if (NumHinge % 2 == 1)  {
				FBRib ( 0, OBoxHeight );
			}
			if (NumHinge >= 2) {
			FBRib ( ldist, OBoxHeight );
			FBRib ( -ldist, OBoxHeight );
			}

// Hinge	
			if (NumHinge % 2 == 1)  {
				BottomHinge( ofs = 0, diaB = ScrewDiameter, diaS= ScrewThreadDiameter );
			}
			if (NumHinge >= 2) {

				BottomHinge( ofs = ldist, diaB = ScrewDiameter, diaS= ScrewThreadDiameter );
				BottomHinge( ofs = -ldist, diaB = ScrewDiameter, diaS= ScrewThreadDiameter );
			}

// Latch
			if (NumLatch %2 == 1) {
				LatchHold ( ofs = 0, dia = ScrewDiameter, cham = BoxLatchRibChamfer, h = OBoxHeight, displace=-LatchDisplacement );
			}
			if (NumLatch >= 2) {
				LatchHold ( ofs = ldist, dia = ScrewDiameter, cham = BoxLatchRibChamfer, h = OBoxHeight,displace=-LatchDisplacement );
				LatchHold ( ofs = -ldist, dia = ScrewDiameter, cham = BoxLatchRibChamfer, h = OBoxHeight,displace=-LatchDisplacement );
			}	
		}

// subtract interior
 
		translate([0,0,WallThickness]) Box(InnerBoxDepth,InnerBoxWidth,InnerBoxBottomHeight+1,InnerCornerRadius,InnerChamferSize);
		
		if (TSealHeight > 0) {
			translate([0,0,OBoxHeight+1]) rotate([180,0,0]) tpuseal ( h1=TSealHeight+1, h2=SealHeight+TSealLid+SealTol, tol=SealTol,e=eps );
		}
		else {
		
		translate([0,0,OBoxHeight-SealHeight]) seal ( h= SealHeight+1, tol=0 ); //SealTol);
		}
		bottomdiff() ;
		
	}
	// Interior
	translate([0,0,WallThickness])	
		intersection() {
				Box(InnerBoxDepth,InnerBoxWidth,InnerBoxBottomHeight+1,InnerCornerRadius,InnerChamferSize);
				translate([-InnerBoxDepth/2,-InnerBoxWidth/2,0]) children();
		}
		
	bottomadd();
}


module Lid() {
	difference() {
		union() {
			Box(OBoxDepth,OBoxWidth,OLidHeight,OCornerRadius,OChamferSize);
			translate([0,0,OLidHeight-SealBHeigh])
				Box(OBoxDepth+2*SealThick,OBoxWidth+2*SealThick,SealBHeigh,OCornerRadius+SealThick,SealThick,SealCAng);
	
	// large Ribs (Side)
			if (NumRibs == 1 ) {
				SideRib (0,OLidHeight);
			} else if (NumRibs == 2 ) {
				SideRib(OBoxDepth/4,OLidHeight);
				SideRib(-OBoxDepth/4,OLidHeight);
			} else {
				SideRib (0,OLidHeight);
				SideRib(OBoxDepth/3,OLidHeight);
				SideRib(-OBoxDepth/3,OLidHeight);
	
			}

	// small Ribs for Hinges and Latch
			if (NumHinge % 2 == 1)  {
				FBRib ( 0, OLidHeight );
			}
			if (NumHinge >= 2) {
			FBRib ( ldist, OLidHeight );
			FBRib ( -ldist, OLidHeight );
			}
	// Hinge 
			if (NumHinge %2 == 1 ) {
				LidHinge(0);
			}
			if (NumHinge >= 2 ) {
				LidHinge(ldist);
				LidHinge(-ldist);
			}
			
	// Latch
			if (NumLatch %2 == 1) {
				LatchHold ( ofs = 0, dia = ScrewDiameter, cham = LidLatchRibChamfer, h = OLidHeight, displace=LatchDisplacement, isLid = true );
			}
			if (NumLatch >= 2) {
				LatchHold ( ofs = ldist, dia = ScrewDiameter, cham = LidLatchRibChamfer, h = OLidHeight, displace=LatchDisplacement, isLid = true );
				LatchHold ( ofs = -ldist, dia = ScrewDiameter, cham = LidLatchRibChamfer, h = OLidHeight, displace=LatchDisplacement, isLid = true );
			}	

			
	} // union
		translate([0,0,WallThickness]) Box(InnerBoxDepth,InnerBoxWidth,InnerBoxLidHeight+1,InnerCornerRadius,InnerChamferSize);
		translate([0,0,OLidHeight]) cuboid ([OBoxDepth+2*SealThick,OBoxWidth+2*SealThick,10],rounding=OCornerRadius, edges="Z", anchor=BOTTOM);
		if (NumLatch %2 == 1) {
			LatchMask ( ofs = 0, dia = ScrewDiameter, cham = LidLatchRibChamfer, h = OLidHeight, displace=LatchDisplacement, isLid = true );
		}
			if (NumLatch >= 2) {
			LatchMask ( ofs = ldist, dia = ScrewDiameter, cham = LidLatchRibChamfer, h = OLidHeight, displace=LatchDisplacement, isLid = true );
			LatchMask ( ofs = -ldist, dia = ScrewDiameter, cham = LidLatchRibChamfer, h = OLidHeight, displace=LatchDisplacement, isLid = true );
		}
		liddiff();
	
	}
	// Seal	

	if (TSealHeight > 0) {
		translate([0,0,OLidHeight-SealTol]) seal ( h= TSealLid+SealTol, tol=-4*SealTol);
	} 
	else {
		translate([0,0,OLidHeight-SealTol]) seal ( h= SealHeight, tol=-SealTol);
	}

	if (InteriorToLid) {
		translate([0,0,WallThickness])	
			intersection() {
					Box(InnerBoxDepth,InnerBoxWidth,InnerBoxLidHeight,InnerCornerRadius,InnerChamferSize);
					scale([1,1,InnerBoxLidHeight/InnerBoxBottomHeight])
					translate([-InnerBoxDepth/2,-InnerBoxWidth/2,0]) 
						translate([0,InnerBoxWidth,0]) mirror([0,1,0]) children();
			}
	}
	lidadd();

}

module Latch () {
	lh = ScrewLength - 2 * HingeLatchRibWidth - LatchWidthTolerance;

	difference() {
		union() {
			zcyl(d=HingeOuterDiameter, h = lh, anchor=BOTTOM);
			translate([LatchDistance,0,0] )  	zcyl(d=HingeOuterDiameter, h= lh, anchor=BOTTOM );
		
			pang=asin((LatchDistance/2) / (LatchRoundRad + LatchWall) )*2;
			translate([LatchDistance/2,LatchRoundRad-ScrewDiameter/4,0])
			difference() {
				rotate([0,0,-90-pang/2]) pie_slice (ang=pang, l=lh, r=LatchRoundRad+LatchWall);
				rotate([0,0,-90-pang/2 - 2]) translate([0,0,-1]) pie_slice (ang=pang+10, l=lh+2, r=LatchRoundRad);
				}
			hull() {		
				translate([LatchDistance,0,0] )  	zcyl(d=LatchWall, h= lh, anchor=BOTTOM );
				translate([LatchDistance+LatchHandleLen,-LatchHandleOfs,0] )  	zcyl(d=LatchWall, h= lh, anchor=BOTTOM );
			}
		}
		translate([0,0,-1]) {
			zcyl(d=ScrewDiameter+ScrewTol, h = lh+2, anchor=BOTTOM);
			translate([LatchDistance,0,0] )  	zcyl(d=ScrewDiameter, h= lh+2, anchor=BOTTOM );
			translate([LatchDistance+ScrewDiameter/3,0,0] )		cuboid([HingeOuterDiameter,HingeOuterDiameter,lh+2],anchor=BOTTOM+RIGHT+FRONT );	
			
		}
	}


}

// Wall in Wide (Y) direction
module wwall (startx=0, starty=0, len=100, hi=100, thick=iWall ) {
	translate([startx/100*InnerBoxDepth,starty/100*InnerBoxWidth,0])
		cuboid([thick,len/100*InnerBoxWidth,hi/100*InnerBoxBottomHeight],anchor=BOTTOM+FRONT);


}

// Wall in Depth (X) direction
module dwall (startx=0, starty=0, len=100, hi=100, thick=iWall ) {
	translate([startx/100*InnerBoxDepth,starty/100*InnerBoxWidth,0])
		cuboid([len/100*InnerBoxDepth,thick,hi/100*InnerBoxBottomHeight],anchor=BOTTOM+LEFT);


}



module complete() {
Bottom() Interior();
if (TSealHeight > 0) {
	translate([0,0,OBoxHeight]) color("Black") rotate([180,0,0]) tpuseal ( h1=TSealHeight+TSealTol, h2=SealHeight+TSealLid+TSealTol, tol=0, e= 0 );
}

translate([0,0,OLidHeight+OBoxHeight]) rotate([180,0,0]) { 
	Lid() Interior();
		if (NumLatch %2 == 1) {
			translate([-OBoxDepth/2-2*SealThick-ScrewDiameter/2, -(ScrewLength - 2 * HingeLatchRibWidth - LatchWidthTolerance)/2,OLidHeight-LatchDistance/2+LatchDisplacement ])
				color("Grey")  rotate([-90,-90,0]) Latch();
		}
		if (NumLatch >= 2) {
			translate([-OBoxDepth/2-2*SealThick-ScrewDiameter/2, ldist-(ScrewLength - 2 * HingeLatchRibWidth - LatchWidthTolerance)/2,OLidHeight-LatchDistance/2+LatchDisplacement ])
				color("Grey")  rotate([-90,-90,0]) Latch();
			translate([-OBoxDepth/2-2*SealThick-ScrewDiameter/2, -ldist-(ScrewLength - 2 * HingeLatchRibWidth - LatchWidthTolerance)/2,OLidHeight-LatchDistance/2+LatchDisplacement ])
				color("Grey")  rotate([-90,-90,0]) Latch();

		}	

	
		
		
		
	}
}
module completeOpen() {
	Bottom() Interior();
	if (TSealHeight > 0) {
		translate([0,0,OBoxHeight]) color("Black") rotate([180,0,0]) tpuseal ( h1=TSealHeight+TSealTol, h2=SealHeight+TSealLid+TSealTol, tol=0, e= 0 );
	}

translate([OBoxDepth/2+SealHeight+HingeOuterDiameter/2,0,OBoxHeight]) 
	rotate([0,ViewAngle,0])
	translate([-OBoxDepth/2-SealThick-HingeOuterDiameter/2,0,OLidHeight])
    rotate([180,0,0]) { 
	Lid() Interior();
		if (NumLatch %2 == 1) {
			translate([-OBoxDepth/2-2*SealThick-ScrewDiameter/2, -(ScrewLength - 2 * HingeLatchRibWidth - LatchWidthTolerance)/2,OLidHeight-LatchDistance/2+LatchDisplacement ])
				color("Grey")  rotate([-90,-90,0]) Latch();
		}
		if (NumLatch >= 2) {
			translate([-OBoxDepth/2-2*SealThick-ScrewDiameter/2, ldist-(ScrewLength - 2 * HingeLatchRibWidth - LatchWidthTolerance)/2,OLidHeight-LatchDistance/2+LatchDisplacement ])
				color("Grey")  rotate([-90,-90,0]) Latch();
			translate([-OBoxDepth/2-2*SealThick-ScrewDiameter/2, -ldist-(ScrewLength - 2 * HingeLatchRibWidth - LatchWidthTolerance)/2,OLidHeight-LatchDistance/2+LatchDisplacement ])
				color("Grey")  rotate([-90,-90,0]) Latch();

		}	

	
		
		
		
	}
}

module parts () {
	Bottom() Interior();
	translate ([OBoxDepth+30, 0, 0]) Lid() Interior();
	translate ([OBoxDepth+30, OBoxWidth+30, 0]) tpuseal ( h1=TSealHeight+TSealTol, h2=SealHeight+TSealLid+TSealTol, tol=0, e= 0 );
	translate ([0,OBoxWidth+30, 0]){
		if (NumLatch %2 == 1) Latch(); 
		if (NumLatch >= 2) {
			translate([0,-20,0]) Latch();
			translate([0,20,0]) Latch();
		}	
	}		
    	
	
}




if ( View=="Complete Open") {
completeOpen();
}
else if ( View=="Complete"){
complete();
}
else if ( View=="Parts"){
parts();
}
else if ( View=="Lid"){
Lid() { Interior(); }
}
else if ( View=="Bottom") {
Bottom() { Interior();  }
}
else if ( View=="Latch") {
Latch();
}
else if ( View=="Seal") {
tpuseal ( h1=TSealHeight+TSealTol, h2=SealHeight+TSealLid+TSealTol, tol=0, e= 0 );
}
