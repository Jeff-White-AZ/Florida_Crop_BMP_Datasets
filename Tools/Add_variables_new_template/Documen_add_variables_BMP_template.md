**Adding Variables to an Empty FDACS Template**

**Script:** FDACS_add_variables_to_template

**Date:** Aug. 9, 2024

**Introduction**

To prepare an FDACS BMP workbook for data entry, researchers will
normally start with the FDACS template and then add variables they
expect to report in their final dataset. Variables need to be defined,
including the required units, and if possible linked to equivalent
variables from the ICASA Master Variable List, accessible at
http://www.tinyurl.com/icasa-mvl.

To assist the initial workbook preparation, the R script
‘FDACS_add_variables_to_template‘ was created. The script reads a
user-prepared list of variables, copies them to the designated sheets in
a workbook, updates the workbook dictionary, and then saves the
workbook.

The new variables are defined in the workbook
‘FDACS_Observed_Crop_Variables_V0.94.xlsx’. Individual worksheets
currently are named by crops (e.g. ‘Carrots’, ‘Cotton’, or ‘Potato’).
Users can create new sheets with names aligned with their projects. Each
sheet contains nine variables:

- SheetName – The name of the sheet where the variable will be added.

- VariableName – The name of the variable to be added.

- Definition – The definition of the variable.

- Units – The units of measurement.

- Priority – Whether FDACS considers the variable to be required,
  preferred or optional.

- ICASA short name – The ICASA synonym using the short name.

- ICASA long name – The ICASA synonym using the long name.

- Equivalent – Whether the new variable is directly equivalent to an
  ICASA variable.

**Procedure for Adding Variables**

The full procedure for adding data is outlined in the steps below. We
assume that the user is familiar with basic operation of the R language,
use of RStudio, and understands how the FDACS BMP template is organized.

1.  Download the script ‘FDACS_add_variables_to_template’ to a folder of
    your choice.

2.  Create two new folders within the chosen folder, ‘/Data’ and
    ‘/Updated’.

3.  Copy the FDACS BMP template file to the ‘/Data’ folder.

4.  Copy the file ‘FDACS_Observed_Crop_Variables_V0.94.xlsx’ to the
    ‘/Data’ folder.

5.  Prepare the list of variables to be added to the crop variables
    workbook.

    1.  Open the workbook and either identify an appropriate crop
        worksheet or create a new sheet. If a new sheet is created, copy
        the eight column names from another sheet.

    2.  For reach variable to be added, identify which worksheet in the
        FDACS template should contain the variable. Copy the sheet name
        to the column ‘SheetName’ and enter the variable name in the
        adjacent column, ‘VariableName.’

    3.  Enter the definition, units and priority. If the project
        proposal states clearly that the variable will be measured, the
        priority should be ‘Req’ for “Required”.

    4.  Attempt to identify the equivalent ICASA short name and long
        name for the variable. If the definition and units make it clear
        that the variables are equivalent, enter “Y’ under ‘Equivalent’.

    5.  Repeat this process for all variables of interest.

    6.  Save the file.

6.  Open the R script ‘FDACS_add_variables_to_template’ in RStudio.

7.  If not done previously, install the package openxlsx2 from Tools -\>
    Install packages …

8.  Edit the variable ‘crop_name’ to contain the name of the worksheet
    in individual FDACS BMP datasets that will receive the new
    variables. This should be the only modification needed to the R
    script.

9.  Run the script from RStudio by entering ‘alt-ctrl-r’ or navigating
    through the menu bar to Code -\> Run Region -\> Run All.

10. The script should run, outputting a few lines of information to
    assist possible de-bugging. The last lines of output are from
    “housekeeping” to free memory and remove objects.

11. Navigate to the folder ‘/Updated’ and open workbook. This file will
    contain the modifications specified in ‘Variables_to_add.xlsx’.

12. Inspect the sheets where variables were expected to be added.

13. Verify that the dictionary sheets were updated as well.

This completes the process for inserting variables into an FDACS BMP
template.

**Troubleshooting**

One anticipated source of problems is in linking specific variables to
equivalent ICASA names. At the moment, the ICASA Master Variable List is
maintained as a Google Sheets file, so users will have to either browse
the sheets or use the search function to locate variables. The standards
include a small number of crop-specific variables but tends not to
include commodity specific harvest quality or crop health variables.
Users may suggest new variables via the FDACS BMP feedback link: ???

The most likely source of errors is mismatches among file names or the
variable ‘SheetNames’.
