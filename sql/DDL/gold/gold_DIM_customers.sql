-- teste tarde3
create table POC.DEV.gold_DIM_customers (
                customer_sk bigint autoincrement,
                customer_id varchar(20),
                company_name varchar(100),
                contact_name varchar(200),
                contact_title varchar(100),
                address varchar(300),
                city varchar(100),
                postal_code varchar(100),
                country varchar(100),
                phone varchar(100),
                fax varchar(100),          
                hash_diff varchar(300),
                creat_at timestamp_ntz default current_timestamp());