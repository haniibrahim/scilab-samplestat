// Copyright (C) 2016 Hani Andreas Ibrahim
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

function trustval = ST_trustarea(v, p)
// Determines the range of dispersion of the mean.
//
// Syntax
//  trustval = ST_trustarea(v, p)
//
// Parameters
// v: vector of numerical values
// p: statistical confidence level (%) as a string or the level of significance (α) as a decimal value, "95%", "99%", "99.9%" or 0.05, 0.01, 0.001 resp (see examples).
// trustval: trust area, range of dispersion of the mean.
//
// Description
// "ST_trustarea" determines the range of dispersion of the mean. It describes the
// quality of the mean and indicates the range of dispersion of the 
// mean and not of the raw values as the stray area does.
//
// <latex>
// \begin{eqnarray}
// T = s \cdot t \\
// T_{\bar{x}} = T/ \sqrt{n} 
// \end{eqnarray}
// </latex>
//
// T: stray area of values; s: sample standard deviation; t: student factor (dependent 
// on statistical confidence level P% and degree of freedom f=n-1 with n: number of values) 
//
// E.g. if trustval = 1.4 at p = 95% and mean(v) = 10.0, the confidence
// interval for the population mean according to this formulation is
// approximately 10.0 +/- 1.4.
//
// Examples
// v = [6 8 14 12 5 15];
// mean(v) // = 10.
// ST_trustarea(v, "95%") // = 4.4514
// ST_trustarea(v, 0.05)  // = 4.4514
//
// See also
//  ST_strayarea
//  ST_studentfactor
//  ST_grubbs
//  ST_esd
//  ST_outlier
//  ST_deandixon
//  ST_pearsonhartley
//  ST_shapirowilk
//  ST_ivplot
//
// Authors
//  Hani A. Ibrahim - hani.ibrahim@gmx.de
//
// Bibliography
//   R. Kaiser, G. Gottschalk; "Elementare Tests zur Beurteilung von Meßdaten", BI Hochschultaschenbücher, Bd. 774, Mannheim 1972.

  // Check arguments
  [lhs,rhs]=argn()
  apifun_checkrhs("ST_trustarea", rhs, 2); // Input args
  apifun_checklhs("ST_trustarea", lhs, 1); // Output args
  apifun_checkvector("ST_trustarea", v, "v", 1); // Vector?
  apifun_checktype ("ST_trustarea", v, "v", 1, "constant"); //Double?
  apifun_checkscalar("ST_trustarea", p, "p", 1); // Scalar?
  if string(p)~="95%" & string(p)~="99%" & string(p)~="99.9%" & p ~= 0.05 & p ~= 0.01 & p ~= 0.001
    error(msprintf("%s: Second argument is the statistical confidence level and has to be a string, as 95%%, 99%% or 99.9%%" + ..
    " or as alpha value: 0.05, 0.01, 0.001", "ST_trustarea"));
  end
  
  if or(isnan(v)) | or(isinf(v)) then
        error("ST_trustarea: First argument v must not contain NaN or Inf values.");
    end
  
 
//  inarg = argn(2);
//  if inarg > 2 | inarg == 0 then error('Commit 2 arguments: v=vector of values; p=confidence level'); end
//  if (~isnum(string(v)) | ~isvector(v)); error("First argument has to be a numeric vector\n"); end
//  if ~(strcmp(string(p),"95%") | strcmp(string(p),"99%") | strcmp(string(p),"99.9%") | p ~= 0.05 | p ~= 0.01 | p ~= 0.001)
//    error("Second argument is the statistical confidence level and has to be a string, as 95%, 99% or 99.9% or as alpha value: 0.05, 0.01, 0.001");
//  end
  
  n = length(v); // Number of values
  if n < 2 then
    error("ST_trustarea: First argument v must contain at least two values.");
  end

  // Calculate the stray area only once. ST_strayarea performs the
  // remaining consistency and confidence-level checks.
  strayval = ST_strayarea(v, p);
  trustval = strayval / sqrt(n);
  
endfunction
