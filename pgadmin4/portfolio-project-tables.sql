-- Table: public.NashvilleHousing

-- DROP TABLE IF EXISTS public."NashvilleHousing";

CREATE TABLE IF NOT EXISTS public."NashvilleHousing"
(
    "UniqueID" integer NOT NULL,
    "ParcelID" text COLLATE pg_catalog."default",
    "LandUse" text COLLATE pg_catalog."default",
    "PropertyAddress" text COLLATE pg_catalog."default",
    "SaleDate" date,
    "SalePrice" numeric(10,2),
    "LegalReference" text COLLATE pg_catalog."default",
    "SoldAsVacant" boolean,
    "OwnerName" text COLLATE pg_catalog."default",
    "OwnerAddress" text COLLATE pg_catalog."default",
    "Acreage" numeric(10,2),
    "TaxDistrict" text COLLATE pg_catalog."default",
    "LandValue" numeric(10,2),
    "BuildingValue" numeric(10,2),
    "TotalValue" numeric(10,2),
    "YearBuilt" integer,
    "Bedrooms" integer,
    "FullBath" integer,
    "HalfBath" integer,
    CONSTRAINT "NashvilleHousing_pkey" PRIMARY KEY ("UniqueID")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."NashvilleHousing"
    OWNER to postgres;

copy "NashvilleHousing" from '/home/jsierra/ub-bint/2023-2/cmps1171/databases/portfolioproject/nashville-housing-data.csv' delimiter ',' csv header;