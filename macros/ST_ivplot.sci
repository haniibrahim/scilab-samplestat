// Copyright (C) 2026 Hani Andreas Ibrahim
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

function ST_ivplot(data, names, marker, offset, tolerance)
    // Individual value plot for one or more data sets.
    //
    //
    // Syntax
    //   ST_ivplot(data)
    //   ST_ivplot(data, names)
    //   ST_ivplot(data, names, marker)
    //   ST_ivplot(data, names, marker, offset)
    //   ST_ivplot(data, names, marker, offset, tolerance)
    //
    // Parameters
    //   data:   numeric vector, list of numeric vectors or
    //           numeric matrix which each column represents one data set
    //   names:  Labels of the data sets as a string vector.
    //   marker: Scilab marker, for example ".", "o", "x", "+", "*", "s", or "d".
    //   offset: Horizontal distance between identical values.
    //           Recommended range 0.02 to 0.12. Default 0.02.
    //   tolerance: Two values are considered equal if their difference is less 
    //           than or equal to tolerance.
    //           Default 0, meaning only exactly identical values.
    //
    // Description
    // Individual value plots (IVP) are well suited for evaluating and comparing 
    // distributions of sample data. A IVP displays a point for the actual value 
    // of each observation in a group, making it easy to identify outliers and 
    // see the dispersion of the distribution. A IVP is especially recommended 
    // for small sample sizes in comparison to histograms, box-plots and 
    // QQ-plots, which need at least 20 values to be significant.
    // <itemizedlist>
    //   <listitem>Displays multiple data sets side by side</listitem>
    //   <listitem>Displays identical values side by side using a symmetric offset</listitem>
    //   <listitem>Supports different sample sizes</listitem>
    //   <listitem>Accepts input data as a list or matrix</listitem>
    //   <listitem>Optionally detects practically identical values using a tolerance</listitem>
    // </itemizedlist>
    //
    // Therefore IVPs are well suited to test very small sample sizes on normal 
    // distribution when outliers or ties could be present and the 
    // Shapiro-Wilk distribution test cannot be reliably applied.
    //
    // Examples
    // // Single data record
    // data = [9.999 9.998 10.002 10.000 10.001 10.000];
    // scf();
    // clf();
    // ST_ivplot(data, "Charge A");
    // ylabel("Sample");
    // title("Individual-Value-Plot from single data record");
    // 
    // // Multi data records in a list & different sample sizes
    // data1 = [9.999 9.998 10.002 10.000 10.001 10.000 10. 10. 10. 10. 10. 10. ];
    // data2 = [10.003 10.001 10.001 10.004 9.997];
    // data3 = [9.995 10.000 10.000 10.000 10.002 10.004 10.006];
    // scf();
    // clf();
    // ST_ivplot( ..
    //    list(data1, data2, data3), ..
    //    ["Lot A", "Lot B", "Lot C"], ..
    //    "d");
    // ylabel("Concentration [mg/L]");
    // title("Multi data records in a list & different sample sizes"]);
    // 
    // //  Multi data record in a matrix
    // data4 = [
    //    10.1  10.4  10.0;
    //    10.2  10.3  10.1;
    //    10.2  10.5  10.1;
    //    10.4  10.4  10.2;
    //    10.3  10.6  10.3
    // ];
    // scf();
    // clf();
    // ST_ivplot(data4, ["1", "2", "3"], ".", 0.04);
    // ylabel("Samples");
    // title("Multi data record in a matrix")
    // 
    // // Tolerance limit specified for nearly identical values
    // // tolerance=0.000001
    // data5 = [
    //    10.0000000
    //    10.0000001
    //     9.9999999
    //    10.1000000
    // ];
    // scf();
    // clf();
    // ST_ivplot(data5, "Sample", "o", 0.02, 0.000001);
    // title("Tolerance limit specified for nearly identical values")
    //
    // See also
    //  ST_shapirowilk
    //  ST_pearsonhartley
    //  ST_nalimov
    //  ST_grubbs
    //  ST_esd
    //  ST_deandixon
    //  ST_outlier
    //  ST_strayarea
    //  ST_trustarea
    
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    //
    
    // -------------------------------------------------------------------------
    // Number of input arguments
    // -------------------------------------------------------------------------
    [lhs, rhs] = argn();

    if rhs < 1 | rhs > 5 then
        error(msprintf( ..
        "ST_ivplot: Es werden 1 bis 5 Eingabeargumente erwartet."));
    end

    // -------------------------------------------------------------------------
    // Default values
    // -------------------------------------------------------------------------
    if rhs < 3 then
        marker = "o";
    end

    if rhs < 4 then
        offset = 0.02;
    end

    if rhs < 5 then
        tolerance = 0;
    end

    // -------------------------------------------------------------------------
    // Convert input data into a list of column vectors
    // -------------------------------------------------------------------------
    datasets = list();

    select type(data)

        // Numeric matrix or numeric vector
    case 1 then

        if size(data, "*") == 0 then
            error("ST_ivplot: Data record is empty.");
        end

        [nr, nc] = size(data);

        // Row or column vector
        if nr == 1 | nc == 1 then
            datasets(1) = matrix(data, -1, 1);

            // Matrix: treat each column as a separate data set
        else
            for columnIndex = 1:nc
                datasets(columnIndex) = data(:, columnIndex);
            end
        end

        // List
    case 15 then

        if length(data) == 0 then
            error("ST_ivplot: The list passed in is empty.");
        end

        for datasetIndex = 1:length(data)

            currentData = data(datasetIndex);

            if type(currentData) <> 1 then
                error(msprintf( ..
                "ST_ivplot: Data record %d is not numeric.", ..
                datasetIndex));
            end

            if size(currentData, "*") == 0 then
                error(msprintf( ..
                "ST_ivplot: Data record %d is empty.", ..
                datasetIndex));
            end

            if ~isvector(currentData) then
                error(msprintf( ..
                "ST_ivplot: Data record %d is not a vector.", ..
                datasetIndex));
            end

            datasets(datasetIndex) = matrix(currentData, -1, 1);
        end

    else
        error(["ST_ivplot: data must be a numeric vector, " + ..
        " a numeric matrix or a list."]);
    end

    numberOfDatasets = length(datasets);

    // -------------------------------------------------------------------------
    // Validate or generate data set names
    // -------------------------------------------------------------------------
    if rhs < 2 then
        names = emptystr(numberOfDatasets, 1);

        for datasetIndex = 1:numberOfDatasets
            names(datasetIndex) = msprintf("Dataset %d", datasetIndex);
        end
    else
        if type(names) <> 10 then
            error("ST_ivplot: names must be a vector of strings.");
        end

        names = matrix(names, -1, 1);

        if size(names, "*") <> numberOfDatasets then
            error(msprintf( ..
            "ST_ivplot: %d records were specified, but %d names were provided.", ..
            numberOfDatasets, size(names, "*")));
        end
    end

    // -------------------------------------------------------------------------
    // Validate marker
    // -------------------------------------------------------------------------
    if type(marker) <> 10 | size(marker, "*") <> 1 then
        error("ST_ivplot: marker must be a single string.");
    end

    validMarkers = [".", "o", "x", "*", "+", "s", "d"];

    if and(marker <> validMarkers) then
        error("ST_ivplot: Invalid marker. The following are allowed: ""."", ""o"", ""x"", ""*"", ""+"", ""s"" und ""d"".");
    end

    // -------------------------------------------------------------------------
    // Validate offset and tolerance
    // -------------------------------------------------------------------------
    if type(offset) <> 1 | size(offset, "*") <> 1 then
        error("ST_ivplot: offset must be a numeric scalar.");
    end

    if offset < 0 then
        error("ST_ivplot: offset must not be negative.");
    end

    if type(tolerance) <> 1 | size(tolerance, "*") <> 1 then
        error("ST_ivplot: tolerance must be a numerical scalar.");
    end

    if tolerance < 0 then
        error("ST_ivplot: tolerance must not be negative.");
    end

    // -------------------------------------------------------------------------
    // Create combined plotting vectors
    // -------------------------------------------------------------------------
    plotX = [];
    plotY = [];

    numberOfValidValues = zeros(numberOfDatasets, 1);

    for datasetIndex = 1:numberOfDatasets

        values = matrix(datasets(datasetIndex), -1, 1);

        // Remove NaN values
        validIndices = find(~isnan(values));

        if validIndices == [] then
            warning(msprintf( ..
            "ST_ivplot: Data record %d contains no valid values.", ..
            datasetIndex));

            numberOfValidValues(datasetIndex) = 0;
            continue;
        end

        values = values(validIndices);
        numberOfValidValues(datasetIndex) = length(values);

        // Sort in ascending order
        sortedValues = gsort(values, "g", "i");

        currentIndex = 1;
        numberOfValues = length(sortedValues);

        // ---------------------------------------------------------------------
        // Identify groups of identical or practically identical values
        // ---------------------------------------------------------------------
        while currentIndex <= numberOfValues

            groupStart = currentIndex;
            referenceValue = sortedValues(groupStart);

            groupEnd = groupStart;

            while groupEnd < numberOfValues

                nextValue = sortedValues(groupEnd + 1);

                if abs(nextValue - referenceValue) <= tolerance then
                    groupEnd = groupEnd + 1;
                else
                    break;
                end
            end

            groupSize = groupEnd - groupStart + 1;

            // Symmetric relative positions:
            //
            // n = 1:  0
            // n = 2: -0.5,  0.5
            // n = 3: -1,    0,    1
            // n = 4: -1.5, -0.5,  0.5, 1.5

//            // No nesting of closely related values
//            relativePositions = ..
//                ((1:groupSize) - (groupSize + 1) / 2) * offset;

            // Symmetric positions for identical values
            relativePositions = (1:groupSize) - (groupSize + 1) / 2;

            // Distance in x-axis units
            relativePositions = relativePositions * offset;

            // Limit the maximum total width of a group
            maxGroupWidth = 0.18;

            if groupSize > 1 then
                currentWidth = max(relativePositions) - min(relativePositions);

                if currentWidth > maxGroupWidth then
                    relativePositions = relativePositions * ..
                    (maxGroupWidth / currentWidth);
                end
            end

            //           // ------------------------------------------------------

            groupX = datasetIndex + relativePositions;
            groupY = sortedValues(groupStart:groupEnd)';

            plotX = [plotX, groupX];
            plotY = [plotY, groupY];

            currentIndex = groupEnd + 1;
        end
    end

    if plotY == [] then
        error("ST_ivplot: There are no valid measurement values available.");
    end

    // -------------------------------------------------------------------------
    // Plot data
    // -------------------------------------------------------------------------
    plot(plotX, plotY, marker);

    plotHandle = gce();

    // Depending on the Scilab version, gce() returns either a Polyline directly
    // or a Compound structure. Therefore, both cases are handled.
    if plotHandle.type == "Polyline" then
        plotHandle.line_mode = "off";
        plotHandle.mark_mode = "on";
    elseif plotHandle.type == "Compound" then
        for childIndex = 1:length(plotHandle.children)
            if plotHandle.children(childIndex).type == "Polyline" then
                plotHandle.children(childIndex).line_mode = "off";
                plotHandle.children(childIndex).mark_mode = "on";
            end
        end
    end

    // -------------------------------------------------------------------------
    // Format axes
    // -------------------------------------------------------------------------
    axesHandle = gca();

    axesHandle.box = "on";
    axesHandle.axes_visible = ["on", "on", "on"];
    //    axesHandle.auto_ticks(1) = "off";
    //
    //    axesHandle.x_ticks.locations = (1:numberOfDatasets)';
    //    axesHandle.x_ticks.labels = names;

    axesHandle.auto_ticks(1) = "off";

    // Explicitly create column vectors
    tickLocations = matrix(1:numberOfDatasets, numberOfDatasets, 1);
    tickLabels    = matrix(names, numberOfDatasets, 1);

    // Assign tick positions and labels together
    axesHandle.x_ticks = tlist( ..
    ["ticks", "locations", "labels"], ..
    tickLocations, ..
    tickLabels);

    // Add some space on the left and right
    currentBounds = axesHandle.data_bounds;
    currentBounds(1, 1) = 0.5;
    currentBounds(2, 1) = numberOfDatasets + 0.5;
    axesHandle.data_bounds = currentBounds;

    axesHandle.sub_ticks(1) = 0;

endfunction
