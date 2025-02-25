# 1. Introduction =============================================================
#' This is a simple script to extract data from rows 4 onward of the data-
#' containing sheets and export the sheets as a series of CSV files.

# 2. Set working directory to script location. Define file name and paths.====
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
print(getwd())  # Debugging step

library(openxlsx2)

# Edit the paths and file names as needed.
file_name <- "FDACS_UFGA8201_peanut.94.xlsx"
path_for_xlsx <- file.path("Test_data", file_name)
path_for_csv <- file.path("Test_data", "./CSV_files")
  
# 3. Load the target wb and obtain sheet names =================================
wb <- wb_load(path_for_xlsx)

#' Specify introductory sheet number to allow skipping
intro_sheets <- 3

sheet_names <- wb_get_sheet_names(wb)
total_sheets <- length(sheet_names)
first_data_sheet <- intro_sheets + 1
last_data_sheet <- total_sheets # Here we include the dictionary sheets

# Create output directory if it doesn't exist
if (!dir.exists(path_for_csv)) {
  dir.create(path_for_csv)
}

# 4. Loop through sheets and write to CSV ======================================
# Get sheet names
sheet_names <- wb$sheet_names

for (i in first_data_sheet: last_data_sheet) {
  sheet <- sheet_names[i]
  df <- wb_to_df(wb, sheet = sheet,  start_row = 1, skip_empty_rows = TRUE, 
                 skip_empty_cols = TRUE)  # Convert sheet to data frame
  df[is.na(df)] <- "" #openxlsx2 does not have na.strings argument. So, we'll have to do it manually.
  csv_file <- file.path(path_for_csv, sprintf("%02d. %s.csv", i, sheet)) # CSV file names include a two digit prefix
  write.csv(df, file = csv_file, row.names = FALSE)
}

# 5. End script with message giving location of the CSV files. =================
cat("CSV files saved in", path_for_csv, "\n")