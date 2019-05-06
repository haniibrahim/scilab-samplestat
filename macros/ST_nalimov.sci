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

function [outlierfree, outlier] = ST_nalimov(v, p)
    // Performs a Nalimov outlier test. 
    //
    // Calling Sequence
    //   [outlierfree] = ST_nalimov(v, p)
    //   [outlierfree, outlier] = ST_nalimov(v, p)
    //
    // Parameters
    // v: vector of numerical values
    // p: statistical confidence level (%) as a string or the level of significance (alpha) as a decimal value, "95%", "99%", "99.9%" or 0.05, 0.01, 0.001 resp (see examples).
    // outlierfree: vector of outlier-free data
    // outlier: vector of outliers
    //
    // Description
    // Performs Nalimov outlier test for small and larger sample sizes. 
    // It calculates for all values the test value "q". 
    // It compares these q-values with the appropriate qcrit value from a table.
    //
    // <latex>
    // \begin{eqnarray}
    // q = \left | \frac{1}{s}(x_i- \bar{x}) \right | \sqrt{\frac{n}{n-1}} \quad;\quad q>q_{crit}\;\Rightarrow \; x_i=\text{outlier} \\
    // x_i: \text{test value} \quad ; \quad \bar{x}: \text{arithmetic mean} \\
    // s: \text{standard deviation of samples} \quad ; \quad n: \text{number of values}
    // \end{eqnarray}
    // </latex>
    //
    // q-values of the sample values which are greater than the qcrit value are 
    // outliers
    //
    // <important><para>
    // Do use ST_nalimov ONLY with NORMAL distributed data and
    // with more than 3 and less than 1000 values!
    // </para></important>
    //
    // <caution><para>
    // Do use ST_nalimov with care. It indicates outliers very strict and is 
    // controversially discussed in the scientific community. For a convervative
    // outlier test substitute Nalimov with Dean-Dixon (ST_deandixon)
    // small sample sizes (<30) and Pearson-Hartley (ST-pearsonhartley) for 
    // larger ones (>30).
    // </para></caution>
    //
    // Examples
    // data = [6 8 14 12 35 15];
    // of = ST_nalimov(data, "95%")      // outlier-free values
    // [of, o] = ST_nalimov(data, "95%") // outlier and outlier-free values
    // [of, o] = ST_nalimov(data, 0.05)  // outlier and outlier-free values
    //
    // See also
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
    //   R. Kaiser, G. Gottschalk; "Elementare Tests zur Beurteilung von Meßdaten", BI Hochschultaschenbücher, Bd. 774, Mannheim 1972.
    
    // === FUNCTIONS ===========================================================

    function [critval] = nalimov_crit(n, p)
        // Returns the critical Q value
        //
        // Parameters
        // n: number of numerical values
        // p: statistical confidence level (%) as a string or the level of significance (alpha) as a decimal value, "95%", "99%", "99.9%" or 0.05, 0.01, 0.001 resp (see examples).
        // critval: critical value
        // 
        // Examples
        // V = [6 8 14 12 5 15];
        // nalimov_crit(length(V), "95%") // = 1.870

        // Check arguments
        [lhs,rhs]=argn()
        apifun_checkrhs("nalimov_crit", rhs, 2); // Input args
        apifun_checklhs("nalimov_crit", lhs, 1); // Output args
        apifun_checkflint("nalimov_crit", n, "n", 1); // Integer?
        apifun_checkscalar("nalimov_crit", n, "n", 1); // Scalar?
        apifun_checkrange("nalimov_crit", n, "n", 1, 3,1002) // 3<= n <=1002
        apifun_checkscalar("nalimov_crit", p, "p", 1); // Scalar?

        // qtable contains the critical values critval for N (number of values)
        // and alpha (niveau of significance)  
        // Column 1 : Dregree of freedom (f = n-2)
        // Column 2 : Student factor, confidence level: 95%, level of significance = 0.05
        // Column 3 : Student factor, confidence level: 99%, level of significance = 0.01
        // Column 4 : Student factor, confidence level: 99.9%, level of significance = 0.001
        qtable = [ ...
        1   1.409   1.414   1.414; ...
        2   1.645   1.715   1.730; ...
        3   1.757   1.918   1.982; ...
        4   1.814   2.051   2.178; ...
        5   1.848   2.142   2.329; ...
        6   1.870   2.208   2.447; ...
        5   1.885   2.256   2.540; ...
        8   1.895   2.294   2.616; ...
        9   1.903   2.324   2.678; ...
        10  1.910   2.348   2.730; ...
        11  1.916   2.368   2.774; ...
        12  1.920   2.385   2.812; ...
        13  1.923   2.399   2.845; ...
        14  1.926   2.412   2.874; ...
        15  1.928   2.423   2.899; ...
        16  1.931   2.432   2.921; ...
        17  1.933   2.440   2.941; ...
        18  1.935   2.447   2.959; ...
        19  1.936   2.454   2.975; ...
        20  1.937   2.460   2.990; ...
        25  1.942   2.483   3.047; ...
        30  1.945   2.498   3.085; ...
        35  1.948   2.509   3.113; ...
        40  1.949   2.518   3.134; ...
        45  1.950   2.524   3.152; ...
        50  1.951   2.529   3.166; ...
        100 1.956   2.553   3.227; ...
        200 1.958   2.564   3.265; ...
        300 1.958   2.566   3.271; ...
        400 1.959   2.568   3.275; ...
        500 1.959   2.570   3.279; ...
        600 1.959   2.571   3.281; ...
        700 1.959   2.572   3.283; ...
        800 1.959   2.573   3.285; ...
        1000 1.960  2.576   3.291 ...
        ];

        // Set the proper column of the t-table, depending on confidence level
        select p
        case("95%")
            j = 2;
        case("99%")
            j = 3;
        case("99.9%")
            j = 4;
        case(0.05)
            j = 2;
        case(0.01)
            j = 3;
        case(0.001)
            j = 4;
        else
            error("Wrong confidence level");
        end

        // degree of freedom
        f = n-2;

        // Pick the appropriate Q_crit value, interpolate if necessary
        if (f >= 1 & f <= 20)
            critval = qtable(f,j);
        elseif (f >= 21  & f <= 50)
            i = 16 + floor(f/5); // Determine row, 16=correction factor
            qs = (qtable(i+1,j) - qtable(i,j))/5;
            mul = f - qtable(i,1); // Multiplicator for qs
            critval = qtable(i,j) + (mul * qs);
        elseif (f >= 51  & f <= 100)
            i = 25 + floor(f/50); // Determine row, 25=correction factor
            qs = (qtable(i+1,j) - qtable(i,j))/50;
            mul = f - qtable(i,1); // Multiplicator for qs
            critval = qtable(i,j) + (mul * qs);
        elseif (f >= 101  & f <= 800)
            i = 26 + floor(f/100); // Determine row, 26=correction factor
            qs = (qtable(i+1,j) - qtable(i,j))/100;
            mul = f - qtable(i,1); // Multiplicator for qs
            critval = qtable(i,j) + (mul * qs);
        elseif (f >= 801  & f < 1000)
            i = 30 + floor(f/200); // Determine row, 30=correction factor
            qs = (qtable(i+1,j) - qtable(i,j))/200;
            mul = f - qtable(i,1); // Multiplicator for qs
            critval = qtable(i,j) + (mul * qs);
        else // for the last value (1000)
            i = 35; // Determine row, 6=correction factor
            critval = qtable(i,j);
        end
        return;
    endfunction

    // === MAIN ================================================================

    // Check arguments
    [lhs,rhs]=argn()
    apifun_checkrhs("ST_nalimov", rhs, 2); // Input args
    apifun_checklhs("ST_nalimov", lhs, 1:2); // Output args
    apifun_checkvector("ST_nalimov", v, "v", 1); // Vector?
    apifun_checktype ("ST_nalimov", v, "v", 1, "constant"); //Double?
    apifun_checkscalar("ST_nalimov", p, "p", 1); // Scalar?
    if string(p)~="95%" & string(p)~="99%" & string(p)~="99.9%" & p ~= 0.05 & p ~= 0.01 & p ~= 0.001
        error(msprintf("%s: Second argument is the statistical confidence level and has to be a string, as 95%%, 99%% or 99.9%%" + ..
        " or as alpha value: 0.05, 0.01, 0.001", "ST_nalimov"));
    end

    n = length(v);

    // Determine Q_crit
    qcritval = nalimov_crit(n, p);

    x = mean(v);   // mean
    sd = stdev(v); // standard deviation

    outlier = [];
    outlierfree = [];

    for i=1:n
        q = abs(v(i)-x)/sd * sqrt(n/(n-1));
        if (q > qcritval)
            outlier = [outlier, v(i)];
        else
            outlierfree = [outlierfree, v(i)];
        end
    end

    return;

endfunction
