alter table reporting.combined_policy_data add row_num integer default -1, original_date timestamp default null;
alter table reporting.combined_policy_data add quote_key varchar(500) default '';
alter table reporting.combined_policy_data add max_created_date timestamp default null;
update reporting.combined_policy_data set original_date = null, row_num=-1, max_created_date = null;

update reporting.combined_policy_data x
set x.quote_key = 
       case
            when product_id in ('p_CarClassicGreenCombined', 'p_CarNewGermany','p_CarPowerTariff','p_YsMwxuaCF9RAcnDXTvkGwERF','p_YsMwxuaCF9RAcnDXTvkGwSWT')
                    then CONCAT(person_birthdate, person_address_postcode, object_vehicle_hsn, object_vehicle_tsn)
            when product_id in ('p_PrivateLiability', 'p_YsMwxuaCF9RAcnDXTvkGcwsssdPISW')
                    then CONCAT(product_private_liability_policyholder_birthdate, product_private_liability_number_insured_children, product_private_liability_number_insured_adults)
            when product_id in ('p_Household', 'p_YsMwxuaCF9RAcnDXTvkGcwPUSW')
                    then CONCAT(object_structure_home_size, product_household_policyholder_birthdate, object_structure_home_address_postcode)
            when product_id in ('p_CarCSuiteSwitzerland','p_CarSwitchSwitzerland')
                    then CONCAT(object_vehicle_driver_nationality,object_vehicle_driver_birthdate,object_vehicle_eurotax_id,object_vehicle_driver_address_postcode)
            when product_id in ('p_HomeCSuiteSwitzerland')
                    then CONCAT(product_home_policyholder_birthdate, product_home_number_of_adults,product_home_number_of_children,object_structure_home_address_postal_code, product_home_policyholder_nationality)       
       end
;


update reporting.combined_policy_data x
set x.row_num = y.row_num, x.max_created_date = y.max_created_date
from 
(
    select quote_key,created_date,
             dense_rank() over (partition by i.quote_key order by to_date(i.created_date)) as row_num,
             max(created_date) over (partition by i.quote_key order by to_date(i.created_date)) as max_created_date,
             oid
      from reporting.combined_policy_data i
) as y
where x.oid = y.oid;


-- original date logic... needs to run on a warehouse size M (Has been further optimized. On next rerun, start again from xs -> s -> m and update comment on minimum size reqd.)
update reporting.combined_policy_data x
set x.original_date = descendant.original_date
from
(with 
        x as (
            select distinct oid, quote_key, created_date, row_num, max_created_date 
              from reporting.combined_policy_data
        )
        ,descendant as ( select oid, quote_key, created_date, created_date as original_date, row_num, max_created_date 
                     from x where row_num = 1 and x.quote_key != ''
                   
                   union all
                     
                     select x.oid, x.quote_key, x.created_date,
                            case
                                when datediff('day', descendant.created_date ,x.created_date) > 30 then x.created_date
                                when datediff('day', descendant.original_date, x.created_date) > 60 then x.created_date
                                else descendant.original_date
                            end as original_date,
                            x.row_num, x.max_created_date 
                     from descendant, x
                     where x.row_num = descendant.row_num + 1 and x.quote_key = descendant.quote_key  and descendant.created_date = descendant.max_created_date  and x.quote_key != ''
                   
                   )
select oid, quote_key, created_date, original_date, row_num from descendant ) as descendant

where x.oid = descendant.oid and x.created_date = descendant.created_date
;


alter table reporting.combined_policy_data drop row_num, max_created_date;

