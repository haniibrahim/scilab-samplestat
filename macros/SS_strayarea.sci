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

//strayval = SS_strayarea(v, p)
//
//"SS_strayarea" determines the range of dispersion of the values. It describes the
//quality of the raw values.
//
//E.g. if strayval = 1.4 at p = 95% with a mean = 10,0 all raw 
//values of the whole population will be expected with a confidence of 95% at 
//about 10.0 +/- 1.4.
//
//The strayarea strayval indicates that P% of all single values are expected
//around mean + strayval and mean - strayval.
//
//v is a vector of numerical values, 
//p is the statistical confidence level (%) as a string or
//  the level of significance (alpha) as a decimal value.
//
//conf. level   level of signif.
//------------------------------
//  "95%"             0.05
//  "99%"             0.01
//  "99.9%"           0.001
//
//Example:
//
//V = [6 8 14 12 5 15];
//mean(V)
//  10.
//SS_strayarea(V, "95%")
//  10.904
//
//SS_strayarea(V, 0.05)
//  10.904
//
//In the committed vector "v" 95% of all values will stray about 10.9 
//around the arithmetic mean of 10 => 0 and 20.9
//
//The strayarea is calculated as s * t. (t = student factor, dependent on the 
//confidence level P% = 95%, 99% or 99.9% and the degree of freedom f = n - 1.
//
//Based on the German book R. Kaiser, G. Gottschalk; "Elementare Tests zur 
//Beurteilung von Meßdaten", BI Hochschultaschenbücher, Bd. 774, Mannheim 1972.

// Author: Hani Andreas Ibrahim <hani.ibrahim@gmx.de>
// License: GPL 3.0
function strayval = SS_strayarea(v, p)

// Check arguments
  inarg = argn(2);
  if inarg > 2 | inarg == 0 then error('Commit 2 arguments: v=vector of values; p=confidence level'); end
  if (~isnum(string(v)) | ~isvector(v)); error("First argument has to be a numeric vector\n"); end
  if ~(strcmp(string(p),"95%") | strcmp(string(p),"99%") | strcmp(string(p),"99.9%") | p ~= 0.05 | p ~= 0.01 | p ~= 0.001)
    error("Second argument is the statistical confidence level and has to be a string, as 95%, 99% or 99.9% or as alpha value: 0.05, 0.01, 0.001");
  end
  
  // Number of values
  n = length(v);

  if SS_studentfactor(n, p) < 0
    error("Wrong studenfactor t was committed. Here is something serously wrong!");
  end
  
  strayval = stdev(v) * SS_studentfactor(n, p);

endfunction
