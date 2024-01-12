    SELECT TOP (1000) [UniqueID]
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
    FROM [master].[dbo].[Nashville Housing Data]

    -- Standarizing date format
    SELECT * FROM [master].[dbo].[Nashville Housing Data]
    SELECT SaleDate, CONVERT(datetime,SaleDate)
    FROM [master].[dbo].[Nashville Housing Data]
    UPDATE [master].[dbo].[Nashville Housing Data]
    SET SaleDate = CONVERT(datetime,SaleDate)

    -- With different query
    SELECT SaleDate, CONVERT(datetime,SaleDate)
    FROM [master].[dbo].[Nashville Housing Data]

    ALTER [master].[dbo].[Nashville Housing Data]
    ADD SaleDate Datetime;

    UPDATE [master].[dbo].[Nashville Housing Data]
    SET SaleDate = CONVERT(datetime,SaleDate)

    -- Populating property address data
    SELECT * 
    FROM [master].[dbo].[Nashville Housing Data]
    WHERE PropertyAddress is NULL
    ORDER BY ParcelId
    Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
    From [master].[dbo].[Nashville Housing Data] a
    JOIN [master].[dbo].[Nashville Housing Data] b
    on a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
    Where a.PropertyAddress is null
    Update a
    SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
    From [master].[dbo].[Nashville Housing Data] a
    JOIN [master].[dbo].[Nashville Housing Data] b
        on a.ParcelID = b.ParcelID
        AND a.[UniqueID ] <> b.[UniqueID ]
    Where a.PropertyAddress is null

-- Breaking out Address into different columns
    Select PropertyAddress
    From [master].[dbo].[Nashville Housing Data]
    --Where PropertyAddress is null
    --order by ParcelID
    SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
    , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
    From [master].[dbo].[Nashville Housing Data]

    ALTER TABLE [Nashville Housing Data]
    Add PropertySplitAddress Nvarchar(255);

    Update [Nashville Housing Data]
    SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


    ALTER TABLE [Nashville Housing Data]
    Add PropertySplitCity Nvarchar(255);

    Update [Nashville Housing Data]
    SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

    Select *
    From [master].[dbo].[Nashville Housing Data]

    Select OwnerAddress
    From [master].[dbo].[Nashville Housing Data]

    Select
    PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
    ,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
    ,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
    From [master].[dbo].[Nashville Housing Data]

    ALTER TABLE [Nashville Housing Data]
    Add OwnerSplitAddress Nvarchar(255);

    Update [Nashville Housing Data]
    SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


    ALTER TABLE [Nashville Housing Data]
    Add OwnerSplitCity Nvarchar(255);

    Update [Nashville Housing Data]
    SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



    ALTER TABLE [Nashville Housing Data]
    Add OwnerSplitState Nvarchar(255);

    Update [Nashville Housing Data]
    SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


    Select *
    From [master].[dbo].[Nashville Housing Data]

-- Change Y and N to Yes and No in SoldVacant 

    Select Distinct(SoldAsVacant), Count(SoldAsVacant)
    From [master].[dbo].[Nashville Housing Data]
    Group by SoldAsVacant
    order by 2

    Select SoldAsVacant,
    CASE When SoldAsVacant = 'Y' THEN 'Yes'
    When SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END
    From [master].[dbo].[Nashville Housing Data]

    Update [Nashville Housing Data]
    SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
    When SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END

-- Removing Duplicates(Using Windows Function)
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

    From [master].[dbo].[Nashville Housing Data]
    --order by ParcelID
    )
        DELETE
        From RowNumCTE
        Where row_num > 1
        --Order by PropertyAddress
    SELECT *
    From RowNumCTE
    Where row_num > 1
    --Order by PropertyAddress


    Select *
    From [master].[dbo].[Nashville Housing Data]

-- Delete Unused Columns
Select *
From [master].[dbo].[Nashville Housing Data]


ALTER TABLE [master].[dbo].[Nashville Housing Data]
DROP COLUMN OwnerAddress, TaxDistrict


















