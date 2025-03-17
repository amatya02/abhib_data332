# Healthcare Visit Analysis: Patient Trends and Billing Insights

## Datasets Used
Billing.xlsx: Contains financial transaction details related to patient visits, including invoice amounts, payment status, and invoice dates.

Patient.xlsx: Includes demographic and personal information about patients, such as their ID, city, state, and other relevant details.

Visit.xlsx: Stores records of patient visits, detailing the reason for the visit, walk-in status, and visit dates.

## Libraries Used
dplyr: Data manipulation

ggplot2: Data visualization

readxl: Reading Excel files

tidyr: Data tidying

## Key Features
### Data merging 
Merge datasets by using relational keys. Visit.xlsx and Patient.xlsx was merged by "Patient ID" and the new dataset merged with Billing.xlsx by "VisitID"

### Extracting birth year
Converts Visit Date into proper date format and extracts on the visit month and year

### Visualizations
#### Reason for visit by months
![reason_month](https://github.com/user-attachments/assets/7602fe5b-0499-4df5-af8d-ebb193d7cc9d)

#### Reason for visit based on walk-in status
![reason_walkin](https://github.com/user-attachments/assets/beb75418-41e9-468d-be04-de9a2f6862e3)

#### Reason for visit by city/state
![reason_city](https://github.com/user-attachments/assets/819e62e2-f2fc-40c2-abb5-48203f320839)

#### Invoice amount and status based on reason for visit
![inv_amt](https://github.com/user-attachments/assets/16762070-09ed-4b42-aa26-48c1f6505da9)

#### Additional Insight
![add_insight](https://github.com/user-attachments/assets/9b67abfa-39d9-45d9-929a-4ec89f38e5d0)

#### Analysis: The graph shows that walk-in visits have considerably higher average invoice amount than not-walk-in visits

## How to run
1. Install the required R libraries using the following commands:

`install.packages(c("dplyr", "ggplot2", "readxl", "tidyr"))`

2. Place the Excel files in your working directory.

3. Run the script file to generate insights and visualizations.

## Results
- Visualizations will be generated and displayed in the RStudio plot pane.

- Summaries will be printed to the console.

