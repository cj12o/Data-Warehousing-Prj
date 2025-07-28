/*
===================================================================
DDL Script to drop existing tables and recreate tables.
Run this script tp redifine the DDL strucyure of 'bronze' tables
===================================================================
*/
DROP TABLE IF EXISTS bronze.crm_cust_info;--safe gaurd against redundant tbl error
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
/*
Note There is no way to work with COPY cmd in postgre Query tool ,so you need to use PSQL to run
the cmd for Bulk INSERT 
commands->


\COPY schema_name.tbl_name FROM 'file path' DELIMITER',' CSV Header


for reference see(https://www.postgresql.org/docs/current/sql-copy.html)
Reason => why copy cmd doesn't work with query tool is that it
\COPY is a psql meta-command that runs on the client side. It reads the file from your local machine and sends data to the server.
while in gui tools like pgAdmin ,the query is sent to server so file path needs to be on server .but that's not the case.


BUT THE BEST WAY WHICH I USED IS TO CREATE AND RUN BATCH FILE->load_csv.bat
