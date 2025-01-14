# INF6027 Project: Liverpool Air Pollution Analysis

## Introduction
Welcome to my GitHub repository! I am [Your Name], a [Your Position, e.g., Data Scientist, Environmental Researcher, etc.] with a strong interest in environmental data analysis, statistical modeling, and sustainable urban development. My professional skills include proficiency in **R**, **Python**, **SQL**, data visualization, and machine learning. I am passionate about leveraging data to inform public health policies and promote cleaner, healthier urban environments.

---

## INF6027 Project: Liverpool Air Pollution Analysis

### Introduction
This project explores air pollution data in Liverpool to understand daily trends in temperature, humidity, and particulate matter (PM1.0, PM2.5, PM10). Utilizing sensor data provided by Aeternum Innovations and the University of Liverpool, the analysis aims to uncover meaningful insights into local air quality patterns and the potential impact of transitioning to hydrogen-fueled buses on the 10A bus route.

### Research Questions
1. **What are the daily variations of PM2.5 in different regions of the city?**
2. **Does temperature significantly correlate with PM levels?**
3. **How do outliers in the recorded data affect the overall interpretation of air quality trends, and what methods can be used to manage these outliers effectively?**
4. **Does the introduction of new sensors (particularly along the 10A bus route) reveal any notable changes or patterns in air quality that might be linked to the shift toward hydrogen-powered buses?**

### Key Findings
- **Strong PM Correlations:** A significant positive correlation exists between PM1.0 and PM2.5 (r = 0.85), indicating shared emission sources or atmospheric processes affecting multiple particle sizes.
- **Outlier Impact:** Removing outliers using the Interquartile Range (IQR) method clarified daily trends, ensuring that extreme spikes did not skew the overall analysis.
- **Temperature Relationship:** Temperature exhibits a moderate negative correlation with PM levels, suggesting that cooler conditions may be associated with slightly higher particulate matter concentrations.
- **Policy Implications:** Insights suggest that transitioning to hydrogen-fueled buses on high-traffic routes like the 10A may contribute to reductions in PM levels, promoting better air quality and public health outcomes.

---

## R Code

The core analysis and visualization steps are encapsulated in the R script below:

- [analysis_script.R](https://github.com/your-username/INF6027-project/blob/main/R/analysis_script.R)

This script includes:
- Data import and cleaning
- Daily aggregation of sensor readings
- Outlier detection and removal using the IQR method
- Correlation analysis
- Generation of visualizations (faceted plots and correlation matrices)

---

## Instructions for Downloading and Running the Code

Follow these steps to replicate the analysis on your local machine:

1. **Clone the Repository**
   Open your terminal or command prompt and execute:
   ```bash
   git clone https://github.com/your-username/INF6027-project.git
