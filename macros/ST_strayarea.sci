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

function strayval = ST_strayarea(v, p)
// Determines the range of dispersion of the values.
//
// Calling Sequence
//  strayval = ST_strayarea(v, p)
//
// Parameters
// v: vector of numerical values
// p: statistical confidence level (%) as a string or the level of significance (alpha) as a decimal value, "95%", "99%", "99.9%" or 0.05, 0.01, 0.001 resp (see examples).
// strayval: stray area, range of dispersion of the values.
//
// Description
// "ST_strayarea" determines the range of dispersion of the values. It describes the quality of the raw values.
//
// E.g. if strayval = 1.4 at p = 95% with a mean = 10,0 all raw 
// values of the whole population will be expected with a confidence of 95% at 
// about 10.0 +/- 1.4.
//
// Examples
// V = [6 8 14 12 5 15];
// mean(V) // = 10.
// strayval1 = ST_strayarea(V, "95%") // = 10.904
// strayval2 = ST_strayarea(V, 0.05)  // = 10.904
//
// See also
//  ST_trustarea
//  ST_studentfactor
//  ST_dixon
//  ST_deandixon
//  ST_grubbs
//  ST_pearsonhartley
//  ST_shapirowilk
//
// Authors
//  Hani A. Ibrahim - hani.ibrahim@gmx.de
//
// Bibliography
//   R. Kaiser, G. Gottschalk; "Elementare Tests zur Beurteilung von Meßdaten", BI Hochschultaschenbücher, Bd. 774, Mannheim 1972.

// Check arguments
  [lhs,rhs]=argn()
  apifun_checkrhs("ST_strayarea", rhs, 2); // Input args
  apifun_checklhs("ST_strayarea", lhs, 1); // Output args
  apifun_checkvector("ST_strayarea", v, "v", 1); // Vector?
  apifun_checktype ("ST_strayarea", v, "v", 1, "constant"); //Double?
  apifun_checkscalar("ST_strayarea", p, "p", 1); // Scalar?
  if ~(strcmp(string(p),"95%") | strcmp(string(p),"99%") | strcmp(string(p),"99.9%") | p ~= 0.05 | p ~= 0.01 | p ~= 0.001)
    error(msprintf("%s: Second argument is the statistical confidence level and has to be a string, as 95%, 99% or 99.9%" + ..
    " or as alpha value: 0.05, 0.01, 0.001", "ST_strayarea"));
  end
  
    
//  inarg = argn(2);
//  if inarg > 2 | inarg == 0 then error('Commit 2 arguments: v=vector of values; p=confidence level'); end
//  if (~isnum(string(v)) | ~isvector(v)); error("First argument has to be a numeric vector\n"); end
//  if ~(strcmp(string(p),"95%") | strcmp(string(p),"99%") | strcmp(string(p),"99.9%") | p ~= 0.05 | p ~= 0.01 | p ~= 0.001)
//    error("Second argument is the statistical confidence level and has to be a string, as 95%, 99% or 99.9% or as alpha value: 0.05, 0.01, 0.001");
//  end
  
  // Number of values
  n = length(v);

  if ST_studentfactor(n, p) < 0
    error("Wrong studenfactor t was committed. Here is something serously wrong!");
  end
  
  strayval = stdev(v) * ST_studentfactor(n, p);

endfunction
