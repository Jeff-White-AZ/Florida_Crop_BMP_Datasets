# Introduction ------------------------------------------------------------

#' This script is used to prepare a crop BMP data entry template by adding a list
#' of user-specific variables that a project may plan to measure or report in their
#' dataset.
#' The lists of variables are entered into a CSV file that contains:
#' 1. The name of the sheet where the variables will appear (e.g., 'O3. ').
#' 2. The desired name for each variable to be added.
#' 3. The definition of each variable.
#' 4. The units	of measurement used in the dataset.
#' 5. The short name of the equivalent ICASA variable.
#' 6. The long name of the equivalent ICASA variable.
#' 7. Whether the variable is considered required or preferred for the 
#'    planned research.
#' 8. Whether the variable is directly equivalent (E) to an ICASA variable, 
#'    or differs in units (U) or was not found in the ICASA Data Dictionary (N).
#'    
#' The ICASA Data Dictionary may be downloaded from:
#' https://github.com/DSSAT/ICASA-Dictionary
#' 
#' Each CSV file corresponds to a single crop and currently may contain 
#' variables for three sheets in the BMP template.
#'   02. Summary Yield
#'   03. Crop Growth
#'   04. Crop Health
#' To create a project-specific Data Entry Template, the user needs to:
#'   1. Find a CSV file of crop variables that corresponds to
#'      for their crop of interest, or if not found, create a new file.
#'   2. Edit variables for the three sheets of observed data. Note that in many 
#'      cases, not all sheets are needed.
#'   3. Edit this R script at line 32 to specify the crop.
#'   4. Possibly, edit names of the template file if this has been changed.
#' Upon running the script, the user is given a moment to check that the crop
#' of interest is correctly named, and then the script creates the template
#' with the requested variables.


#==================================

# 1. Load libraries and set working directory ----------------------------

library(openxlsx2)  #Required for manipulating rows and columns of Excel



#' Sets the working directory to the folder where the script, the template  
#' and the variable list reside. The new file will also be created here.
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# 2. Define a function to test whether a specified file exists ------------

check_file_exists <- function(file_path, file_specific_message = NULL) {
  if (!file.exists(file_path)) {
    message <- if (!is.null(file_specific_message)) {
      paste("Error:", file_specific_message)
    } else {
      paste("Error: File not found -", file_path)
    }
    stop(message, call. = FALSE)
  } else {print(paste("Processing", file_path))}
}

# 3. Specify name of CSV file with information on variables ---------------

#'Specify the name of the CSV file containing variables, definitions, etc.
csv_crop_file <- "Tomato.csv"
csv_path <- file.path("Data", csv_crop_file)
csv_message <- "Error: CSV file not found. Check name and location."
check_file_exists(csv_path, csv_message)

#'Specify the name of the BMP template
template_xlsx <- "FL_Crop_BMP_template_1.00.xlsx"
template_path <- paste0("./Data/", template_xlsx)
template_message <- "Error: data template file not found. Check name and location."
check_file_exists(template_path, template_message)

target_wb <- wb_load(template_path)
sheet_list <- wb_get_sheet_names(target_wb)
data_sheets <- sheet_list[(4):(length(sheet_list) - 3)]  # Skips three intro sheets and three disctionary sheets

# 4. Read the CSV file containing the variables to be added ----
df_crop_vars <- read.csv(csv_path)
names(df_crop_vars) <- gsub("\\.", " ", names(df_crop_vars))

#' Rename VariableType to SheetNameto match names in dictionaries
names(df_crop_vars)[names(df_crop_vars) == "VariableType"] <- "SheetName"

#' Write the crop variable information into the template file.
#' This is done with a loop that specifies which sheets are to be updated.
#' The list of sheets could be expanded in the future to allow for more types of
#' data.

#' Create a list of the three dictionaries
dictionaries <- c('Z1. Dictionary Metadata', 'Z2. Dictionary Observations', 'Z3. Dictionary Soils Weather')

# 5. Function to add variable names to existing worksheets ====
add_variable_info <- function(target_wb, data_sheets, df_crop_vars) {
  
  for (i in seq_along(data_sheets)) {
    # Get the target sheet name
    target_template_sheet <- data_sheets[i]
    
    # Filter the data frame for the current sheet
    vars_to_add <- df_crop_vars[df_crop_vars$SheetName == target_template_sheet, ]
    
    # Skip if no variables are associated with the current sheet
    if (nrow(vars_to_add) == 0) {
      next
    }
    
    for (j in 1:nrow(vars_to_add)) {
      var_name <- vars_to_add$VariableName[j]
      
      # Read the existing fourth row
      existing_row <- wb_to_df(target_wb, sheet = target_template_sheet, rows = 4)
      
      # Determine the start column (last filled column + 1)
      if (ncol(existing_row) > 0) {
        column_to_add <- ncol(existing_row) + 1
      } else {
        column_to_add <- 1
      }
      
      # Write the variable name to the target sheet
      target_wb$add_data(x = var_name, 
                           sheet = target_template_sheet, 
                           start_row = 4, 
                           start_col = column_to_add, 
                           col_names = FALSE)
      # Write the units to the target sheet
      unit <- vars_to_add$Units[j]
      target_wb$add_data(x = unit, 
                           sheet = target_template_sheet, start_row = 3, 
                           start_col = column_to_add, 
                           col_names = FALSE)
      # Apply the bold/left aligned style to row 4
      target_dims <- wb_dims(rows = 4, cols = 1:column_to_add)
      target_wb <- wb_add_cell_style(target_wb, sheet = target_template_sheet, dims = target_dims, horizontal = "left")
      target_wb <- wb_add_font(target_wb, sheet = target_template_sheet, dims = target_dims, bold= TRUE)
      
      }
  }
}

# 6. Function to add variable name, definition, etc. to the dictionaries ----

insert_new_definitions <- function(target_wb, df_crop_vars, dictionaries) {
  # Loop through the rows
  for (j in 1:nrow(df_crop_vars)) {
    #' Read the three dictionaries on each loop so all modifications are captured.
    dictionary_meta <- wb_to_df(target_wb, sheet = dictionaries[1], start_row = 4,
                                skip_empty_rows = FALSE, skip_empty_cols = TRUE,)
    dictionary_obs  <- wb_to_df(target_wb, sheet = dictionaries[2], start_row = 4,
                                skip_empty_rows = FALSE, skip_empty_cols = TRUE,)
    dictionary_sw   <- wb_to_df(target_wb, sheet = dictionaries[3], start_row = 4, 
                                skip_empty_rows = FALSE, skip_empty_cols = TRUE,)
    
    # Determine which dictionary needs to be updated and identify as target dictionary
    test_name <- df_crop_vars$SheetName[ j]
    print(paste0("At start of loop through rows: ", j, ". Name to test: ",test_name))
    
    # Apply modifications to the selected data frame
    first_char <- substr(test_name, 1, 1)
    
    if (first_char %in% c("M", "E")) {
      df <- modify_dataframe(dictionary_meta, test_name, df_crop_vars, j)
      print("First char M E, Returned from modify_dataframe()")
      target_wb <- wb_add_data(wb = target_wb, x = df, 
                               sheet = dictionaries[1], start_row = 4, start_col = 1, 
                               col_names = TRUE)
    } else if (first_char == "O") {
      print("First char O")
      df <- modify_dataframe(dictionary_obs, test_name, df_crop_vars, j)
      print("First char O, Returned from modify_dataframe()")
      
      target_wb <- wb_add_data(wb = target_wb, x = df, 
                               sheet = dictionaries[2], start_row = 4, start_col = 1, 
                               col_names = TRUE)
      print("First char O, Returned from wb_add_data()")
      
    } else {
      df <- modify_dataframe(dictionary_sw, test_name, df_crop_vars, j)
      print("First char S W, Returned from modify_dataframe()")
      target_wb <- wb_add_data(wb = target_wb, x = df, 
                               sheet = dictionaries[3], start_row = 4, start_col = 1, 
                               col_names = TRUE)
    }
    
  }
  
  return(target_wb)
}

# 7. Function to modify the selected data frame ================================

modify_dataframe <- function(df, test_name, rows_to_insert, j) {
  print(paste("From modify_dataframe(), print rows_to_insert. Index j = ", j))
  print(rows_to_insert[ j, ])
  
  # Determine the last row number in the 'target_dictionary' for a given 'test_name'
  # Find indices where SheetName is equal to test_name
  print(paste("Name to match: ", test_name))
  matching_indices <- which(df$SheetName == as.character(test_name))
  print(paste("Matching indices:", matching_indices))
  # Get the last matching index
  last_index <- tail(matching_indices, n = 1)
  print(paste("Last index of matching dictionary sheet", last_index))
  
  # Split dictionary into two data frames
  print("Ready to split dictionary")
  dictionary_length <- nrow(df)
  print(paste("Dictionary rows: ", dictionary_length))
  print(names(df))
  
  #' Need to handle two cases. If last_index < dictionary_length, then break
  #' data frame into two sections, and add the new definition between the two
  #' sections. Otherwise, just add to the data frame
  #' Case for last_index < dictionary_length
  if (last_index < dictionary_length){
    target_dictionary_1 <- df[1:last_index, ]
    target_dictionary_2 <- df[(last_index + 1):dictionary_length, ]
    
    # Add in new variable as 'rows_to_insert'
    df <- rbind(target_dictionary_1, rows_to_insert[j, ])
    df <- rbind(df, target_dictionary_2)
  } else {
    df <- rbind(df, rows_to_insert[j, ])  
    }
      
  print ("Finished iteration of function")
  return(df)
}



# 8. Call the two functions to add the variables and update the dictionary ====
add_variable_info(target_wb, data_sheets, df_crop_vars)
print ("Completed call for add_variable().")
target_wb <- insert_new_definitions(target_wb, df_crop_vars, dictionaries)

# 9. Housekeeping before closing the file. ====================================
#' As housekeeping before closing the file, want to make "A1" as the focus 
#' (visible upper left) cell and A1 or A5 as the selected (active) cell.
#' 
for (i in 1:length(sheet_list)) {
  if (i <= 3) {   
    target_wb$worksheets[[i]]$freezePane <- "<selection activeCell=\"A1\" sqref=\"A1\"/>"
    target_wb$worksheets[[i]]$sheetViews <- "<sheetViews><sheetView tabSelected=\"i\" topLeftCell=\"A1\" workbookViewId=\"0\"/></sheetViews>"
  } else {
    target_wb$worksheets[[i]]$sheetViews <- "<sheetViews><sheetView tabSelected=\"i\" topLeftCell=\"A1\" workbookViewId=\"0\"/></sheetViews>"
  }
  target_wb$freeze_pane(sheet = i, first_active_row = 5, first_active_col = NULL) # Freezes rows 1 to 4
  }
  
#' The next two commands specify that the first sheet is seen when you open the 
#' modified workbook. Note the critical difference in numbering of sheets. 
#' 'set_selected' uses the normal convention of 1 to z, but 'set_bookview' works 
#' with Microsoft coding that starts with 0.
target_wb$set_selected(sheet = 1)  # Necessary to avoid multiple sheets being selected.
target_wb$set_bookview(active_tab = 0, first_sheet = 0)

#==========================================================
#' Save the new Excel workbook that is the new data entry template.
crop_name <- substr(csv_crop_file, 1, (nchar(csv_crop_file) - 4))
saved_file <- paste0("FL_Crop_BMP_dataset_", crop_name, ".xlsx")
saved_path <- file.path(saved_file)

target_wb$save(saved_path)
writeLines(c("Updated crop template is in source folder: ", saved_file))

#==========================================================
#' Generic R housekeeping
#rm(list = ls()) # removes all objects from the session
gc()     # garbage collection from memory. Produces summary of memory use.

# End of script.
