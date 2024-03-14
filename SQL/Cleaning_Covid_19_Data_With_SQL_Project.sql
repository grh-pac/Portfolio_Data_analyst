-- database: :memory:
-- Selecting SaleDate and converting it to Date data type
select saleDate, convert(Date,SaleDate)
from Nashville$

-- Updating Nashville$ table, converting SaleDate column to Date data type
update Nashville$ 
set SaleDate = convert(Date, SaleDate)

-- Adding a new column 'convertedDate' to Nashville$ table
alter table Nashville$
add convertedDate Date;

-- Updating convertedDate column with converted SaleDate values
update Nashville$
set convertedDate = convert(Date, SaleDate);

-- Selecting all columns from Nashville$ table
select *
from Nashville$;

-- Selecting all columns from PortfolioProject.dbo.Nashville$ table, ordered by ParcelID
Select *
From PortfolioProject.dbo.Nashville$
--Where PropertyAddress is null
order by ParcelID;

-- Joining Nashville$ table with itself and selecting certain columns where PropertyAddress is null
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville$ a
JOIN Nashville$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;

-- Updating PropertyAddress column in Nashville$ table where PropertyAddress is null
update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
From Nashville$ a
JOIN Nashville$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;

-- Selecting PropertyAddress column from Nashville$ table
Select PropertyAddress
From Nashville$;
--Where PropertyAddress is null
--order by ParcelID;

-- Selecting substrings of PropertyAddress column from Nashville$ table
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From Nashville$;

-- Adding PropertySplitAddress and PropertySplitCity columns to Nashville$ table
ALTER TABLE Nashville$
Add PropertySplitAddress Nvarchar(255);
ALTER TABLE Nashville$
Add PropertySplitCity Nvarchar(255);

-- Updating PropertySplitAddress column with substrings of PropertyAddress column
Update Nashville$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );

-- Updating PropertySplitCity column with substrings of PropertyAddress column
Update Nashville$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));

-- Selecting all columns from PortfolioProject.dbo.Nashville$ table
Select *
From PortfolioProject.dbo.Nashville$;

-- Selecting OwnerAddress column from PortfolioProject.dbo.Nashville$ table
Select OwnerAddress
From PortfolioProject.dbo.Nashville$;

-- Selecting parsed parts of OwnerAddress column from PortfolioProject.dbo.Nashville$ table
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.Nashville$;

-- Adding OwnerSplitAddress column to Nashville$ table
ALTER TABLE Nashville$
Add OwnerSplitAddress Nvarchar(255);

-- Updating OwnerSplitAddress column with parsed part of OwnerAddress column
Update Nashville$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);

-- Adding OwnerSplitCity column to Nashville$ table
ALTER TABLE Nashville$
Add OwnerSplitCity Nvarchar(255);

-- Updating OwnerSplitCity column with parsed part of OwnerAddress column
Update Nashville$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);

-- Adding OwnerSplitState column to Nashville$ table
ALTER TABLE Nashville$
Add OwnerSplitState Nvarchar(255);

-- Updating OwnerSplitState column with parsed part of OwnerAddress column
Update Nashville$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

-- Selecting all columns from PortfolioProject.dbo.Nashville$ table
Select *
From PortfolioProject.dbo.Nashville$;

-- Selecting distinct SoldAsVacant values and their counts from PortfolioProject.dbo.Nashville$ table
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.Nashville$
Group by SoldAsVacant
order by 2;

-- Converting SoldAsVacant values to 'Yes' or 'No'
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.Nashville$;

-- Updating SoldAsVacant column values to 'Yes' or 'No'
Update Nashville$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;

-- Selecting rows with duplicate entries in PortfolioProject.dbo.Nashville$ table
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject.dbo.Nashville$
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

-- Selecting all columns from PortfolioProject.dbo.Nashville$ table
Select *
From PortfolioProject.dbo.Nashville$;

-- Selecting all columns from PortfolioProject.dbo.Nashville$ table
Select *
From PortfolioProject.dbo.Nashville$;

-- Dropping specified columns from PortfolioProject.dbo.Nashville$ table
ALTER TABLE PortfolioProject.dbo.Nashville$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
