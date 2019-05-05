//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("samplestat.dem.gateway.sce");

    subdemolist = [
	"Range of dispersion (stray/trustarea)", "samplestat.dem.sce"; ..
	];

    subdemolist(:,2) = demopath + subdemolist(:,2);

endfunction

subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
