DROP TABLE IF EXISTS report;

CREATE TABLE report (
    report_id integer primary key,
    created_date date,
    date_of_event date,
    patient_age integer,
    age_units VARCHAR(100),
    sex VARCHAR(50),
);

DROP TABLE IF EXISTS symptom;

CREATE TABLE symptom (
    symptom_id serial primary key,
    medra_preferred_terms text,
);


DROP TABLE IF EXISTS report_symptom_link;

CREATE TABLE report_symptom_link (
    symptom_id serial primary key REFERENCES symptom (symptom_id),
    report_id integer REFERENCES report (report_id)
);


DROP TABLE IF EXISTS product_desrip;

CREATE TABLE product_desrip (
    product_code integer,
    description varchar(200)
);

DROP TABLE IF EXISTS product;

CREATE TABLE product (
    product_id serial primary key,
    product varchar(200),
    product_code integer REFERENCES product_desrip(product_code)
);

DROP TABLE IF EXISTS report_product_link;

CREATE TABLE report_product_link (
    report_product_id serial primary key,
    product_id serial REFERENCES product(product_id),
    report_id integer REFERENCES report(report_id),
    product_type varchar(100)
);

DROP TABLE IF EXISTS outcomes;

CREATE TABLE report_product_link (
    outcome_id serial primary key,
    outcomes text
);


DROP TABLE IF EXISTS outcomes_report_link;

CREATE TABLE report_product_link (
    outcome_id serial primary key REFERENCES outcomes(outcome_id),
    report_id integer REFERENCES report(report_id)
);