select * from evsaleshistoricalcars

select region from evsaleshistoricalcars
where parameter like 'EV%sales%share%'
group by region;


CREATE VIEW EVStock AS
SELECT region, parameter, mode, powertrain, year, unit, value
FROM evsaleshistoricalcars
WHERE parameter like 'EV stock'; 

CREATE VIEW EVSales AS
SELECT region, parameter, mode, powertrain, year, unit, value
FROM evsaleshistoricalcars
WHERE parameter like 'EV sales';

CREATE VIEW ElectricityDemand AS
SELECT region, parameter, mode, powertrain, year, unit, value
FROM evsaleshistoricalcars
WHERE parameter like '%Electrici%';

CREATE VIEW OilDisplacement AS
SELECT region, parameter, mode, powertrain, year, unit, value
FROM evsaleshistoricalcars
WHERE parameter like '%Oil%Mbd%';

CREATE VIEW EVsalesshare AS
SELECT region, parameter, mode, powertrain, year, unit, value
FROM evsaleshistoricalcars
where parameter like 'EV%sales%share%'

CREATE VIEW EVstockshare AS
SELECT region, parameter, mode, powertrain, year, unit, value
FROM evsaleshistoricalcars
where parameter like 'EV%st%share%'

select region from electricitydemand
group by region;

select year,sum(value) from evsales
where region like 'USA' and powertrain like 'BEV'
group by year
order by sum(value);

select region, sum(value) from evsales
group by region
delete from evsales where region = 'World'
delete from evsales where region = 'Rest of the world'
delete from evsales where region = 'EU27' 
delete from evsales where region = 'Europe'
delete from evsales where region = 'Other Europe'

select region, sum(value) from evstock 
group by region
delete from evstock where region = 'World'
delete from evstock where region = 'Rest of the world'
delete from evstock where region = 'EU27' 
delete from evstock where region = 'Europe'
delete from evstock where region = 'Other Europe'

select region, sum(value) from evstockshare
group by region
delete from evstockshare 
where region IN ('World', 'Rest of the world', 'EU27','Europe',
'Other Europe')

select region, sum(value) from evsalesshare
group by region
delete from evsalesshare 
where region IN ('World', 'Rest of the world', 'EU27','Europe',
'Other Europe')

select * from evstock
