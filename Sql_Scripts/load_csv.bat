@echo off
call load_csv_var.bat

SET start_time=%TIME%
echo start time %start_time%

%postgre_bin_path% -d DWH -c "TRUNCATE bronze.crm_cust_info;"
%postgre_bin_path% -d DWH -c "\COPY bronze.crm_cust_info FROM %crm_cust_info_csv_path% DELIMITER ',' CSV HEADER;"

echo load data in crm_cust_info completed.

%postgre_bin_path% -d DWH -c "TRUNCATE bronze.crm_product_info;"
%postgre_bin_path% -d DWH -c "\COPY bronze.crm_product_info FROM %crm_prd_info_csv_path% DELIMITER ',' CSV HEADER;"

echo load data in crm_product_info completed.

%postgre_bin_path% -d DWH -c "TRUNCATE bronze.crm_sales_detail;"
%postgre_bin_path% -d DWH -c "\COPY bronze.crm_sales_detail FROM %crm_sales_details_csv_path% DELIMITER ',' CSV HEADER;"

echo load data in crm_sales_detail completed.


%postgre_bin_path% -d DWH -c "TRUNCATE bronze.erp_cust_az12;"
%postgre_bin_path% -d DWH -c "\COPY bronze.erp_cust_az12 FROM %erp_cust_az12_csv_path% DELIMITER ',' CSV HEADER;"

echo load data in erp_cust_az12 completed.

%postgre_bin_path% -d DWH -c "TRUNCATE bronze.erp_loc_a101;"
%postgre_bin_path% -d DWH -c "\COPY bronze.erp_loc_a101 FROM %erp_loc_a101_csv_path% DELIMITER ',' CSV HEADER;"

echo load data in erp_loc_a101 completed.

%postgre_bin_path% -d DWH -c "TRUNCATE bronze.erp_px_cat_g1v2;"
%postgre_bin_path% -d DWH -c "\COPY bronze.erp_px_cat_g1v2 FROM %erp_px_cat_g1v2_csv_path% DELIMITER ',' CSV HEADER;"

echo load data in erp_px_cat_g1v2 completed.

SET end_time=%TIME%
echo end time %end_time%

pause

