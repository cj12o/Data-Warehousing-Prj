CREATE OR REPLACE PROCEDURE silver.load_silver() 
LANGUAGE plpgsql
AS $$
BEGIN 
	BEGIN 
		TRUNCATE TABLE silver.crm_cust_info;
		RAISE NOTICE 'truncated silver.crm_cust_info';
		--insert

		INSERT INTO silver.crm_cust_info(cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gender,cst_create_date)
		SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE
			WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
			WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
			ELSE 'n/a'
		END AS cst_marital_status,
		CASE 
			WHEN UPPER(TRIM(cst_gender))='F' THEN 'Female'
			WHEN UPPER(TRIM(cst_gender))='M' THEN  'Male'
			ELSE 'n/a'
		END AS cst_gender,
		cst_create_date
		FROM(
		SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY cst_id Order by cst_create_date DESC) AS latest
		FROM bronze.crm_cust_info) as sbq1
		WHERE latest=1;
		
		RAISE NOTICE 'Inserted data into  silver.crm_cust_info';
		---
	EXCEPTION 
		WHEN undefined_table THEN 
			RAISE NOTICE 'undefined table,skipping insertion in table silver.crm_cust_info';
	END;
	------------------------------------------------------------------------------------------
	BEGIN
		TRUNCATE TABLE silver.crm_product_info;
		RAISE NOTICE 'truncated silver.crm_product_info';
		--insert 
		INSERT INTO silver.crm_product_info(
		prd_id,
		cat_id,
		prd_key,
		prd_name,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt)
		SELECT 
		prd_id,
		SUBSTRING(prd_key,1,2)||'_'|| SUBSTRING(prd_key,4,2) AS cat_id,
		SUBSTRING(prd_key,7,LENGTH(prd_key)-6) AS prd_key,
		prd_name,
		COALESCE(prd_cost,0) AS prd_cost,
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			Else 'n/a'
		END AS prd_line,
		prd_start_dt,
		CASE 
			WHEN prd_end_dt<prd_start_dt THEN
			LEAD(prd_start_dt,1) OVER(PARTITION BY prd_name ORDER BY prd_start_dt) -1 
			ELSE prd_end_dt
		END AS prd_end_dt
		FROM  bronze.crm_product_info;

		RAISE NOTICE 'Inserted data into  silver.crm_product_info';
		---
	EXCEPTION 
		WHEN undefined_table THEN 
			RAISE NOTICE 'undefined table,skipping insertion in table silver.crm_product_info';
	END;
	------------------------------------------------------------------------------------------
	BEGIN	
		TRUNCATE TABLE silver.crm_sales_detail;
		RAISE NOTICE 'truncated silver.crm_sales_detail';	
		--insert
		INSERT INTO silver.crm_sales_detail(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id ,
		sls_order_dt,
		sls_ship_dt ,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price)
		SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE 
			WHEN LENGTH(CAST(sls_order_dt AS VARCHAR))=8 
			THEN TO_DATE(CAST(sls_order_dt AS VARCHAR),'YYYYMMDD')
			ELSE null
		END AS sls_order_dt, 
		CASE 
			WHEN LENGTH(CAST(sls_ship_dt AS VARCHAR))=8 
			THEN TO_DATE(CAST(sls_ship_dt AS VARCHAR),'YYYYMMDD')
			ELSE null
		END AS sls_ship_dt,
		CASE 
			WHEN LENGTH(CAST(sls_due_dt AS VARCHAR))=8 
			THEN TO_DATE(CAST(sls_due_dt AS VARCHAR),'YYYYMMDD')
			ELSE null
		END AS sls_due_dt,
		CASE 
			WHEN sls_sales<=0 OR sls_sales IS NULL OR sls_sales!=sls_quantity* ABS(sls_price)
				THEN ABS(sls_price)*sls_quantity
			ELSE sls_sales
		END AS sls_sales,
		sls_quantity,
		CASE 
			WHEN sls_price<=0 OR sls_price IS NULL THEN sls_sales/NULLIF(sls_quantity,0)
			ELSE sls_price
		END AS sls_price
		FROM bronze.crm_sales_detail; 

		RAISE NOTICE 'Inserted data into  silver.crm_sales_details';
		---
	EXCEPTION 
	WHEN undefined_table THEN 
			RAISE NOTICE 'undefined table,skipping insertion in table silver.crm_sales_detail';
	END;
	------------------------------------------------------------------------------------------
	BEGIN
		TRUNCATE TABLE  silver.erp_cust_az12;
		RAISE NOTICE 'truncated silver.erp_cust_az12';
		--insert
		INSERT INTO silver.erp_cust_az12(
		cid,
		bdate,
		gen
		)
		SELECT 
		CASE 
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid))
			ELSE cid
		END AS cid,
		CASE
			WHEN bdate>CURRENT_DATE THEN NULL
			ELSE bdate
		END AS bdate,
		CASE 
			WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
			WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female' 
			ELSE 'n/a'
		END AS gen
		FROM bronze.erp_cust_az12;
		
		RAISE NOTICE 'Inserted data into  silver.erp_cust_az12';
		
		----
	EXCEPTION 
		WHEN undefined_table THEN 
			RAISE NOTICE 'undefined table,skipping insertion in table silver.erp_cust_az12';
	END;
	------------------------------------------------------------------------------------------
	BEGIN
		TRUNCATE TABLE silver.erp_loc_a101;
		RAISE NOTICE 'truncated silver.erp_loc_a101';
		--insert
		INSERT INTO silver.erp_loc_a101(
		cid,
		cntry
		)
		SELECT 
		REPLACE(cid,'-','') AS cid,
		CASE 
			WHEN TRIM(cntry)='DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
			WHEN TRIM(cntry)='' THEN 'n/a'
			ELSE COALESCE(TRIM(cntry),'n/a')
		END AS cntry
		FROM bronze.erp_loc_a101;

		RAISE NOTICE 'Inserted data into  silver.erp_loc_a101';
		----
	EXCEPTION
		WHEN undefined_table THEN 
			RAISE NOTICE 'undefined table,skipping insertion in table silver.erp_loc_a101';
	END;
	------------------------------------------------------------------------------------------
	BEGIN
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		RAISE NOTICE 'truncated silver.erp_px_cat_g1v2';
		--insert
		INSERT INTO silver.erp_px_cat_g1v2(
		id_,
		cat,
		subcat,
		maintenance
		)
		SELECT 
		id_,
		cat,
		subcat,
		maintenance
		FROM bronze.erp_px_cat_g1v2;

		RAISE NOTICE 'Inserted data into  silver.erp_px_cat_g1v2';
		----
	EXCEPTION
		WHEN undefined_table THEN 
			RAISE NOTICE 'undefined table,skipping insertion in table silver.erp_px_cat_g1v2';
	END;
END;
$$;


--call silver.load_silver()  to call the procedure
