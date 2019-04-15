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

function trustval = SS_trustarea(v, p)
// Determines the range of dispersion of the mean.
//
// Calling Sequence
//   trustval = SS_trustarea(v, p)
//
// Parameters
// v: vector of numerical values
// p: statistical confidence level (%) as a string or the level of significance (alpha) as a decimal value, "95%", "99%", "99.9%" or 0.05, 0.01, 0.001 resp (see examples).
// trustval: trust area, range of dispersion of the mean.
//
// Description
// "SS_trustarea" determine the range of dispersion of the mean. It describes the
// quality of the mean and indicates the range of dispersion of the 
// mean and not of the raw values as the stray area does.
//
// E.g. if trustval = 1.4 at p = 95% with a mean = 10,0 the mean for
// the whole population will stray with a confidence of 95% at about 10.0 +/- 1.4.
//
// Examples
// V = [6 8 14 12 5 15];
// mean(V) // = 10.
// trustval1 = SS_trustarea(V, "95%") // = 4.4514
// trustval2 = SS_trustarea(V, 0.05)  // = 4.4514
//
// See also
//  SS_strayarea
//  SS_studentfactor
//
// Authors
//  Hani A. Ibrahim ; hani.ibrahim@gmx.de
//
// Bibliography
//   R. Kaiser, G. Gottschalk; "Elementare Tests zur Beurteilung von Meßdaten", BI Hochschultaschenbücher, Bd. 774, Mannheim 1972.

  // Check arguments
  inarg = argn(2);
  if inarg > 2 | inarg == 0 then error('Commit 2 arguments: v=vector of values; p=confidence level'); end
  if (~isnum(string(v)) | ~isvector(v)); error("First argument has to be a numeric vector\n"); end
  if ~(strcmp(string(p),"95%") | strcmp(string(p),"99%") | strcmp(string(p),"99.9%") | p ~= 0.05 | p ~= 0.01 | p ~= 0.001)
    error("Second argument is the statistical confidence level and has to be a string, as 95%, 99% or 99.9% or as alpha value: 0.05, 0.01, 0.001");
  end
  
  n = length(v); // Number of values
  
  if (SS_strayarea(v,p) < 0) then
    error("Wrong studenfactor t was committed. Here is something serously wrong!");
  else
   trustval = SS_strayarea(v,p)/sqrt(n);
  end
  
endfunction