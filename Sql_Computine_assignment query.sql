use Competishun_assignment

select * from leads_basic_details
select * from sales_managers_assigned_leads_details
select * from leads_interaction_details
select * from leads_demo_watched_details
select * from leads_reasons_for_no_interest


select *  from
(
		select a.*,snr_sm_id,b.jnr_sm_id,assigned_date,cycle, lead_stage,call_done_date,call_status,call_reason 
		from leads_basic_details as a
			join sales_managers_assigned_leads_details as b 
		on a.lead_id = b.lead_id
			join leads_interaction_details as c 
		on b.jnr_sm_id = c.jnr_sm_id and b.lead_id = c.lead_id ) as k ;



select a.*,b.reasons_for_not_interested_in_demo,b.reasons_for_not_interested_to_consider,b.reasons_for_not_interested_to_convert
from leads_demo_watched_details as a
join leads_reasons_for_no_interest as b 
on a.lead_id = b.lead_id ;

---1.	Lead Journey and Stages: 

---a.	How many leads were generated in the given month?

select count(*) as Total_leads from leads_basic_details;

---b.	What is the distribution of leads across different age groups, genders, cities, education levels, and parent occupations? 

---i) Age wise
select 
		case when age >= 15 and age < 20 then  '15-20'
		when age >= 20 and age <= 25 then  '20-25'
		end as 'Age_Group', count(*) as Total
from leads_basic_details
group by 
		case when age >= 15 and age < 20 then  '15-20'
		when age >= 20 and age <= 25 then  '20-25' end ;

---ii) Gender wise 

select gender, count(*) as Total from leads_basic_details
group by gender ;

--- iii) cities wise

select current_city, count(*) as Total from leads_basic_details
group by current_city ;

--- iv) education wise

select current_education, count(*) as Total from leads_basic_details
group by current_education ;

--- v)  parent occupations wise 

select parent_occupation, count(*) as Total from leads_basic_details
group by parent_occupation ;


---c.	How many leads progressed from the lead stage to the awareness stage, consideration stage, and conversion stage?

select  lead_stage, count(lead_id) as total from
(
select *, ROW_NUMBER() over (partition by lead_id order by call_done_date desc) as rnk from leads_interaction_details
) as a
where rnk = 1 and lead_stage ! = 'lead'
group by lead_stage ;


---d.	What is the dropout rate at each stage of the customer acquisition flow? 

select lead_stage, round((total / 360) * 100 ,2) as Droupout_rate from 
(
select  lead_stage, cast (count(lead_id)as float)  total from
(
select *, ROW_NUMBER() over (partition by lead_id order by call_done_date desc) as rnk from leads_interaction_details
) as a
where rnk = 1 and lead_stage != 'lead'
group by lead_stage) as a ;


---e.	What are the reasons stated by leads for not being interested at each stage? 


---f.	How many leads watched the demo session? What percentage of the session did they watch? 

 select count(*)  as total_Watch from leads_demo_watched_details ;

---g.	What is the language preference of leads while watching the demo session?

select language, count(*) as Total from leads_demo_watched_details
group by language ;

--- Create new table with the combination of first three tables 


select * into basic_lead_manager_conversation_table from
(
select *  from
(
		select a.*,snr_sm_id,b.jnr_sm_id,assigned_date,cycle, lead_stage,call_done_date,call_status,call_reason 
		from leads_basic_details as a
			join sales_managers_assigned_leads_details as b 
		on a.lead_id = b.lead_id
			join leads_interaction_details as c 
		on b.jnr_sm_id = c.jnr_sm_id and b.lead_id = c.lead_id ) as k ) as d ;


---a.	How many leads were assigned to each junior sales manager in each cycle?

select cycle, count(*) as Total from sales_managers_assigned_leads_details
group by cycle

---b.	Which junior sales managers have the highest and lowest call success rates? 
---c.	How many calls were made by each junior sales manager?
---d.	What is the average duration between the lead assignment and the first call made by the junior sales manager? 
---e.	How many follow-up calls were made at each stage? 

select * from basic_lead_manager_conversation_table

---f.	What is the average call duration for successful calls?
