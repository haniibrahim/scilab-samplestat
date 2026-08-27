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

function distribution_demo()
    // Distribution-Test-Demo is a demo script of the toolbox "samplestat"
    // it uses the distribution test for normality Shapiro-Wilk
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
    
   
    // Distribution test ===========================================
    [sw1_90, w1] = ST_shapirowilk(data1,"90%"); 
    [sw1_95]     = ST_shapirowilk(data1,"95%"); 
    [sw1_99]     = ST_shapirowilk(data1,"99%"); 
    [sw2_90, w2] = ST_shapirowilk(data2,"90%"); 
    [sw2_95]     = ST_shapirowilk(data2,"95%"); 
    [sw2_99]     = ST_shapirowilk(data2,"99%"); 

    // Output ======================================================
    // Console output
    
    mprintf("\n" + ..
        "Shapiro-Wilk distribution test and individual value plot\n\n" + ..
        "Data record 1:" + ..
        "\n");
    disp(data1')
    mprintf("\nData record 2:\n")
    disp(data2')
    
    mprintf("\n" + ..
            "SHAPIRO-WILK TEST FOR NORMAL DISTRIBUTIONS\n" + ..
            "==========================================\n")
    mprintf("Data record 1 normally distributed with 90%% confidence? => %s \n", sw1_90);
    mprintf("Data record 1 normally distributed with 95%% confidence? => %s \n", sw1_95);
    mprintf("Data record 1 normally distributed with 99%% confidence? => %s \n", sw1_99);
    mprintf("Data record 1 test statistic                            => W = %g \n\n", w1);
    
    mprintf("Data record 2 normally distributed with 90%% confidence? => %s \n", sw2_90);
    mprintf("Data record 2 normally distributed with 95%% confidence? => %s \n", sw2_95);
    mprintf("Data record 2 normally distributed with 99%% confidence? => %s \n", sw2_99);
    mprintf("Data record 2 test statistic                            => W = %g \n\n", w2);
    
    mprintf("The value W allows to see exactly how well or poorly a dataset passes\n " + ..
            "or fails the normality test, rather than just seeing %%T or %%F. \n"      + ..
            "The closer W is to 1, the more clearly the distribution follows \n"       + ..
            "a normal distribution");

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
