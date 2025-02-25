# 1. Introduction =============================================================
#' This script provides examples of uploading data to an existing crop BMP
#' dataset based on the BMP template.
#' We assume that this script resides in a root directory and that the original
#' workbook and the two file containing data to upload reside in the /Data
#' folder.
#' Three examples of uploading data are given:
#' 1. A complete set of daily weather data from a column-separated value 
#' (CSV) file. Loaded to "W2. Daily Weather Data".
#' 2. Summary data in an Excel file that need to be appended to existing data.
#'  Loaded to "O2. Yield Summary" 
#' 3. Fertilizer application data in an Excel file that need to be inserted into
#' existing records. Loaded to "E7. Fertilizer" 

#' The three cases are only examples of the approaches that might be required for
#' different types of data. For specific cases, the user will to 
#' change file and sheet names, data ranges,   data are sorted, etc.

#' The code uses "base R". No special libraries or syntax are used other than
#' the openxlsx2 library. Extensive comments are given, so people with limited 
#' familiarity with R can more easily understand the specific steps. 
  
# 2. Load libraries, set working directory and specify file to process ========

library(openxlsx2)  # Required for manipulating Excel spreadsheets

#' Sets the working directory to the folder where the script, the BMP dataset, and 
#' the data to be added reside.
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#'The name of the existing BMP workbook that will be updated:
file_to_update <- 'FL_BMP_UFGA8201_peanut_partial.xlsx'
update_source_path <- file.path("Test_data", "Data", file_to_update)

# 3. Load workbook and get list of sheets ======================================
wb_to_update <- wb_load(update_source_path)          # This creates a workbook object
data_start_position <- 4 # Flag to indicate which sheet is the first with actual data. 

#' Get and display the names of the sheets in the workbook to be updated
dataset_sheets <- wb_get_sheet_names(wb_to_update) 
print(dataset_sheets)

# 4. Case 1. A complete set of data for one sheet. =============================
#'  Data to be added are in a CSV file. 
#' Our example is daily weather data, contained in Weather_Gainesville_1982.csv. 
#' In this case, we assume that, the variables are correctly named, 
#' but that the station_identifier 'UFGA' needs to be added.
#' Load the CSV file
source_file <- 'Weather_Gainesville_1982.csv'
upload_path <-  file.path("Test_data", "Data", source_file)
weather_upload <- read.csv(upload_path)

#' Checking that the data are loaded as expected.
summary(weather_upload) 

#' Specifying the target sheet of the workbook being updated. In this case:
target_sheet <- "W2. Daily Weather Data"

#' Adding the value for 'weather station ID'
weather_upload$'Weather station ID' <- 'UFGA'  

#' Re-ordering the variables so 'Weather station ID', the seventh column, will 
#' appear first.
weather_upload <- weather_upload[ , c(7, 1:6)] 

#' Checking that the target_sheet appears in the file to be updated.
#' If not, halt execution.
if (!(target_sheet %in% dataset_sheets)) {
  stop(paste0(crop_name, " not found in list. Please check source file, ", source_file))
}

#' As the final step, add the data, starting at row 4 since in this case, 
#' we include the variable names.
wb_to_update$add_data(x = weather_upload, 
                     sheet = target_sheet, start_row = 4, start_col = 1, 
                     col_names = TRUE) 
#' The workbook still has to be saved to the folder "./Update", but we will 
#' only do this after making two more updates.

# 5. Case 2: Updating growth data for one sheet. Data from a workbook. =========
#' The workbook 'Gainesville_1982_updates.xlsx' is loaded below as 'wb_source'.

#' The name of the workbook containing data for updating for cases 2 and 3.
source_file <- 'Gainesville_1982_updates.xlsx'
upload_path <- file.path("Test_data", "Data", source_file)
wb_source <- wb_load(upload_path)     # This creates a workbook object for some of the data to be uploaded.

#' We first load the data already present in the workbook to update, sheet 
#' "O2. Yield Summary"
target_sheet <- "O2. Yield Summary"

old_growth_data <- wb_to_df(wb_to_update, sheet = target_sheet, colNames = TRUE,
                            start_row=4, na.strings = "",
                            skip_empty_rows = TRUE, skip_empty_cols = TRUE)

#' Read the additional data from the source of new data, 'wb_source'.
#' Note various options to control how the sheet is loaded. 
new_growth_data <- wb_to_df(wb_source, sheet = "Growth", colNames = TRUE,
                            start_row=1, 
                            skip_empty_rows = TRUE, skip_empty_cols = TRUE)

summary(old_growth_data)
summary(new_growth_data)

#' The dataframe 'new_growth_data' only contains the identifier variable 
#' 'Plot ID', so the two data frames are merged merge using "Plot ID'.
merged_growth <- merge(old_growth_data, new_growth_data, by='Plot ID', all = TRUE)

#' The names on the dataframe of merged data are out of order:
names(merged_growth)

#' So they are reordered using the column numbers.
merged_growth <- merged_growth[ , c(2:6, 1, 7:18)]

#' Finally, the merged growth data are added to the workbook.
wb_to_update$add_data(x = merged_growth, 
                      sheet = target_sheet, start_row = 4, start_col = 1, 
                      col_names = TRUE) 

#' The workbook still has to be saved to the folder "./Update", but we will 
#' only do this after making two more updates.

# 6. Case 3: Updating fertilizer applications from a workbook. =================
#' The workbook 'Gainesville_1982_updates.xlsx' was already loaded (see above)
#' as wb_source in Case 2.
#' We start by loading the data already in the workbook at sheet 
#' "E7. Fertilizer"
#' Specifying the target sheet of the workbook being updated. In this case,
target_sheet <- "E7. Fertilizer"

#' Loading the data already in target_sheet
old_fertilizer_data <- wb_to_df(wb_to_update, sheet = target_sheet, colNames = TRUE,
                            start_row=4, na.strings = "",
                            skip_empty_rows = TRUE, skip_empty_cols = TRUE)

#' Then we read the additional fertilizer data from the source workbook. The 
#' correct name can be found here.
wb_get_sheet_names(wb_source)

#' Loading the data from "Fertilizer_info" into a dataframe
new_fertilizer_data <- wb_to_df(wb_source, sheet = "Fertilizer_info", colNames = TRUE,
                            start_row=1, na.strings = "",
                            skip_empty_rows = TRUE, skip_empty_cols = TRUE)

#' The data lack three identifier variables, so we add them to new_fertilizer_data.
new_fertilizer_data$'Experiment ID' <- "UFGA8201"
new_fertilizer_data$Year            <- 1982
new_fertilizer_data$Site            <- "UFGA"

#' Checking the contents of the two data frames prior to merging.
summary(old_fertilizer_data)
summary(new_fertilizer_data)

#' Merging the two data frames
merged_fertilizer <- merge(old_fertilizer_data, new_fertilizer_data, all=TRUE)

#' The names on the data frame are out of order:
names(merged_fertilizer)

#' So they are reordered using the column numbers.
merged_fertilizer <- merged_fertilizer[ , c(1:6, 8:11, 7,13,14,12)]

#' The data rows are not in the desired order (by 'Fertilizer schedule' and Date),
#' so we use order() to re-order the dataframe.
merged_fertilizer <- merged_fertilizer[order(merged_fertilizer$'Fertilizer schedule',
                                             merged_fertilizer$Date), ]

# Finally, the merged fertilizer data are added to the workbook.
wb_to_update$add_data(x = merged_fertilizer, 
                      sheet = target_sheet, start_row = 4, start_col = 1, 
                      col_names = TRUE, na.strings = "") 

# 7. Apply formatting to sheets ================================================
#' Applying the numeric style to the columns that should have numeric data.
wb_to_update$add_numfmt(target_sheet, "D5:K100", numfmt = 1)

#' Applying a cell style to make all identifiers centered in their cells. 
wb_to_update$add_cell_style(dims = "A2:K4",
                  horizontal = "center",
                  vertical = "center")

#' Applying a cell style to align all data to the right within their cells. 
wb_to_update$add_cell_style(dims = "G5:M100",
                            horizontal = "right",
                            vertical = "center")

#' As a final housekeeping step before saving the updated workbook, we want to 
#' make "A1" as the focus (visible upper left) cell and A1 or A5 as the selected 
#' (active) cell.
#' 
for (i in 1:length(dataset_sheets)) {
  if (i < data_start_position) {
    wb_to_update$worksheets[[i]]$freezePane <- "<selection activeCell=\"A1\" sqref=\"A1\"/>"
    wb_to_update$worksheets[[i]]$sheetViews <- "<sheetViews><sheetView tabSelected=\"i\" topLeftCell=\"A1\" workbookViewId=\"0\"/></sheetViews>"
  } else {
    wb_to_update$worksheets[[i]]$sheetViews <- "<sheetViews><sheetView tabSelected=\"i\" topLeftCell=\"A1\" workbookViewId=\"0\"/></sheetViews>"
  }
  wb_to_update$freeze_pane(sheet = i, first_active_row = 5, first_active_col = NULL) # Freezes rows 1 to 4
}
  
#' The next two commands specify that the first sheet is seen when you open the 
#' modified workbook. Note the strange but critical difference in numbering of sheets. 
#' The function 'set_selected' uses the normal convention of 1 to z, 
#' but 'set_bookview' uses Microsoft coding which starts with 0.
wb_to_update$set_selected(sheet = 1)  # Necessary to avoid multiple sheets being selected.
wb_to_update$set_bookview(active_tab = 0, first_sheet = 0) # Actually sets the active sheet

# 8. Create the filename for the updated workbook and save =====================
#' Creating the file name for the updated Excel workbook by appending "UPDATED".
filename_prefix <- substr(file_to_update,1, nchar(file_to_update) - 5)
updated_file <- paste0(filename_prefix, "_UD.xlsx")
update_path <- file.path("Test_data", "Updated", updated_file)
wb_to_update$save(update_path)

#' End of processing. Check folder for the newly created crop template file:
writeLines(c("Completed file should appear in folder './Updated' as: ", updated_file))

#' Generic R housekeeping
rm(merged_fertilizer, merged_growth, new_fertilizer_data, new_growth_data,
   old_fertilizer_data, old_growth_data, 
   wb_source, wb_to_update, weather_upload,
   data_start_position, dataset_sheets, file_to_update, filename_prefix,
   i, source_file, target_sheet, update_path, update_source_path,
   updated_file, upload_path)
gc()

#' End of script