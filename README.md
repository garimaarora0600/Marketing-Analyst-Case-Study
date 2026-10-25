# Marketing Analytics Project — Customer Review Sentiment Analysis

## Project Overview

This project is part of a Marketing Analytics portfolio project focused on analyzing customer reviews to understand customer sentiment and improve insights into customer experience.

SQL Server is used to clean and prepare customer review data, while Python is used to perform sentiment analysis on the written reviews. The processed data can then be exported to CSV for further analysis and visualization.

## Objectives

- Clean and prepare customer review data using SQL.
- Create a SQL Server view to make the cleaned data accessible for further analysis.
- Connect Python to SQL Server to retrieve the cleaned data.
- Apply sentiment analysis to customer review text using NLTK's VADER sentiment analyzer.
- Categorize reviews using sentiment scores and numerical ratings.
- Export the processed data to CSV for further analysis and reporting.

## Tools and Technologies

- **SQL Server:** Data cleaning, querying, and view creation.
- **SQL Server Management Studio (SSMS):** Writing and executing SQL queries.
- **Python:** Data processing and sentiment analysis.
- **Pandas:** Data manipulation and CSV export.
- **PyODBC:** Connecting Python to SQL Server.
- **NLTK (VADER):** Text sentiment analysis.

## Project Workflow

### 1. Data Preparation and Cleaning — SQL

The customer review data is stored in the `fact_customer_reviews` table.

SQL queries are used to clean and prepare the data for analysis. A SQL Server view, `vw_cleaned_customer_reviews`, is used to expose the cleaned data for the Python workflow.

The view provides the following fields:

- `ReviewID`
- `CustomerID`
- `ProductID`
- `ReviewDate`
- `Rating`
- `ReviewText`

*Note: Update the view name and column list if your final SQL implementation differs.*

### 2. Connecting SQL Server to Python

Python connects to SQL Server using PyODBC and retrieves the cleaned customer review data using Pandas.

The data is loaded into a Pandas DataFrame for further processing.

### 3. Sentiment Analysis — Python

NLTK's VADER sentiment analyzer is used to calculate sentiment scores for customer reviews.

The compound sentiment score ranges from -1 to +1:

- Negative scores indicate negative sentiment.
- Scores around zero indicate relatively neutral sentiment.
- Positive scores indicate positive sentiment.

### 4. Sentiment Categorization

The analysis creates three additional columns:

| Column | Description |
|---|---|
| `SentimentScore` | The compound sentiment score calculated from the review text. |
| `SentimentCategory` | A category determined using both the sentiment score and the numerical rating. |
| `SentimentBucket` | A group assigned according to the sentiment score range. |

The sentiment category logic considers both the written review and the numerical rating to identify positive, negative, neutral, and mixed sentiment cases.

### 5. Exporting the Results

The processed DataFrame is exported to a CSV file named:

`fact_customer_reviews_with_sentiment.csv`

The CSV contains the original review data along with the additional sentiment analysis columns.

This output can be used for further exploration, reporting, or integration into a business intelligence dashboard.

## Python Libraries

Install the required libraries using:

```bash
pip install pandas nltk pyodbc sqlalchemy
```

The script uses Pandas for data processing, PyODBC for the SQL Server connection, and NLTK for sentiment analysis. SQLAlchemy is included in the environment setup but is not directly used in the current script.

Download the VADER lexicon if it is not already available:

```python
import nltk
nltk.download('vader_lexicon')
```

## How to Run the Project

1. Set up SQL Server and ensure the project database is available.
2. Execute the SQL cleaning queries and create the cleaned customer review view.
3. Install the required Python libraries.
4. Update the Python connection string with your SQL Server instance name and database name.
5. Run the Python script to retrieve the cleaned data and calculate sentiment scores.
6. Check the output directory for `fact_customer_reviews_with_sentiment.csv`.

## Key Learning Outcomes

- Writing SQL queries for data preparation.
- Creating and using SQL Server views.
- Connecting Python to a relational database.
- Working with Pandas DataFrames.
- Applying rule-based sentiment analysis to text data.
- Combining text sentiment with numerical ratings.
- Exporting processed data for downstream analysis.

## Future Improvements

- Analyze sentiment patterns across products and review dates.
- Identify products with consistently negative customer feedback.
- Compare sentiment categories with numerical ratings.
- Build visualizations to communicate customer feedback trends.
- Explore how sentiment insights can support marketing and product decisions.

## Project Status

**In Progress** — SQL data preparation, database connectivity, and the Python sentiment analysis workflow are being developed and tested.

