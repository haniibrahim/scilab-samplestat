// Copyright (C) 2008 - INRIA
// Copyright (C) 2009-2011 - DIGITEO

// This file is released under the 3-clause BSD license. See COPYING-BSD.

mode(-1);
lines(0);

function main_builder()
    TOOLBOX_NAME  = "samplestat";
    TOOLBOX_TITLE = "SampleSTAT";
    toolbox_dir   = get_absolute_file_path("builder.sce");

    // Check Scilab's version
    // =============================================================================

    try
        v = getversion("scilab");
    catch
        error(gettext("Scilab 5.3 or more is required."));
    end

    if v(1) < 5 & v(2) < 3 then
        // new API in scilab 5.3
        error(gettext("Scilab 5.3 or more is required."));
    end

    // Check modules_manager module availability
    // =============================================================================

    if ~isdef("tbx_build_loader") then
        error(msprintf(gettext("%s module not installed."), "modules_manager"));
    end

    // Action
    // =============================================================================
    
    // Update help XML-files from sci-files but only with Scilab <6 because of 
    // Syntax/Calling Sequence problem w/ v5 and v6. Means, you have to compile
    // sampeSTAT w/ Scilab 5 first to produce the XML-help files even if you 
    // uss v6.
    // This workaround was made to keep compatibility to v5 w/ just one code 
    // base. If you use the downloaded src distribution od sampleSTAT the XML-
    // help-files are already provided. As long as you do not edit the macro
    // sci-files you can compile this distribution w/ v6 directly. 
    if v(1) < 6 then
        exec(fullfile(toolbox_dir,"/help/en_US/update_help.sce"),-1);
    end
    // ------------------------------------

    tbx_builder_macros(toolbox_dir);
 //   tbx_builder_src(toolbox_dir);
 //   tbx_builder_gateway(toolbox_dir);
 //   tbx_build_localization(toolbox_dir);
    tbx_builder_help(toolbox_dir);
    if v(1) == 5  then // For Scilab versions 5 and 6
        tbx_build_loader(TOOLBOX_NAME, toolbox_dir);
    else
        tbx_build_loader(toolbox_dir);
    end
    tbx_build_cleaner(toolbox_dir);

endfunction
// =============================================================================
main_builder();
clear main_builder; // remove main_builder on stack
// =============================================================================


