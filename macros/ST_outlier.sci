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

function [outlierfree, outlier] = ST_outlier(v, mod, q)
    // Basic outlier tests for normal distributions
    //
    // Syntax
    //   [outlierfree] = ST_outlier(v)
    //   [outlierfree] = ST_outlier(v, mod)
    //   [outlierfree] = ST_outlier(v, mod, q)
    //   [outlierfree, outlier] = ST_outlier(v)
    //   [outlierfree, outlier] = ST_outlier(v, mod)
    //   [outlierfree, outlier] = ST_outlier(v, mod, q)
    //
    // Parameters
    // v: n-by-1 or 1-by-m matrix of doubles, numerical values (n>10, better n>25)
    // mod: 1-by-1 matrix of strings, "sd", "iqr15" or "iqr30" mode
    // q: 1-by-1 matrix of doubles. OPTIONAL. Quantile interpolation type for IQR modes 7 = Hyndman-Fan type 7, 8 = Hyndman-Fan type 8 (default)
    // outlierfree : input vector with all detected outliers removed; unchanged if the test does not identify an outlier
    // outlier : detected outliers in their original input order; [] if no outlier is detected
    //
    // Description
    // Performs basic outlier tests. 
    //
    // SD-MODE: If you have a normal, symetric and unimodal distribution you
    // can use the "sd" mode (population standard deviation, S.D. or sigma). In this mode 
    // a value is presented as an outlier when it is more than 2.5xS.D. off 
    // the arithmetic mean in both directions.
    //
    // <latex>
    // x_i < (\bar{x} - 2.5\sigma) \; \text{or} \; x_i > (\bar{x} + 2.5\sigma) \; \text{with} \quad \sigma = \sqrt{{1 \over n}\sum_{i=1}^{n}(x_i-\bar{x})^2} \quad \Rightarrow \quad x_i = \text{outlier}\\
    // \begin{eqnarray}
    // x_i: \text{value} \quad                            &;& \quad \bar{x}: \text{arithmetic mean} \\
    // \sigma: \text{population standard deviation} \quad &;& \quad       n: \text{number of values}
    //\end{eqnarray}
    //</latex>
    //
    // IQR-MODES:Testing on outliers with interquartile range (IQR) distance is
    // recommended for skewed data in the first place. But it is also applicaple
    // for normally distributed data.
    //
    // IQR15-MODE: It is common to consider a value an outlier when it is more 
    // than 1.5xIQR (inter-quartile range) off from the lower or upper quartile.  
    // The "iqr15"-mode make use of this.
    //
    // IQR30-MODE: But with a border of 1,5xIQR 0.7% of the distribution can be  
    // expected as an outlier automatically. This means that a distribution of 143 
    // values or more could have at least one outlier in any case. To avoid this, 
    // values between 1.5xIQR and 3.0xIQR from the lower or upper quartile are 
    // called extreme values or weak outliers and just values outside of 3.0xIQR  
    // are strong outliers. SampleSTAT toolbox take care of this by introducing  
    // the "iqr30" mode.
    //
    // For quantile interpolation (IQR) two types are optionally available. 
    // Hyndman-Fan type 7- widely used, e.g. in the statistic software R and 
    // Hyndman-Fan type 8 - distribution independent, median-unbiased (default).
    //
    // <latex>
    // IQR = x_{0.75} - x_{0.25} \\
    // x_i < (x_{0.25} - 1.5 \cdot IQR) \; \text{or} \; x_i > (x_{0.75} + 1.5 \cdot IQR) \quad \Rightarrow \quad x_i = \text{outlier (iqr15 mode)} \\
    // x_i < (x_{0.25} - 3.0 \cdot IQR) \; \text{or} \; x_i > (x_{0.75} + 3.0 \cdot IQR) \quad \Rightarrow \quad x_i = \text{strong outlier (iqr30 mode)}
    //</latex>
    //
    // <important><para>
    // Do use ST_outlier "sd" mode ONLY with NORMAL distributed data and
    // with more than 10 or better more than 25 values! Use ST_deandixon 
    // (or ST_grubbs, ST_esd) for distributions with lower number of values.
    // </para></important>
    //
    // Examples
    // data = [
    //  0.4827129   0.3431706  -0.4127328    0.3843994 .. 
    // -0.7107495  -0.2547306   0.0290803    0.1386087 .. 
    // -0.7698385   1.0743628   1.0945652    0.4365680 .. 
    // -0.5913411  -0.7426987   1.609719     0.8079680 .. 
    // -2.1700554  -4.7361261   0.0069708    14.626386 ..
    // -2.5036545  -2.9046385 ..
    // ];
    // of              = ST_outlier(data')             // outlier-free values with sd-mode
    // [of, o]         = ST_outlier(data', "sd")       // outlier and outlier-free values
    // [of15, o15]     = ST_outlier(data', "iqr15")    // IQR, quantile type 8 (default)
    // [of15t7, o15t7] = ST_outlier(data', "iqr15", 7) // IQR, quantile type 7
    // [of30, o30]     = ST_outlier(data', "iqr30", 8) // IQR, quantile type 8
    //
    // See also
    //  ST_grubbs
    //  ST_esd
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

    function quant = ST_quantile(v, p, q)
        // Internal quantile dispatcher.
        // q = 7: Hyndman-Fan type 7
        // q = 8: Hyndman-Fan type 8 (default)
        [lhs_q, rhs_q] = argn();
        if rhs_q < 3 then q = 8; end
        if q == 7 then
            quant = ST_quantile_type7(v, p);
        elseif q == 8 then
            quant = ST_quantile_type8(v, p);
        else
            error("ST_quantile: q must be 7 or 8.");
        end
    endfunction

    function quant = ST_quantile_type7(v, p)
        // Hyndman-Fan quantile type 7:
        // h = (n - 1) * p + 1
        // Q(p) = x[j] + g * (x[j+1] - x[j]), j=floor(h), g=h-j
        x = gsort(v(:), "g", "i");
        n = size(x, "*");
        quant = zeros(p);
        for k = 1:size(p, "*")
            h = (n - 1) * p(k) + 1;
            if h <= 1 then
                quant(k) = x(1);
            elseif h >= n then
                quant(k) = x(n);
            else
                j = floor(h);
                g = h - j;
                quant(k) = x(j) + g * (x(j + 1) - x(j));
            end
        end
    endfunction

    function quant = ST_quantile_type8(v, p)
        // Hyndman-Fan quantile type 8 (default):
        // h = (n + 1/3) * p + 1/3
        // Q(p) = x[j] + g * (x[j+1] - x[j]), j=floor(h), g=h-j
        x = gsort(v(:), "g", "i");
        n = size(x, "*");
        quant = zeros(p);
        for k = 1:size(p, "*")
            h = (n + 1/3) * p(k) + 1/3;
            if h <= 1 then
                quant(k) = x(1);
            elseif h >= n then
                quant(k) = x(n);
            else
                j = floor(h);
                g = h - j;
                quant(k) = x(j) + g * (x(j + 1) - x(j));
            end
        end
    endfunction

    // MAIN =================================================================================
    // Check arguments
    [lhs,rhs]=argn();
    apifun_checkrhs("ST_outlier", rhs, 1:3); // Input args
    apifun_checklhs("ST_outlier", lhs, 1:2); // Output args
    apifun_checkvector("ST_outlier", v, "v", 1); // Vector?
    apifun_checktype("ST_outlier", v, "v", 1, "constant"); //Double?
    if rhs > 1 then
        apifun_checkoption("ST_outlier",mod,"mod",2,["sd" "iqr15" "iqr30"]);
    end
    if rhs < 2 then mod = "sd"; end  // if mode is not specified S.D.-mode is default
    if rhs < 3 then q = 8; end       // Hyndman-Fan type 8 is default
    if rhs > 2 then
        apifun_checktype("ST_outlier", q, "q", 3, "constant");
        if size(q, "*") <> 1 then
            error("ST_outlier: Third argument q must be a scalar.");
        end
        if q <> 7 & q <> 8 then
            error("ST_outlier: Third argument q must be 7 (Hyndman-Fan type 7) or 8 (Hyndman-Fan type 8).");
        end
    end
    if length(v) < 10 then
        warning("ST_outlier: Number of values should be >10, better >25");
    end
    
    if or(isnan(v)) | or(isinf(v)) then
        error("ST_outlier: First argument v must not contain NaN or Inf values.");
    end

    // Quantiles and inter-quartile range
    x25 = ST_quantile(v, 0.25, q);
    x75 = ST_quantile(v, 0.75, q);
    IQR = x75-x25; // Inter-quartile range
    m   = mean(v);

    // Outlier borders
    oIQR15lo = x25 - IQR * 1.5; // low border for outliers (mode "iqr15")
    oIQR15hi = x75 + IQR * 1.5; // high border for outliers (mode "iqr15")
    oIQR30lo = x25 - IQR * 3; // low border for outliers (mode "iqr30")
    oIQR30hi = x75 + IQR * 3; // high border for outliers (mode "iqr30")
    oSDlo  = m - 2.5 * stdev(v, "*", m) // low border 2.5 * standard deviation of population(mode "sd") 
    oSDhi  = m + 2.5 * stdev(v, "*", m) // high border 2.5 * standard deviation of population (mode "sd") 

    if mod =="sd" then // standard deviation mode
        outlierfree = v([v<=oSDhi & v>=oSDlo]);
        outlier     = v([v>oSDhi | v<oSDlo]);
    elseif mod == "iqr15" then // Inter-quartile range mode (IQR*1.5)
        outlierfree = v([v<=oIQR15hi & v>=oIQR15lo]);
        outlier     = v([v>oIQR15hi | v<oIQR15lo]);
    elseif mod == "iqr30" then // Inter-quartile range mode (IQR*3.0)
        outlierfree = v([v<=oIQR30hi & v>=oIQR30lo]);
        outlier     = v([v>oIQR30hi | v<oIQR30lo]);
    end
endfunction
