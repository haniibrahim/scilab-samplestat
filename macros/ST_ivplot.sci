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

function ST_ivplot(dat, datname)
    // Very basic Individual Value Plot (EXPERIMENTAL)
    //
    // Calling Sequence
    //   ST_ivplot(v)
    //   ST_ivplot(v, datname)
    //
    // Parameters
    // v: n-by-1 or 1-by-m matrix of doubles, numerical values (n>10, better n>25)
    // datname: 1-by-1 matrix of strings, name of the data, displayed unter the data set in the graph
    //
    // Description
    // Individual value plots (IVP) are well suited for evaluating and comparing 
    // distributions of sample data. A IVP displays a point for the actual value 
    // of each observation in a group, making it easy to identify outliers and 
    // see the dispersion of the distribution. A IVP is especially recommended 
    // for small sample sizes in comparison to histograms, box-plots and QQ-plots,
    // which need at least 20 values to be significant.
    //
    // <inlinemediaobject>
    //  <imageobject>
    //      <imagedata fileref="../../images/ivplot.png" align="center" valign="middle"/>
    //  </imageobject>
    // </inlinemediaobject>
    //
    // Therefore IVPs are well suited to test very small sample sizes on normal 
    // distribution when outliers or ties could be present and the Shapiro-Wilk 
    // distribution test cannot be reliably applied. 
    //
    // <note><para>
    // Please be advised that ST_ivplot is EXPERIMENTAL and very basic. It can 
    // just handle one data set at a time at the moment. 
    // </para><para>
    // ST_ivplot uses Scilab's plot()-function and graphs can be adjusted with the
    // well-known commands (e.g. title, ylabel, etc).
    // </para></note>
    //
    // Examples
    // data1 = [9.999  9.998  10.002  10.  10.001  10.];
    // data2 = [30.41 30.05 30.49 29.22 30.40 30.42];
    // scf();
    // ST_ivplot(data1, "Normal Distribution")
    // scf();
    // ST_ivplot(data2, "Non-Normal Distribution")
    //
    // See also
    //  ST_outlier
    //  ST_deandixon
    //  ST_pearsonhartley
    //  ST_nalimov
    //  ST_strayarea
    //  ST_trustarea
    //  ST_shapirowilk
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    //
    // Bibliography
    //   Lohringer, H., "Grundlagen der Statistik", Oct, 10th, 2012, http://www.statistics4u.info/fundstat_germ/cc_outlier_tests_4sigma.html
    
    

    n=length(dat);
    x=ones(1,n);
    plot(x,dat, "o");

    a=gca()
    a.axes_visible=["off","on","off"]
    a.box="off"    

    xlabel(datname);   
endfunction
