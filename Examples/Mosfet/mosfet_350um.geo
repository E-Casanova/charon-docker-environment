// Characteristic lengths for mesh sizing (based on surface interval sizes)
lc_sub  = 0.025;     
lc_chan = 0.0125;    
lc_gox  = 0.00675;   
lc_fine = 0.002;     

// --- Points ---
// Substrate & Buried Oxide Bounds (Widened to 1.0 um total)
Point(1) = {-0.500, -0.35, 0, lc_sub};
Point(2) = {0.500, -0.35, 0, lc_sub};
Point(3) = {0.500, -0.10, 0, lc_chan};
Point(4) = {-0.500, -0.10, 0, lc_chan};
Point(5) = {0.500, -0.05, 0, lc_chan};
Point(6) = {-0.500, -0.05, 0, lc_chan};

// Channel & Contacts along Y = 0.0
Point(7) = {0.500, 0.0, 0, lc_chan};
Point(8) = {-0.500, 0.0, 0, lc_chan};
Point(9) = {-0.400, 0.0, 0, lc_chan};       // Source start
Point(10) = {-0.200, 0.0, 0, lc_chan};      // Source end
Point(11) = {-0.175, 0.0, 0, lc_fine};      // Gate oxide left (Start of 350nm channel)
Point(12) = {0.175, 0.0, 0, lc_fine};       // Gate oxide right (End of 350nm channel)
Point(13) = {0.200, 0.0, 0, lc_chan};       // Drain start
Point(14) = {0.400, 0.0, 0, lc_chan};       // Drain end

// Gate Oxide Top & Contact along Y = 0.005
Point(15) = {-0.175, 0.005, 0, lc_gox};
Point(16) = {-0.170, 0.005, 0, lc_gox};     // Gate contact left
Point(17) = {0.170, 0.005, 0, lc_gox};      // Gate contact right
Point(18) = {0.175, 0.005, 0, lc_gox};

// --- Lines ---
// Substrate
Line(1) = {1, 2}; // Substrate contact
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

// Buried Oxide OPTIONAL
Line(5) = {3, 5};
Line(6) = {5, 6};
Line(7) = {6, 4};

// Channel & Interface Lines
Line(8) = {5, 7};
Line(9) = {7, 14};
Line(10) = {14, 13}; // Drain contact
Line(11) = {13, 12};
Line(12) = {12, 11}; // Gate oxide / Channel interface
Line(13) = {11, 10};
Line(14) = {10, 9};  // Source contact
Line(15) = {9, 8};
Line(16) = {8, 6};

// Gate Oxide
Line(17) = {12, 18};
Line(18) = {18, 17};
Line(19) = {17, 16}; // Gate contact
Line(20) = {16, 15};
Line(21) = {15, 11};

// --- Surfaces ---
// Substrate
Curve Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};

// Buried Oxide
Curve Loop(2) = {-3, 5, 6, 7};
Plane Surface(2) = {2};

// Channel
Curve Loop(3) = {-6, 8, 9, 10, 11, 12, 13, 14, 15, 16};
Plane Surface(3) = {3};

// Gate Oxide
Curve Loop(4) = {-12, 17, 18, 19, 20, 21};
Plane Surface(4) = {4};

// --- Physical Groups (Blocks and Sidesets) ---
// Volumes
Physical Surface("substrateregion") = {1};
Physical Surface("buriedoxide") = {2};
Physical Surface("channel") = {3};
Physical Surface("gateoxide") = {4};

// Contacts / Boundaries
Physical Curve("substrate") = {1};
Physical Curve("drain") = {10};
Physical Curve("gate") = {19};
Physical Curve("source") = {14};
Physical Curve("gateoxideislandinterface") = {12};

// --- Mesh Refinement ---
// Create a bounding box for finer resolution as defined in the .jou file
Field[1] = Box;
Field[1].VIn = lc_fine;
Field[1].VOut = lc_chan;
Field[1].XMin = -0.500;
Field[1].XMax = 0.500;
Field[1].YMin = -0.05;
Field[1].YMax = 0.001;

Background Field = 1;