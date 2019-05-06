dat1=[ .. 
94.8 97.6 98.2 98.4	99.2 99.4 99.8 94.8	97.7 98.2 98.5 99.2 99.4 100 95.1 97.8 .. 
98.2 98.6 99.2 99.5 100.1 97 97.8 98.3 98.7 99.3 99.5 100.2 97 97.9 98.4 98.9 ..
99.3 99.5 100.3 97.1 97.9 98.4 99.2 99.4 99.6 100.3 97.3 98.2 98.4 99.2 99.4 ..
99.7 100.5 ..
]

// Check for sample size
disp("Check for sample size: " + string(length(dat1)))

//Check for skewness & normal distribution
histplot(20,dat1,style=2);
disp("Check for skewness: " + string(ST_skewness(dat1)))
disp("Values are normal distributed according histogram but negative skewed " + ..
     "(left-skewed")
halt("\nPress a key\n");

disp("Because of sample size and skewness just the following outlier tests are " + ..
     "applicable: ST_outlier with iqr-modes only, ST_pearsonhartley, ST_nalimov. " + ..
     "We choose the basic rule outlier test based on 1.5xIQR => ST_outlier(A,""iqr"")")

[of,o]=ST_outlier(dat1,"iqr15");

disp("The data have the following outliers:")
disp(o)
     


