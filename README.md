# Market_Basket_Analysis_SQL
An analysis used to uncover relationships between items in a retail setting using Association rules.


## Introduction
Market Basket Analysis is a data mining technique used to uncover purchasing pattern in any retail setting. It looks to find what combination of products occur frequently in a transaction. It helps businesses and retailers to understand and ultimately serve their customers by predicting their purchasing behaviours. These relationships can help increase profitability through cross-selling, recommendations, promotions or simple placement of items on a menu or in a store. It answers the question **" How likely is it that a customer buys product B if he already has product A"**

The approach is based on the theory that customers who buy certain item (or group of items) are likely to also buy another item (or group of item). Take for instance: A Supermarket, If a customer buys a trouser, they are more likely to buy a shirt than someone that did not buy a trouser. 

So market basket analysis tells us which item or product are often bought together. So if a customer buys a trouser, how likley is it that this customer will allso buy a shirt, or shoe, or cap.


## Aims and Objectives

This analysis is aimed at:

- Helping businesses and Retailers uncover Customer Purchasing Patterns.
- Discover items that are frequently bought together
- Uncover rules that describes the relationship between different items
- To identify opportunities for cross-selling by recommending complementary products based on what customers have already purchased.
- To optimize the placement of products in a store or on a website by placing frequently bought-together items near each other, which can increase sales.


## Data Source
Data for this analysis was gotten from "*KAGGLE*" and the file can be found [here](https://github.com/NStanley0524/Market_Basket_Analysis_SQL/blob/main/Groceries%20data.csv)


## Data Tools
Tools used for this analysis were:

1. MySQL
2. Power BI


## Data Overview 

![image](https://github.com/user-attachments/assets/3313fd5c-d32e-4d3c-8a2b-08a2dcdf6a59)



## Data Structure
The Groceries data table contains 7 columns:

- Member_NUmber : Unique Member ID of Customers
- Date: Date of Tranactions
- Item_Description: Type of item bought by the customer
- Year: Year of transaction
- Month: Month of transaction
- Day: Day of transaction
- Day_of_the_week: Day of the week of transaction


## Data Pre-Procesing and Cleaning

### Creating The Database

```sql
CREATE DATABASE Market_Basket_Analysis;
```

```sql
USE Market_Basket_Analysis;
```



### Create Table

```sql
CREATE TABLE groceries_data(
Member_number INT,
Date DATE,
itemDescription VARCHAR(100),
Year INT,
Month INT,
Day INT,
Day_of_Week INT
);
```


### Loading The Data

```sql
LOAD DATA INFILE "Groceries Data.csv" INTO TABLE groceries_data
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES;
```

```sql
SELECT * FROM groceries_data;
```


## Data Cleaning

### Deleting all rows with null values

```sql
DELETE FROM groceries_data
WHERE itemDescription is null;
```

```sql
DELETE FROM groceries_data
WHERE Member_number = 0;
````

```sql
DELETE FROM groceries_data
WHERE Date = 0;
```

### Validating data values

```sql
SELECT * FROM groceries_data
WHERE Date LIKE "____-__-%";
```

```sql
SELECT * FROM groceries_data
WHERE itemDescription REGEXP "[a-b]";
```


## Methodology
