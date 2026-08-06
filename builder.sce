// Copyright (C) 2008 - INRIA
// Copyright (C) 2009-2011 - DIGITEO

// This file is released under the 3-clause BSD license. See COPYING-BSD.

// Uncomment this line to make a debug version of the Toolbox
//setenv("DEBUG_SCILAB_DYNAMIC_LINK","YES")

function main_builder()
    TOOLBOX_NAME  = "samplestat";
    TOOLBOX_TITLE = "SampleSTAT";
    toolbox_dir   = get_absolute_file_path("builder.sce");

    // Check Scilab's version
    // =============================================================================
    try
        v = getversion("scilab");
    catch
        error(gettext("Scilab 5.5 or higher is required."));
    end

    if v(1) < 6 & v(2) < 1  then 
        error(gettext("Scilab 2024.0.0 or higher is required."));
    end

    // Check modules_manager module availability
    // =============================================================================

//    if ~isdef("tbx_build_loader") then
//        error(msprintf(gettext("%s module not installed."), "modules_manager"));
//    end

    // Action ----------------------------------------------------------------------

    // Update help XML-files from sci-files via Helptbx
    exec(fullfile(toolbox_dir,"/help/en_US/update_help.sce"),-1);
    
    // =============================================================================

    tbx_builder_macros(toolbox_dir);
    tbx_builder_help(toolbox_dir);
    tbx_build_loader(toolbox_dir);
    tbx_build_cleaner(toolbox_dir);
    
endfunction
// =============================================================================
main_builder();
clear main_builder; // remove main_builder on stack
// =============================================================================


