// Copyright (C) 2026 Hani Andreas Ibrahim
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

function [outlierfree, outlier] = ST_grubbs_iterat(v, p, side)
    // Iterative Grubbs outlier test without adapting critical value (Not recommended)
    //
    // Syntax
    //   [outlierfree, outlier] = ST_grubbs_iterat(v, p)
    //   [outlierfree, outlier] = ST_grubbs_iterat(v, p, side)
    //   [outlierfree] = ST_grubbs_iterat(v, p)
    //   [outlierfree] = ST_grubbs_iterat(v, p, side)
    //
    //
    // Parameters
    //   v : vector of numerical values
    //   p : statistical confidence level (%) as a string or the level of significance (α) as a decimal value, "95%", "99%", "99.9%" or 0.05, 0.01, 0.001 resp (see examples).
    //   side: one-or two-sided "both" (default), "left", "right"
    //   outlierfree : input vector with the detected outlier removed; unchanged if
    //                 the test does not identify an outlier
    //   outlier : detected outliers as a scalar vector; [] if no outlier is detected
    //
    // Description
    // Performs an INTERACTIVE Grubbs outlier test. The classic Grubbs test detects just one outlier at a time. This function
    // applies the test iteratively on the same data record until no further outlier is found. 
    //
    // <caution><para>IMPORTANT: When ST_grubbs_iterat() repeatedly used its interative algorithm on the same data it does not adapting the critical value. 
    // After each iterative run, the statistical confidence decreases. This means that even if a confidence level of 99% was 
    // specified, the result does not correspond to that level of statistical confidence. It is lower and increases the probability of removing valid observations.</para>
    // <para> </para>
    // <para>For statistically reliable outlier removal, the classic Grubbs test (ST_grubbs) is recommended. However, it can only 
    // detect one outlier in a data record. If more than one outlier is expected, Roesner-ESD (ST_esd) is the statistically clean alternative.</para>
    // <para>A warning is displayed on very output of ST_grubbs_iterat()</para>
    // <para> </para>
    // <para>It is implemented for comparison purposes because it is often used this way in lab practice. Use it with care.</para></caution>
    //
    // Confidence levels 95%, 99% or 99.9% (α: 0.05, 0.01 or 0.001) are available.
    //
    // The test can be applied one- or two-sided.  If “side” is set to “left,” the outliers are determined 
    // one-sided from the minimum side; if “side” is set to “right,” from the maximum side. If "side" is set to "both" or 
    // omitted the test is performed two-sided and determine outliers from the minimum and the maximum side.
    // 
    // The test statistic
    //
    // <latex>
    // \begin{eqnarray}
    // G_{two-sided} &=& \frac{\underset{i..n}{max} \left| x_i - \overline{x} \right|}{s} \\
    // G_{left-sided(min)} &=& \frac{\overline{x} - x_{min}}{s} \\
    // G_{right-sided(max)} &=& \frac{x_{max} - \overline{x}}{s} \\
    // \end{eqnarray}
    // </latex>
    //
    // Critical value:
    //
    // <latex>
    // \begin{eqnarray}
    // G_{crit} &=& \frac{n-1}{\sqrt{n}} \sqrt{\frac{t^2}{n-2+t^2}} \\ \\
    // t       &=& t_{\frac{1-\alpha}{2n}, n-2} \quad : \quad \text{ Student t quantile for two-sided test} \\
    // t       &=& t_{\frac{1-\alpha}{n}, n-2} \quad : \quad \text{ Student t quantile for on-sided test} \\
    // \text{and} \\
    // x_i     &:& \text{test value} \\
    // n       &:& \text{number of values} \\
    // s       &:& \text{sample standard deviation} \\
    // \bar{x} &:& \text{arithmetic mean} \\
    // x_{max} &:& \text{max. value} \\
    // x_{min} &:& \text{min value} \\
    // \alpha  &:& \text{statistical confidence level}
    // \end{eqnarray}
    // </latex>
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
    //
    // // two-sided & confidence-level 95%
    // of = ST_grubbs_iterat(data, "95%")              // Output: outlier-free values, only
    // [of, o] = ST_grubbs_iterat(data, "95%", "both") // Output: outlier and outlier-free values
    // [of, o] = ST_grubbs_iterat(data, 0.05)
    //
    // // left-sided & confidence-level 99%, outlier and outlier-free values output
    // [of, o] = ST_grubbs_iterat(data, "99%", "left")
    //
    // // right-sided & confidence-level 99.9%, outlier and outlier-free values output
    // [of, o] = ST_grubbs_iterat(data, 0.001, "right")
    //
    // See also
    //  ST_grubbs
    //  ST_esd
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

    [lhs,rhs]=argn();

    apifun_checkrhs("ST_grubbs_iterat", rhs, 2:3);
    apifun_checklhs("ST_grubbs_iterat", lhs, 1:2);

    apifun_checkvector("ST_grubbs_iterat", v, "v", 1);
    apifun_checktype("ST_grubbs_iterat", v, "v", 1, "constant");

    if type(p)<>1 & type(p)<>10 then
        error("ST_grubbs_iterat: Invalid confidence level.");
    end

    select string(p)
    case "95%" then alpha=0.05;
    case "99%" then alpha=0.01;
    case "99.9%" then alpha=0.001;
    else
        if p==0.05 then
            alpha=0.05;
        elseif p==0.01 then
            alpha=0.01;
        elseif p==0.001 then
            alpha=0.001;
        else
            error("ST_grubbs_iterat: Confidence level must be ""95%"", ""99%"", ""99.9%"", 0.05, 0.01 or 0.001.");
        end
    end

    if rhs<3 then
        side="both";
    else
        apifun_checkscalar("ST_grubbs_iterat", side, "side", 3);
        apifun_checktype("ST_grubbs_iterat", side, "side", 3, "string");
        side=convstr(side,"l");
        if side<>"both" & side<>"left" & side<>"right" then
            error("ST_grubbs_iterat: Third argument must be ""both"", ""left"" or ""right"".");
        end
    end

    if or(isnan(v)) | or(isinf(v)) then
        error("ST_grubbs_iterat: Input vector contains NaN or Inf values.");
    end

    rowvector=(size(v,1)==1);
    data=v(:);
    outlier=[];

    while %t
        n=length(data);
        if n<3 then break; end

        m=mean(data);
        s=stdev(data);
        if s==0 then break; end

        select side
        case "both" then
            d=abs(data-m);
        case "right" then
            d=data-m;
        case "left" then
            d=m-data;
        end

        [mx,idx]=max(d);
        G=mx/s;

        if side=="both" then
            prob=1-alpha/(2*n);
        else
            prob=1-alpha/n;
        end

        t=cdft("T",n-2,prob,1-prob);
        Gcrit=((n-1)/sqrt(n))*sqrt(t^2/(n-2+t^2));

        if G>Gcrit then
            outlier($+1,1)=data(idx);
            mask=ones(n,1);
            mask(idx)=0;
            data=data(find(mask));
        else
            break;
        end
    end

    outlierfree=data;
    if rowvector then
        outlierfree=outlierfree';
        outlier=outlier';
    end
    warning("ST_grubbs_iterat: Iterative Grubbs-test. Statistical confidence level are not secure. Use with care");

endfunction
