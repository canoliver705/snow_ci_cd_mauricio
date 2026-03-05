create or replace task task_bronze_customers
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 17 13 * * * America/Sao_Paulo'
as call load_bronze_customers();

-- Silver

create or replace task task_silver_customers
    warehouse = COMPUTE_WH
    after task_bronze_customers
as call load_silver_customers();

-- Gold

create or replace task task_gold_DIM_customers
    warehouse = COMPUTE_WH
    after task_silver_customers
as call load_gold_DIM_customers();