# pip install pandas ntlk pyodbc sqlalchemy

import pandas as pd
import pyodbc
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer

# Download the VADER lexicon for sentiment analysis if not already present
nltk.download('vader_lexicon')

# Define a function to fetch data from a SQL database using a SQL Query
def fetch_data_from_sql():
    # connection string for db connection
    conn_str = (
        "Driver={SQL Server};"
        "Server=Garima_Arora\SQLEXPRESS;"
        "Database=PortfolioProject_MarketingAnalytics;"
        "Trusted_Connection=yes;"
    )

    # Establish the conn to the db
    conn = pyodbc.connect(conn_str);

    # SQL query to fetch customer reviews data
    query = "SELECT ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText from vw_cleaned_customer_reviews"

    # execute the query
    df = pd.read_sql(query,conn)

    conn.close();
    return df;


# fetching customer reviews data from SQL db
customer_reviews_df = fetch_data_from_sql()

print(customer_reviews_df);

# vader sentiment analysis for analyzing the sentiment of text data
sia = SentimentIntensityAnalyzer()

# function to calculate sentiment scores using VADER
def calculate_sentiment(review):
    # sentiment scores for the review text
    sentiment = sia.polarity_scores(review)
    # print("=============================",sentiment)
    return sentiment['compound']

def categorize_sentiment(score, rating):
    if score > 0.05:  # positive sentiment score 
         if rating >= 4:
            return 'Positive'
         elif rating == 4:
            return 'Mixed Positive'
         else:
            return 'Mixed Negative'
    elif score < -0.05:  # negative sentiment score
        if rating <= 2:
            return 'Negative'
        elif rating == 3:
            return 'Mixed Negative'
        else:
            return 'Mixed Positive'
    else: # neutral sentiment score
        if rating >= 4:
            return 'Positive'
        elif rating <= 2:
            return 'Negative'
        else:
            return 'Neutral'

# function to bucket sentiment scores into text ranges
def sentiment_bucket(score):
    if score >= 0.5:
        return '0.5 to 1.0' # strong positive sentiment
    elif 0.0 <= score < 0.5:
        return '0.0 to 0.49' # mildly positive sentiment
    elif -0.5 <= score < 0.0:
        return '-0.50 to 0.0' # mildly negative sentiment
    else:
        return '-1.0 to -0.5' # strongly negative sentiment

# calculate sentiment score for eaach review by applying sentiment analysis
customer_reviews_df['SentimentScore'] = customer_reviews_df['ReviewText'].apply(calculate_sentiment)
# print("*******************************************************",customer_reviews_df['SentimentScore'])

# sentiment categorization using both text and rating
customer_reviews_df['SentimentCategory'] = customer_reviews_df.apply(
    lambda row: categorize_sentiment(
        row['SentimentScore'],
        row['Rating']
    ),
    axis=1
)

# sentiment bucketing to categorize scores into defined ranges
customer_reviews_df['SentimentBucket'] = (
    customer_reviews_df['SentimentScore'].apply(sentiment_bucket)
)

print(customer_reviews_df.head())

# saving the df with sentiment score, categories, and buckets to new csv file
customer_reviews_df.to_csv('fact_customer_reviews_with_sentiments.csv', index=False)

