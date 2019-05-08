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

function [normal] = ST_shapirowilk(v, p)   
    // Shapiro-Wilk test of normality 
    //
    // Calling Sequence
    //   [normal] = ST_shapirowilk(v, p)
    //
    // Parameters
    // v: m-by-1 or 1-by-n matrix of doubles
    // p: statistical confidence level (%) as a string or the level of significance (alpha) as a decimal value, "90%", "95%", "99%" or 0.1, 0.05, 0.01 resp. (see examples).
    // normal: Returns %T if sample distribution is normally distributed or %F if not. 
    //
    // Description
    // The Shapiro-Wilk test is a statistical significance test that tests the 
    // hypothesis that the underlying population of a sample is normally 
    // distributed.
    //
    // The Shapiro-Wilk test exhibiting high power, leading to good results 
    // even with a small number of observations. In contrast to other comparison 
    // tests the Shapiro-Wilk test is only applicable to check for normality. 
    //
    // The test can be used for sample sizes from 3 to 50 values.
    //
    // The theory behind Shapiro-Wilk can be find at 
    // <link linkend="distribution_overview">Distribution Overview</link>.
    //
    // <caution><para>
    // The test reacts very sensitively to outliers, both for one-sided and 
    // two-sided ones. Outliers can strongly distort the distribution pattern so 
    // that the normal distribution assumption could be erroneously rejected.
    // </para><para>
    // The test is relatively susceptible to Ties, i.e. if there are many identical 
    // values, the test strength is strongly affected.
    // </para></caution>
    //
    // <important><para>
    // Although the Shapiro-Wilk test has a big test strength, especially for 
    // smaller sample sizes, it should not be used blindfolded for the reasons 
    // mentioned above. 
    // </para>
    // <para>
    // Check the results graphically with individual value plot, histogram, 
    // QQ-plot or box-plot. The latter two are provided in the toolbox STIXBOX.
    // </para></important>
    //
    // Examples
    // scf();
    // data1 = [200, 545, 290, 165, 190, 355, 185, 205, 175, 255];
    // normal = ST_shapirowilk(data1, "95%") // normal = %F => non-normally distr.
    // ST_ivplot(data1,"data1");
    // scf();
    // data2 = [-15.6, -21.6, -19.5, -19.1, -20.9, -20.7, -19.3, -18.3, -15.1]; 
    // normal = ST_shapirowilk(data2, "95%") // normal = %T => normally distributed
    // ST_ivplot(data2,"data2"); 
    //
    // See also
    //  ST_ivplot
    //  ST_deandixon
    //  ST_pearsonhartley
    //  ST_nalimov
    //  ST_strayarea
    //  ST_trustarea
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    //
    // Bibliography
    // 

    // === FUNCTIONS ===========================================================

    function [critval] = shapirowilk_crit(n, p)

        // watable contains the critical values critval for N (number of values)
        // and alpha (niveau of significance)  
        // Column 1 : Number of values (N)
        // Column 2 : W_alpha_crit, 90% confidence level, alpha = 0.10
        // Column 3 : W_alpha_crit, 95% confidence level, alpha = 0.05
        // Column 4 : W_alpha_crit, 99% confidence level, alpha = 0.01
        watable = [ ...
        3   0.789 0.767 0.753; ... 
        4   0.792 0.748 0.687; ...
        5   0.806 0.762 0.686; ...
        6   0.826 0.788 0.713; ...
        7   0.838 0.803 0.730; ...
        8   0.851 0.818 0.749; ...
        9   0.859 0.829 0.764; ...
        10  0.869 0.842 0.781; ...
        11  0.876 0.850 0.792; ...
        12  0.883 0.859 0.805; ...
        13  0.889 0.866 0.814; ...
        14  0.895 0.874 0.825; ...
        15  0.901 0.881 0.835; ...
        16  0.906 0.887 0.844; ...
        17  0.910 0.892 0.851; ...
        18  0.914 0.897 0.858; ...
        19  0.917 0.901 0.863; ...
        20  0.920 0.905 0.868; ...
        25  0.931 0.918 0.888; ...
        30  0.939 0.927 0.900; ...
        35  0.944 0.934 0.910; ...
        40  0.949 0.940 0.919; ...
        45  0.953 0.944 0.925; ...
        50  0.955 0.947 0.930	...
        ];

        // Set the proper column of the watable, depending on confidence level
        select(p)
        case("90%")
            j = 2;
        case("95%")
            j = 3;
        case("99%")
            j = 4;
        case(0.10)
            j = 2;
        case(0.05)
            j = 3;
        case(0.01)
            j = 4;
        else
            error();
        end

        // Pick the appropriate G_crit value, interpolate if necessary
        if (n >= 5 & n <= 20)
            critval = watable(n-2,j);
        elseif (n >= 21  & n <= 49)
            i = 14 + floor(n/5); // Determine row, 12=correction factor
            qs = (watable(i+1,j) - watable(i,j))/5;
            mul = n - watable(i,1); // Multiplicator for qs
            critval = watable(i,j) + (mul * qs);
        else // for the last value (600)
            i = 14 + floor(n/5); // Determine row, 12=correction factor
            critval = watable(i,j);
        end
        return;
    endfunction

    // =========================================================================

    function alpha = shapirowilk_a(i,n)

        // Coefficients a for the W test for normality
        //                n-i+1
        //
        // Row 1:         number of values (n-value)
        // Column 1:      index (i-value)
        // Column 2 - 50: alpha-coefficients (alpha)
        alpha_table = [ ...
        0	  2	      3	      4	      5	      6	      7	      8	      9	      10	    11	    12	    13	    14	    15	    16	    17	    18	    19	    20	    21	    22	    23	    24	    25	    26	    27	    28	    29	    30	    31	    32	    33	    34	    35	    36	    37	    38	    39	    40	    41	    42	    43	    44	    45	    46	    47	    48	    49	    50; ...
        1	  0.7071	0.7071	0.6872	0.6646	0.6431	0.6233	0.6052	0.5888	0.5739	0.5601	0.5475	0.5359	0.5251	0.5150	0.5056	0.4968	0.4886	0.4808	0.4734	0.4643	0.4590	0.4542	0.4493	0.4450	0.4407	0.4366	0.4328	0.4291	0.4254	0.4220	0.4188	0.4156	0.4127	0.0410	0.4068	0.4040	0.4015	0.3989	0.3964	0.0394	0.3917	0.0389	0.3872	0.3850	0.3830	0.3808	0.3789	0.3770	0.3751; ...
        2	  %nan	    0.0000	0.1677	0.2413	0.2806	0.3031	0.3164	0.3244	0.3291	0.3315	0.3325	0.3318	0.3318	0.3306	0.3290	0.3273	0.3253	0.3232	0.3211	0.3185	0.3156	0.3126	0.3098	0.3069	0.3043	0.3018	0.2992	0.2968	0.2944	0.2921	0.2898	0.2876	0.2854	0.2834	0.2813	0.2794	0.2774	0.2755	0.2737	0.2719	0.2701	0.2684	0.2667	0.2651	0.2635	0.2620	0.2604	0.2589	0.2574; ...
        3	  %nan	    %nan	    %nan	    0.0000	0.0875	0.1401	0.1743	0.1976	0.2141	0.2260	0.2347	0.2412	0.2460	0.2495	0.2521	0.2540	0.2553	0.2561	0.2565	0.2578	0.2571	0.2563	0.2554	0.2543	0.2533	0.2522	0.2510	0.2499	0.2487	0.2475	0.2463	0.2451	0.2439	0.2427	0.2415	0.2403	0.2391	0.2380	0.2368	0.2357	0.2345	0.2334	0.2323	0.2313	0.2302	0.2291	0.2281	0.2271	0.2260; ...
        4	  %nan	    %nan	    %nan	    %nan	    %nan   	0.0000	0.0561	0.0947	0.1224	0.1429	0.1586	0.1707	0.1802	0.1878	0.1939	0.1988	0.2027	0.2059	0.2085	0.2119	0.2131	0.2139	0.2145	0.2148	0.2151	0.2152	0.2151	0.2150	0.2148	0.2145	0.2141	0.2137	0.2132	0.2127	0.2121	0.2116	0.2110	0.2104	0.2098	0.2091	0.2085	0.2078	0.2072	0.2065	0.2058	0.2052	0.2045	0.2038	0.2032; ...
        5	  %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0399	0.0695	0.0922	0.1099	0.1240	0.1353	0.1447	0.1524	0.1587	0.1641	0.1686	0.1736	0.1764	0.1787	0.1807	0.1822	0.1836	0.1848	0.1857	0.1864	0.1870	0.1874	0.1878	0.1880	0.1882	0.1883	0.1883	0.1883	0.1881	0.1880	0.1878	0.1876	0.1874	0.1871	0.1868	0.1865	0.1862	0.1859	0.1855	0.1851	0.1847; ...
        6	  %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0303	0.0539	0.0727	0.0880	0.1005	0.1109	0.1197	0.1271	0.1334	0.1399	0.1443	0.1480	0.1512	0.1539	0.1563	0.1584	0.1601	0.1616	0.1630	0.1641	0.1651	0.1660	0.0167	0.1673	0.1678	0.1683	0.1686	0.1689	0.1691	0.1693	0.1694	0.1695	0.1695	0.1695	0.1695	0.1695	0.1693	0.1692	0.1691; ...
        7	  %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0240	0.0433	0.0593	0.0725	0.0837	0.0932	0.1013	0.1092	0.1150	0.1201	0.1245	0.1283	0.1316	0.1346	0.1372	0.1395	0.1415	0.1433	0.1449	0.1463	0.1475	0.1487	0.1496	0.1505	0.1513	0.1520	0.1526	0.1531	0.1535	0.1539	0.1542	0.1545	0.1548	0.1550	0.1551	0.1553	0.1554; ...
        8	  %nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0196	0.0359	0.0496	0.0612	0.0711	0.0804	0.0878	0.0941	0.0997	0.1046	0.1089	0.1128	0.1162	0.1192	0.1219	0.1243	0.1265	0.1284	0.1301	0.1317	0.1331	0.1344	0.1356	0.1366	0.1376	0.1384	0.1392	0.1398	0.1405	0.1410	0.1415	0.1420	0.1423	0.1427	0.0143; ...
        9	  %nan	    %nan	    %nan	    %nan   	%nan   	%nan   	%nan	    %nan	    %nan   	%nan	    %nan    	%nan	    %nan	    %nan   	%nan	    0.0000	0.0163	0.0303	0.0422	0.0530	0.0618	0.0696	0.0764	0.0823	0.0876	0.0923	0.0965	0.1002	0.1036	0.1066	0.1093	0.1118	0.1140	0.1160	0.1179	0.1196	0.1211	0.1225	0.1237	0.1249	0.1259	0.1269	0.1278	0.1286	0.1293	0.1300	0.1306	0.1312	0.1317; ...
        10	%nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0140	0.0263	0.0368	0.0459	0.0539	0.0610	0.0672	0.0728	0.0778	0.0822	0.0862	0.0899	0.0931	0.0961	0.0988	0.1013	0.1036	0.1056	0.1075	0.1092	0.1108	0.1123	0.1136	0.1149	0.1160	0.1170	0.1180	0.1189	0.1197	0.1205	0.1212; ...
        11	%nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan     %nan	    %nan   	%nan	    %nan	    %nan	    0.0000	0.0122	0.0228	0.0321	0.0403	0.0476	0.0540	0.0598	0.0650	0.0697	0.0739	0.0777	0.0812	0.0844	0.0873	0.0900	0.0924	0.0947	0.0967	0.0986	0.1004	0.1020	0.1035	0.1049	0.1062	0.1073	0.1085	0.1095	0.1105	0.1113; ...
        12	%nan	    %nan   	%nan    	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan   	%nan   	%nan	    %nan	    0.0000	0.0107	0.0200	0.0284	0.0358	0.0424	0.0483	0.0537	0.0585	0.0629	0.0669	0.0706	0.0739	0.0770	0.0798	0.0824	0.0848	0.0870	0.0891	0.0909	0.0927	0.0943	0.0959	0.0972	0.0986	0.0998	0.1010	0.1020; ...
        13	%nan   	%nan	    %nan	    %nan	    %nan   	%nan   	%nan     %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan     %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	0.0000	0.0094	0.0178	0.0253	0.0320	0.0381	0.0435	0.0485	0.0530	0.0572	0.0610	0.0645	0.0677	0.0706	0.0733	0.0759	0.0782	0.0804	0.0824	0.0842	0.0860	0.0876	0.0892	0.0906	0.0919	0.0932; ...
        14	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0084	0.0159	0.0227	0.0289	0.0344	0.0395	0.0441	0.0484	0.0523	0.0559	0.0592	0.0622	0.0651	0.0677	0.0701	0.0724	0.0745	0.0765	0.0783	0.0801	0.0817	0.0832	0.0846; ...
        15	%nan	    %nan	    %nan   	%nan   	%nan   	%nan   	%nan   	%nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0076	0.0144	0.0206	0.0262	0.0314	0.0361	0.0404	0.0444	0.0481	0.0515	0.0546	0.0575	0.0602	0.0628	0.0651	0.0673	0.0694	0.0713	0.0731	0.0748	0.0764; ...
        16	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0068	0.0131	0.0187	0.0239	0.0287	0.0331	0.0372	0.0409	0.0444	0.0476	0.0506	0.0534	0.0560	0.0584	0.0607	0.0628	0.0648	0.0667	0.0685; ...
        17	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0062	0.0119	0.0172	0.0220	0.0264	0.0305	0.0343	0.0379	0.0411	0.0442	0.0471	0.0497	0.0522	0.0546	0.5680	0.0588	0.0608; ...
        18	%nan	    %nan	    %nan     %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan     %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0057	0.0110	0.0158	0.0203	0.0244	0.0283	0.0318	0.0352	0.0383	0.0412	0.0439	0.0405	0.0489	0.0511	0.0532; ...
        19	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0053	0.0101	0.0146	0.0188	0.0227	0.0263	0.0296	0.0328	0.0357	0.0385	0.0411	0.0436	0.0459; ...
        20	%nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0049	0.0094	0.0136	0.0175	0.0211	0.0245	0.0277	0.0307	0.0335	0.0361	0.0386; ...
        21	%nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan   	%nan   	%nan	    %nan	    %nan   	%nan	    %nan   	%nan	    %nan	    %nan   	%nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan   	%nan	    %nan	    %nan	    0.0000	0.0045	0.0087	0.0126	0.0163	0.0197	0.0229	0.0259	0.0288	0.0314; ...
        22	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan   	%nan   	%nan	    %nan   	%nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0042	0.0081	0.0118	0.0153	0.0185	0.0215	0.0244; ...
        23	%nan	    %nan	    %nan   	%nan	    %nan   	%nan     %nan   	%nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan   	%nan   	%nan   	%nan	    %nan	    %nan	    %nan   	%nan   	%nan   	%nan   	%nan	    %nan	    %nan	    %nan	    0.0000	0.0039	0.0076	0.0111	0.0143	0.0174; ...
        24	%nan	    %nan	    %nan   	%nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan	    %nan   	%nan   	%nan	    %nan   	%nan	    %nan	    %nan   	%nan   	%nan     %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    0.0000	0.0037	0.0071	0.0104; ...
        25	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan   	%nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan	    %nan   	%nan	    %nan	    0.0000	0.0035 ...
        ];

        alpha = alpha_table(i+1, n);

        return;

    endfunction

    // === MAIN ================================================================

    // Check arguments
    [lhs,rhs]=argn()
    apifun_checkrhs("ST_shapirowilk", rhs, 2); // Input args
    apifun_checklhs("ST_shapirowilk", lhs, 1:2); // Output args
    apifun_checkvector("ST_shapirowilk", v, "v", 1); // Vector?
    apifun_checktype ("ST_shapirowilk", v, "v", 1, "constant"); //Double?
    apifun_checkscalar("ST_shapirowilk", p, "p", 1); // Scalar?
    if string(p)~="90%" & string(p)~="95%" & string(p)~="99%" & p ~= 0.10 & p ~= 0.05 & p ~= 0.01
        error(msprintf("%s: Second argument is the statistical confidence level and has to be a string, as 90%%, 95%% or 99%%" + ..
        " or as alpha value: 0.1, 0.05, 0.01", "ST_shapirowilk"));
    end

    n = length(v);

    if (n < 3 | n > 50) then
        error(msprintf("Shapiro-Wilk normal distribution test is just applicable for " + ..
        "sample distributions greater than 3 and lesser than 50 values.")); 
    end

    // sort data ascendingly
    v = gsort(v);

    // Calc. mean
    x = mean(v);

    // Calculate S^2 = SUM ( x_i - mean)^2
    s2 =0;
    for i=1:n
        s2 = s2 + (v(i) - x)^2;
    end

    // Calulate b for even or odd n
    b = 0;
    if ~(n-fix(n ./ 2) .* 2) // ~rem(n,2) in Matlab
        // Calculate for even-n => b = SUM a_n-i+1 (v_n-i+1 - v_i) from i=1 to i=n/2
        for i=1:(n/2)
            b = b + shapirowilk_a(i,n) * (v(n-i+1) - v(i));
        end
    else
        // Calculate for odd-n => b = SUM a_n-i+1 (v_n-i+1 - v_i) from i=1 to i=(n-1)/2
        for i=1:((n-1)/2)
            b = b + shapirowilk_a(i,n) * (v(n-i+1) - v(i));
        end
    end

    // Calculate W = b^2/S^2
    W = b^2/s2;

    // Compare W with W_alpha, 
    // if W is greater the W_alpha the distribution is normally distributed
    if W > shapirowilk_crit(n, p)
        normal = %T;
    else
        normal = %F;
    end

    return;

endfunction
