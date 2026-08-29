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

function [outlierfree, outlier] = ST_esd(v, p, maxoutliers, side)
    // Generalized Extreme Studentized Deviate test according to Rosner
    //
    // Syntax
    //   [outlierfree, outlier] = ST_esd(v, p, maxoutliers)
    //   [outlierfree, outlier] = ST_esd(v, p, maxoutliers, side)
    //   outlierfree = ST_esd(v, p, maxoutliers)
    //   outlierfree = ST_esd(v, p, maxoutliers, side)
    //
    // Parameters
    //   v: real vector of numerical sample values; at least three values are required
    //   p: statistical confidence level as a string or significance level alpha as a decimal value "95%", "99%", "99.9%", 0.05, 0.01 or 0.001
    //   maxoutliers: positive integer specifying the maximum number of suspected outliers; it must not exceed n-2
    //   side: test direction, "both" (default), "left" or "right"
    //   outlierfree: input vector with all detected outliers removed; unchanged if the test does not identify an outlier
    //   outlier: detected outliers in their original input order; [] if no outlier is detected
    //
    // Description
    //   ST_esd performs Rosner's generalized Extreme Studentized Deviate (ESD)
    //   test for one or more outliers. Unlike repeatedly applying the classical
    //   Grubbs test, the generalized ESD procedure evaluates a sequence of test
    //   statistics and matching critical values while controlling the overall
    //   significance level for up to maxoutliers suspected observations.
    //
    //   The procedure first removes the most extreme remaining observation and
    //   calculates R<subscript>i</subscript> and λ<subscript>i</subscript> for i = 1,...,maxoutliers. The number of
    //   outliers is then the largest index k for which R<subscript>k</subscript> > λ<subscript>k</subscript>. The first
    //   k observations removed during the sequence are classified as outliers.
    //   Observations removed only for calculating later test statistics are restored
    //   when their index is greater than k.
    //
    //   The test assumes that the non-outlying observations are independent and
    //   approximately normally distributed. A minimum sample size of n >= 3 is
    //   required. Rosner's critical-value approximation is most reliable for
    //   moderate and large samples; test power and calibration are restricted for
    //   very small samples. maxoutliers should be chosen before inspecting the
    //   results and should normally be small relative to the sample size.
    //
    //   Test directions:
    //     "both"  removes the observation with the largest absolute deviation from
    //             the current sample mean. The critical probability uses
    //             α/(2*n<subscript>i</subscript>). This is Rosner's standard two-sided procedure.
    //     "left"  removes only the current minimum. The critical probability uses
    //             α/n<subscript>i</subscript>.
    //     "right" removes only the current maximum. The critical probability uses
    //             α/n<subscript>i</subscript>.
    //
    //   The sample standard deviation is calculated with denominator n<subscript>i-1</subscript>.
    //   If all remaining values are identical at any step, no additional test
    //   statistic can be calculated and the sequence stops.
    //
    // Test statistic at step i
    //
    // <latex>
    // \begin{eqnarray}
    // n_i &=& n-i+1 \\
    // R_i &=& \frac{\max_j |x_j-\overline{x}_i|}{s_i}
    //       \quad\text{for a two-sided test} \\
    // R_i &=& \frac{\overline{x}_i-x_{min,i}}{s_i}
    //       \quad\text{for a left-sided test} \\
    // R_i &=& \frac{x_{max,i}-\overline{x}_i}{s_i}
    //       \quad\text{for a right-sided test}
    // \end{eqnarray}
    // </latex>
    //
    // Critical value at step i
    //
    // <latex>
    // \begin{eqnarray}
    // \lambda_i &=& \frac{(n_i-1)t_i}{\sqrt{(n_i-2+t_i^2)n_i}} \\
    // t_i &=& t_{1-\alpha/(2n_i),\,n_i-2} \quad \text{for a two-sided test} \\
    // t_i &=& t_{1-\alpha/n_i,\,n_i-2} \quad \text{for a one-sided test} \\
    // \text{with} \\
    // x_i     &:& \text{test value} \\
    // n       &:& \text{number of values} \\
    // s       &:& \text{sample standard deviation} \\
    // \bar{x} &:& \text{arithmetic mean} \\
    // x_{max} &:& \text{max. value} \\
    // x_{min} &:& \text{min value} \\
    // t       &:& \text{student factor} \\
    // \alpha  &:& \text{statistical confidence level}
    // \end{eqnarray}
    // </latex>
    //
    // Decision rule
    //
    // Let k be the largest index i for which R<subscript>i</subscript> > λ<subscript>i</subscript>. The first k
    // observations removed during the calculation sequence are classified as
    // outliers. Equality does not lead to rejection. If no such index exists,
    // no outlier is returned.
    //
    // Examples
    //   data = [0.4827129 0.3431706 -0.4127328 0.3843994 ..
    //          -0.7107495 -0.2547306 0.0290803 0.1386087 ..
    //          -0.7698385 1.0743628 1.0945652 0.4365680 ..
    //          -0.5913411 -0.7426987 1.609719 0.8079680 ..
    //          -2.1700554 -9.7361261 0.0069708 14.626386 ..
    //          -2.5036545 -2.9046385];
    //
    //   // Test for up to three two-sided outliers at 95% confidence
    //   [of, o] = ST_esd(data, "95%", 3)
    //   // Expected outliers in original input order: [-9.7361261 14.626386]
    //
    //   // Test for up to three low outliers at 99% confidence
    //   [of, o] = ST_esd(data, "99%", 3, "left")
    //
    //   // Test for up to two high outliers at 99.9% confidence
    //   [of, o] = ST_esd(data, 0.001, 2, "right")
    //
    // See also
    //   ST_grubbs
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
    //   Rosner, B. (1983). Percentage Points for a Generalized ESD Many-Outlier Procedure. Technometrics, 25(2), 165-172.
    //   NIST/SEMATECH e-Handbook of Statistical Methods, Generalized ESD Test for Outliers.
    //

    [lhs, rhs] = argn();

    // Check the number of input and output arguments.
    apifun_checkrhs("ST_esd", rhs, 3:4);
    apifun_checklhs("ST_esd", lhs, 1:2);

    // Check the sample vector.
    apifun_checkvector("ST_esd", v, "v", 1);
    apifun_checktype("ST_esd", v, "v", 1, "constant");

    if ~isreal(v) then
        error("ST_esd: First argument v must contain real values.");
    end

    if size(v, "*") < 3 then
        error("ST_esd: First argument v must contain at least three values.");
    end

    if or(isnan(v)) | or(isinf(v)) then
        error("ST_esd: First argument v must not contain NaN or Inf values.");
    end

    // Check and convert the confidence/significance argument.
    apifun_checkscalar("ST_esd", p, "p", 2);

    if type(p) <> 1 & type(p) <> 10 then
        error("ST_esd: Second argument p must be a string or a real scalar.");
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
            error("ST_esd: Second argument p must be ""95%"", ""99%"", ""99.9%"", 0.05, 0.01 or 0.001.");
        end
    else
        if ~isreal(p) | isnan(p) | isinf(p) then
            error("ST_esd: Second argument p must be a finite real scalar.");
        end

        if p == 0.05 then
            alpha = 0.05;
        elseif p == 0.01 then
            alpha = 0.01;
        elseif p == 0.001 then
            alpha = 0.001;
        else
            error("ST_esd: Second argument p must be ""95%"", ""99%"", ""99.9%"", 0.05, 0.01 or 0.001.");
        end
    end

    // Check the maximum number of suspected outliers.
    apifun_checkscalar("ST_esd", maxoutliers, "maxoutliers", 3);
    apifun_checktype("ST_esd", maxoutliers, "maxoutliers", 3, "constant");

    if ~isreal(maxoutliers) | isnan(maxoutliers) | isinf(maxoutliers) then
        error("ST_esd: Third argument maxoutliers must be a finite real scalar.");
    end

    if maxoutliers <> floor(maxoutliers) | maxoutliers < 1 then
        error("ST_esd: Third argument maxoutliers must be a positive integer.");
    end

    n = size(v, "*");
    if maxoutliers > n - 2 then
        error("ST_esd: Third argument maxoutliers must not exceed n-2.");
    end

    // Check and normalize the test direction.
    if rhs < 4 then
        side = "both";
    else
        apifun_checkscalar("ST_esd", side, "side", 4);
        apifun_checktype("ST_esd", side, "side", 4, "string");
        side = convstr(side, "l");

        if side <> "both" & side <> "left" & side <> "right" then
            error("ST_esd: Fourth argument side must be ""both"", ""left"" or ""right"".");
        end
    end

    // Preserve the orientation of the input vector in the returned values.
    rowvector = (size(v, 1) == 1);
    originaldata = v(:);
    data = originaldata;
    originalindices = (1:n)';

    teststatistics = zeros(maxoutliers, 1);
    criticalvalues = zeros(maxoutliers, 1);
    removedindices = zeros(maxoutliers, 1);
    calculatedsteps = 0;

    // Calculate all sequential ESD statistics up to maxoutliers.
    for i = 1:maxoutliers
        ni = size(data, "*");
        samplemean = mean(data);
        samplestdev = stdev(data);

        // No further observation can be distinguished when all values are identical.
        if samplestdev == 0 then
            break;
        end

        select side
        case "both" then
            [deviation, candidateindex] = max(abs(data - samplemean));
            probability = 1 - alpha / (2 * ni);
        case "left" then
            [candidatevalue, candidateindex] = min(data);
            deviation = samplemean - candidatevalue;
            probability = 1 - alpha / ni;
        case "right" then
            [candidatevalue, candidateindex] = max(data);
            deviation = candidatevalue - samplemean;
            probability = 1 - alpha / ni;
        end

        teststatistics(i) = deviation / samplestdev;

        // Scilab 2026 syntax: T = cdft("T", Df, P, Q), with Q = 1-P.
        tcritical = cdft("T", ni - 2, probability, 1 - probability);
        criticalvalues(i) = ((ni - 1) / sqrt(ni)) * ..
                            sqrt(tcritical^2 / (ni - 2 + tcritical^2));

        removedindices(i) = originalindices(candidateindex);
        calculatedsteps = i;

        keep = ones(ni, 1);
        keep(candidateindex) = 0;
        data = data(find(keep));
        originalindices = originalindices(find(keep));
    end

    // Determine the largest significant step k.
    detectedcount = 0;
    if calculatedsteps > 0 then
        significantsteps = find(teststatistics(1:calculatedsteps) > ..
                                criticalvalues(1:calculatedsteps));
        if size(significantsteps, "*") > 0 then
            detectedcount = max(significantsteps);
        end
    end

    // Return only the first k removed observations, preserving original order.
    if detectedcount == 0 then
        outlierfree = originaldata;
        outlier = [];
    else
        detectedindices = removedindices(1:detectedcount);
        detectedindices = gsort(detectedindices, "g", "i");

        outlier = originaldata(detectedindices);
        keep = ones(n, 1);
        keep(detectedindices) = 0;
        outlierfree = originaldata(find(keep));
    end

    if rowvector then
        outlierfree = outlierfree';
        outlier = outlier';
    end
endfunction
