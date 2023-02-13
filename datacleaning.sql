--Standarize the date
SELECT SaleDateConverted, CONVERT(date, SaleDate) as SaleDateFixed
FROM DataCleaningPortfolio..nashvillehousing

Alter table DataCleaningPortfolio..NashvilleHousing
Add SaleDateConverted Date;

Update DataCleaningPortfolio..NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted
from DataCleaningPortfolio..NashvilleHousing


-- Populate property address data
SELECT *
from DataCleaningPortfolio..NashvilleHousing
ORDER BY ParcelID
--where PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.PropertyAddress, b.ParcelID, isnull(a.propertyaddress, b.PropertyAddress)
from DataCleaningPortfolio..NashvilleHousing a
JOIN DataCleaningPortfolio..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET  PropertyAddress = isnull(a.propertyaddress, b.PropertyAddress)
from DataCleaningPortfolio..NashvilleHousing a
JOIN DataCleaningPortfolio..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


-- Breaking out Address into individual columns (address, city, state)
select
SUBSTRING (propertyaddress,1, CHARINDEX(',',PROPERTYADDRESS)-1) AS Address,
SUBSTRING (propertyaddress,CHARINDEX(',',propertyaddress) +1, LEN(PropertyAddress)) AS city
FROM DataCleaningPortfolio..NashvilleHousing


Alter table DataCleaningPortfolio..NashvilleHousing
Add PropertySplitAdress Nvarchar(255);

Update DataCleaningPortfolio..NashvilleHousing
SET PropertySplitAdress = SUBSTRING (propertyaddress,1, CHARINDEX(',',PROPERTYADDRESS)-1)

Alter table DataCleaningPortfolio..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update DataCleaningPortfolio..NashvilleHousing
SET PropertySplitCity = SUBSTRING (propertyaddress,CHARINDEX(',',propertyaddress) +1, LEN(PropertyAddress))

select *
FROM DataCleaningPortfolio..NashvilleHousing


select PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as city,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as state 
FROM DataCleaningPortfolio..NashvilleHousing

Alter table DataCleaningPortfolio..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update DataCleaningPortfolio..NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


Alter table DataCleaningPortfolio..NashvilleHousing
Add OwnerCity Nvarchar(255);

Update DataCleaningPortfolio..NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter table DataCleaningPortfolio..NashvilleHousing
Add OwnerState Nvarchar(255);

Update DataCleaningPortfolio..NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM DataCleaningPortfolio..NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field
SELECT Distinct(SoldAsVacant), COUNT (soldasvacant)
FROM DataCleaningPortfolio..NashvilleHousing
group by SoldAsVacant
order by 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' then 'Yes'
	WHEN SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	end
FROM DataCleaningPortfolio..NashvilleHousing

UPDATE DataCleaningPortfolio..NashvilleHousing
set SoldasVacant = CASE WHEN SoldAsVacant = 'Y' then 'Yes'
	WHEN SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	end
