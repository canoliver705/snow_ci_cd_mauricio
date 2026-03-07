create or replace procedure load_silver_customers()
returns string
language SQL
as 
$$
begin
    truncate table silver_customers;
        insert into silver_customers(
            select 
                $1:"customer_id":: string as customer_id, 
                upper($1:"company_name":: string) as company_name,
                upper($1:"contact_name":: string) as contact_name,
                upper($1:"contact_title":: string) as contact_title,
                upper($1:"country":: string) as country,
                upper($1:"city":: string) as city,
                upper($1:"address":: string) as address,
                upper($1:"phone":: string) as phone,
                coalesce(upper($1:"postal_code":: string), 'N/A') as postal_code,
                filename,
                creat_at,
                current_user()
            from poc.dev.bronze_customers);
            return 'Tabela Silver Carregada com Sucesso';
end;
$$;
--aula arruda 2026-03-07