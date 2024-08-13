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
In this analysis, we explored the use of association rule mining and with a focus on one of the most popular algorithmms, Apriori Algorithm. We will look at the association rule mining and the inner workings of the algorithm to understand how it can be applied to reveal patterns in customer pirchasing behaviour.

### Association rule mining
Association Rule Mining is a powerful technique that can be used to identify interesting relationships between items in large datasets. It involves identifying frequent itemsets, which are sets of items that are often purchased or appear together in transactions, and then generating association rules that describe the relationships between these itemsets.
An association rule has two parts: **Antecedent** and **Consequent**. Antecedent are items that appear on the left hand side while Consequent are item that appear on the right hand side. 
To determine the items that are frequent, we use these three metrics: **Support, Confidence and Lift.**

### Apriori algorithm
Apriori algorithm was used in this market basket analysis. The Apriori algorithm was choosen in association rule mining because of its efficiency in discovering interesting relationships between items in large datasets. It employs a bottom-up approach to mine frequent itemsets and generates association rules that describe the relationships between them. In the apriori algorithm, only those items that are frequent are considered.
We will break down the methodology and the processes taken to identify and perform this analysis:

The Groceries data table was joined to create the antecedent and consequent, making sure that what appears on the left hand side is different from what appears on the right hand side. The following sql script was used:

```sql
SELECT G1.itemDescription, G2.ItemDescription
FROM groceries_data AS G1
JOIN groceries_data AS G2
ON G1.Member_number = G2.Member_number
WHERE G1.itemDescription > G2.itemDescription;
```
Here was the result of the script:

![Screenshot 2024-08-13 182153](https://github.com/user-attachments/assets/9599acac-5230-4c9f-ae64-29d9dfef115e)


### Frequency
Frequency tells us how often item 1 and item 2 appear in the whole transaction. Below is the queries to extract the frequency of the items.

```sql
SELECT G1.itemDescription AS Item_1,
G2.ItemDescription AS Item_2,
COUNT(1) as frequency
FROM groceries_data AS G1
JOIN groceries_data AS G2
ON G1.Member_number = G2.Member_number
WHERE G1.itemDescription > G2.itemDescription
GROUP BY Item_1,Item_2;
```
Here are the reuslt of tthe query:

![Screenshot 2024-08-13 183345](https://github.com/user-attachments/assets/1c313acd-851e-40f6-888b-0db358913afb)


### Support
The probability that the antecedent will occur, i.e that customer will buy the items in item 1 is called the support of this rule. It is calculated as thus:

![Screenshot 2024-08-13 185607](https://github.com/user-attachments/assets/6efc1f2a-6bd8-40f6-8994-b0cce33860a4)

In otherwords, it can be seen as the percentage of transactions that contain all the items in an itemset (item 1), How likely the iten 1 will occur in a transaction.

```sql
with MBA as (
SELECT G1.itemDescription AS Item_1,
 G2.ItemDescription AS Item_2,
 COUNT(1) AS frequency,
 (SELECT COUNT(Member_number) FROM groceries_data) AS Total_transactions
FROM groceries_data AS G1
JOIN groceries_data AS G2
ON G1.Member_number = G2.Member_number
WHERE G1.itemDescription > G2.itemDescription
GROUP BY Item_1,Item_2
)
SELECT Item_1, Item_2, frequency, (frequency/Total_transactions *100) AS support
FROM MBA;
```
Below is the screenshot showing the support:

![Screenshot 2024-08-13 185056](https://github.com/user-attachments/assets/1f0ca9ee-372b-46fd-ac3b-c98e0db1a2fd)

The higher the support, the more frequent the itemset occurs.

### Confidence
Confidence measures the strenght of relationship between two items. It is calculated as:

![Screenshot 2024-08-13 190701](https://github.com/user-attachments/assets/586f9b5c-1957-462c-922d-544f48a20a00)

Confidence tells us that if the products on the left hand side are ordered, how likely it is that the product on the right hand side are also in the shopping cart

```sql
with MB as 
(select G1.itemDescription as Item_1,
G2.ItemDescription as Item_2,
count(1) as frequency,
(select count(Member_number) from groceries_data as c) as Total_transactions,
G3.Freq_1 as Frequency_LHS
from groceries_data as G1
join groceries_data as G2
on G1.Member_number = G2.Member_number
and G1.itemDescription > G2.itemDescription
join
(select itemDescription, Count(*) as Freq_1 from groceries_data
group by itemDescription) as G3 on G1.itemDescription = G3.itemDescription

GROUP BY Item_1, Item_2)

select Item_1, Item_2, Frequency, (Frequency /Total_transactions) * 100 as Support,
(Frequency / Frequency_LHS) * 100 as Confidence
 from MB;
```
Below shows the screenshot of the query:

![Screenshot 2024-08-13 192318](https://github.com/user-attachments/assets/102718aa-dc70-4923-aa9a-25c620c454df)


The higher the confidence, the more likely that the item on the right hand side will be purchased. Confidence can be used for product placement strategy to increase profitability. Placing high margin items near associated high confidence items can increase the overall margin on purchases.


### Lift
The lift indicates the factor by which the probability of buying the products on the right hand side increases if the products on the right hand side have already been bought. 
It is calculated as thus:

![Screenshot 2024-08-13 195245](https://github.com/user-attachments/assets/76ee0ef1-c5af-4104-8067-1052b7f06fb9)

So in the example below, If the product youghurt is in the shopping cart, it is 3.26 times more likely that tropical fruit will be purchased than if the product youghurt is not in the shopping cart.

```sql
with MB as 
(select G1.itemDescription as Item_1,
G2.ItemDescription as Item_2,
count(1) as frequency,
(select count(Member_number) from groceries_data as c) as Total_transactions,
G3.Freq_1 as Frequency_LHS,
G4. Freq_2 as Frequency_RHS
from groceries_data as G1
join groceries_data as G2
on G1.Member_number = G2.Member_number
and G1.itemDescription > G2.itemDescription
join
(select itemDescription, Count(*) as Freq_1 from groceries_data
group by itemDescription) as G3 on G1.itemDescription = G3.itemDescription
join
(select itemDescription, count(*) as Freq_2 from groceries_data
group by itemDescription) as G4 on G2. itemDescription = G4.itemDescription
GROUP BY Item_1, Item_2)

select Item_1, Item_2, Frequency, (Frequency /Total_transactions) * 100 as Support,
(Frequency / Frequency_LHS) * 100 as Confidence, 
(Frequency / Total_transactions) / ((Frequency_LHS / Total_transactions) *100) + ((Frequency_RHS / Total_transactions) *100) as Lift from MB;
```

See result of query below

![Screenshot 2024-08-13 194009](https://github.com/user-attachments/assets/4df652bf-b4ae-4a6e-8a0f-5a94139cf0c9)


- A lift greater than 1 suggests that the presence of the antecedent increases the chances that the consequent will occur in a given transaction
- Lift below 1 indicates that purchasing the antecedent reduces the chances of purchasing the consequent in the same transaction.
- When the lift is 1, then purchasing the antecedent makes no difference on the chances of purchasing the consequent


## Result
Below is the result of the analysis

![Screenshot 2024-08-13 201140](https://github.com/user-attachments/assets/efe7c398-ca77-4448-b625-4ed8389456e4)


