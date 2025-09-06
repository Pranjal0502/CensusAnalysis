select * from dataset1;
select * from dataset2;

-- Average Literacy --
select avg(Literacy) as Avg_Literacy from dataset1;

-- State and districtwise area --
select District, State, Area_km2 
from dataset2
where Area_km2 < '12,000';

-- States by Average growth --
select State, round(avg(Growth),2) as Avg_Growth
from dataset1
group by State;

-- States by Average Sex Ratio --
select State, round(avg(Sex_Ratio),0) as Avg_Sex_Ratio
from dataset1
group by State
having Avg_Sex_Ratio > 1000
order by Avg_Sex_Ratio DESC;

-- States by Population --
select State, round(avg(Population),0) as Avg_Population
from dataset2
group by state;

-- Top 3 States showing highest literacy rate --
select State, avg(Literacy) as Avg_Literacy
from dataset1
group by State
order by Avg_Literacy DESC
LIMIT 3;

-- Bottom 3 states showing lowest growth rate --
select State, round(avg(Growth),2) as Avg_Growth
from dataset1
group by State
order by Avg_Growth asc
limit 3;

select State, round(avg(Sex_Ratio),0) as Avg_Sex_Ratio
from dataset1
group by State
order by Avg_Sex_Ratio asc
limit 3;

-- Top and bottom 3 States by literacy rate --
drop table if exists topstates;
create table topstates
(
State text,
TopState float
);
insert into topstates
select State, round(avg(Literacy),0) as Avg_Literacy
from dataset1
group by State
order by Avg_Literacy DESC;

drop table if exists bottomstates;
create table bottomstates
(
State text,
BottomState float
);
insert into bottomstates
select State, round(avg(Literacy),0) as Avg_Literacy
from dataset1
group by State
order by Avg_Literacy DESC;

select * from
(
select * from topstates
order by Topstate DESC limit 3) as A

union

select * from
(
select * from bottomstates
order by Bottomstate asc limit 3) as B;

-- States and district starting and ending with some particular letter --
select * from dataset1
where state like 'T%' and district like '%m';

-- Join the two tables --
select d1.District, d1.State, d1.Sex_Ratio, d1.Literacy, d2.Population
from dataset1 as d1
inner join dataset2 as d2 on d1.District = d2.District;

-- Number of females and males --
select a.District, a.state, round(a.Population/(a.Sex_Ratio + 1), 0) as Males, round((a.Population * a.Sex_Ratio)/(a.Sex_Ratio + 1), 0) as Females from
(select d1.District, d1.State, d1.Sex_Ratio/1000 as Sex_Ratio, d1.Literacy, d2.Population
from dataset1 as d1
inner join dataset2 as d2 on d1.District = d2.District) as a;

-- Statewise males and females --
select b.State, sum(b.Males) as Total_Males, sum(b.Females) as Total_Females from
(select a.District, a.state, round(a.Population/(a.Sex_Ratio + 1), 0) as Males, round((a.Population * a.Sex_Ratio)/(a.Sex_Ratio + 1), 0) as Females from
(select d1.District, d1.State, d1.Sex_Ratio/1000 as Sex_Ratio, d1.Literacy, d2.Population
from dataset1 as d1
inner join dataset2 as d2 on d1.District = d2.District) as a) as b
group by b.State;

-- Total literacy rate --
select c.State, sum(Literate_people) as Total_literate_people, sum(Illiterate_people) as Total_illiterate_people from
(select a.District, a.State, round(a.Literacy_Ratio * a.Population,0) as Literate_people, round((1-a.Literacy_Ratio)*a.Population,0) as Illiterate_people from
(select d1.District, d1.State, d1.Literacy/100 Literacy_Ratio, d1.Literacy, d2.Population
from dataset1 as d1
inner join dataset2 as d2 on d1.District = d2.District) as a)as c
group by c.State;

-- Top 3 districts from each state with highest literacy rate --
select a.* from
(select District, State, Literacy, rank() over (partition by State order by Literacy DESC) as rnk
from dataset1) as a
where a.rnk in (1,2,3) order by State;

select District, State, Literacy
from dataset1
where State like "%a" and Literacy > 80;







