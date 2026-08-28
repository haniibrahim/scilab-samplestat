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

function outlier_demo()
    // Outlier-Demo is a demo script of the toolbox "samplestat"
    // ist uses the outlier-tests GRUBBS and ESD
    // Author: Hani Andreas Ibrahim <hani.ibrahim@gmx.de>
    // License: GPL 3.0
    
    clc;
    
    // Data ========================================================
    data1 = [ ..
    10.195, 10.625, 9.294, 10.405, 9.619, 13.446 ..
    ]
    
    data2 = [9.060, 8.864, 10.404, 9.450, 11.053, ...
       9.537, 9.809, 9.940, 9.827, 9.282, ...
       9.044, 10.525, 9.712, 9.911, 8.615, ...
       9.951, 10.419, 10.676, 6.882, 12.985];

    n = length(data1); // Sample size

    // Individual value plot =======================================
    clf();
    title("Individual Value Plots")
    subplot(1,2,1);
    ST_ivplot(data1,"Data 1",".");
    subplot(1,2,2);
    ST_ivplot(data2, "Data 2",".", 0.02, 0.1);
    sda();
    
    // 6 values => Grubbs test
    // of: oulier-free values
    // o : outliers
    [g_of095, g_o095] = ST_grubbs(data1, "95%");
    [g_of099, g_o099] = ST_grubbs(data1, "99%");
    [g_of999, g_o999] = ST_grubbs(data1, "99.9%");
    
    // 22 samples => ESD test, max 3 outliers commited
    // of: oulier-free values
    // o : outliers
    [e_of095, e_o095] = ST_esd(data2, "95%", 2);
    [e_of099, e_o099] = ST_esd(data2, "99%", 2);
    [e_of999, e_o999] = ST_esd(data2, "99.9%", 2);

    // Output ======================================================
    
    // Avoid problems in Scilab 6 w/ empty matrices [] and the + in disp()
    // => if +[] the whole string is []
    if g_o095 == [] then g_o095 = "none"; end
    if g_o099 == [] then g_o099 = "none"; end
    if g_o999 == [] then g_o999 = "none"; end
    if e_o095 == [] then e_o095 = "none"; end
    if e_o099 == [] then e_o099 = "none"; end
    if e_o999 == [] then e_o999 = "none"; end
    
    // Console output
    
    mprintf("\n" + ..
        "Grubbs and ESD (Generalized Extreme Studentized Deviate) Outlier- and \n" + ..
        "Shapiro-Wilk distribution test as well as individual value plot\n\n" + ..
        "Data record 1:" + ..
        "\n");
    disp(data1')
    mprintf("\nData record 2:\n")
    disp(data2')
    
    mprintf("\n" + ..
            "GRUBBS OUTLIER TEST ON DATA RECORD 1\n" + ..
            "====================================\n")
    mprintf("Data record 1: Grubbs-Outliers at 95%% confidence level (probable outliers):\n");
    disp(g_o095);
    mprintf("Data record 1: Grubbs-Outliers at 99%% confidence level (signigicant outliers):\n");
    disp(g_o099);
    mprintf("Data record 1: Grubbs-Outliers at 99.9%% confidence level (highly significant outliers):\n");
    disp(g_o099);
    
    mprintf("\n" + ..
            "ESD OUTLIER TEST ON DATA RECORD 2\n" + ..
            "=================================\n")
    mprintf("Data record 2: ESD-Outliers at 95%% confidence level (probable outliers):\n");
    disp(e_o095);
    mprintf("Data record 2: ESD-Outliers at 99%% confidence level (signigicant outliers):\n");
    disp(e_o099)
    mprintf("Data record 2: ESD-Outliers at 99.9%% confidence level (highly significant outliers):\n");
    disp(e_o999)

//    disp("Dean-Dixon-Outliers at 95% confidence level  : " + string(o095) + " (probable outliers)")
//    disp("Dean-Dixon-Outliers at 99% confidence level  : " + string(o099) + " (significant outliers)")
//    disp("Dean-Dixon-Outliers at 99.9% confidence level: " + string(o999) + " (highly significant outliers")
//
//    disp("Outlier(s): " + string(o095) + " does show up at 95% confidence level only, therefore it is a probable outlier.")

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
