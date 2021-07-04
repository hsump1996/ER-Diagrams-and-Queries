COPY staging_caers_events (report_id, created_date, date_of_event, product_type, product, product_code, description, patient_age, age_units, sex, medra_preferred_terms, outcomes) 
FROM '/Users/sunpyohong/Desktop/Database Management/hsump1996-homework07/data/CAERS_ASCII_11_14_to_12_17.csv' (format csv, header, encoding 'LATIN1');;




COPY eatery (name, location, park_id, start_date, end_date, description, permit_number, phone, website, type_name) 
FROM '/Users/sunpyohong/Desktop/DPR_Eateries_001.json' (format json, header);;

