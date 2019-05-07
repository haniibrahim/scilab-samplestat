function [outlierfree, outlier] = ST_pearsonhartley(v, p)
    // Pearson-Hartley outlier test
    //
    // Calling Sequence
    //   [outlierfree] = ST_pearsonhartley(v, p)
    //   [outlierfree, outlier] = ST_pearsonhartley(v, p)
    //
    // Parameters
    // v: vector of numerical values
    // p: statistical confidence level (%) as a string or the level of significance (alpha) as a decimal value, "95%", "99%" or 0.05, 0.01 resp (see examples).
    // outlierfree: vector of outlier-free data
    // outlier: vector of outliers
    //
    // Description
    // Performs the Pearson-Hartley outlier test. It should be used for distributions 
    // with more than 30 values.
    //
    // <latex>
    // \begin{eqnarray}
    // q=\left| \frac{1}{s}(x_i - \bar{x}) \right| \quad ; \quad q >q_{crit} \quad  \Rightarrow \quad x_i = \text{outlier} \\
    // x_i: \text{test value} \quad ; \quad \bar{x}: \text{arithmetic mean} \quad ; \quad s: \text{standard deviation}
    // \end{eqnarray}
    // </latex>
    //
    // <important><para>
    // Do use ST_pearsonhartley ONLY with NORMAL distrinutions and
    // with more than 30 values! For less than 30 values use 
    // Dean-Dixon test "ST_deandion()" instead. 
    // </para></important>
    //
    // Examples
    // data = [..
    // 0.21 0.75 0.00 0.33 0.66 0.62 0.84 0.68 0.87 0.06 ..
    // 0.56 0.66 0.72 0.19 0.54 0.23 0.23 0.21 0.88 0.65 ..
    // 0.30 0.93 0.21 0.31 0.36 0.29 0.56 0.48 0.33 0.59 ..
    // 1.23 1.84 0.50 0.43 0.26 0.63 ..
    // ];
    // of = ST_pearsonhartley(data, "95%")      // outlier-free values
    // [of, o] = ST_pearsonhartley(data, "95%") // outlier and outlier-free values
    // [of, o] = ST_pearsonhartley(data, 0.05)  // outlier and outlier-free values
    //
    // See also
    //  ST_outlier
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

    function critval = pearsonhartley_crit(n, p)
        // Returns the critical q value for Pearson-Hartley outlier test.
        //
        // Parameter
        // n: number of numerical values
        // p: statistical confidence level (%) as a string or the level of significance (alpha) as a decimal value, "95%", "99%" or 0.05, 0.01 resp.

        // qtable contains the critical values critval for N (number of values)
        // and alpha (niveau of significance)  
        // Column 1 : Number of values (N)
        // Column 2 : Q_crit, 95% confidence level, alpha = 0.05
        // Column 3 : Q_crit, 99% confidence level, alpha = 0.01
        qtable = [ ...
        1	1.645	2.326; ...
        2	1.955	2.575; ...
        3	2.121	2.712; ...
        4	2.234	2.806; ...
        5	2.319	2.877; ...
        6	2.386	2.934; ...
        7   2.438   2.978; ...
        8	2.490	3.022; ...
        9   2.529   3.056; ...
        10	2.568	3.089; ...
        15	2.705	3.207; ...
        20	2.799	3.289; ...
        25	2.870	3.351; ...
        30	2.928	3.402; ...
        35	2.975	3.444; ...
        40	3.016	3.479; ...
        45	3.051	3.511; ...
        50	3.083	3.539; ...
        55	3.111	3.564; ...
        60	3.137	3.587; ...
        65	3.160	3.607; ...
        70	3.182	3.627; ...
        75  3.201   3.644; ...
        80	3.220	3.661; ...
        85  3.237   3.676; ...
        90	3.254	3.691; ...
        95  3.269   3.705; ...
        100	3.283	3.718; ...
        200	3.474	3.889; ...
        300	3.581	3.987; ...
        400	3.656	4.054; ...
        500	3.713	4.106; ...
        600	3.758	4.148; ...
        700	3.797	4.183; ...
        800	3.830	4.214; ...
        900	3.859	4.240; ...
        1000 3.884	4.264...
        ];

        // Set the proper column of the t-table, depending on confidence level
        select(p)
        case("95%")
            j = 2;
        case("99%")
            j = 3;
        case(0.05)
            j = 2;
        case(0.01)
            j = 3;
        else
            error("Wrong confidence level");
        end

        // Pick the appropriate Q_crit value, interpolate if necessary
        if (n >= 1 & n <= 10)
            critval = qtable(n,j);
        elseif (n >= 11  & n <= 100)
            i = 8 + floor(n/5); // Determine row, 27=correction factor
            qs = (qtable(i+1,j) - qtable(i,j))/5;
            mul = n - qtable(i,1); // Multiplicator for qs
            critval = qtable(i,j) + (mul * qs);
        elseif (n >=101 & n < 1000)
            i = 27 + floor(n/100); // Determine row, 8=correction factor
            qs = (qtable(i+1,j) - qtable(i,j))/100;
            mul = n - qtable(i,1); // Multiplicator for qs
            critval = qtable(i,j) + (mul * qs);
        else // for the last value (1000)
            i = 27 + floor(n/100); // Determine row, 6=correction factor
            critval = qtable(i,j);
        end
        return;
    endfunction 

    // === MAIN ================================================================

    // Check arguments
    [lhs,rhs]=argn()
    apifun_checkrhs("ST_pearsonhartley", rhs, 2); // Input args
    apifun_checklhs("ST_pearsonhartley", lhs, 1:2); // Output args
    apifun_checkvector("ST_pearsonhartley", v, "v", 1); // Vector?
    apifun_checktype ("ST_pearsonhartley", v, "v", 1, "constant"); //Double?
    apifun_checkscalar("ST_pearsonhartley", p, "p", 1); // Scalar?
    if string(p)~="95%" & string(p)~="99%" & p ~= 0.05 & p ~= 0.01 then
        error(msprintf("%s: Second argument is the statistical confidence level \nand has to be a string, as 95%% or 99%%" + ..
        " or as alpha value: 0.05, 0.01.", "ST_pearsonhartley"));
    end

    n = length(v);
        if (n < 30 | n > 1000)
            error(msprintf( ..
    "Pearson-Hartley is just applicable for sample distributions greater than 30\n" + ..
    "and less than 1000 values. Use the Dean-Dixon outlier test ""ST_deandixon()""\n" + ..
    "or the Nalimov test ""ST_nalimov()"" for less than 30 samples")); 
        end

    // Determine Q_crit
    qcritval = pearsonhartley_crit(n, p);

    S = stdev(v);
    X = mean(v);
    j = 1; // index variable for outlier vector
    k = 1; // index variable for outlier-free vector
    outlier = [];
    outlierfree = [];

    for i=1:n
        q = abs((v(i)-X)/S);
        if (q > qcritval)
            outlier(j) = v(i);
            j = j + 1;
            continue;
        end
        outlierfree(k) = v(i);
        k = k + 1;
    end

    // make column vectors
    outlierfree = outlierfree';
    outlier = outlier';

    return;

endfunction
