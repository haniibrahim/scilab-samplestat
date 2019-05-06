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
