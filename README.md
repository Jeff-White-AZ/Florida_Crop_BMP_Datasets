# Florida Crop BMP Datasets
## Introduction
In managing data from agricutural research, a recurring problem is how to organize the data in a manner that describes experiment treatments, the environment and any measurements in a structured manner without requiring full development of a formal database. To support research on best management practices for crops in Forida, we have developed an spreadsheet-based template that is designed to help researchers easily document their work. Most researchers will expect to use project- or crop-specific terminology, but for subsequent analyses, a more widely used terminology is often needed. To this end, the template is organized around the ICASA data standards, and the data dictionary allows dataset-specific terms to be matched with equivalent ICASA terms.

This web site contains the blank template, example datasets, and several tools written in R to facilitate data management. The empty template is found in the main folder. Example datasets are provided in the folder Example_datasets. Various tools are provided under the Tools folder. Each tool is accompanied by a document to explain it use. Basic familiarity with R and RStudio are assumed. The current tools are:
- Add_variables_new_template: Allows users to populate a blank template with variables listed in a crop- or research-specific CSV file. The CSV includes which sheet should recieve each variable, definitions, units of measurement and ICASA equivalents. the The sub-folder Crop_specific_variable_lists contains example CSV files for many crops
- Data_uploading_script: Provides three examples of how data can be uploaded to a template.
- Quality_assurance: Reviews a dataset for four broad categories of quality and exports the review as a PDF report.
- Dataset_comparison: Allows two datasets to be compared in order to detect differences in versions. The checks start with simle checks for number and names of worksheets and then compares content of each sheet.
## Basic Template Features

## Dataset Tools
## References
Porter, C.H., Villalobos, C., Holzworth, D., Nelson, R., White, J.W., Athanasiadis, I.N., Janssen, S., Ripoche, D., Cufi, J., Raes, D., Zhang, M., Knapen, R., Sahajpal, R., Boote, K., Jones, J.W., 2014. Harmonization and translation of crop modeling data to ensure interoperability. Environmental Modelling & Software 62, 495–508. https://doi.org/10.1016/j.envsoft.2014.09.004
White, J.W., Hunt, L.A., Boote, K.J., Jones, J.W., Koo, J., Kim, S., Porter, C.H., Wilkens, P.W., Hoogenboom, G., 2013. Integrated description of agricultural field experiments and production: The ICASA Version 2.0 data standards. Computers and Electronics in Agriculture 96, 1–12. https://doi.org/10.1016/j.compag.2013.04.003
