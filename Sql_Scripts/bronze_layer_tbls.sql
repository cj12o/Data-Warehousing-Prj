
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
cst_id INT,
cst_key VARCHAR(50),
cst_firstname VARCHAR(20),
cst_lastname VARCHAR(20),
cst_marital_status VARCHAR(2),
cst_gender VARCHAR(2),
cst_create_date DATE
);

DROP TABLE IF EXISTS bronze.crm_product_info;
CREATE TABLE bronze.crm_product_info(
prd_id INT,
prd_name VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(2),
prd_start_dt DATE,
prd_end_dt DATE
);

DROP TABLE IF EXISTS bronze.crm_sales_detail;
CREATE TABLE bronze.crm_sales_detail(
sls_ord_num VARCHAR(50),
sls_prd_key VARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales FLOAT,
sls_quantity INT,
sls_price FLOAT
);

--Crm table creation
DROP TABLE IF EXISTS bronze.erp_CUST_AZ12;
CREATE TABLE bronze.erp_CUST_AZ12(
cid VARCHAR(50),
bdate DATE,
gen VARCHAR(2)
);

DROP TABLE IF EXISTS bronze.erp_LOC_A101;
CREATE TABLE bronze.erp_LOC_A101(
cid VARCHAR(50),
cntry VARCHAR(50)
);

DROP TABLE IF EXISTS bronze.erp_PX_CAT_G1V2;
CREATE TABLE bronze.erp_PX_CAT_G1V2(
id_ VARCHAR(50),
cat VARCHAR(50),
subcat VARCHAR(50),
maintenance  VARCHAR(50)
)
