# ===============================
# Air Pollution Data Analysis Script with Dual Y-Axes
# (SHORTENED VERSION: removed 'if' checks for installed packages)
# ===============================

# -------------------------------
# 1. Load Necessary Libraries
# -------------------------------
library(ggplot2)
library(reshape2)
library(lubridate)
library(dplyr)
library(writexl)
library(corrplot)  # Needed for correlation plots

# -------------------------------
# 2. Define the File Path and Read CSV
# -------------------------------
file_path <- "D:/TONY/SECOND ASSIGNMENT/data_aeturnum_2024Q1/air_pollution.csv"
if (!file.exists(file_path)) {
  stop(paste("The file", file_path, "does not exist. Please check the file path."))
}
air_data <- read.csv(file_path, stringsAsFactors = FALSE)

print("First few rows of the dataset:")
print(head(air_data))

# -------------------------------
# 3. Rename 'Date...Time' to 'DateTime_Str'
# -------------------------------
date_time_col_original <- "Date...Time"
date_time_col_new <- "DateTime_Str"

if (date_time_col_original %in% names(air_data)) {
  colnames(air_data)[which(names(air_data) == date_time_col_original)] <- date_time_col_new
  print(paste("Renamed column", date_time_col_original, "to", date_time_col_new))
} else {
  stop(paste("Column", date_time_col_original, "not found in the dataset. Please check the column name."))
}

print("First few entries of the DateTime_Str column:")
print(head(air_data$DateTime_Str))

# -------------------------------
# 4. Parse 'DateTime_Str' into POSIXct DateTime Object
# -------------------------------
air_data$DateTime <- ymd_hms(air_data$DateTime_Str)
# air_data$DateTime <- ymd_hm(air_data$DateTime_Str)  # Uncomment if needed

# Verify parsing
num_na <- sum(is.na(air_data$DateTime))
if (num_na > 0) {
  warning(paste("There are", num_na, "NA values in the DateTime column. Please check the DateTime_Str format."))
} else {
  print("DateTime parsing successful. No NA values found.")
}

# -------------------------------
# 5. Extract the Date Component
# -------------------------------
air_data$Date <- as.Date(air_data$DateTime)
print("First few entries of the Date column:")
print(head(air_data$Date))

# -------------------------------
# 6. Compute Daily Means for Specified Parameters
# -------------------------------
variables_to_plot <- c("Temperature", "Humidity", "PM1.0", "PM2.5", "PM10")
missing_vars <- setdiff(variables_to_plot, names(air_data))
if (length(missing_vars) > 0) {
  stop(paste("The following required variables are missing from the dataset:",
             paste(missing_vars, collapse = ", ")))
}

daily_means <- air_data %>%
  group_by(Date) %>%
  summarise(
    Mean_Temperature = mean(Temperature, na.rm = TRUE),
    Mean_Humidity    = mean(Humidity, na.rm = TRUE),
    Mean_PM1.0       = mean(PM1.0, na.rm = TRUE),
    Mean_PM2.5       = mean(PM2.5, na.rm = TRUE),
    Mean_PM10        = mean(PM10, na.rm = TRUE)
  ) %>%
  ungroup()

print("First few rows of the daily_means dataframe:")
print(head(daily_means))

# -------------------------------
# 7. Detect Outliers Using the IQR Method
# -------------------------------
identify_outliers <- function(data, variable) {
  Q1 <- quantile(data[[variable]], 0.25, na.rm = TRUE)
  Q3 <- quantile(data[[variable]], 0.75, na.rm = TRUE)
  IQR_value <- IQR(data[[variable]], na.rm = TRUE)
  lower_bound <- Q1 - 1.5 * IQR_value
  upper_bound <- Q3 + 1.5 * IQR_value
  ifelse(data[[variable]] < lower_bound | data[[variable]] > upper_bound, TRUE, FALSE)
}

parameters <- c("Mean_Temperature", "Mean_Humidity", "Mean_PM1.0", "Mean_PM2.5", "Mean_PM10")
for (param in parameters) {
  outlier_column <- paste0(param, "_Outlier")
  daily_means[[outlier_column]] <- identify_outliers(daily_means, param)
}

print("First few rows of the daily_means dataframe with outlier flags:")
print(head(daily_means))

# -------------------------------
# 8. Remove Outliers
# -------------------------------
daily_means_no_outliers <- daily_means %>%
  filter(
    !Mean_Temperature_Outlier &
      !Mean_Humidity_Outlier &
      !Mean_PM1.0_Outlier &
      !Mean_PM2.5_Outlier &
      !Mean_PM10_Outlier
  )

print("First few rows of the daily_means dataframe without outliers:")
print(head(daily_means_no_outliers))

# -------------------------------
# 9. Melt the Filtered Data for Plotting
# -------------------------------
melted_daily_means_no_outliers <- melt(
  daily_means_no_outliers,
  id.vars       = "Date",
  measure.vars  = c("Mean_Temperature", "Mean_Humidity", "Mean_PM1.0", "Mean_PM2.5", "Mean_PM10"),
  variable.name = "Parameter",
  value.name    = "Mean_Value"
)

print("First few rows of the melted dataframe without outliers:")
print(head(melted_daily_means_no_outliers))

# -------------------------------
# 10. Plot: Multiple Lines with Dual Y-Axes (Facet)
# -------------------------------
scaling_factor <- 0.25  # Example for dual-axis scaling if needed

facet_plot <- ggplot(melted_daily_means_no_outliers, aes(x = Date, y = Mean_Value, color = Parameter)) +
  geom_line(size = 1.2) +
  facet_wrap(~Parameter, scales = "free_y", ncol = 2) +
  labs(
    title = "Daily Mean Air Pollution Parameters",
    x = "Date",
    y = "Mean Values"
  ) +
  scale_color_manual(values = c("red", "blue", "green", "purple", "orange")) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(hjust = 0.5, size = 18, face = "bold", color = "darkblue"),
    axis.title.x     = element_text(size = 14, face = "bold", color = "darkgrey"),
    axis.title.y     = element_text(size = 14, face = "bold", color = "darkgrey"),
    axis.text.x      = element_text(angle = 45, hjust = 1, size = 12, color = "black"),
    axis.text.y      = element_text(size = 12, color = "black"),
    strip.text       = element_text(size = 14, face = "bold", color = "darkblue"),
    panel.grid.major = element_line(color = "grey80"),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "white", color = "grey80"),
    legend.position  = "none"
  )

print(facet_plot)

output_dir <- "D:/TONY/SECOND ASSIGNMENT/data_aeturnum_2024Q1/plots_without_outliers/"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
ggsave(
  filename = paste0(output_dir, "Improved_Faceted_Plots.png"),
  plot     = facet_plot,
  width    = 14,
  height   = 8,
  dpi      = 300,
  bg       = "white"
)

# -------------------------------
# 11. Correlation Analysis & Plot
# -------------------------------
correlation_vars <- c("Mean_Temperature", "Mean_Humidity", "Mean_PM1.0", "Mean_PM2.5", "Mean_PM10")
missing_correlation_vars <- setdiff(correlation_vars, names(daily_means_no_outliers))
if (length(missing_correlation_vars) > 0) {
  stop(paste("The following variables are missing in daily_means_no_outliers:",
             paste(missing_correlation_vars, collapse = ", ")))
}
selected_data <- daily_means_no_outliers[, correlation_vars, drop = FALSE]
corr_matrix <- cor(selected_data, use = "pairwise.complete.obs", method = "pearson")

# Plot full correlation matrix with corrplot (shortened)
corrplot(
  corr_matrix,
  method      = "color",
  type        = "full",
  order       = "original",
  addCoef.col = "black",
  tl.col      = "black",
  tl.srt      = 45,
  title       = "Correlation Matrix of the Variables",
  mar         = c(0, 0, 2, 0),
  diag        = TRUE
)
