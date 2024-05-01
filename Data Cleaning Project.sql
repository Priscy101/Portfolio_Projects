SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[Housing]








select SaleDateConverted, convert(Date, SaleDate)
from PortfolioProject.dbo.Housing

UPDATE Housing
SET SaleDateConverted = convert(Date, SaleDate)



select *
from PortfolioProject.dbo.Housing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.Housing a
JOIN PortfolioProject.dbo.Housing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress =ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.Housing a
JOIN PortfolioProject.dbo.Housing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null






-- Breaking out Address into Individual Column


SELECT PropertyAddress
from PortfolioProject.dbo.Housing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address 
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress))  as Address
from PortfolioProject.dbo.Housing


Alter table Housing
add PropertySplitAddress Nvarchar(255);

update Housing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter table Housing
add PropertySplitCity Nvarchar(255);

update Housing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress))


select *

From PortfolioProject.dbo.Housing


select OwnerAddress
from PortfolioProject.dbo.Housing




SELECT Distinct(SoldasVacant), count(SoldasVacant)
FROM PortfolioProject.dbo.Housing
group by SoldAsVacant
order by 2


select SoldAsVacant
, CASE when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject.dbo.Housing


update Housing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-- Removing Duplicates
with RowNumCTE AS(
select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
				     UniqueID
					 ) row_num

from PortfolioProject.dbo.Housing
--order by ParcelID
)
select *
FROM RowNumCTE
WHERE row_num > 1
order by PropertyAddress


SELECT *
from PortfolioProject.dbo.Housing




SELECT *
from PortfolioProject.dbo.Housing



alter table PortfolioProject.dbo.Housing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject.dbo.Housing
drop column SaleDate