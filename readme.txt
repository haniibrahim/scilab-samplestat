Description: Toolbox for statistics of normal distributed populations.
 
 This toolbox provides elemantary tests for evaluation of measuring data. It 
 calculates the range of dispersion of the values and the mean regarding a 
 given statistical confidence level.
 
 These functions are good to extend the built-in functions mean(), stdev(), 
 max(), min(), median().
 
 -------------------------------------------------------------------------------
 
 INSTALLATION:
 atomsInstall("/path/to/samplestat_x.x.x_x.x_bin.zip")
 
 -------------------------------------------------------------------------------
 
 The toolbox SampleSTAT provide the following functions (details refer example 
 below).
 
 MACROS:
 
   * ST_strayarea: 
     Calculates the stray area (range of dispersion of the values) 
     for a given vector and for a statistical confidence level (95%, 99%, 99.9%)
     and level of significance (0.5, 0.01, 0.001), resp.
   * ST_trustarea: 
     Calculates the trust area (range of dispersion of the mean) 
     for a given vector and for a statistical confidence level (95%, 99%, 99.9%)
     and level of significance (0.5, 0.01, 0.001), resp.
   * ST_studentfactor: 
     Determines the student factor for an amount of numbers and for a
     statistical confidence level (95%, 99%, 99.9%) and level of 
     significance (0.5, 0.01, 0.001), resp.- service function for 
     ST_staryarea and ST_trustarea
   * samplestat.dem.sce: 
     Demo for mean evaluation via "ST_strayarea()" and "ST_trustarea()"
  
 -------------------------------------------------------------------------------
   
 EXAMPLES:
 
   v = [9.999 9.998 10.002  10. 10.001  10.];
   stdev(v)
   => ans = 0.0014142
 
   ST_strayarea(v, "95%") // confidence level in percent OR
   ST_strayarea(v, 0.05)  // confidence level of significance
   => ans = 0.0036345
 
   ST_trustarea(v, "95%")
   ST_trustarea(v, 0.05)
   => ans = 0.0014838
   
   68 percent of the values will stray arount 10.000 +- 0.001 (S.D.). 95% of the 
   values will be expected around 10.000 +/- 0.004 (Range of disp. of the values,
   stray area). With a propability of 95% the mean of 10.000 will stray around 
   10.000 +/- 0.001 (Rage of dispersion of the mean, trust area).
 -------------------------------------------------------------------------------

 LITERATURE:
 
 Based on the German book R. Kaiser, G. Gottschalk; "Elementare Tests zur 
 Beurteilung von Meßdaten", BI Hochschultaschenbücher, Bd. 774, Mannheim 1972.
