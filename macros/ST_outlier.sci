// Copyright (C) 2019 Hani Andreas Ibrahim
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

function [outlierfree, outlier] = ST_outlier(v, mod)
    // Basic outlier tests for normal distributions
    //
    // Calling Sequence
    //   [outlierfree] = ST_outlier(v)
    //   [outlierfree] = ST_outlier(v, mod)
    //   [outlierfree, outlier] = ST_outlier(v)
    //   [outlierfree, outlier] = ST_outlier(v, mod)
    //
    // Parameters
    // v: n-by-1 or 1-by-m matrix of doubles, numerical values (n>10, better n>25)
    // mod: 1-by-1 matrix of strings, "sd" or "iqr" mode
    // outlierfree: n-by-1 or 1-by-m matrix of doubles, outlier-free data
    // outlier: n-by-1 or 1-by-m matrix of doubles, outliers
    //
    // Description
    // Performs basic outlier tests. 
    //
    // If you have a normal, symetric and unimodal distribution you
    // can use the "sd" mode (standard deviation, S.D.). In this mode 
    // a value is presented as an outlier when it is greater or less 
    // than 2.5*S.D. from the arithmetic mean.
    //
    // If you have a normal but skewed distribution the "iqr"-mode
    // should be used. If the value is greater or less than 
    // 1.5*IQR (inter-quartile range) it is presented as an outlier.
    //
    // <important><para>
    // Do use ST_outlier ONLY with NORMAL distrinutions and
    // with more than 10 or better more than 25 values!
    // </para></important>
    //
    // Examples
    // data = [
    //  0.4827129   0.3431706  -0.4127328    0.3843994 .. 
    // -0.7107495  -0.2547306   0.0290803    0.1386087 .. 
    // -0.7698385   1.0743628   1.0945652    0.4365680 .. 
    // -0.5913411  -0.7426987   1.609719     0.8079680 .. 
    // -2.1700554  -0.7361261   0.0069708    14.626386  
    // ];
    // of = ST_outlier(data)      // outlier-free values with sd-mode
    // [of, o] = ST_outlier(data', "sd")  // outlier and outlier-free values
    // [of, o] = ST_outlier(data', "iqr")  // outlier and outlier-free values
    //
    // See also
    //  ST_strayarea
    //  ST_trustarea
    //  ST_studentfactor
    //  ST_nalimov
    //  ST_dixon
    //  ST_deandixon
    //  ST_grubbs
    //  ST_pearsonhartley
    //  ST_shapirowilk
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    //
    // Bibliography
    //   Lohringer, H., "Grundlagen der Statistik", Oct, 10th, 2012, http://www.statistics4u.info/fundstat_germ/cc_outlier_tests_4sigma.html
    //   

    function q = ST_quantile(v, p)
        // Quantile
        //
        // Calling Sequence
        //   q=ST_quantile(x,p)
        //
        // Parameters
        // v : a n-by-1 matrix of doubles
        // p : a m-by-1 matrix of doubles, the probabilities (0.25 or 0.50 or 0.75)
        // q : a m-by-1 matrix of doubles, the quantiles. q(i)is greater than p(i) percents of the values in v
        if min(size(v))==1 then
            v = v(:);
            %v1=size(p);
            q = zeros(%v1(1),%v1(2));
        else
            q = zeros(size(p,'*'),size(v,2));
        end
        if min(size(p))>1 then
            error('Not matrix p input');
        end
        if or(p>1|p<0) then
            error('Input p is not probability');
        end
        %val = v
        if min(size(%val))==1 then 
            %val=gsort(%val)
        else 
            %val=gsort(%val,'r')
        end
        v = %val($:-1:1,:);
        p = p(:);
        n = size(v,1);
        v = [v(1,:);v;v(n,:)];
        i = p*n+1.5;
        iu = ceil(i);
        il = floor(i);
        d = (i-il)*ones(1,size(v,2));
        qq = v(il,:) .* (1-d)+v(iu,:) .* d;
        q(:) = qq;
    endfunction

//    // Load Internals lib
//    path = ST_getpath()
//    internallib = lib(fullfile(path,"macros","internal"))

    // Check arguments
    [lhs,rhs]=argn();
    apifun_checkrhs("ST_outlier", rhs, 1:2); // Input args
    apifun_checklhs("ST_outlier", lhs, 1:2); // Output args
    apifun_checkvector("ST_outlier", v, "v", 1); // Vector?
    apifun_checktype("ST_outlier", v, "v", 1, "constant"); //Double?
    if rhs > 1 then
        apifun_checkoption("ST_outlier",mod,"mod",2,["sd" "iqr"]);
    end
    if rhs < 2 then mod = "sd"; end  // if mode is not specified S.D.-mode is default
    if length(v) < 10 then
        warning("ST_outlier: Number of values should be >10, better >25");
    end

    // Quantiles and inter-quartile range
    x25 = ST_quantile(v, 0.25);
    x75 = ST_quantile(v, 0.75);
    IQR = x75-x25; // Inter-quartile range 

    // Outlier borders
    oIQRlo = x25 - IQR * 1.5; // low border outliers (mode "iqr")
    oIQRhi = x75 + IQR * 1.5; // high border outliers (mode "iqr")
    oSDlo  = mean(v) - 2.5 * stdev(v) // low border 2.5 * standard deviation (mode "sd") 
    oSDhi  = mean(v) + 2.5 * stdev(v) // high border 2.5 * standard deviation (mode "sd") 

    if mod =="sd" then // standard deviation mode
        outlierfree = v([v<oSDhi & v>oSDlo]);
        outlier     = v([v>oSDhi | v<oSDlo]);
    elseif mod == "iqr" // Inter-quartile range mode
        outlierfree = v([v<oIQRhi & v>oIQRlo]);
        outlier     = v([v>oIQRhi | v<oIQRlo]);
    else
        error("ST_outlier: Wrong mode => ""sd"" or ""iqr"" are valid");
    end
endfunction
