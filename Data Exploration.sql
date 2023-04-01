/*
Cleaning Data in SQL Queries
*/


Select *
From portfolioproject.`nashville housing data for data cleaning`
--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.`nashville housing data for data cleaning`


Update `nashville housing data for data cleaning`
SET SaleDate = CONVERT(Date,SaleDate)





 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProject.`nashville housing data for data cleaning`
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.`nashville housing data for data cleaning` a
JOIN PortfolioProject.`nashville housing data for data cleaning` b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.`nashville housing data for data cleaning`a
JOIN PortfolioProject.`nashville housing data for data cleaning` b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.`nashville housing data for data cleaning`
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.`nashville housing data for data cleaning`


ALTER TABLE `nashville housing data for data cleaning`
Add PropertySplitAddress Nvarchar(255);

Update `nashville housing data for data cleaning`
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE `nashville housing data for data cleaning`
Add PropertySplitCity Nvarchar(255);

Update `nashville housing data for data cleaning`
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProject.`nashville housing data for data cleaning`





Select OwnerAddress
From PortfolioProject.`nashville housing data for data cleaning`


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.`nashville housing data for data cleaning`



ALTER TABLE `nashville housing data for data cleaning`
Add OwnerSplitAddress Nvarchar(255);

Update `nashville housing data for data cleaning`
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE `nashville housing data for data cleaning`
Add OwnerSplitCity Nvarchar(255);

Update `nashville housing data for data cleaning`
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE `nashville housing data for data cleaning`
Add OwnerSplitState Nvarchar(255);

Update `nashville housing data for data cleaning`
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.`nashville housing data for data cleaning`




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.`nashville housing data for data cleaning`
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.`nashville housing data for data cleaning`


Update `nashville housing data for data cleaning`
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

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

From PortfolioProject.`nashville housing data for data cleaning`
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.`nashville housing data for data cleaning`




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.`nashville housing data for data cleaning`


ALTER TABLE PortfolioProject.`nashville housing data for data cleaning`
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate











