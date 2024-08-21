-- calculate the support = frequency of both / total number of transactions
-- calculate the confidence = frequency of both / frequency of LHS
-- calculate the lift = support /support of A + support of B

use market_basket_analysis;

select * from groceries_data;


select * from groceries_data as G1
join groceries_data as G2
on G1.Member_number = G2.Member_number;


select G1.itemDescription, G2.ItemDescription
from groceries_data as G1
join groceries_data as G2
on G1.Member_number = G2.Member_number
where G1.itemDescription > G2.itemDescription;


-- Calculating the frequency and total transaction

select G1.itemDescription as Item_1,
G2.ItemDescription as Item_2,
count(1) as frequency,
(select count(Member_number) from groceries_data as c) as Total_transactions
from groceries_data as G1
join groceries_data as G2
on G1.Member_number = G2.Member_number
where G1.itemDescription > G2.itemDescription
group by Item_1,Item_2;

-- Using CTE 
-- Calculating Support 

with MBA as (
select G1.itemDescription as Item_1,
 G2.ItemDescription as Item_2,
 count(1) as frequency,
 (select count(Member_number) from groceries_data) as Total_transactions
from groceries_data as G1
join groceries_data as G2
on G1.Member_number = G2.Member_number
where G1.itemDescription > G2.itemDescription
group by Item_1,Item_2
)
select Item_1, Item_2, frequency, (frequency/Total_transactions *100) as support
from MBA;


-- Calculating for Frequency on LHS

#Failed attemp to calculate confidence

select G1.itemDescription as Item_1,
G2.ItemDescription as Item_2,
count(1) as frequency,
(select count(Member_number) from groceries_data as c) as Total_transactions,
(select count(member_number) from groceries_data as d where d.itemDescription= Item_1) as frequency_LHS
from groceries_data as G1
join groceries_data as G2
on G1.Member_number = G2.Member_number
where G1.itemDescription > G2.itemDescription
group by Item_1,Item_2;


#Corrected Query for confidence

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
group by Item_1, Item_2)

select * from MB;


-- Calculating for Frequency on RHS and Lift

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
(Frequency / Total_transactions) / ((Frequency_LHS / Total_transactions) *100) + ((Frequency_RHS / Total_transactions) *100) as Lift from MB
order by Frequency desc
limit 5;

