include <portal.scad>
use <bottom-frame.scad>

$fn = 5;
$previes = true;
$show_threads = true;

GHOST=false;
bottomFrame();
translate([ portal_y_margin, 0, 0 ]) portal();

// nut_in_plastic();