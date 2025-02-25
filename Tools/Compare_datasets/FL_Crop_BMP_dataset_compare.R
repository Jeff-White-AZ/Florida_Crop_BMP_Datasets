# 1. Introduction ====================================================
#' Compares the content (not formatting) of two datasets that are organized by
#' three areas as in the Florida Crops BMP Template.
#' The most frequent use woudl be when questions about differences between file
#' versions arise.
#' The script performs a series of comparisons starting with worksheet names, 
#' then for each worksheet, the variable names and content.
#' The final comparison creates a list of sheets that have issues and provides 
#' instructions on how to use the diffObj() function to display differences in
#' RStudio. This last comparison considers three areas or zones in each sheet:
#' Row 1 - Used for instructions.
#' Rows 2 and 3 - Used for any suggested terms (row 2) and units of measure or 
#' cell format (row 3)
#' Rows 4 and onward - Usually contains the main block of data for that sheet.

# 2. Load libraries and specify file names and locations (paths). =============
library(openxlsx2) # For manipulating *.xlsx files
library(logr)      # For creating simple log files
library(diffobj)   # For the graphical display of comparisons

# Set working directory to script location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Configure logging. Results of tests will be exported to the file "Excel compare.log"
comparison_log_path <- file.path(getwd(), "Excel compare.log")
comparison_log <- log_open(comparison_log_path, logdir = FALSE)

# Input file names
file_path1 <- file.path("Test_data", "FDACS_UFGA8201_peanut.94.xlsx")
file_path2 <- file.path("Test_data", "FDACS_UFGA8201_peanut.94_new.xlsx")

# Checking whether the files exist
if (!file.exists(file_path1)) {
  log_print(paste("ERROR: First file not found -", file_path1))
  log_close()  # Ensure the log is closed before stopping execution
  stop("File not found. Halting execution.")
}
if (!file.exists(file_path2)) {
  log_print(paste("ERROR: Second file not found -", file_path2))
  log_close()  # Ensure the log is closed before stopping execution
  stop("File not found. Halting execution.")
}

# 3. Load the two workbooks and extract sheet names. =================
# Load workbooks
wb1 <- wb_load(file_path1)
wb2 <- wb_load(file_path2)

# Get sheet names
sheet_names1 <- wb_get_sheet_names(wb1, escape = FALSE)
sheet_names2 <- wb_get_sheet_names(wb2, escape = FALSE)

#' Start the comparisons.
# 4. Begin the comparisons with numbers of sheets and sheet names. =====
# Compare the number of sheets in each workbook.
log_print(paste("Sheets in ", file_path1))
log_print(sheet_names1)
log_print(paste("Sheets in ", file_path2))
log_print(sheet_names2)
if (length(sheet_names1) != length(sheet_names2)) {
  msg <- ifelse(length(sheet_names1) < length(sheet_names2),
                paste(file_path1, "has fewer sheets than \n", file_path2),
                paste(file_path1, "has more sheets than", file_path2))
  log_print(msg)
  log_close()
  stop(msg)  # Proper message with stop
} else {
  msg <- "Same number of sheets in both files."
  log_print(msg)
}

# Compare sheet names
if (!identical(sheet_names1, sheet_names2)) {
  msg <- "Sheet names differ between the two files. Processing halted."
  cat(msg)
  log_print(msg)
  log_close()
  stop(msg)
} else {
  msg <- "Sheet names are identical for the two files."
  cat(msg, "/n")
  log_print(msg)
}

# 5. Compare the sheet contents =========================================
# Create a function suggested by ChatGPT
compare_data_frames <- function(df1, df2) {
  #Ensure both data frames have content
  if (length(df1) == 0 & length(df2) == 0) {
    stop(paste0("Sheet ", test_sheet, " has no valid data.\n"))
      }
  
  # Ensure both data frames have the same structure
  if (!identical(dim(df1), dim(df2))) {
    stop("Data frames have different dimensions.")
  }
  
  # Check for missing or unequal column names
  if (anyNA(names(df1)) || anyNA(names(df2))) {
    stop("One or both data frames have missing column names (NA).")
  }
  if (!all(names(df1) == names(df2))) {
    stop("Data frames have different column names.")
  }
  
  # Use compare() to obtain a detailed report of differences
  compare(df1, df2, allowAll = TRUE)
  
}

# Initialize a list to track mismatched sheets
mismatched_sheets1 <- list()
mismatched_sheets2 <- list()
mismatched_sheets3 <- list()

# 5.1. Compare the sheet contents of cell A1 (Instructions) ==================

for (test_sheet in sheet_names1) {
    print(paste("Comparing first row of: ", test_sheet))
  df1 <- wb_to_df(file = wb1, sheet = test_sheet, rows=1, col_names = FALSE,
                  skip_empty_cols = TRUE)
  df1 <- df1[, !is.na(names(df1))]
  df2 <- wb_to_df(file = wb2, sheet = test_sheet, rows=1, col_names = FALSE,
                  skip_empty_cols = TRUE)
  df2 <- df2[, !is.na(names(df2))]
  if (length(df1) == 0 & length(df2) == 0) {
    msg <- paste0("Sheet ", test_sheet, " has no valid data.")
    cat(msg, "\n")
    log_print(msg)
   } else {
  print("Satisfied conditions, now comparing sheet content")
  # Compare data frames
  if (identical(df1, df2)) {
    msg <- "Worksheets are identical in first row."
    cat(msg, "\n")
  } else {
    print(paste("Worksheets differ in sheet:", test_sheet))
    mismatched_sheets1[[test_sheet]] <- list(df1 = df1, df2 = df2)
  }
   }
}

# 5.2. Compare the sheet contents in rows 2 and 3 (units and text notes) ===========
# sheet_names1 <- c("Z2. Dictionary Observations", "Z3. Dictionary Soils Weather")
# sheet_names2 <- sheet_names1
for (test_sheet in sheet_names1) {
  print(paste("Comparing rows 2 and 3 of: ", test_sheet))
  #df1 <- wb_to_df(file = wb1, sheet = test_sheet, dims='A2:Z3', col_names = FALSE)
  df1 <- wb_to_df(file = wb1, sheet = test_sheet, start_row = 2, rows=2, col_names = FALSE)
  #  df1 <- df1[, !is.na(names(df1))]
  #df2 <- wb_to_df(file = wb2, sheet = test_sheet, dims='A2:Z3', col_names = FALSE)
  df2 <- wb_to_df(file = wb2, sheet = test_sheet, start_row = 2, rows=2, col_names = FALSE)
  #  df2 <- df2[, !is.na(names(df2))]
  if (length(df1) == 0 & length(df2) == 0) {
    msg <- (paste0("Sheet ", test_sheet, " has no valid data."))
    cat(msg, "\n")
    log_print(msg) 
  } else {
    print("Satisfied conditions, now comparing sheet content")
    # Compare data frames
    if (identical(df1, df2)) {
      msg <- "Worksheets are identical in rows 2 and 3."
      cat(msg, "\n")
    } else {
      msg <- (paste("Worksheets differ for rows 2 and 3 in sheet:", test_sheet))
      cat(msg, "\n")
      log_print(msg)
      mismatched_sheets2[[test_sheet]] <- list(df1 = df1, df2 = df2)
    }
  }
}

#' Compare content of main data sheets
for (test_sheet in sheet_names1) {
  print(paste("Comparing main sheets of: ", test_sheet))
  df1 <- wb_to_df(file = wb1, sheet = test_sheet, start_row = 4)
  df1 <- df1[, !is.na(names(df1))]
  df2 <- wb_to_df(file = wb2, sheet = test_sheet, start_row = 4)
  df2 <- df2[, !is.na(names(df2))]
  if (length(df1) == 0 & length(df2) == 0) {
    cat(paste0("Sheet ", test_sheet, " has no valid data.\n"))
  } else {
    print(paste("Satisfied conditions, now comparing sheet content for: ", test_sheet))
    print(names(df1))
    # Compare data frames
    if (identical(df1, df2)) {
      cat("Worksheets are identical.\n")
    } else {
      cat(paste("Worksheets differ in sheet:", test_sheet))
      mismatched_sheets3[[test_sheet]] <- list(df1 = df1, df2 = df2)
    }
  }
}

#' After all loops, prompt to review any differences in the content of the 
#' sheets. As stated in the instructions, this requires running a single line of
#' code from the Rstudio console. The results will appear in a line-by-line 
#' comparison in the Viewer window.
area_options <- c("First row with instructions", "Rows 2 and 3 for suggested terms and units", "Row 4 and beyond for main data")
mismatch_lists <- c("mismatched_sheets1", "mismatched_sheets2", "mismatched_sheets3")

for (j in 1:3) {
  mismatch_name <- mismatch_lists[j]
  mismatch <- get(mismatch_name)  # Convert string to actual object
  
  if (length(mismatch) > 0) {
    # Determine area of worksheet based on suffix of 1, 2 or 3.
    area_index <- substr(mismatch_name, nchar(mismatch_name), nchar(mismatch_name))
    area_text <- area_options[area_index]
    cat(paste("Differences were found for the area:", j , "= ", area_options[j], "\nin the following sheets:\n"))
    cat(paste(names(mismatch), "\n")) }
  if (j == 3) {
    msg <- "To see a detailed comparison for individual sheets, use the console
    of RStudio to run the code given below. Enter each sheet name as given above
    twice, once for each workbook being compared. 
    diffObj(mismatched_sheetsN[['sheet_name']]$df1, mismatched_sheetsN[['sheet_name']]$df2)
    Where \'N\' indicates which of the three areas of the sheet has a mismatch. For example:
    diffObj(mismatched_sheets1[['Z2. Dictionary Observations']]$df1, mismatched_sheets1[['Z2. Dictionary Observations']]$df2)"
    cat(msg)
    log_print(msg)
  }
}

log_close()  # Close log file created with logr functions.
