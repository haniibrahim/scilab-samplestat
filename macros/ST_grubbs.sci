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

function [outlierfree, outlier] = ST_grubbs(v, p, side)
    // Classical non-iterative Grubbs test for a single outlier
    //
    // Syntax
    //   [outlierfree, outlier] = ST_grubbs(v, p)
    //   [outlierfree, outlier] = ST_grubbs(v, p, side)
    //   outlierfree = ST_grubbs(v, p)
    //   outlierfree = ST_grubbs(v, p, side)
    //
    // Parameters
    //   v : real vector of numerical sample values; at least three values are required
    //   p : statistical confidence level as a string or significance level α
    //       as a decimal value "95%", "99%", "99.9%", 0.05, 0.01 or 0.001
    //   side : test direction, "both" (default), "left" or "right"
    //
    // Returned values
    //   outlierfree : input vector with the detected outlier removed; unchanged if
    //                 the test does not identify an outlier
    //   outlier : detected outlier as a scalar vector; [] if no outlier is detected
    //
    // Description
    //   ST_grubbs performs the classical, non-iterative Grubbs test and can detect
    //   at most one outlier in a sample. The test is performed exactly once on the
    //   complete input vector. It is therefore not affected by the changing critical
    //   limits and accumulated type-I error associated with repeated application.
    //
    //   The test assumes that the observations are independent and approximately
    //   normally distributed. A minimum sample size of n >= 3 is required. The test
    //   has limited power for very small samples, and a non-significant result must
    //   not be interpreted as proof that the sample contains no outlier.
    //
    //   Test directions:
    //     "both"  tests the observation with the largest absolute deviation from
    //             the sample mean. The critical probability uses α/(2*n).
    //     "left"  tests only the minimum observation. The critical probability
    //             uses α/n.
    //     "right" tests only the maximum observation. The critical probability
    //             uses α/n.
    //
    //   The sample standard deviation is calculated with denominator n-1.
    //   If all sample values are identical, the standard deviation is zero and no
    //   outlier is returned.
    //
    // Test statistic
    //
    // <latex>
    // \begin{eqnarray}
    // G_{two-sided} &=& \frac{\max_i |x_i-\overline{x}|}{s} \\
    // G_{left} &=& \frac{\overline{x}-x_{min}}{s} \\
    // G_{right} &=& \frac{x_{max}-\overline{x}}{s}
    // \end{eqnarray}
    // </latex>
    //
    // Critical value
    //
    // <latex>
    // \begin{eqnarray}
    // G_{crit} &=& \frac{n-1}{\sqrt{n}}
    // \sqrt{\frac{t^2}{n-2+t^2}} \\
    // t &=& t_{1-\alpha/(2n),\,n-2}\quad\text{Student t quantile for a two-sided test} \\
    // t &=& t_{1-\alpha/n,\,n-2}\quad\text{Student t quantile for a one-sided test} \\
    // \text{with} \\
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
    // Decision rule
    // 
    // The selected observation is classified as an outlier when G > G<subscript>crit</subscript>.
    // Equality does not lead to rejection.
    //
    // Examples
    //   data = [0.4827129 0.3431706 -0.4127328 0.3843994 ..
    //          -0.7107495 -0.2547306 0.0290803 0.1386087 ..
    //          -0.7698385 1.0743628 1.0945652 0.4365680 ..
    //          -0.5913411 -0.7426987 1.609719 0.8079680 ..
    //          -2.1700554 -4.7361261 0.0069708 14.626386 ..
    //          -2.5036545 -2.9046385];
    //
    //   // Two-sided test at 95% confidence
    //   [of, o] = ST_grubbs(data, "95%")
    //   [of, o] = ST_grubbs(data, 0.05, "both")
    //
    //   // Test only the minimum at 99% confidence
    //   [of, o] = ST_grubbs(data, "99%", "left")
    //
    //   // Test only the maximum at 99.9% confidence
    //   [of, o] = ST_grubbs(data, 0.001, "right")
    //
    // See also
    //   ST_grubbs_iterat
    //   ST_esd
    //   ST_pearsonhartley
    //   ST_nalimov
    //   ST_deandixon
    //   ST_outlier
    //   ST_strayarea
    //   ST_trustarea
    //   ST_shapirowilk
    //   ST_ivplot
    //
    // Authors
    //   Hani A. Ibrahim - hani.ibrahim@gmx.de
    //
    // Bibliography
    //   Grubbs, F. E. (1950). Sample criteria for testing outlying observations. Annals of Mathematical Statistics, 21(1), 27-58.
    //   Grubbs, F. E. (1969). Procedures for detecting outlying observations in samples. Technometrics, 11(1), 1-21.
    //   NIST/SEMATECH e-Handbook of Statistical Methods, Grubbs' Test for Outliers.
    //

    [lhs, rhs] = argn();

    // Check the number of input and output arguments.
    apifun_checkrhs("ST_grubbs", rhs, 2:3);
    apifun_checklhs("ST_grubbs", lhs, 1:2);

    // Check the sample vector.
    apifun_checkvector("ST_grubbs", v, "v", 1);
    apifun_checktype("ST_grubbs", v, "v", 1, "constant");

    if ~isreal(v) then
        error("ST_grubbs: First argument v must contain real values.");
    end

    if size(v, "*") < 3 then
        error("ST_grubbs: First argument v must contain at least three values.");
    end

    if or(isnan(v)) | or(isinf(v)) then
        error("ST_grubbs: First argument v must not contain NaN or Inf values.");
    end

    // Check and convert the confidence/significance argument.
    apifun_checkscalar("ST_grubbs", p, "p", 2);

    if type(p) <> 1 & type(p) <> 10 then
        error("ST_grubbs: Second argument p must be a string or a real scalar.");
    end

    if type(p) == 10 then
        select p
        case "95%" then
            alpha = 0.05;
        case "99%" then
            alpha = 0.01;
        case "99.9%" then
            alpha = 0.001;
        else
            error("ST_grubbs: Second argument p must be ""95%"", ""99%"", ""99.9%"", 0.05, 0.01 or 0.001.");
        end
    else
        if ~isreal(p) | isnan(p) | isinf(p) then
            error("ST_grubbs: Second argument p must be a finite real scalar.");
        end

        if p == 0.05 then
            alpha = 0.05;
        elseif p == 0.01 then
            alpha = 0.01;
        elseif p == 0.001 then
            alpha = 0.001;
        else
            error("ST_grubbs: Second argument p must be ""95%"", ""99%"", ""99.9%"", 0.05, 0.01 or 0.001.");
        end
    end

    // Check and normalize the test direction.
    if rhs < 3 then
        side = "both";
    else
        apifun_checkscalar("ST_grubbs", side, "side", 3);
        apifun_checktype("ST_grubbs", side, "side", 3, "string");
        side = convstr(side, "l");

        if side <> "both" & side <> "left" & side <> "right" then
            error("ST_grubbs: Third argument side must be ""both"", ""left"" or ""right"".");
        end
    end

    // Preserve the orientation of the input vector in the returned values.
    rowvector = (size(v, 1) == 1);
    data = v(:);
    n = size(data, "*");
    outlier = [];

    samplemean = mean(data);
    samplestdev = stdev(data);

    // No observation can be distinguished when all values are identical.
    if samplestdev == 0 then
        outlierfree = data;
        if rowvector then
            outlierfree = outlierfree';
        end
        return;
    end

    // Select exactly one candidate according to the requested test direction.
    select side
    case "both" then
        [deviation, candidateindex] = max(abs(data - samplemean));
        probability = 1 - alpha / (2 * n);

    case "left" then
        [candidatevalue, candidateindex] = min(data);
        deviation = samplemean - candidatevalue;
        probability = 1 - alpha / n;
    case "right" then
        [candidatevalue, candidateindex] = max(data);
        deviation = candidatevalue - samplemean;
        probability = 1 - alpha / n;
    end

    G = deviation / samplestdev;

    // Scilab 2026 syntax: T = cdft("T", Df, P, Q), with Q = 1-P.
    tcritical = cdft("T", n - 2, probability, 1 - probability);
    Gcritical = ((n - 1) / sqrt(n)) * ..
                sqrt(tcritical^2 / (n - 2 + tcritical^2));

    // Perform one decision only; no iterative retesting is applied.
    if G > Gcritical then
        outlier = data(candidateindex);
        keep = ones(n, 1);
        keep(candidateindex) = 0;
        outlierfree = data(find(keep));
    else
        outlierfree = data;
    end

    if rowvector then
        outlierfree = outlierfree';
        outlier = outlier';
    end
endfunction
