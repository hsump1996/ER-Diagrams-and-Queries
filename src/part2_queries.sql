-- 1. Show the possible values of the year column in the country_stats table sorted by most recent year first.

select distinct year from country_stats order by year desc;

-- 2. Show the names of the first 5 countries in the database when sorted in alphabetical order by name.

select name from countries order by name asc;

-- 3. Adjust the previous query to show both the country name and the gdp from 2018, but this time show the top 5 countries by gdp.

select cs.gdp, c.name from countries c
inner join country_stats cs on c.country_id = cs.country_id
where cs.year = 2018
order by cs.gdp desc
limit 5;

-- 4. How many countries are associated with each region id?

select c.region_id, count(c.name) as country_count from countries c
inner join regions r on c.region_id = r.region_id
group by c.region_id
order by country_count desc;


-- 5. What is the average area of countries in each region id?

select c.region_id, round(avg(c.area)) as avg_area from countries c
inner join regions r on c.region_id = r.region_id
group by c.region_id
order by avg_area asc;


-- 6. Use the same query as above, but only show the groups with an average country area less than 1000

select c.region_id, round(avg(c.area)) as avg_area from countries c
inner join regions r on c.region_id = r.region_id
group by c.region_id
having round(avg(c.area)) < 1000
order by avg_area;

-- 7. Create a report displaying the name and population of every continent in the database from the year 2018 in millions.


select ct.name as name, round(sum(x.population)/1000000, 2) as tot_pop
from continents ct
inner join
    (select r.region_id, r.continent_id, sum(cs.population) as population
    from countries c
    inner join regions r on c.region_id = r.region_id
    inner join country_stats cs on c.country_id = cs.country_id
    where cs.year = 2018
    group by r.region_id)
as x on x.continent_id = ct.continent_id
group by name
order by tot_pop desc;


-- 8. List the names of all of the countries that do not have a language.


select c.name
from countries c
LEFT OUTER join country_languages cl on c.country_id = cl.country_id
where cl.language_id IS NULL;


-- 9. Show the country name and number of associated languages of the top 10 countries with most languages


select c.name, count(l.language_id) as lang_count
from countries c
inner join country_languages cl on c.country_id = cl.country_id
inner join languages l on cl.language_id = l.language_id
group by c.name
order by lang_count desc
limit 10;



-- 10. Repeat your previous query, but display a comma separated list of spoken languages rather than a count (use the aggregate function for strings, string_agg. 
-- A single example row (note that results before and above have been omitted for formatting):

select c.name,  string_agg(l.language, ',')
from countries c
inner join country_languages cl on c.country_id = cl.country_id
inner join languages l on cl.language_id = l.language_id
group by c.name
limit 10;


-- 11. What's the average number of languages in every country in a region in the dataset? Show both the region's name and the average. 
-- Make sure to include countries that don't have a language in your calculations. (Hint: using your previous queries and additional subqueries may be useful)


select r.name, round(avg(x.count), 1)  as avg_lang_count_per_country
from regions r
inner join
    (select c.region_id, c.country_id, count(cl.language_id) as count
        from countries c
        left outer join country_languages cl on c.country_id = cl.country_id
        group by c.country_id) as x on x.region_id = r.region_id
group by r.name
order by avg_lang_count_per_country desc;


-- 12. Show the country name and its "national day" for the country with the most recent national day and the country with the oldest national day. Do this with a single query. 
-- (Hint: both subqueries and UNION may be helpful here). The output may look like this:


(select name, national_day
from countries
where national_day IS NOT NULL
order by national_day desc
limit 1) UNION
(select name, national_day from countries
    where national_day IS NOT NULL
    order by national_day
    limit 1);