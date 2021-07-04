DROP TABLE IF EXISTS staging_caers_events;

CREATE TABLE staging_caers_events (
    caers_event_id serial primary key,
    report_id varchar(255),
    created_date date,
    date_of_event date,
    product_type text,
    product text,
    product_code text,
    description text,
    patient_age integer,
    age_units text,
    sex text,
    medra_preferred_terms text,
    outcomes text
);

