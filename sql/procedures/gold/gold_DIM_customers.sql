create or replace procedure load_gold_DIM_customers()
returns string
language SQL
as 
$$
begin
    merge into gold_dim_customers g
                using (
            
                select 
                    CUSTOMER_ID, 
                    COMPANY_NAME, 
                    CONTACT_NAME, 
                    CONTACT_TITLE, 
                    COUNTRY, 
                    CITY, 
                    ADDRESS, 
                    PHONE, 
                    POSTAL_CODE, 
                    md5(
                        nvl(COMPANY_NAME,'')    || '|' || 
                        nvl(CONTACT_NAME,'')    || '|' || 
                        nvl(CONTACT_TITLE,'')   || '|' ||  
                        nvl(COUNTRY,'')         || '|' || 
                        nvl(CITY,'')            || '|' ||
                        nvl(ADDRESS,'')         ||  '|' ||
                        nvl(PHONE,'')           || '|' || 
                        nvl(POSTAL_CODE,'')
                        ) as hash_diff
                from silver_customers
                ) s
            
                on g.customer_id = s.customer_id
            
                when matched 
                        and g.hash_diff != s.hash_diff then
                        update set 
                                g.COMPANY_NAME   = s.COMPANY_NAME,
                                g.CONTACT_NAME   = s.CONTACT_NAME,
                                g.CONTACT_TITLE  = s.CONTACT_TITLE,
                                g.COUNTRY        = s.COUNTRY,
                                g.CITY           = s.CITY,
                                g.ADDRESS        = s.ADDRESS, 
                                g.PHONE          = s.PHONE, 
                                g.POSTAL_CODE    = s.POSTAL_CODE, 
                                g.hash_diff      = s.hash_diff
                when not matched then
                    insert (
                        CUSTOMER_ID, 
                        COMPANY_NAME, 
                        CONTACT_NAME, 
                        CONTACT_TITLE, 
                        COUNTRY, 
                        CITY, 
                        ADDRESS, 
                        PHONE, 
                        POSTAL_CODE,
                        hash_diff
                    )
                values
                    (
                        s.CUSTOMER_ID, 
                        s.COMPANY_NAME, 
                        s.CONTACT_NAME, 
                        s.CONTACT_TITLE, 
                        s.COUNTRY, 
                        s.CITY, 
                        s.ADDRESS, 
                        s.PHONE, 
                        s.POSTAL_CODE,
                        s.hash_diff
                    );
            return 'Tabela Gold Carregada com Sucesso';
end;
$$;