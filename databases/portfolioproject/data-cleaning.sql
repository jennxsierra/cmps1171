-- Standardize SaleDate
SELECT "SaleDate", CAST("SaleDate" AS DATE)
FROM "NashvilleHousing";

-- Update NULL values in PropertyAddress
SELECT *
FROM "NashvilleHousing"
WHERE "PropertyAddress" IS NULL;

SELECT a."ParcelID", a."PropertyAddress", b."ParcelID", b."PropertyAddress", COALESCE(a."PropertyAddress", b."PropertyAddress")
FROM "NashvilleHousing" a
JOIN "NashvilleHousing" b
	ON a."ParcelID" = b."ParcelID"
	AND a."UniqueID" != b."UniqueID"
WHERE a."PropertyAddress" IS NULL;

UPDATE "NashvilleHousing"
SET "PropertyAddress" = COALESCE(a."PropertyAddress", b."PropertyAddress")
FROM "NashvilleHousing" a
JOIN "NashvilleHousing" b
	ON a."ParcelID" = b."ParcelID"
	AND a."UniqueID" != b."UniqueID"
WHERE a."PropertyAddress" IS NULL;

-- Separating PropertyAddress into individual columns (Address, City, State)
SELECT "PropertyAddress"
FROM "NashvilleHousing";

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address
FROM "NashvilleHousing";