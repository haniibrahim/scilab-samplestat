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

function ST_ivplot(v, datname, frmtpt)
    // Very basic Individual Value Plot (EXPERIMENTAL)
    //
    // Calling Sequence
    //   ST_ivplot(v)
    //   ST_ivplot(v, datname)
    //   ST_ivplot(v, datname, frmtpt)
    //
    // Parameters
    // v: n-by-1 or 1-by-m matrix of doubles, numerical values (n>10, better n>25)
    // datname: 1-by-1 matrix of strings, name of the data, displayed unter the data set in the graph
    // frmtpt: 1-by-1 matrix of charakter string, marker type of the values (".","o","x","*","+","s","d")
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
    // just handle one data set at a time at the moment and ties (same values) 
    // are not displayed side-by-site!
    // </para><para>
    // ST_ivplot uses Scilab's plot()-function and graphs can be adjusted with the
    // well-known commands (e.g. xtitle, ylabel, etc).
    // </para></note>
    //
    // Examples
    // data1 = [9.999  9.998  10.002  10.  10.001  10.];
    // data2 = [30.41 30.05 30.49 29.22 30.40 30.42];
    // scf();
    // ST_ivplot(data1, "Normal Distribution")
    // scf();
    // ST_ivplot(data2, "Non-Normal Distribution","o")
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

    // Check arguments
    [lhs,rhs]=argn()
    apifun_checkrhs("ST_ivplot", rhs, 1:3); // Input args
    apifun_checkvector("ST_ivplot", v, "v", 1); // Vector?
    apifun_checktype ("ST_ivplot", v, "v", 1, "constant"); //Double?
    if rhs == 1 then 
        datname=""; 
    end
    if rhs == 2 then
        apifun_checkscalar("ST_ivplot", datname, "datname", 2); // Scalar?
        apifun_checktype("ST_ivplot", datname, "datname",2, "string");
    end
    if rhs < 3 then
        frmtpt=".";
    end
    if rhs ==3 then
         apifun_checktype("ST_ivplot", frmtpt, "frmtpt",3,"string"); // String?
         apifun_checkoption("ST_ivplot", frmtpt, "frmtpt",3,["." "o" "x" "*" "+" "s" "d"])
    end

    n=length(v);
    x=ones(1,n);
    plot(x,v, frmtpt);

    a=gca()
    a.box="off" 
    a.axes_visible=["on","on","on"]
    a.auto_ticks=["off","on","on"]   

    xlabel(datname);   
endfunction
