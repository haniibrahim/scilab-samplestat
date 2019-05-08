cwd = get_absolute_file_path("update_help.sce");
mprintf("Working dir = %s\n",cwd);
//
// Generate the root help
mprintf("Updating root\n");
helpdir = fullfile(cwd);
funmat = [
  "ST_strayarea"
  "ST_studentfactor"
  "ST_trustarea"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "samplestat";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );
//
// Generate the distribution help
mprintf("Updating distribution\n");
helpdir = fullfile(cwd,"distribution");
funmat = [
  "ST_ivplot"
  "ST_shapirowilk"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "samplestat";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );
//
// Generate the outlier help
mprintf("Updating outlier\n");
helpdir = fullfile(cwd,"outlier");
funmat = [
  "ST_deandixon"
  "ST_nalimov"
  "ST_outlier"
  "ST_pearsonhartley"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "samplestat";
//
// Generate the tool help
mprintf("Updating outlier\n");
helpdir = fullfile(cwd,"tool");
funmat = [
  "ST_getpath"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "samplestat";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );

