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

function [outlierfree, outlier] = ST_deandixon(v, p)
    // Basic Dean-Dixon outlier test
    //
    // Calling Sequence
    //   [outlierfree] = ST_deandixon(v, p)
    //   [outlierfree, outlier] = ST_deandixon(v, p)
    //
    // Parameters
    // v: vector of numerical values
    // p: statistical confidence level (%) as a string or the level of significance (alpha) as a decimal value, "95%", "99%", "99.9%" or 0.05, 0.01, 0.001 resp (see examples).
    // outlierfree: vector of outlier-free data
    // outlier: vector of outliers
    //
    // Description
    // Performs the basic Dean-Dixon outlier test. It sorts the distribution in
    //  ascending or descending order, then takes the minimum and maximum values 
    // (xi) and calculates the respective Q value for both xi values. This is 
    // compared with the critical value from a table (Qcrit). If one of the two 
    // or both Q values greater than the corresponding Qcrit value, one orboth
    // xi values are outliers.
    //
    // <latex>
    // \begin{eqnarray}
    // Q = \left | x_{i+1}-x_i \right |/\left | x_n-x_i \right | \quad ; \quad Q > Q_{crit} \quad \Rightarrow \quad x_i = \text{outlier}
    // \end{eqnarray}
    // </latex>
    //
    // Only one outlier can be found on each side.
    //
    // <important><para>
    // Apply this test ONLY one time to your data.
    // </para></important>
    //
    // <important><para>
    // Do use ST_deandixon ONLY with NORMAL distributed data and
    // with more than 3 and less than 30 values! For more than 30 values use 
    // Pearson-Hartley test ""ST_pearsonhartley()"" instead.
    // </para></important>
    //
    // Examples
    // data = [6 8 14 12 35 15];
    // of = ST_deandixon(data, "95%")      // outlier-free values
    // [of, o] = ST_deandixon(data, "95%") // outlier and outlier-free values
    // [of, o] = ST_deandixon(data, 0.05)  // outlier and outlier-free values
    //
    // See also
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
    //   

    
    // === FUNCTIONS ===========================================================

    function [critval] = deandixon_crit(n, p)
        // Returns the critical Q value for Dean-Dixon test.
        //
        // Parameter
        // n: number of numerical values
        // p: statistical confidence level (%) as a string or the level of significance (alpha) 
        //    as a decimal value, "95%", "99%", "99.9%" or 0.05, 0.01, 0.001 resp.

        // qtable contains the critical values critval for N (number of values)
        // and alpha (niveau of significance)  
        // Column 1 : Number of values (N)
        // Column 2 : Q_crit, 95% confidence level, alpha = 0.05
        // Column 3 : Q_crit, 99% confidence level, alpha = 0.01
        // Column 4 : Q_crit, 99.9% confidence level, alpha = 0.001
        qtable = [ ...
        3 0.941 0.994 0.999; ...
        4 0.766 0.921 0.964; ...
        5 0.643 0.824 0.895; ...
        6 0.563 0.744 0.822; ...
        7 0.507 0.681 0.763; ...
        8 0.467 0.633 0.716; ...
        9 0.436 0.596 0.675; ...
        10 0.412 0.568 0.647; ...
        15 0.338 0.473 0.544; ...
        20 0.300 0.426 0.491; ...
        25 0.277 0.395 0.455; ...
        30 0.260 0.371 0.430  ...
        ];

        // Set the proper column of the t-table, depending on confidence level
        select(p)
        case("95%")
            j = 2;
        case(0.05)
            j = 2;
        case("99%")
            j = 3;
        case(0.01)
            j = 3;
        case("99.9%")
            j = 4;
        case(0.001)
            j = 4;
        else
            error("Wrong confidence level");
        end

        // Pick the appropriate Q_crit value, interpolate if necessary
        if (n >= 3 & n <= 10)
            critval = qtable(n-2,j);
        elseif (n >= 11  & n <= 29)
            i = 6 + floor(n/5); // Determine row, 6=correction factor
            qs = (qtable(i,j) - qtable(i+1,j))/5;
            mul = n - qtable(i,1); // Multiplicator for qs
            critval = qtable(i,j) - (mul * qs);
            //    critval = qtable(i,j) - ((qtable(i,j)-qtable(i+1,j))/5);
        else // for the last value (30)
            i = 6 + floor(n/5); // Determine row, 6=correction factor
            critval = qtable(i,j);
        end
        return;
    endfunction
    
    // === MAIN ================================================================
    
    // Check arguments
    [lhs,rhs]=argn()
    apifun_checkrhs("ST_deandixon", rhs, 2); // Input args
    apifun_checklhs("ST_deandixon", lhs, 1:2); // Output args
    apifun_checkvector("ST_deandixon", v, "v", 1); // Vector?
    apifun_checktype ("ST_deandixon", v, "v", 1, "constant"); //Double?
    apifun_checkscalar("ST_deandixon", p, "p", 1); // Scalar?
    if string(p)~="95%" & string(p)~="99%" & string(p)~="99.9%" & p ~= 0.05 & p ~= 0.01 & p ~= 0.001
        error(msprintf("%s: Second argument is the statistical confidence level and has to be a string, as 95%%, 99%% or 99.9%%" + ..
        " or as alpha value: 0.05, 0.01, 0.001", "ST_deandixon"));
    end

    n = length(v);
    if (n < 3 | n > 30)
        error("Dean-Dixon Outliertest is just applicable for sample distributions greater than 3 and lesser than 30 values. For more than 30 values use Pearson-Hartley test ""ST_pearsonhartley()"" instead."); 
    end

    // Determine Q_crit
    qcritval = deandixon_crit(n, p);

    // Calculate Q for the smallest value
    vasc = gsort(v, "g", "i");
    qsmall = abs(vasc(2)-vasc(1))/abs(vasc(n)-vasc(1));

    // Calculate Q for the biggest value
    vdes = gsort(v, "g","d");
    qbig = abs(vdes(2)-vdes(1))/abs(vdes(n)-vdes(1));

    // Compare Q with Qcrit
    if qsmall > qcritval
        osmall = %T;
    else
        osmall = %F;
    end

    if qbig > qcritval
        obig = %T;
    else
        obig = %F;
    end

    // Output
    if osmall & obig
        outlierfree = vasc(2:n-1);
        outlier = [vasc(1), vasc(n)];
    elseif osmall & ~obig
        outlierfree = vasc(2:n);
        outlier = vasc(1);
    elseif ~osmall & obig
        outlierfree = vasc(1:n-1);
        outlier = vasc(n);
    else
        outlierfree = vasc;
        outlier = []; // empty vector
    end
    return;
endfunction
