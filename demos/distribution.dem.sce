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

function distribution_demo()
    clc;

    dat1=[ .. 
    94.8 97.6 98.2 98.4	99.2 99.4 99.8 94.8	97.7 98.2 98.5 99.2 99.4 100 95.1 97.8 .. 
    98.2 98.6 99.2 99.5 100.1 97 97.8 98.3 98.7 99.3 99.5 100.2 97 97.9 98.4 98.9 ..
    99.3 99.5 100.3 97.1 97.9 98.4 99.2 99.4 99.6 100.3 97.3 98.2 98.4 99.2 99.4 ..
    99.7 100.5 ..
    ];

    // Check for sample size
    n=length(dat1);
    disp("Check for sample size: " + string(n))
    W=0;
    //Check for skewness & normal distribution
    nclass = round(sqrt(n)) // number of classes for the histogram, Rule of thumb: sqrt(n)
    histplot(nclass,dat1,style=2);
    //W = ST_shapirowilk(dat1)); // 1=normal distributed 0=not normal distributed
    disp("Check for normality via Shapiro-Wilk: W = " + string(W))
    
    disp("Values are NOT normal distributed according histogram and " + ..
    "Shapiro-Wilk test (W=0), normal distributed values W=1")
    disp("SampleSTAT''s routines cannot be applied to this data! ")
    
    //
    // Load this script into the editor
    //
    filename = "distribution.dem.sce";
    dname = get_absolute_file_path(filename);
    editor ( fullfile(dname,filename) );
    
endfunction

// Main

distribution_demo();
clear distribution_demo;




