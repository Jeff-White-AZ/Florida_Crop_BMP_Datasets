# Florida Crop BMP Datasets

## Introduction

In managing data from agricutural research, a recurring problem is how to organize the data in a manner that describes experiment treatments, the environment and any measurements in a structured manner without requiring development of a formal database. To support research on best management practices (BMPs) for crops in Forida, we developed an spreadsheet-based template that allows researchers to easily document their work in a way that allows easy use with other software tools and ensures that the experiment is documented to an extent that satisifes criteria for reproducibility. Furthermore, while most researchers will expect to use project- or crop-specific terminology, subsequent analyses may require a more widely used set of terms. To this end, the template is organized around the ICASA data standards (Hunt et al., 2001; White et al., 2013; Porter et al., 2014), and the dictionary within the spreadsheet allows dataset-specific terms to be matched with equivalent ICASA terms. The ICASA Data Dictionary is accessible at [the DSSAT github respository)[https://github.com/DSSAT/ICASA-Dictionary].

This web site contains the blank template (FL_Crops_BMP_Template.xlsx), example datasets, and several tools written in R to facilitate data management. The empty template is found in the main folder. Example datasets are provided in the folder Example_datasets. Various tools are provided under the Tools folder. Each tool is accompanied by a document to explain its use. Basic familiarity with R and RStudio are assumed. The current tools are:

- Add_variables_new_template: Allows users to populate a blank template with variables listed in a crop- or research-specific CSV file. The CSV includes columns indicating which template worksheet should recieve each variable, definitions, units of measurement and ICASA equivalents. The sub-folder Crop_specific_variable_lists contains example CSV files for many crops.

- Compare_datasets: Allows two datasets to be compared in order to detect differences in versions or other issues. The checks start with simple checks for number and names of worksheets and then compares content of each sheet.

- Convert_xlsx_to_csv: Extracts data from each sheet of a dataset and exports as individual .csv files. This allows using data with any software tools that cannot access spreadsheets.

- Data_uploading_script: Provides three examples of how data can be uploaded to a partially completed dataset.

- Quality_assurance_control: Analyses a dataset according to what we term "the four C's of dataset. Datasets should be Correct, Complete, Coherent, and Compatible. The results are provided as text-based report in PDF that inlcudes a map of locations, time-line plots, and box-plots.

For further introduction to the template and associated scripts, four videos are available at the FDACS BMP research site: [Florida Department of Agriculture &amp; Consumer Services](https://www.fdacs.gov/Water/Agricultural-Water-Field-Services/Agricultural-Best-Management-Practices/BMP-Research)

## Basic Template Features

Folders within the template workbook are organized in blocks coded by tab colors as follows:

- Introduction and Instructions: Three sheets that introduce the content and provide guidance on how to fill the sheets with data. The sheet 'List of sheets and keys' includes links that allow users to jump to specific sheets.

- Metadata: Provides basic information about the dataset including experiment names, researchers, insitutions, experimental designs, experiment type, and sites.

- Management: Describes treatments, plot layouts, and management practices for each treatment. Management includes plantings, irrigations, fertilization practices, tillage, use of agrochemicals, mulches, manure applications, and harvests. Details vary for each type of management, but events are usually characterized by a level indicator (to link information to treatments), dates, what was applied, amounts of materials applied, and method of application.

- Measurements (Observations) - Allows reporting measurements on crops, soil or water. For crops, data may be of summary types such as flowering date or economic yield, or data can represent time series for growth, canopy reflectance, or other traits.

- Soils: Describes basic properties of the soil profile, including both surface features and properties measured by soil layers.

- Weather: Decribes sources of daily weather data and report daily values for variables such as solar radiation, maximum and minimum temperature, and precipitation.

- Dictionary: Contains names of all variables with the associated location (sheet), definition, unit of measurement, and equivalent ICASA terms.

## Dataset Tools

  To assist users in populating templates and managing datasets as they are being completed, a series of scripts written for R are available. Each tool is in a separate folder that contains the script, a document explaining how to use the script, and any additional sub-folders and files that the script may require. To run most scripts, the user mainly has to save the script to a desired location and then edit the script to provide the name of the spreadsheet file and the path. We assume users have a basic understanding of programming with R within the RStudio environment. The scripts are written using base R as far as possible.
  New tools are developed as the need arises. We welcome suggestions for new tools or how to make the tools more user friendly.

## References

* Hunt, L.A., White, J.W., Hoogenboom, G., 2001. Agronomic data: advances in documentation and protocols for exchange and use. Agricultural Systems 70, 477–492. https://doi.org/10.1016/S0308-521X(01)00056-7

* Porter, C.H., Villalobos, C., Holzworth, D., Nelson, R., White, J.W., Athanasiadis, I.N., Janssen, S., Ripoche, D., Cufi, J., Raes, D., Zhang, M., Knapen, R., Sahajpal, R., Boote, K., Jones, J.W., 2014. Harmonization and translation of crop modeling data to ensure interoperability. Environmental Modelling & Software 62, 495–508. https://doi.org/10.1016/j.envsoft.2014.09.004

* White, J.W., Hunt, L.A., Boote, K.J., Jones, J.W., Koo, J., Kim, S., Porter, C.H., Wilkens, P.W., Hoogenboom, G., 2013. Integrated description of agricultural field experiments and production: The ICASA Version 2.0 data standards. Computers and Electronics in Agriculture 96, 1–12. https://doi.org/10.1016/j.compag.2013.04.003
