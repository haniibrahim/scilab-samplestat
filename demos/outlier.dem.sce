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

function outlier_demo()
    clc;
    dat1 = [ ..
    30.41 30.05 30.49 29.22 30.40 30.42 ..
    ]

    n = length(dat1); // Sample size

    // Plot individual value plot because of sample size
    ST_ivplot(dat1,"values") // EXPERIMENTAL

    // 6 values only => Dean-Dixon test is best
    // of: oulier-free values
    // o : outliers
    [of095, o095] = ST_deandixon(dat1, "95%");
    [of099, o099] = ST_deandixon(dat1, "99%");
    [of999, o999] = ST_deandixon(dat1, "99.9%");

    // Output

    disp("Outliertest for a sample size of 6 values => Dean-Dixon test and individual value plot is recommended")

    disp("Values:")
    disp(dat1')

    disp("Dean-Dixon-Outliers 95% confidence level  : " + string(o095) + " (probable outliers)")
    disp("Dean-Dixon-Outliers 99% confidence level  : " + string(o099) + " (significant outliers)")
    disp("Dean-Dixon-Outliers 99.9% confidence level: " + string(o999) + " (highly significant outliers")

    disp("Outlier(s): " + string(o095) + " does show up at 95% confidence level only, therefore it is a probable outlier.")

    //
    // Load this script into the editor
    //
    filename = "outlier.dem.sce";
    dname = get_absolute_file_path(filename);
    editor ( fullfile(dname,filename) );

endfunction

// Main
outlier_demo();
clear outlier_demo;
