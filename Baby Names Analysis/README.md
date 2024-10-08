# Baby Names Analytics

## Project Overview

This project analyzes the popularity of baby names over time, across different regions, and among different genders using SQL. The data is sourced from the `names_data.csv` file and documented in the `baby_names_db_data_dictionary.csv` file.

## Folder Structure

- **data/**
  - `names_data.csv`: Source data containing baby names and their respective number of births.
  - `baby_names_db_data_dictionary.csv`: Data dictionary for the source data.
- **scripts/**
  - `create_baby_names_db.sql`: Script to create the database from the source file.
  - `changes_in_name_popularity.sql`: Analysis of changes in name popularity.
  - `compare_popularity_across_decades.sql`: Comparison of name popularity across decades.
  - `compare_popularity_across_regions.sql`: Comparison of name popularity across regions.
  - `explore_unique_names.sql`: Exploration of unique names.
  
## How to Run the Scripts

1. **Setup the Database**: Use `create_baby_names_db.sql` to create the database and load the data from `names_data.csv`. There is a manual step invovled, please read the comments in the sql file.
2. **Run Analysis Scripts**: Execute the SQL scripts in the `scripts/` folder to perform various analyses.

## License

This project is licensed under the MIT License.
