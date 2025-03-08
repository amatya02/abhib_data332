# Visualizing Student Data using R Studio
## Overview
This project performs exploratory data analysis and visualization on student majors, registration, and payments using RStudio. The process involves merging datasets, generating visual insights and summarizing key financial matters.
## Datasets
Course.xlsx: Contains majors offered, their unique ID, their start and end dates, and the cost

Registration.xlsx: Contains student's total cost, balance due on their account and their payment plan status

Student.xlsx: Contains student demographic and contact information 

## Libraries Used
dplyr: Data manipulation

ggplot2: Data visualization

readxl: Reading Excel files

tidyr: Data tidying

scales: Formatting axis labels

ggcorrplot: Correlation matrix visualization

wordcloud: Word cloud visualization

RColorBrewer: Color palettes

plotly: Interactive pie charts

## Key Features
### Data merging 
Left joins to combine registration, student and course data by Student ID and Instance ID

### Extracting birth year
Converts Birth Date into proper date format and extracts on the birth year

### Visualizations
#### Bar chart for number of students in each major
![students_per_major](https://github.com/user-attachments/assets/02b995e5-3d70-4f7f-a550-bc36ce3d229d)

#### Histogram for student birth years
![histrogram_birthyear](https://github.com/user-attachments/assets/7d458127-a935-4414-9252-0b99c806d7bf)

#### Grouped bar chart for total cost per major by payment plan
![costper_major](https://github.com/user-attachments/assets/817c655c-80d9-4bcd-8698-a61fe150d0fa)

#### Grouped bar chart for total balance due per major by payment plan
![total_bal_bymajor](https://github.com/user-attachments/assets/5f255dae-407b-4fb1-bc07-3cb56e2be604)

#### Grouped bar chart for average cost per major by payment plan
![avg_cost_permajor](https://github.com/user-attachments/assets/de4cdfba-203e-4f4a-9de4-a0237ae11d64)

#### Correlation for matrix numeric variables
![correlation_matrix](https://github.com/user-attachments/assets/dc71da6b-d8ed-4591-bf71-9302fae491d5)

#### Stacked bar chart for payment plan proportion by major
![paymentplan_proportion](https://github.com/user-attachments/assets/a8524f24-72e9-462c-8e4c-eb128ba5b030)

#### Word cloud for popular majors
![word_cloud](https://github.com/user-attachments/assets/4c8497b9-aebe-47d2-84d3-9fb0212daac6)

## How to run
1. Install the required R libraries using the following commands:

`install.packages(c("dplyr", "ggplot2", "readxl", "tidyr", "scales", "ggcorrplot", "wordcloud", "RColorBrewer", "plotly"))`

2. Place the Excel files in your working directory.

3. Run the script file to generate insights and visualizations.

## Results
- Visualizations will be generated and displayed in the RStudio plot pane.

- Summaries will be printed to the console.






