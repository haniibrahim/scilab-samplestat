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

function [outlierfree, outlier] = ST_grubbs(v, p)
    // Iterative Grubbs outlier test.
    //
    // Syntax
    //   [outlierfree, outlier] = ST_grubbs(v, p)
    //   [outlierfree] = ST_grubbs(v, p)
    //
    //
    // Parameters
    //   v : vector of numerical values
    //   p : statistical confidence level (%) as a string or the level of significance (alpha) as a decimal value, "95%", "99%", "99.9%" or 0.05, 0.01, 0.001 resp (see examples).
    // outlierfree: vector of outlier-free data
    // outlier: vector of outliers
    //
    // Description
    // Performs the interative Grubbs outlier test. The Grubbs test detects one outlier at a time. This function
    // applies the test iteratively until no further outlier is found.
    // 
    // The test statistic:
    // <latex>
    // \begin{align}
    // G &=& \frac{\text{max} \left| x_i - \overline{x} \right|}{S_n} \\
    // \text{with:} \\
    // x_i && &\rightarrow& \quad \text{sample value} \\
    // \overline{x} &=& \frac{1}{n}\sum^{n}_{i=1}{x_i} \quad &\Rightarrow& \quad \text{arithmetic mean}\\
    // S^2_n &=& \frac{1}{n-1} \sum^n_{i=1}{\left(x_i - \overline{x}\right)^2} \quad &\Rightarrow& \quad \text{sample variance}
    // \end{align}
    // </latex>
    //
    // Critical value:
    //
    // $G_{crit}= \frac{n-1}{\sqrt{n}} \sqrt{\frac{t^2}{n-2+t^2}}$
    //
    // where t is the Student t quantile:
    //
    // $t=t_{\frac{1-\alpha}{2n}, n-2}$
    //
    //
    // <note> The classical Grubbs test assumes normally distributed data.
    //  Applying the test repeatedly increases the probability of
    //  removing valid observations. Use the results with care.</note>
    //
    // Examples
    // data = [
    // 0.4827129   0.3431706  -0.4127328    0.3843994 ..
    // -0.7107495  -0.2547306   0.0290803    0.1386087 ..
    //-0.7698385   1.0743628   1.0945652    0.4365680 ..
    // -0.5913411  -0.7426987   1.609719     0.8079680 ..
    // -2.1700554  -4.7361261   0.0069708    14.626386 ..
    // -2.5036545  -2.9046385 ..
    // ];
    // of = ST_grubbs(data, "95%")      // outlier-free values
    // [of, o] = ST_grubbs(data, "95%") // outlier and outlier-free values
    // [of, o] = ST_grubbs(data, 0.05)  // outlier and outlier-free values
    //
    // See also
    //  ST_pearsonhartley
    //  ST_nalimov
    //  ST_deandixon
    //  ST_outlier
    //  ST_strayarea
    //  ST_trustarea
    //  ST_shapirowilk
    //  ST_ivplot
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    //
    // Bibliography
    //   Lohringer, H., "Grundlagen der Statistik", Oct, 10th, 2012, http://www.statistics4u.info/fundstat_germ/cc_outlier_tests_4sigma.html
    //


    //--------------------------------------------------------------
    // Check arguments
    //--------------------------------------------------------------

    [lhs,rhs] = argn();
    apifun_checkrhs("ST_grubbs", rhs, 2);
    apifun_checklhs("ST_grubbs", lhs, 1:2);
    apifun_checkvector("ST_grubbs", v, "v", 1);
    apifun_checktype("ST_grubbs", v, "v", 1, "constant");
    apifun_checkscalar("ST_grubbs", p, "p", 1); // Scalar?
    if string(p)~="95%" & string(p)~="99%" & string(p)~="99.9%" & p ~= 0.05 & p ~= 0.01 & p ~= 0.001
        error(msprintf("%s: Second argument is the statistical confidence level and has to be a string, as 95%%, 99%% or 99.9%%" + ..
        " or a double as alpha value: 0.05, 0.01, 0.001", "ST_grubbs"));
    end

    //--------------------------------------------------------------
    // Convert confidence level to alpha
    //--------------------------------------------------------------

    select(string(p))

    case("95%")
        alpha = 0.05;
    case("99%")
        alpha = 0.01;
    case("99.9%")
        alpha = 0.001;
    else
        if p == 0.05 then
            alpha = 0.05;
        elseif p == 0.01 then
            alpha = 0.01;
        elseif p == 0.001 then
            alpha = 0.001;
        else
            error(msprintf('%s: Invalid confidence level.', "ST_grubbs"));
        end
    end

    //--------------------------------------------------------------
    // Remove invalid values
    //--------------------------------------------------------------

    if or(isnan(v)) | or(isinf(v)) then
        error("ST_grubbs: Input vector contains NaN or Inf values.");
    end


    //--------------------------------------------------------------
    // Preserve input orientation
    //--------------------------------------------------------------

    rowvector = (size(v,1)==1);
    data = v(:);
    outlier = [];

    //--------------------------------------------------------------
    // Iterative Grubbs test
    //--------------------------------------------------------------

    while %t
        
        n = length(data);
        
        // Grubbs test requires at least three observations
        if n < 3 then
            break;
        end
        meanvalue = mean(data);
        stdvalue  = stdev(data);

        // No variation -> no possible outlier
        if stdvalue == 0 then
            break;
        end

        //----------------------------------------------------------
        // Calculate test statistic
        //----------------------------------------------------------

        deviation = abs(data - meanvalue);
        [maximum, index] = max(deviation);
        G = maximum / stdvalue;

        //----------------------------------------------------------
        // Calculate critical value
        //----------------------------------------------------------

        probability = 1 - alpha/(2*n);
        t = cdft("T", n-2, probability, 1-probability);
        Gcritical = ((n-1)/sqrt(n)) * ...
                   sqrt(t^2/(n-2+t^2));

        //----------------------------------------------------------
        // Remove detected outlier
        //----------------------------------------------------------

        if G > Gcritical then
            outlier($+1,1) = data(index);
            mask = ones(n,1);
            mask(index) = 0;
            data = data(find(mask));
        else
            break;
        end
    end

    //--------------------------------------------------------------
    // Output formatting
    //--------------------------------------------------------------

    outlierfree = data;
    
    if rowvector then
        outlierfree = outlierfree';
        outlier     = outlier';
    end

endfunction
