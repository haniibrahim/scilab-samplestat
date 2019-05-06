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

function skew = ST_skewness(v)
    // Skewness of a sample distribution
    //
    // Calling Sequence
    //   skew = ST_skewness(v)
    //
    // Parameters
    // v: m-by-1 or 1-by-n matrix of doubles, numerical values (n>10, better n>25)
    // skew: 1-by-1 matrix of doubles, skewness
    //
    // Description
    // In probability theory and statistics, skewness is a measure of the 
    // asymmetry of the probability distribution of a real-valued random 
    // variable about its mean. The skewness value can be positive or negative, 
    // or undefined.
    //
    // As a measure of the type and strength of asymmetry, you can calculate 
    // the skewness "v" of your empirical distribution as the third empirical 
    // moment:
    //
    // <latex>
    // \begin{eqnarray}
    // v = {1\over n}\sum_{i=1}^{n} \left( {1 \over \sigma} (x_i-\bar{x}) \right )^3 \; \text{with}\quad\bar{x}= {1 \over n}\sum_{i=1}^{n} x_i \quad \text{and} \quad \sigma = \sqrt{{1 \over n}\sum_{i=1}^{n}(x_i-\bar{x})^2} \\
    // x_i: \text{value} \quad ; \quad \bar{x}: \text{arithmetic mean} \\
    // \sigma: \text{standard deviation of population} \quad ; \quad n: \text{number of values}
    // \end{eqnarray}
    // </latex>
    //
    // So with a symmetrical distribution you get the value close to zero for v.  
    // If v is greater than zero, then there is a right-skewed/left-sided distribution; 
    // in the case of a negative value of v, the distribution is left-skewed or 
    // right-sided.
    // 
    // <inlinemediaobject><imageobject>
    // <imagedata fileref="../../images/skewness.png" align="center" valign="middle"/>
    // </imageobject></inlinemediaobject>
    //
    // <important><para>
    // Do use ST_skewness ONLY with NORMAL distributions and
    // with more than 10 or better more than 25 values!
    // </para></important>
    //
    // Examples
    // data = [18 23 27 31 34 39 42 45 52 65]
    // skew = ST_skewness(data) // = 0.49 => positive skew = right skewed
    //
    // See also
    //  ST_outlier
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    //
    // Bibliography
    //   Lohringer, H., "Grundlagen der Statistik", Oct, 10th, 2012, http://www.statistics4u.info/
    // 
    
    // Check arguments
    [lhs,rhs]=argn();
    apifun_checkrhs("ST_skewness", rhs, 1); // Input args
    apifun_checklhs("ST_skewness", lhs, 1); // Output args
    apifun_checkvector("ST_skewness", v, "v", 1); // Vector?
    apifun_checktype("ST_skewness", v, "v", 1, "constant"); //Double?
    
    xm = mean(v); // arithmetic mean
    sdp = stdev(v, "*", xm); // S.D. of population/univers
    n  = length(v); // number of values
    skew = 0;
    for i=1:n
        skew = skew + ((v(i)-xm) ./ sdp).^3 .* 1/n
    end
endfunction
