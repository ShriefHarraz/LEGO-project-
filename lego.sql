----Create VIEW	------

Create view [dbo].[analytics_main] as

select s.set_num, s.name as set_name, s.year, s.theme_id, cast(s.num_parts as numeric) num_parts, t.name as theme_name, t.parent_id, p.name as parent_theme_name,
case 
	when s.year between 1901 and 2000 then '20th_Century'
	when s.year between 2001 and 2100 then '21st_Century'
end
as Century
from dbo.sets s
left join [dbo].[themes] t
	on s.theme_id = t.id
left join [dbo].[themes] p
	on t.parent_id = p.id

	GO


             ---- Question no# 1------
---- what is the total number of  parts  pair themes -----

SELECT  theme_name, SUM(num_parts) as Total_parts 
FROM analytics_main
group by  theme_name
ORDER BY TOTAL_PARTS desc

             ---- Question no# 2 ------
---- What is the total number of parts per year -----

select year ,  SUM(num_parts) as Total_parts
FROM analytics_main
group by  year
ORDER BY TOTAL_PARTS desc

               ---- Question no# 3 ------
--- How many sets where created in each Century in the dataset

select Century, count (set_num) total_num_set
FROM analytics_main
group by  Century


                 ---- Question no# 4 ------
--- What percentage of sets ever released in the 21st Century were Trains Themed 

;with cte as 
(
	select Century, theme_name, count(set_num) total_set_num
	from analytics_main
	where Century = '21st_Century'
	group by Century, theme_name
)
select sum(total_set_num)total_set_num , sum(percentage) total_percentage
from(
	select Century, theme_name, total_set_num, sum(total_set_num) OVER() as total,  cast(1.00 * total_set_num / sum(total_set_num) OVER() as decimal(5,4))*100 Percentage
	from cte	
	--order by 3 desc
	)m
where theme_name like '%Star wars%'

                ---- Question no# 5 ------
--- What was the popular theme by year in terms of sets released in the 21st Century
select year, theme_name, total_set_num
from (
	select year, theme_name, count(set_num) total_set_num, ROW_NUMBER() OVER (partition by year order by count(set_num) desc) rn
	from analytics_main
	where Century = '21st_Century'
		--and parent_theme_name is not null
	group by year, theme_name
)m
where rn = 1	
order by year desc



   



