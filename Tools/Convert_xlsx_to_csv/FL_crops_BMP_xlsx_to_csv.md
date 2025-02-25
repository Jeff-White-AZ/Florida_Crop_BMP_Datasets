**Converting a Florida Crops BMP Dataset from XLSX format to CSV**

**Script:** FL_Crops_BMP_xlsx_to_csv.R

**Date:** 2025-02-25

**Introduction**

Situations may arise where users are asked to provide their data in comma-separated variable (CSV) format. This might be for software that lacks compatibility with the xlsx format or for data repositories that require all data to be submited in CSV format. The script 'FL_Crops_BMP_xlsx_to_csv.R' takes a single Florida Crops BMP Dataset in the xlsx (workbook) format and converts it to a series of CSV-formatted files. The conversion processes only rows 4 and beyond since these should correspond to the portion of the sheets that contain variable names and associated data. 

**Procedure for Running the Script**

The procedure for using the script is outlined below. We assume
that the user is familiar with basic operation of the R language, use of
RStudio, and understands how Crop BMP datasets are organized.

1. Download the script ‘FL_Crops_BMP_xlsx_to_csv’ to a folder of your
   choice.

2. Copy the Crop BMP dataset file to the same folder or a subfolder such as 'Data'.

3. Open the R script ‘FL_Crops_BMP_xlsx_to_csv’ in RStudio.

4. If not done previously, install the openxlsx2 package.

5. In the script, edit the variable ‘file_name’ to contain the name
   of the Crop BMP dataset to be converted. Similarly, edit 'path_for_xlsx' as needed. These should be the only modification to the R script.

6. Optionally, edit the variable 'path_for_csv' and create the designated folder. If the specified path is not found, the script will create the path.

7. Run the script. The console will display the commands as executed and end with a message that the CSV files have been created.

8. Inspect the CSV files to ensure that they were extracted as expected. The file name includes a numeric prefix so that the files are listed in the same order as in the dataset.

**Troubleshooting**
The most likely problem to arise is incorrect specification of the Crop BMP dataset file name or the path for the CSV files. Errors or unexpected results also might arise if the workbook contains sheets where the variables are not listed on row 4.
