select * from nashville_housing
where propertyaddress is null
order by parcelid;

-- Populate property address data 
select a.parcelid, a.propertyaddress,b.parcelid, b.propertyaddress
from nashville_housing as a
join nashville_housing as b
ON a.parcelid = b.parcelid
	AND a.uniqueid_ <> b.uniqueid_
where a.propertyaddress is null;

-- Alter table 
Alter table nashville_housing
ADD column new_add varchar

Alter table nashville_housing
drop column new_add


-- update the property address 
select a.new_add,a.parcelid, a.propertyaddress,b.parcelid, b.propertyaddress
,Coalesce(b.propertyaddress,a.propertyaddress) as new_address
from nashville_housing as a
join nashville_housing as b
ON a.parcelid = b.parcelid
	AND a.uniqueid_ <> b.uniqueid_
where a.propertyaddress is null;

-- Delete the null rows 

delete from nashville_housing 
where propertyaddress is null

-- Breaking out address into individual columns (address, city, state)
select 
substring (propertyaddress,1, position(',' in propertyaddress)-1) as address
,substring (propertyaddress, position(',' in propertyaddress)+1
			,length(propertyaddress)) as City
from nashville_housing

-- Property Address_line
Alter table nashville_housing
Add column property_address_line varchar(255)

update nashville_housing
set property_address_line = substring (propertyaddress,1
									   , position(',' in propertyaddress)-1) 
-- Property City 
Alter table nashville_housing
Add column property_city varchar(100)

update nashville_housing 
set property_city = substring (propertyaddress
							   , position(',' in propertyaddress)+1
							   ,length(propertyaddress)) 


-- Owner Address_line
Alter table nashville_housing
Add column owner_address_line varchar(255)

update nashville_housing
set owner_address_line = split_part(owneraddress,',',1) 


-- Owner City 
Alter table nashville_housing
Add column owner_city varchar(255)

update nashville_housing 
set owner_city = split_part(owneraddress,',',2) 

-- Owner State
Alter table nashville_housing
Add column owner_state varchar(255)

update nashville_housing 
set owner_state = split_part(owneraddress,',',3) 

-- Sold as vacant - field update from Y/N to Yes/No 

select distinct(soldasvacant)
,count(soldasvacant) 
from nashville_housing
group by 1
order by 2

select soldasvacant 
,case 
	when soldasvacant = 'Y' THEN 'Yes'
	when soldasvacant = 'N' THEN 'No'
	ELSE soldasvacant
	END
from nashville_housing
where soldasvacant like 'N';

update nashville_housing
set soldasvacant = case 
	when soldasvacant = 'Y' THEN 'Yes'
	when soldasvacant = 'N' THEN 'No'
	ELSE soldasvacant
	END

-- Duplicates in the data

Alter table nashville_housing
Add column row_num int

with RownumCTE AS 
(
	select *,
		Row_number() OVER (
		partition by parcelid,
			saleprice,
			saledate,
			legalreference
			order by 
				uniqueid_
		) r_num 
from nashville_housing
)
select * from RownumCTE
where r_num > 1
order by parcelid


-- Delete unused columns 

Alter table nashville_housing
Drop column propertyaddress

Alter table nashville_housing
Drop column taxdistrict

Alter table nashville_housing
Drop column owneraddress

Alter table nashville_housing
Drop column row_num

select * from nashville_housing


