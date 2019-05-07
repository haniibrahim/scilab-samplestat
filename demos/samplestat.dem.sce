// Copyright (C) 2016 Hani Andreas Ibrahim
//
// This program is free software; you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation; either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, see <http://www.gnu.org/licenses/>.

// SampleStatDemo is a demo script for the toolbox_samplestat
// - ST_strayarea.sci
// - ST_trustarea.sci
// Core functions as mean(), stdev(), min() and max() are also used.
// Author: Hani Andreas Ibrahim <hani.ibrahim@gmx.de>
// License: GPL 3.0

function samplestat_demo()

    // Sample data
    v = [ ..
    9.999; ..
    9.998; ..
    10.002; ..
    10.000; ..
    10.001; ..
    10.000 ..
    ];

    // Statistical confidence level
    p = "95%";

    // Calculate statistical results
    n  = length(v);           // Number of values
    x  = mean(v);             // Arithmetic mean
    s  = stdev (v);           // Sample standard deviation
    sa = ST_strayarea(v, p);  // Range of dispersion of the values (stray area)
    ta = ST_trustarea(v, p);  // Range of dispersion of the mean (trust area)
    mi = min(v);              // Minimal value
    ma = max(v);              // Maximal value

    // Output
    clc;
    mprintf("\nDemo for range of dispersion (stray- and trustarea)\n\n");
    mprintf("Values:\n");
    disp(v); // Display data
    mprintf("\n"); // blank line
    mprintf(..
    "Number of Values            : %i\n" + ..
    "Arithmetic Mean             : %f\n" + ..
    "Sample standard Deviation   : %f\n" + ..
    "Confidence Level            : %s\n" + ..
    "Range of Dispersion (values): %f\n" + ..
    "Range of Dispersion (mean)  : %f\n" + ..
    "Minimum                     : %f\n" + ..
    "Maximum                     : %f\n", ..
    n, x, s, p, sa, ta, mi, ma);

    mprintf("\n"); // blank line

    mprintf( ..
    "68 percent of the values will stray arount %.3f +/- %.3f (sample standard \n" + .. 
    "deviation). %s of the values will be expected around %.3f +/- %.3f (Range \n" + ..
    "of disp. of the values, stray area).\n" + ..
    "With a propability of %s the mean of %.3f will stray around %.3f +/- %.3f \n" + ..
    "(Rage of dispersion of the mean, trust area).\n", x, s, p, x, sa, p, x, x, ta);
    
    //
    // Load this script into the editor
    //
    filename = "samplestat.dem.sce";
    dname = get_absolute_file_path(filename);
    editor ( fullfile(dname,filename) );

endfunction

// Main

samplestat_demo();
clear samplestat_demo;
