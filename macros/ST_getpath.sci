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

function path = ST_getpath()
// Returns the path to the current module.
//
// Calling Sequence
//   path = ST_getpath()
//
// Parameters
// path : a 1-by-1 matrix of strings, the path to the current module.
//
// Examples
// path = ST_getpath()
//
// Authors
//  Hani A. Ibrahim - hani.ibrahim@gmx.de
// 

[lhs, rhs] = argn()
apifun_checkrhs("ST_getpath", rhs, 0)
apifun_checklhs("ST_getpath", lhs, 1)

path=get_function_path("ST_getpath");
path=fullpath(fullfile(fileparts(path),".."));

endfunction
