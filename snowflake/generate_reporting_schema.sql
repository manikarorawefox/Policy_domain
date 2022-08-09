
use database "POLICY__NEXUS";
--Create Schema reporting;


CREATE or replace TABLE reporting.calculations AS
select
    json_string:_id."$oid"::STRING as oid,
    to_timestamp(json_string:created_date."$date"::bigint/1000) as 
created_date,
    to_timestamp(json_string:last_modified_date."$date"::bigint/1000) as 
last_modified_date,
    json_string:premium_with_tax::float as calculated_premium,
    json_string:product_id::string as product_id,
    json_string:product_version::string as product_version,
    json_string:currency::string as currency,
    json_string:payment_frequency::string as payment_frequency
from
    KOBLE_EE3CBF3C_3690_4547_B51D_61F79659ACE6.calculations
where created_date >= '2021-09-01';
    
 
create or replace table reporting.products as
select distinct
    json_string:_id."$oid"::STRING as oid,
    json_string:country::STRING as country,
    json_string:product_group::STRING as product_group,
    json_string:external_id::STRING as external_id
from 
    KOBLE_EE3CBF3C_3690_4547_B51D_61F79659ACE6.products;
    

create or replace table reporting.calculations_inputs as
select * 
  from 
  (
    select
        json_string:_id."$oid"::STRING as oid,
        inp.value:name::string as name,
        inp.value:value::string as _value
    from 
        KOBLE_EE3CBF3C_3690_4547_B51D_61F79659ACE6.calculations, 
        lateral flatten(input => json_string:inputs) inp
  ) calc_inputs
    pivot(LISTAGG(_value) for name in 
('object.vehicle.usage-type','product.household.coverage.elemental-damages.is-included',
                                       
'product.household.coverage.mobility.is-included','premium_with_tax','car.vehicle.driver.youngest.age'
                                       
,'product.household.calculated-sum-insured','product.household.policyholder.birthdate',
                                       
'product.household.coverage.theft-away-valuables.sum-insured','car.package','product.household.coverage.theft-away.sum-insured',
                                       
'car.product-type','product.private-liability.deductible','product.private-liability.coverage.keyloss-office.is-included',
                                       
'product.motor.coverage.passenger-cover.is-included','person.address.postcode','product.motor.coverage.comprehensive.fully.deductible',
                                       
'product.motor.coverage.liability.first-party-damage.is-included','product.household.jewelry.sum-insured',
                                       
'product.home.number-of-children','product.household.coverage.valuables.sum-insured','object.vehicle.hsn',
                                       
'product.private-liability.number-insured-children','car.vehicle-liability.no-claim-discount','object.vehicle.yearly-mileage',
                                       
'object.vehicle.driver.residence-permit.type','product.household.coverage.glass-damage.is-included','object.previous-insurer',
                                       
'object.vehicle.tsn','car.variable-commission-rate','object.vehicle.driver.driving-license.loss',
                                       
'object.structure.home.address.canton','object.vehicle.insured.first.date','car.fully-comprehensive.deductible',
                                       
'product.household.coverage.bicycle-theft.is-included','payment_frequency','car.fully-comprehensive.no-claim-discoun',
                                       
'car.new-value-compensation.yes','product.home.package','product.private-liability.previous-claims-number',
                                       
'car.vehicle-liability.deductibl','product.private-liability.coverage.sum-insured',
                                       
'product.motor.coverage.comprehensive.partial.personal-effects.is-included','car.vehicle.driver.other',
                                       
'product.home.policyholder.nationality','product.household.furnishing-standard','object.structure.home.address.postcode',
                                       
'product.motor.previous-claims-number','object.vehicle.first-registration',
                                       
'product.private-liability.coverage.foreign-vehicle.is-included','product.home.product-type',
                                       
'product.motor.coverage.liability.deductible','object.vehicle.driver.driving-license.issue-date',
                                       
'car.assistance.yes','object.vehicle.driver.birthdate','product.motor.no-claims-discount-liability.level',
                                       
'product.household.previous-claims-number','car.start-date','object.vehicle.eurotax-id',
                                       
'product.private-liability.number-insured-adults','product.private-liability.package',
                                       
'object.special-equipment-vehicle.value','product.home.policyholder.birthdate','object.vehicle.registration.first.date',
                                       
'car.gap-coverage.yes','product.household.coverage.theft-away-valuables.is-included','car.partial-comprehensive.deductible',
                                       
'product.motor.coverage.comprehensive.fully.parking-damage.is-included','product.household.number-of-rooms',
                                       
'product.household.coverage.glass-bathroom.sum-insured','product.private-liability.policyholder.birthdate',
                                       
'product.household.deductible','object.new-registration.yes','product.household.coverage.glass-building.sum-insured',
                                       
'object.vehicle.driver.gender','object.structure.home.address.postal-code','product.household.underinsurance.is-included',
                                       
'product.home.multiple-persons-included','product.household.package','product.motor.product-type','product.motor.package',
                                       
'product.motor.previous-policy-cancellation-insurer','object.vehicle.first-registration-by-policyholder',
                                       
'car.new-valuecompensation.yes','product.motor.coverage.comprehensive.gross-negligence.is-included',
                                       
'product.motor.no-claims-discount-comprehensive-fully.level','product.private-liability.coverage.gross-negligence.is-included',
                                       
'car.part-replacement.deductible.yes','product.household.coverage.glass-furniture.sum-insured',
                                       
'product.household.coverage.bicycle-theft.sum-insured','object.vehicle.driver.address.postcode',
                                       
'product.motor.coverage.vehicle-assistance.is-included','product.home.policyholder.previous-insurer.canceled',
                                       
'product.household.vacation-house','product.household.chosen-sum-insured','product.household.coverage.sum-insured',
                                       
'car.garage-binding.yes','product.motor.coverage.comprehensive.partial.deductible','car.abroad-protection.yes',
                                       
'car.driver-protection.yes','person.birthdate','car.better-performance-guarantee.yes','product.home.number-of-adults',
                                       
'product.household.elemental-sum-insured','object.vehicle.driver.nationality','car.vehicle.kilometers.yearly',
                                       
'product.motor.coverage.discount-protection.is-included','product.motor.coverage.comprehensive.compensation-new-value.is-included',
                                       
'product.motor.coverage.comprehensive.glass-damage-extended.is-included','product.home.policyholder.residence-permit.type',
                                       
'product.home.policyholder.previous-insurer.rejected','object.structure.home.size','object.policy-number-previous-insurance',
                                       
'car.discount-protection.yes','product.home.ownership','product.motor.coverage.comprehensive.fully.parking-damage.sum-insured'))
      as p(oid,
           
object_vehicle_usage_type,product_household_coverage_elemental_damages_is_included,product_household_coverage_mobility_is_included,premium_with_tax,
           
car_vehicle_driver_youngest_age,product_household_calculated_sum_insured,product_household_policyholder_birthdate,
           
product_household_coverage_theft_away_valuables_sum_insured,car_package,product_household_coverage_theft_away_sum_insured,
           
car_product_type,product_private_liability_deductible,product_private_liability_coverage_keyloss_office_is_included,
           
product_motor_coverage_passenger_cover_is_included,person_address_postcode,product_motor_coverage_comprehensive_fully_deductible,
           
product_motor_coverage_liability_first_party_damage_is_included,product_household_jewelry_sum_insured,product_home_number_of_children,
           
product_household_coverage_valuables_sum_insured,object_vehicle_hsn,product_private_liability_number_insured_children,
           
car_vehicle_liability_no_claim_discount,object_vehicle_yearly_mileage,object_vehicle_driver_residence_permit_type,
           
product_household_coverage_glass_damage_is_included,object_previous_insurer,object_vehicle_tsn,car_variable_commission_rate,
           
object_vehicle_driver_driving_license_loss,object_structure_home_address_canton,object_vehicle_insured_first_date,
           
car_fully_comprehensive_deductible,product_household_coverage_bicycle_theft_is_included,payment_frequency,
           
car_fully_comprehensive_no_claim_discoun,car_new_value_compensation_yes,product_home_package,product_private_liability_previous_claims_number,
           
car_vehicle_liability_deductibl,product_private_liability_coverage_sum_insured,product_motor_coverage_comprehensive_partial_personal_effects_is_included,
           
car_vehicle_driver_other,product_home_policyholder_nationality,product_household_furnishing_standard,object_structure_home_address_postcode,
           
product_motor_previous_claims_number,object_vehicle_first_registration,product_private_liability_coverage_foreign_vehicle_is_included,product_home_product_type,
           
product_motor_coverage_liability_deductible,object_vehicle_driver_driving_license_issue_date,car_assistance_yes,object_vehicle_driver_birthdate,
           
product_motor_no_claims_discount_liability_level,product_household_previous_claims_number,car_start_date,object_vehicle_eurotax_id,
           
product_private_liability_number_insured_adults,product_private_liability_package,object_special_equipment_vehicle_value,product_home_policyholder_birthdate,
           
object_vehicle_registration_first_date,car_gap_coverage_yes,product_household_coverage_theft_away_valuables_is_included,car_partial_comprehensive_deductible,
           
product_motor_coverage_comprehensive_fully_parking_damage_is_included,product_household_number_of_rooms,product_household_coverage_glass_bathroom_sum_insured,
           
product_private_liability_policyholder_birthdate,product_household_deductible,object_new_registration_yes,product_household_coverage_glass_building_sum_insured,
           
object_vehicle_driver_gender,object_structure_home_address_postal_code,product_household_underinsurance_is_included,product_home_multiple_persons_included,
           
product_household_package,product_motor_product_type,product_motor_package,product_motor_previous_policy_cancellation_insurer,
           
object_vehicle_first_registration_by_policyholder,car_new_valuecompensation_yes,product_motor_coverage_comprehensive_gross_negligence_is_included,
           
product_motor_no_claims_discount_comprehensive_fully_level,product_private_liability_coverage_gross_negligence_is_included,car_part_replacement_deductible_yes,
           
product_household_coverage_glass_furniture_sum_insured,product_household_coverage_bicycle_theft_sum_insured,object_vehicle_driver_address_postcode,
           
product_motor_coverage_vehicle_assistance_is_included,product_home_policyholder_previous_insurer_canceled,product_household_vacation_house,
           
product_household_chosen_sum_insured,product_household_coverage_sum_insured,car_garage_binding_yes,product_motor_coverage_comprehensive_partial_deductible,
           
car_abroad_protection_yes,car_driver_protection_yes,person_birthdate,car_better_performance_guarantee_yes,product_home_number_of_adults,
           
product_household_elemental_sum_insured,object_vehicle_driver_nationality,car_vehicle_kilometers_yearly,product_motor_coverage_discount_protection_is_included,
           
product_motor_coverage_comprehensive_compensation_new_value_is_included,product_motor_coverage_comprehensive_glass_damage_extended_is_included,
           
product_home_policyholder_residence_permit_type,product_home_policyholder_previous_insurer_rejected,object_structure_home_size,
           
object_policy_number_previous_insurance,car_discount_protection_yes,product_home_ownership,
           
product_motor_coverage_comprehensive_fully_parking_damage_sum_insured);

create or replace table reporting.calculations_coverages as
select * 
  from 
  (
    select
        json_string:_id."$oid"::STRING as oid,
        inp.value:name::string as name,
        inp.value:value::string as _value
    from 
        KOBLE_EE3CBF3C_3690_4547_B51D_61F79659ACE6.calculations, 
        lateral flatten(input => json_string:inputs) inp
  ) calc_coverages
    pivot(LISTAGG(_value) for name in ('name','value'))
      as p(oid,coverage_name,coverage_value);
      
create or replace table reporting.calculations_insurance_lines as
select * 
  from 
  (
    select
        json_string:_id."$oid"::STRING as oid,
        inp.value:name::string as name,
        inp.value:value::string as _value
    from 
        KOBLE_EE3CBF3C_3690_4547_B51D_61F79659ACE6.calculations, 
        lateral flatten(input => json_string:inputs) inp
  ) calc_coverages
    pivot(LISTAGG(_value) for name in ('id'))
      as p(oid,insurance_lines_id);


create or replace table reporting.calculations_premium_breakdown as
select * 
  from 
   (
     select
        json_string:_id."$oid"::STRING as oid,
        inp.value:premium_with_tax::float as premium_with_tax,
        inp.value:type::string as type
     from 
        KOBLE_EE3CBF3C_3690_4547_B51D_61F79659ACE6.calculations, 
        lateral flatten(input => json_string:premium_breakdown) inp
   ) temp_calculations_premium_breakdown
    pivot(max(premium_with_tax) for type in 
('Liability','Comprehensive','Fully Comprehensive', 'Passenger 
Cover','Coverage vehicle liability','Glass coverage',
                                                 'Elemental 
damage','Vandalism and socio-political events','Motor legal protection - 
Base up to 10.000€','Gross Negligence',
                                                 'Motor legal protection - 
Premium up to 30.000€','Kasko','Household','Fire/Theft in case of 
suspended policy',
                                                 'Fire, theft and robbery 
(FTR)','Road assistance','Waiver of recourse','Assistance','New value 
compensation','Partial Comprehensive',
                                                 'Private 
Liability','Damages in case of fire - extension Third party fire 
recourse','IC coverage'))
      as p(oid,liability,comprehensive,fully_comprehensive,passenger_cover 
,coverage_vehicle_liability ,glass_coverage ,
           elemental_damage ,vandalism_and_socio_political_events 
,motor_legal_protection_base_up_to_10000 ,gross_negligence ,
           motor_legal_protection_premium_up_to_30000 ,kasko ,household 
,fire_theft_in_case_of_suspended_policy ,
           fire_theft_and_robbery_ftr ,road_assistance ,waiver_of_recourse 
,assistance ,new_value_compensation ,partial_comprehensive ,
           private_liability 
,damages_in_case_of_fire_extension_third_party_fire_recourse ,ic_coverage 
);

CREATE or replace TABLE reporting.contracts AS
select
    json_string:_id."$oid"::STRING as oid,
    json_string:calculation."$oid"::STRING as calculation_oid,
    to_timestamp(json_string:created_date."$date"::bigint/1000) as 
converted_date
from
    KOBLE_EE3CBF3C_3690_4547_B51D_61F79659ACE6.contracts;
    

create or replace table reporting.combined_policy_data as
select   
  Ca.OID,
  Ca.CREATED_DATE,
  Ca.CALCULATED_PREMIUM,
  Ca.PRODUCT_ID,
  Pr.COUNTRY,
  Pr.PRODUCT_GROUP,
  
object_vehicle_usage_type,product_household_coverage_elemental_damages_is_included,product_household_coverage_mobility_is_included,premium_with_tax,
           
car_vehicle_driver_youngest_age,product_household_calculated_sum_insured,product_household_policyholder_birthdate,
           
product_household_coverage_theft_away_valuables_sum_insured,car_package,product_household_coverage_theft_away_sum_insured,
           
car_product_type,product_private_liability_deductible,product_private_liability_coverage_keyloss_office_is_included,
           
product_motor_coverage_passenger_cover_is_included,person_address_postcode,product_motor_coverage_comprehensive_fully_deductible,
           
product_motor_coverage_liability_first_party_damage_is_included,product_household_jewelry_sum_insured,product_home_number_of_children,
           
product_household_coverage_valuables_sum_insured,object_vehicle_hsn,product_private_liability_number_insured_children,
           
car_vehicle_liability_no_claim_discount,object_vehicle_yearly_mileage,object_vehicle_driver_residence_permit_type,
           
product_household_coverage_glass_damage_is_included,object_previous_insurer,object_vehicle_tsn,car_variable_commission_rate,
           
object_vehicle_driver_driving_license_loss,object_structure_home_address_canton,object_vehicle_insured_first_date,
           
car_fully_comprehensive_deductible,product_household_coverage_bicycle_theft_is_included,CaI.payment_frequency 
as payment_frequency_input,
           
car_fully_comprehensive_no_claim_discoun,car_new_value_compensation_yes,product_home_package,product_private_liability_previous_claims_number,
           
car_vehicle_liability_deductibl,product_private_liability_coverage_sum_insured,product_motor_coverage_comprehensive_partial_personal_effects_is_included,
           
car_vehicle_driver_other,product_home_policyholder_nationality,product_household_furnishing_standard,object_structure_home_address_postcode,
           
product_motor_previous_claims_number,object_vehicle_first_registration,product_private_liability_coverage_foreign_vehicle_is_included,product_home_product_type,
           
product_motor_coverage_liability_deductible,object_vehicle_driver_driving_license_issue_date,car_assistance_yes,object_vehicle_driver_birthdate,
           
product_motor_no_claims_discount_liability_level,product_household_previous_claims_number,car_start_date,object_vehicle_eurotax_id,
           
product_private_liability_number_insured_adults,product_private_liability_package,object_special_equipment_vehicle_value,product_home_policyholder_birthdate,
           
object_vehicle_registration_first_date,car_gap_coverage_yes,product_household_coverage_theft_away_valuables_is_included,car_partial_comprehensive_deductible,
           
product_motor_coverage_comprehensive_fully_parking_damage_is_included,product_household_number_of_rooms,product_household_coverage_glass_bathroom_sum_insured,
           
product_private_liability_policyholder_birthdate,product_household_deductible,object_new_registration_yes,product_household_coverage_glass_building_sum_insured,
           
object_vehicle_driver_gender,object_structure_home_address_postal_code,product_household_underinsurance_is_included,product_home_multiple_persons_included,
           
product_household_package,product_motor_product_type,product_motor_package,product_motor_previous_policy_cancellation_insurer,
           
object_vehicle_first_registration_by_policyholder,car_new_valuecompensation_yes,product_motor_coverage_comprehensive_gross_negligence_is_included,
           
product_motor_no_claims_discount_comprehensive_fully_level,product_private_liability_coverage_gross_negligence_is_included,car_part_replacement_deductible_yes,
           
product_household_coverage_glass_furniture_sum_insured,product_household_coverage_bicycle_theft_sum_insured,object_vehicle_driver_address_postcode,
           
product_motor_coverage_vehicle_assistance_is_included,product_home_policyholder_previous_insurer_canceled,product_household_vacation_house,
           
product_household_chosen_sum_insured,product_household_coverage_sum_insured,car_garage_binding_yes,product_motor_coverage_comprehensive_partial_deductible,
           
car_abroad_protection_yes,car_driver_protection_yes,person_birthdate,car_better_performance_guarantee_yes,product_home_number_of_adults,
           
product_household_elemental_sum_insured,object_vehicle_driver_nationality,car_vehicle_kilometers_yearly,product_motor_coverage_discount_protection_is_included,
           
product_motor_coverage_comprehensive_compensation_new_value_is_included,product_motor_coverage_comprehensive_glass_damage_extended_is_included,
           
product_home_policyholder_residence_permit_type,product_home_policyholder_previous_insurer_rejected,object_structure_home_size,
           
object_policy_number_previous_insurance,car_discount_protection_yes,product_home_ownership,
           
product_motor_coverage_comprehensive_fully_parking_damage_sum_insured,
  
CapD.liability,CaPD.comprehensive,CaPD.fully_comprehensive,CaPD.passenger_cover 
,CaPD.coverage_vehicle_liability ,CaPD.glass_coverage ,
  CaPD.elemental_damage ,CaPD.vandalism_and_socio_political_events 
,CaPD.motor_legal_protection_base_up_to_10000 ,CaPD.gross_negligence ,
  CaPD.motor_legal_protection_premium_up_to_30000 ,CaPD.kasko 
,CaPD.household ,CaPD.fire_theft_in_case_of_suspended_policy ,
  CaPD.fire_theft_and_robbery_ftr ,CaPD.road_assistance 
,CaPD.waiver_of_recourse ,CaPD.assistance ,CaPD.new_value_compensation ,
  CaPD.partial_comprehensive ,CaPD.private_liability 
,CaPD.damages_in_case_of_fire_extension_third_party_fire_recourse 
,CaPD.ic_coverage,
  CaC.COVERAGE_NAME,
  CaC.COVERAGE_VALUE
from reporting.calculations Ca
left join reporting.products Pr on Ca.product_id = Pr.external_id
left join reporting.calculations_inputs CaI on Ca.oid = CaI.oid
left join reporting.calculations_premium_breakdown CaPD on Ca.oid = 
CaPD.oid
left join reporting.calculations_coverages CaC on Ca.oid = CaC.oid;

-- logic for flag_converted, converted_date, flag_converted_same_day, 
calculated_premium_converted

ALTER TABLE reporting.combined_policy_data ADD flag_converted int NOT NULL 
DEFAULT (0);
ALTER TABLE reporting.combined_policy_data ADD converted_date timestamp 
DEFAULT NULL;
alter table reporting.combined_policy_data add flag_converted_same_day int 
default(0), calculated_premium_converted float default null;

UPDATE reporting.combined_policy_data CPD
SET CPD.flag_converted = 1, CPD.converted_date = Co.converted_date, 
CPD.calculated_premium_converted = CPD.calculated_premium 
--calculated_premium_converted is not null if flag_converted is 1
FROM reporting.contracts Co WHERE CPD.oid = Co.CALCULATION_OID;

update reporting.combined_policy_data CPD
set flag_converted_same_day = 1
where flag_converted = 1 and to_date(converted_date) = 
to_date(created_date);
