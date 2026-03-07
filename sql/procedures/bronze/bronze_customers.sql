create or replace procedure load_bronze_customers()
returns string
language SQL
as 
$$
begin

    truncate table bronze_customers;

    insert into bronze_customers
        select distinct        
            cast($1 as variant) as row_data,
            metadata$filename,
            current_timestamp creat_at          
        from @POC.PUBLIC.NORTH/customers/
        (FILE_FORMAT => 'POC.PUBLIC.PARQUET_FORMAT');

        return 'Tabela Bronze Customer Carregada com Sucesso';
end;
$$;
--aula arruda 2026-03-07