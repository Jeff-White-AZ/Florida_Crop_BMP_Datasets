**Upload data to an Existing Crop BMP Datasets**

**Script:** Upload_data_FL_Crop_BMP_dataset

**Date:** Aug. 4, 2024

**Introduction**

Researchers may add data to an FDACS BMP workbook by filling cells
manually (typing), copying data from other sources using the clipboard
(“cut-and-paste”), or using software such as R to copy data. The first
two options should be easy for users to follow without further
instruction and will often prove sufficient. Adding data via other
software may seem too daunting but has advantages, especially when
dealing with large sets of data or when the update process will be
repeated several times during an experiment. Advantages of using
software include:

1.  For large amount of data on a repetitive basis, the effort to
    configure a script to update the sheets may justify the extra
    effort.

2.  The process of updating will automatically save the updated file in
    a separate location, allowing the user to check the contents
    carefully.

3.  ….

There are many scenarios for how data might be added to an FL Crop BMP
Workbook. We consider three example cases:

1.  A full year of daily weather data as a comma-separated variables
    (CSV) file.

2.  Fertilizer application records contained in a source workbook.

3.  Yield and summary data in a source workbook.

For each case, the script reads the data, organizes the data as needed,
and then writes the data to the target Crop BMP workbook. Key
differences in processing the examples concern whether the variables are
already listed in the worksheet, whether data are already present, and
if so, what identifiers are needed to allow merging the data.

The script is intended only to illustrate possible approaches for
uploading data using R and openxlsx2. The exact approach will depend on
the type of data that need to be uploaded. We assume that the user is
sufficiently familiar with the R language and use of RStudio to be able
to modify the script according to their specific needs or to develop new
scripts.

**Basic Procedure for Uploading Data: Three Examples**

The procedure for adding the three **example** sets of data are outlined
below:

1.  Download the script ‘Upload_data_FL_Crop_BMP_dataset’ to a folder of
    your choice.

2.  Create two new folders within the chosen folder, ‘/Data’ and
    ‘/Updated’.

3.  Copy the files to be updated to the ‘Data’ folder. Most often, this
    would just be a single BMP dataset that already is partially
    completed. For demonstration purposes, we use the dataset
    ‘FL_BMP_UFGA8201_peanut_partial.xlsx’.

4.  Copy the source data file, which may be CSV or XLSX format. For
    demonstration purposes, copy two files to the ‘Data’ folder:

    1.  ‘Gainesville_1982_updates.xlsx’

    2.  ‘Weather_Gainesville_1982.csv’

5.  Open the R script ‘Upload_data_FL_Crop_BMP_dataset’ in RStudio.

6.  If not already loaded, install the package openxlsx2 from Tools -\>
    Install packages …

7.  Edit the list ‘set_list’ to contain the name of the BMP dataset that
    will be receive additional data.

8.  Run the script from RStudio by entering ‘alt-ctrl-r’ or navigating
    through the menu bar to Code -\> Run Region -\> Run All.

9.  The script should run, outputting a few lines of information to
    assist possible de-bugging.

10. Navigate to the folder ‘/Updated’ and examine the workbook file to
    ensure that it was updated. The three target sheets were:

    1.  ‘W2. Daily Weather Data’

    2.  ‘O2. Yield Summary’

    3.  ‘E7. Fertilizer’

This completes the basic process for uploading data to Crop BMP
workbooks.

Currently, the script does not update the dictionary ‘Z2. Dictionary
Observations’. The corresponding variables can be added manually or
using the script for adding variables to a blank template.

**Adapting the Upload Script to Specific Needs**

Prior to attempting to modify the script for another workbook and data
source, the user is urged to review the R script, paying close attention
to the comments which explain key processing steps. Once the user
understands the basic approach used in the script, a new script can be
created taking into account factors including:

- Source and formatting of the digital data, including whether variables
  are already in appropriate units and identified using variables
  already in the FDACS template.

- How identifiers will be used to identify individual rows (records) and
  allow merging.

**Troubleshooting**

Since each user will likely have different needs for uploading data, it
is difficult to anticipate what sorts of problems will arise.
