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

function ivp_demo()
    // Individual-Value-Plot-Demo is a demo script of the toolbox "samplestat"
    // Author: Hani Andreas Ibrahim <hani.ibrahim@gmx.de>
    // License: GPL 3.0

    clc;

    // Single data record ======================================================
    data = [9.999 9.998 10.002 10.000 10.001 10.000];
    scf();
    clf();
    ST_ivplot(data, "Product");
    ylabel("");
    title("Individual-Value-Plot from single data record");


    // Multi data records in a list & different sample sizes ===================
    data1 = [9.999 9.998 10.002 10.000 10.001 10.000 10. 10. 10. 10. 10. 10. ];
    data2 = [10.003 10.001 10.001 10.004 9.997];
    data3 = [9.995 10.000 10.000 10.000 10.002 10.004 10.006];
    scf();
    clf();
    ST_ivplot( ..
    list(data1, data2, data3), ..
    ["Lot A", "Lot B", "Lot C"], ..
    "d");
    title("Multi data records in a list & different sample sizes");


    //  Multi data record in a matrix ==========================================
    data4 = [
    10.1  10.4  10.0;
    10.2  10.3  10.1;
    10.2  10.5  10.1;
    10.4  10.4  10.2;
    10.3  10.6  10.3
    ];
    scf();
    clf();
    ST_ivplot(data4, ["Product 1", "Product 2", "Product 3"], ".", 0.04);
    ylabel("mmol/L");
    title("Multi data record in a matrix")
    

    // Tolerance limit specified for nearly identical values ===================
    // tolerance=0.000001

    data5 = [
    10.0000000
    10.0000001
    9.9999999
    10.1000000
    9.9000000
    9.9500000
    ];
    scf();
    clf();
    ST_ivplot(data5, "Sample", "xr", 0.02, 0.000001);
    title("Tolerance limit specified for nearly identical values")


    //  Multi data record in a matrix & arbitrary color ========================
    data4 = [
    1.1  1.4  1.0;
    1.2  1.3  1.1;
    1.2  1.5  1.1;
    1.4  1.4  1.2;
    1.3  1.6  1.3
    ];
    scf();
    clf();

    // Add arbitrary color, here light gray
    grey = [0.65 0.65 0.65];           // Set gray color as RGB (red green blue)
    f = gcf();                         // Get handle of graphic window
    f.color_map = [f.color_map; grey]; // Add gray to the color map
    grey_idx = size(f.color_map, 1);   // Index of gray in color map

    // Plot IVP
    ST_ivplot(data4, ["Sample 1", "Sample 2", "Sample 3"], ".", 0.04);

    // Apply color
    h = gce();                         // Get handle of the current entity,
    // here IV-plot
    h.children.mark_foreground = ..    // Apply gray to the plot 
    grey_idx;

    // Apply labels
    ylabel("Density (kg/m³)");
    title("Multi data record in a matrix & arbitrary color")
    
    // =========================================================================
    //
    // Load this script into the editor
    //
    filename = "ivp.dem.sce";
    dname = get_absolute_file_path(filename);
    editor ( fullfile(dname,filename) );

endfunction

// Main
ivp_demo();
clear ivp_demo;
