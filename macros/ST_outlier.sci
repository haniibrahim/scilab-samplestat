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
    // mod: 1-by-1 matrix of strings, "sd" "iqr15"or "iqr30" mode
    // outlierfree: n-by-1 or 1-by-m matrix of doubles, outlier-free data
    // outlier: n-by-1 or 1-by-m matrix of doubles, outliers
    //
    // Description
    // Performs basic outlier tests. 
    //
    // SD-MODE: If you have a normal, symetric and unimodal distribution you
    // can use the "sd" mode (standard deviation, S.D.). In this mode 
    // a value is presented as an outlier when it is more than 2.5xS.D. off 
    // the arithmetic mean in both directions.
    //
    // IQR15-MODE: If you have a normal but skewed distribution one of the iqr-modes
    // should be used. But they can be applied for non-skewed distribution, too.
    // It is common to specify a value as an outlier when it is more than 1.5xIQR 
    // (inter-quartile range) off from the lower or upper quartile. The 
    // "iqr15"-mode make use of this.
    //
    // IQR30-MODE: But with a border of 1,5xIQR 0.7% of the distribution can be  
    // expected as an outlier automatically. This means that a distribution of 143 
    // values or more could have at least one outlier in any case. To avoid this, 
    // values between 1.5xIQR and 3.0xIQR from the lower or upper quartileare 
    // called extreme values but not outliers and just values outside of 3.0xIQR  
    // are outliers. SampleSTAT toolbox take care of this by introducing the "iqr30" 
    // mode. All values inside 3.0xIQR from the quartiles are valid data 
    // outside this barrier outliers.
    //
    // <latex>
    // \begin{eqnarray}
    // IQR = x_{0.75} - x_{0.25} \\
    // (x_{0.25} - 1.5 \cdot IQR)  < x_i < (x_{0.25} + 1.5 \cdot IQR)  \quad \Rightarrow \quad x_i = \text{weak outlier (iqr15 mode)} \\
    // (x_{0.25} - 3.0 \cdot IQR)  < x_i < (x_{0.25} + 3.0 \cdot IQR)  \quad \Rightarrow \quad x_i = \text{strong outlier (iqr30 mode)}
    //\end{eqnarray}
    //</latex>
    //
    // You can use "ST_skewness" to check for skewed distributions
    //
    // <important><para>
    // Do use ST_outlier ONLY with NORMAL distributed data and
    // with more than 10 or better more than 25 values! Use ST_nalimov or 
    // ST_deandixon for distributions with lower number of values.
    // </para></important>
    //
    // Examples
    // data = [
    //  0.4827129   0.3431706  -0.4127328    0.3843994 .. 
    // -0.7107495  -0.2547306   0.0290803    0.1386087 .. 
    // -0.7698385   1.0743628   1.0945652    0.4365680 .. 
    // -0.5913411  -0.7426987   1.609719     0.8079680 .. 
    // -2.1700554  -0.7361261   0.0069708    14.626386 .. 
    // ];
    // of = ST_outlier(data')      // outlier-free values with sd-mode
    // [of, o] = ST_outlier(data', "sd")  // outlier and outlier-free values
    // [of, o] = ST_outlier(data', "iqr15")  // outlier and outlier-free values
    // [of, o] = ST_outlier(data', "iqr30")  // outlier and outlier-free values
    //
    // See also
    //  ST_skewness
    //  ST_nalimov
    //  ST_deandixon
    //  ST_pearsonhartley
    //  ST_strayarea
    //  ST_trustarea
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
        apifun_checkoption("ST_outlier",mod,"mod",2,["sd" "iqr15" "iqr30"]);
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
    oIQR15lo = x25 - IQR * 1.5; // low border for outliers (mode "iqr15")
    oIQR15hi = x75 + IQR * 1.5; // high border for outliers (mode "iqr15")
    oIQR30lo = x25 - IQR * 3; // low border for outliers (mode "iqr30")
    oIQR30hi = x75 + IQR * 3; // high border for outliers (mode "iqr30")
    oSDlo  = mean(v) - 2.5 * stdev(v) // low border 2.5 * standard deviation (mode "sd") 
    oSDhi  = mean(v) + 2.5 * stdev(v) // high border 2.5 * standard deviation (mode "sd") 

    if mod =="sd" then // standard deviation mode
        outlierfree = v([v<oSDhi & v>oSDlo]);
        outlier     = v([v>oSDhi | v<oSDlo]);
    elseif mod == "iqr15" // Inter-quartile range mode (IQR*1.5)
        outlierfree = v([v<oIQR15hi & v>oIQR15lo]);
        outlier     = v([v>oIQR15hi | v<oIQR15lo]);
    elseif mod == "iqr30" // Inter-quartile range mode (IQR*3.0)
        outlierfree = v([v<oIQR30hi & v>oIQR30lo]);
        outlier     = v([v>oIQR30hi | v<oIQR30lo]);
    else
        error("ST_outlier: Wrong mode => ""sd"", ""irq15"" or ""iqr30"" are valid");
    end
endfunction
