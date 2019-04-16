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

function [retval] = ST_studentfactor(n, p)
// Determine the student factor
//
// Calling Sequence
//  retval = studentfactor(n, p)
//
// Parameters
// n: number of values in the sample distribution
// p: statistical confidence level (%) as a string or the level of significance (alpha) as a decimal value, "95%", "99%", "99.9%" or 0.05, 0.01, 0.001 resp (see examples).
// retval: student factor
//
// Description
// Determine the student factor from the internal t-table and 
// interpolate the value if necessary. It is a service function for 
// ST_strayarea() and ST_trustarea().
//
// Examples
// retval = ST_studentfactor(35, "95%") // = 2.0324
// retval = ST_studentfactor(35, 0.05)  // = 2.0324
//
// See also
//  ST_trustarea
//  ST_strayarea
//
// Authors
//  Hani A. Ibrahim - hani.ibrahim@gmx.de
//
// Bibliography
//   R. Kaiser, G. Gottschalk; "Elementare Tests zur Beurteilung von Meßdaten", BI Hochschultaschenbücher, Bd. 774, Mannheim 1972.

  
  // Check arguments
  [lhs,rhs]=argn()
  apifun_checkrhs("ST_studentfactor", rhs, 2); // Input args
  apifun_checklhs("ST_studentfactor", lhs, 1); // Output args
  apifun_checkflint("ST_studentfactor", n, "n", 1); // Integer?
  apifun_checkscalar("ST_studentfactor", n, "n", 1); // Scalar?
  apifun_checkscalar("ST_studentfactor", p, "p", 1); // Scalar?
  if ~(strcmp(string(p),"95%") | strcmp(string(p),"99%") | strcmp(string(p),"99.9%") | p ~= 0.05 | p ~= 0.01 | p ~= 0.001)
    error(msprintf("%s: Second argument is the statistical confidence level and has to be a string, as 95%, 99% or 99.9%" + ..
    " or as alpha value: 0.05, 0.01, 0.001", "ST_studentfactor") );
  end
  
//  inarg = argn(2);
//  if inarg > 2 | inarg == 0 then error('Commit 2 arguments: n=Numbers of values; p=confidence level'); end
//  if ~isnum(string(n)) then error("First argument is the number of values and has to be an integer"); end
//  if (n < 2 | n > 1000); error("First value has to be greater or equal 2 and less or equal 1000"); end
//  if ~(strcmp(string(p),"95%") | strcmp(string(p),"99%") | strcmp(string(p),"99.9%") | p ~= 0.05 | p ~= 0.01 | p ~= 0.001)
//    error("Second argument is the statistical confidence level and has to be a string, as 95%, 99% or 99.9% or as alpha value: 0.05, 0.01, 0.001");
//  end

  // Contains the Student factor t-table
  // ===================================
  // Column 1 : Degree of freedom (f)
  // Column 2 : Student factor, confidence level: 95%, level of significance = 0.05
  // Column 3 : Student factor, confidence level: 99%, level of significance = 0.01
  // Column 4 : Student factor, confidence level: 99.9%, level of significance = 0.001
  ttable = [
    1.0, 12.71,  63.66, 636.62; ...
    2.0,  4.30,   9.92,  31.60; ...
    3.0,  3.18,   5.84,  12.92; ...
    4.0,  2.78,   4.60,   8.61; ...
    5.0,  2.57,   4.03,   6.86; ...
    6.0,  2.45,   3.71,   5.96; ...
    7.0,  2.37,   3.50,   5.41; ...
    8.0,  2.31,   3.36,   5.04; ...
    9.0,  2.26,   3.25,   4.78; ...
   10.0,  2.23,   3.17,   4.59; ...
   11.0,  2.20,   3.11,   4.44; ...
   12.0,  2.18,   3.06,   4.32; ...
   13.0,  2.16,   3.01,   4.22; ...
   14.0,  2.15,   2.98,   4.14; ...
   15.0,  2.13,   2.95,   4.07; ...
   16.0,  2.12,   2.92,   4.02; ...
   17.0,  2.11,   2.90,   3.96; ...
   18.0,  2.10,   2.88,   3.92; ...
   19.0,  2.09,   2.86,   3.88; ...
   20.0,  2.08,   2.85,   3.85; ...
   25.0,  2.060,  2.787,  3.725; ...
   30.0,  2.042,  2.750,  3.646; ...
   35.0,  2.030,  2.724,  3.592; ...
   40.0,  2.021,  2.704,  3.551; ...
   45.0,  2.014,  2.689,  3.521; ...
   50.0,  2.009,  2.678,  3.496; ...
  100.0,  1.984,  2.626,  3.390; ...
  200.0,  1.972,  2.601,  3.340; ...
  300.0,  1.969,  2.595,  3.328; ...
  400.0,  1.967,  2.590,  3.318; ...
  500.0,  1.965,  2.586,  3.310; ...
  600.0,  1.964,  2.585,  3.307; ...
  700.0,  1.963,  2.584,  3.304; ...
  800.0,  1.963,  2.583,  3.302; ...
  999.0,  1.960,  2.576,  3.291];
  
  // Degree of freedom (f)
  f = n - 1; 
  
  // Set the proper column of the t-table, depending on confidence level
  select p
    case("95%") then
      j = 2;
    case(0.05) then
      j = 2;
    case("99%") then
      j = 3;
    case(0.01) then
      j = 3;
    case("99.9%") then
      j = 4;
    case(0.001) then
      j = 4;
    else
      error('Second argument is the statistical confidence level and has to be a string, as 95%, 99% or 99.9% or as alpha value: 0.05, 0.01, 0.001');
  end
  
  // Pick the correct studentfactor out of the t-table and interpolate if necessary
  if (f >= 1 & f <= 20) then
    retval = ttable(f,j);
  elseif (f >= 21  & f <= 50) then
     i = 16 + floor(f/5); // Determine row, 16=correction factor
    qs = (ttable(i,j) - ttable(i+1,j))/5;
    mul = f - ttable(i,1); // Multiplicator for qs
    retval = ttable(i,j) - (mul * qs);
  elseif (f >= 51  & f <=100) then
    i = 25 + floor(f/50); // Determine row, 25=correction factor
    qs = (ttable(i,j) - ttable(i+1,j))/50;
    mul = f - ttable(i,1); // Multiplicator for qs
    retval = ttable(i,j) - (mul * qs);
  elseif (f >= 101 & f <=800) then
    i = 26 + floor(f/100); // Determine row, 26=correction factor
    qs = (ttable(i,j) - ttable(i+1,j))/100;
    mul = f - ttable(i,1); // Multiplicator for qs
    retval = ttable(i,j) - (mul * qs);
  elseif (f >=801 & f <= 998) then
    i = 30 + floor(f/200); // Determine row, 30=correction factor
    qs = (ttable(i,j) - ttable(i+1,j))/199;
    mul = f - ttable(i,1); // Multiplicator for qs
    retval = ttable(i,j) - (mul * qs);
  elseif (f == 999) then
    retval = ttable(35,j);
  else
    error("To many numbers of values. Must be less than 1000");
  end
  
endfunction
