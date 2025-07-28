DROP TABLE IF EXISTS silver.crm_cust_info;--safe gaurd against redundant tbl error
CREATE TABLE silver.crm_cust_info(
cst_id INT,
cst_key VARCHAR(50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_marital_status VARCHAR(50),
cst_gender VARCHAR(50),
cst_create_date DATE,
dwh_date_created TIMESTAMP DEFAULT LOCALTIMESTAMP
);

DROP TABLE IF EXISTS silver.crm_product_info;
CREATE TABLE silver.crm_product_info(
prd_id INT,
cat_id VARCHAR(50),
prd_key VARCHAR(50),
prd_name VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_date_created TIMESTAMP DEFAULT LOCALTIMESTAMP
);

DROP TABLE IF EXISTS silver.crm_sales_detail;
CREATE TABLE silver.crm_sales_detail(
sls_ord_num VARCHAR(50),
sls_prd_key VARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales FLOAT,
sls_quantity INT,
sls_price FLOAT,
dwh_date_created TIMESTAMP DEFAULT LOCALTIMESTAMP
);

--Crm table creation
DROP TABLE IF EXISTS silver.erp_CUST_AZ12;
CREATE TABLE silver.erp_CUST_AZ12(
cid VARCHAR(50),
bdate DATE,
gen VARCHAR(50),
dwh_date_created TIMESTAMP DEFAULT LOCALTIMESTAMP
);

DROP TABLE IF EXISTS silver.erp_LOC_A101;
CREATE TABLE silver.erp_LOC_A101(
cid VARCHAR(50),
cntry VARCHAR(50),
dwh_date_created TIMESTAMP DEFAULT LOCALTIMESTAMP
);

DROP TABLE IF EXISTS silver.erp_PX_CAT_G1V2;
CREATE TABLE silver.erp_PX_CAT_G1V2(
id_ VARCHAR(50),
cat VARCHAR(50),
subcat VARCHAR(50),
maintenance  VARCHAR(50),
dwh_date_created TIMESTAMP DEFAULT LOCALTIMESTAMP
);
