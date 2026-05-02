// ============================================================================
// 3D Transistor Mesh: Variable Z-Refinement + Hexahedrons + Doping Fields
// ============================================================================

// --- Characteristic lengths for mesh sizing ---
lc_sub  = 0.25;     
lc_chan = 0.0125;   
lc_gox  = 0.0675;   
lc_fine = 0.005;     

// ============================================================================
// 1. Base 2D Geometry (Z = 0)
// ============================================================================

// --- Points ---
Point(1) = {-1.000, -0.65, 0, lc_sub};
Point(2) = {1.000, -0.65, 0, lc_sub};
Point(3) = {1.000, -0.30, 0, lc_chan};
Point(4) = {-1.000, -0.30, 0, lc_chan};
Point(5) = {1.000, -0.2, 0, lc_chan};
Point(6) = {-1.000, -0.2, 0, lc_chan};

Point(7) = {1.000, 0.0, 0, lc_chan};
Point(8) = {-1.000, 0.0, 0, lc_chan};
Point(9) = {-0.900, 0.0, 0, lc_chan};       
Point(10) = {-0.250, 0.0, 0, lc_chan};      
Point(11) = {-0.175, 0.0, 0, lc_fine};      
Point(12) = {0.175, 0.0, 0, lc_fine};       
Point(13) = {0.250, 0.0, 0, lc_chan};       
Point(14) = {0.900, 0.0, 0, lc_chan};       

Point(15) = {-0.175, 0.025, 0, lc_gox};
Point(16) = {-0.15, 0.025, 0, lc_gox};      
Point(17) = {0.15, 0.025, 0, lc_gox};       
Point(18) = {0.175, 0.025, 0, lc_gox};

// --- Lines ---
Line(1) = {1, 2}; 
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Line(5) = {3, 5};
Line(6) = {5, 6};
Line(7) = {6, 4};

Line(8) = {5, 7};
Line(9) = {7, 14};
Line(10) = {14, 13}; 
Line(11) = {13, 12};
Line(12) = {12, 11}; 
Line(13) = {11, 10};
Line(14) = {10, 9};  
Line(15) = {9, 8};
Line(16) = {8, 6};

Line(17) = {12, 18};
Line(18) = {18, 17};
Line(19) = {17, 16}; 
Line(20) = {16, 15};
Line(21) = {15, 11};

// --- Surfaces ---
Curve Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};

Curve Loop(2) = {-3, 5, 6, 7};
Plane Surface(2) = {2};

Curve Loop(3) = {-6, 8, 9, 10, 11, 12, 13, 14, 15, 16};
Plane Surface(3) = {3};

Curve Loop(4) = {-12, 17, 18, 19, 20, 21};
Plane Surface(4) = {4};

// ============================================================================
// 2. Dummy Geometry for mgauss Doping Fields
// ============================================================================
// These lines act as scaffolding to pull the mesh tight where doping gradients are highest.
Point(101) = {-0.900, -0.200, 0};
Point(102) = {-0.175, -0.200, 0};
Line(101) = {101, 102}; // Source Bottom Junction
Line(102) = {102, 11};  // Source Side Junction

Point(103) = {0.175, -0.200, 0};
Point(104) = {0.900, -0.200, 0};
Line(103) = {12, 103};  // Drain Side Junction 
Line(104) = {103, 104}; // Drain Bottom Junction

// ============================================================================
// 3. 2D Mesh Refinement Fields
// ============================================================================
Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeFromPoints = 0;

Field[1] = Distance;
Field[1].CurvesList = {12, 101, 102, 103, 104};
Field[1].NumPointsPerCurve = 300;

Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = lc_fine;
Field[2].SizeMax = lc_sub;
Field[2].DistMin = 0.010; 
Field[2].DistMax = 0.150; 

Field[3] = Box;
Field[3].VIn = lc_chan;
Field[3].VOut = lc_sub;
Field[3].XMin = -1.100;
Field[3].XMax =  1.100;
Field[3].YMin = -0.300; 
Field[3].YMax =  0.050; 

Field[4] = Min;
Field[4].FieldsList = {2, 3};

Background Field = 4;


// ============================================================================
// 5. 3D Extrusion (Structured with Variable Z-Refinement)
// ============================================================================
z_layers = 3; 

// Extrude using Layers and Recombine to force a swept, structured mesh
v_sub[] = Extrude {0, 0, 1.0} { Surface{1}; Layers{z_layers} ; };
v_box[] = Extrude {0, 0, 1.0} { Surface{2}; Layers{z_layers} ; };
v_chn[] = Extrude {0, 0, 1.0} { Surface{3}; Layers{z_layers}; };
v_gox[] = Extrude {0, 0, 1.0} { Surface{4}; Layers{z_layers}; };

// ============================================================================
// 6. Physical Groups (Mapped to 3D Extrusion Arrays)
// ============================================================================
Physical Volume("substrateregion") = {v_sub[1]};
Physical Volume("buriedoxide")     = {v_box[1]};
Physical Volume("channel")         = {v_chn[1]};
Physical Volume("gateoxide")       = {v_gox[1]};

Physical Surface("substrate")                = {v_sub[2]}; 
Physical Surface("drain")                    = {v_chn[5]}; 
Physical Surface("source")                   = {v_chn[9]}; 
Physical Surface("gate")                     = {v_gox[5]}; 
Physical Surface("gateoxideislandinterface") = {v_chn[7]}; 

// Zip up overlapping internal walls created by extrusion
