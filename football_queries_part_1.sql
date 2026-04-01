use football;

-- EASY (Q1 – Q30)

-- 1. Select all records from player_stats.
select * from player_stats;

-- 2. Show player name, club and country for all players.
select player, club, country from player_stats;

-- 3. List all unique countries in the dataset.
select distinct country from player_stats;

-- 4. List all unique clubs in the dataset.
select distinct club from player_stats;

-- 5. Find all players from Brazil.
select * from player_stats
where country = 'Brazil';

-- 6. Find all players from Spain.
select * from player_stats
where country = 'Spain';

-- 7. Find all players whose age is 25.
select * from player_stats
where age = 25;

-- 8. Find players older than 30.
select * from player_stats
where age > 30;

-- 9. Find players younger than 20.
select * from player_stats
where age < 20;

-- 10. Find players with height greater than 190 cm.
select * from player_stats
where height > 190;

-- 11. Find players with weight less than 70 kg.
select * from player_stats
where weight < 70;

-- 12. Count total number of players in the dataset.
select count(*) as total_players from player_stats;

-- 13. Find players where finishing > 80.
select player, club, country, finishing from player_stats
where finishing > 80;

-- 14. Find players where sprint_speed > 90.
select player, club, country, sprint_speed from player_stats
where sprint_speed > 90;

-- 15. Find players where dribbling > 85.
select player, club, country, dribbling from player_stats
where dribbling > 85;

-- 16. Find players with shot_power = 95.
select player, club, country, shot_power from player_stats
where shot_power = 95;

-- 17. Find players whose name starts with 'A'.
select * from player_stats
where player like 'A%';

-- 18. Find players whose name ends with 'o'.
select * from player_stats
where player like '%o';

-- 19. Find players whose country contains 'land'.
select * from player_stats
where country like '%land%';

-- 20. Find players from clubs whose name starts with 'Real'.
select * from player_stats
where club like 'Real%';

-- 21. Find players where vision is not null.
select * from player_stats
where vision is not null;

-- 22. Find players where marking is null.
select * from player_stats
where marking is null or marking = 'None';

-- 23. Count number of players from each country.
select country, count(*) as total_players from player_stats
group by country
order by total_players desc;

-- 24. Count number of players in each club.
select club, count(*) as total_players from player_stats
group by club
order by total_players desc;

-- 25. Find the maximum age in the dataset.
select max(age) as oldest_player_age from player_stats;

-- 26. Find the minimum age in the dataset.
select min(age) as youngest_player_age from player_stats;

-- 27. Find the average height of all players.
select round(avg(height), 2) as avg_height from player_stats;

-- 28. Find the average weight of all players.
select round(avg(weight), 2) as avg_weight from player_stats;

-- 29. Show players ordered by age in ascending order.
select player, club, country, age from player_stats
order by age asc;

-- 30. Show top 10 players with highest dribbling score.
select player, club, country, dribbling from player_stats
order by dribbling desc
limit 10;


-- MEDIUM (Q31 – Q70)

-- 31. Find the average dribbling score per country.
select country, round(avg(dribbling), 2) as avg_dribbling from player_stats
group by country
order by avg_dribbling desc;

-- 32. Find the average finishing score per club.
select club, round(avg(finishing), 2) as avg_finishing from player_stats
group by club
order by avg_finishing desc;

-- 33. Find clubs with more than 10 players in the dataset.
select club, count(*) as total_players from player_stats
group by club
having total_players > 10
order by total_players desc;

-- 34. Find countries with more than 50 players in the dataset.
select country, count(*) as total_players from player_stats
group by country
having total_players > 50
order by total_players desc;

-- 35. Find the top 5 countries by average sprint_speed.
select country, round(avg(sprint_speed), 2) as avg_sprint from player_stats
group by country
order by avg_sprint desc
limit 5;

-- 36. Find players with both dribbling > 80 and finishing > 80.
select player, club, country, dribbling, finishing from player_stats
where dribbling > 80 and finishing > 80;

-- 37. Find players from 'France' OR 'Germany'.
select player, club, country from player_stats
where country in ('France', 'Germany');

-- 38. Find players from Brazil, Argentina, or Portugal using IN.
select player, club, country from player_stats
where country in ('Brazil', 'Argentina', 'Portugal');

-- 39. Find players NOT from England.
select player, club, country from player_stats
where country not in ('England');

-- 40. Find average shot_power grouped by country, only for countries with avg > 70.
select country, round(avg(shot_power), 2) as avg_shot_power from player_stats
group by country
having avg_shot_power > 70
order by avg_shot_power desc;

-- 41. Find max sprint_speed per club.
select club, max(sprint_speed) as max_sprint from player_stats
group by club
order by max_sprint desc;

-- 42. Find min age per country.
select country, min(age) as youngest_age from player_stats
group by country
order by youngest_age asc;

-- 43. Find players with stamina > 85 and strength > 80.
select player, club, country, stamina, strength from player_stats
where stamina > 85 and strength > 80;

-- 44. Classify players as 'Tall' (height >= 185) or 'Short' using CASE.
select player, club, height,
case when height >= 185 then 'Tall'
     else 'Short'
end as height_category
from player_stats;

-- 45. Classify players by age group using CASE.
select player, age,
case when age < 23 then 'Young'
     when age between 23 and 29 then 'Prime'
     when age between 30 and 33 then 'Experienced'
     else 'Veteran'
end as age_group
from player_stats;

-- 46. Use COALESCE to replace null marking values with 0.
select player, club,
coalesce(nullif(marking, 'None'), '0') as marking_safe
from player_stats;

-- 47. Use CAST to convert age to float.
select player, cast(age as float) as age_float from player_stats
limit 10;

-- 48. Find average vision score per country using subquery in FROM.
select country, round(avg_vision, 2) as avg_vision
from (
    select country, avg(vision) as avg_vision
    from player_stats
    group by country
) t
order by avg_vision desc;

-- 49. Find players with dribbling above the overall average dribbling (subquery in WHERE).
select player, club, country, dribbling from player_stats
where dribbling > (
    select avg(dribbling) from player_stats
);

-- 50. Find players with sprint_speed above the overall average sprint_speed.
select player, club, country, sprint_speed from player_stats
where sprint_speed > (
    select avg(sprint_speed) from player_stats
);

-- 51. Find players with finishing above average finishing using subquery.
select player, club, country, finishing from player_stats
where finishing > (
    select avg(finishing) from player_stats
);

-- 52. Find the player with the maximum shot_power using subquery.
select player, club, country, shot_power from player_stats
where shot_power = (
    select max(shot_power) from player_stats
);

-- 53. Find the youngest player in the dataset using subquery.
select player, club, country, age from player_stats
where age = (
    select min(age) from player_stats
);

-- 54. Find all players from clubs that have at least one player with finishing > 90 (subquery with IN).
select player, club, country, finishing from player_stats
where club in (
    select distinct club from player_stats where finishing > 90
);

-- 55. Find countries that have at least one player with sprint_speed > 90 (subquery with IN).
select distinct country from player_stats
where country in (
    select country from player_stats where sprint_speed > 90
);

-- 56. Use UNION to list all unique clubs from players in Brazil and Argentina.
select distinct club from player_stats where country = 'Brazil'
union
select distinct club from player_stats where country = 'Argentina';

-- 57. Use UNION ALL to combine players from Spain and France (including duplicates).
select player, club, country from player_stats where country = 'Spain'
union all
select player, club, country from player_stats where country = 'France';

-- 58. Count players with vision above 70 vs below or equal to 70 using CASE + SUM.
select
sum(case when vision > 70 then 1 else 0 end) as high_vision_players,
sum(case when vision <= 70 then 1 else 0 end) as low_vision_players
from player_stats;

-- 59. Count players per age group using CASE inside GROUP BY subquery.
select age_group, count(*) as total
from (
    select
    case when age < 23 then 'Young'
         when age between 23 and 29 then 'Prime'
         when age between 30 and 33 then 'Experienced'
         else 'Veteran'
    end as age_group
    from player_stats
) t
group by age_group;

-- 60. Find top 5 players with the best long_pass score.
select player, club, country, long_pass from player_stats
order by long_pass desc
limit 5;

-- 61. Find top 5 clubs by average composure score.
select club, round(avg(composure), 2) as avg_composure from player_stats
group by club
order by avg_composure desc
limit 5;

-- 62. Find players with acceleration > 90 and balance > 85.
select player, club, country, acceleration, balance from player_stats
where acceleration > 90 and balance > 85;

-- 63. Show average stamina per country for countries with more than 20 players.
select country, round(avg(stamina), 2) as avg_stamina, count(*) as total_players
from player_stats
group by country
having total_players > 20
order by avg_stamina desc;

-- 64. Find clubs where average finishing is greater than average finishing of the whole dataset.
select club, round(avg(finishing), 2) as avg_finishing
from player_stats
group by club
having avg_finishing > (
    select avg(finishing) from player_stats
)
order by avg_finishing desc;

-- 65. Find players whose crossing score is in top 10% using subquery.
with t as (
    select player, club, crossing,
           ntile(10) over (order by crossing desc) as p
    from player_stats
)
select player, club, crossing
from t
where p = 1
order by crossing desc;

-- 66. Find the country with the highest average dribbling using subquery.
select country from (
    select country, avg(dribbling) as avg_drib
    from player_stats
    group by country
) t
where avg_drib = (
    select max(avg_drib) from (
        select country, avg(dribbling) as avg_drib
        from player_stats
        group by country
    ) inner_t
);

-- 67. Find players with heading > 80 and jumping > 80.
select player, club, country, heading, jumping from player_stats
where heading > 80 and jumping > 80;

-- 68. Show count of players per country where avg sprint_speed > 72.
select country, count(*) as players, round(avg(sprint_speed),2) as avg_sprint
from player_stats
group by country
having avg_sprint > 72
order by avg_sprint desc;

-- 69. Find players with penalties > 80 and fk_acc > 75.
select player, club, country, penalties, fk_acc from player_stats
where penalties > 80 and fk_acc > 75;

-- 70. Find the oldest player from each country using subquery.
select player, country, age from player_stats p1
where age = (
    select max(age) from player_stats p2 where p1.country = p2.country
)
order by country;


-- HARD (Q71 – Q100)

-- 71. Use CTE to find players with dribbling above the average dribbling.
with avg_dribbling_cte as (
    select avg(dribbling) as avg_drib from player_stats
)
select player, club, country, dribbling
from player_stats, avg_dribbling_cte
where dribbling > avg_drib
order by dribbling desc;

-- 72. Use CTE to find the top 3 players by finishing per country.
with ranked_players as (
    select player, country, club, finishing,
    dense_rank() over (partition by country order by finishing desc) as rnk
    from player_stats
)
select player, country, club, finishing
from ranked_players
where rnk <= 3
order by country, finishing desc;

-- 73. Use CTE to calculate average sprint_speed per club and find clubs above overall average.
with club_avg as (
    select club, avg(sprint_speed) as avg_sprint
    from player_stats
    group by club
),
overall_avg as (
    select avg(sprint_speed) as overall_sprint from player_stats
)
select club, round(avg_sprint, 2) as avg_sprint
from club_avg, overall_avg
where avg_sprint > overall_sprint
order by avg_sprint desc;

-- 74. Use CTE to find the best dribbler in each country.
with country_rank as (
    select player, country, club, dribbling,
    rank() over (partition by country order by dribbling desc) as rnk
    from player_stats
)
select player, country, club, dribbling
from country_rank
where rnk = 1
order by dribbling desc;

-- 75. Use CTE to find the top 5 clubs by average overall skill (avg of dribbling, finishing, vision, short_pass).
with club_skills as (
    select club,
    round(avg((dribbling + finishing + vision + short_pass) / 4.0), 2) as avg_skill
    from player_stats
    group by club
)
select club, avg_skill
from club_skills
order by avg_skill desc
limit 5;

-- 76. Use window function ROW_NUMBER to rank all players by sprint_speed.
select player, club, country, sprint_speed,
row_number() over (order by sprint_speed desc) as speed_rank
from player_stats;

-- 77. Use RANK() to rank players by finishing within each country.
select player, country, finishing,
rank() over (partition by country order by finishing desc) as finish_rank
from player_stats;

-- 78. Use DENSE_RANK() to rank clubs by average dribbling.
select club, round(avg(dribbling), 2) as avg_dribbling,
dense_rank() over (order by avg(dribbling) desc) as club_rank
from player_stats
group by club;

-- 79. Use LAG() to compare each player's dribbling with the previous player (ordered by dribbling).
select player, club, dribbling,
lag(dribbling) over (order by dribbling desc) as prev_dribbling,
dribbling - lag(dribbling) over (order by dribbling desc) as diff
from player_stats;

-- 80. Use LEAD() to compare each player's finishing with the next player (ordered by finishing desc).
select player, club, finishing,
lead(finishing) over (order by finishing desc) as next_finishing,
finishing - lead(finishing) over (order by finishing desc) as diff
from player_stats;

-- 81. Use ROW_NUMBER() to get the top 1 player by sprint_speed per country.
select * from (
    select player, country, club, sprint_speed,
    row_number() over (partition by country order by sprint_speed desc) as rn
    from player_stats
) t
where rn = 1
order by sprint_speed desc;

-- 82. Use CTE + window function to find the top 3 players by stamina per club.
with stamina_rank as (
    select player, club, country, stamina,
    dense_rank() over (partition by club order by stamina desc) as rnk
    from player_stats
)
select player, club, country, stamina
from stamina_rank
where rnk <= 3
order by club, stamina desc;

-- 83. Use subquery to find players whose dribbling is higher than their club's average dribbling.
select player, club, country, dribbling
from player_stats p1
where dribbling > (
    select avg(dribbling) from player_stats p2
    where p1.club = p2.club
)
order by club, dribbling desc;

-- 84. Use subquery to find players whose sprint_speed is higher than their country's average sprint_speed.
select player, country, club, sprint_speed
from player_stats p1
where sprint_speed > (
    select avg(sprint_speed) from player_stats p2
    where p1.country = p2.country
)
order by country, sprint_speed desc;

-- 85. Use CTE to find countries where every player has vision > 50 (all players above threshold).
with country_min_vision as (
    select country, min(vision) as min_vision
    from player_stats
    group by country
)
select country
from country_min_vision
where min_vision > 50
order by country;

-- 86. Use CTE to find the club with the highest average aggression.
with club_aggression as (
    select club, avg(aggression) as avg_aggression
    from player_stats
    group by club
)
select club, round(avg_aggression, 2) as avg_aggression
from club_aggression
where avg_aggression = (select max(avg_aggression) from club_aggression);

-- 87. Find players whose finishing is above average AND sprint_speed is above average using CTE.
with averages as (
    select avg(finishing) as avg_fin, avg(sprint_speed) as avg_spd
    from player_stats
)
select p.player, p.club, p.country, p.finishing, p.sprint_speed
from player_stats p, averages
where p.finishing > avg_fin and p.sprint_speed > avg_spd
order by p.finishing desc;

-- 88. Use window function to show cumulative count of players ordered by age.
select player, age,
count(*) over (order by age asc rows between unbounded preceding and current row) as cumulative_count
from player_stats;

-- 89. Use CASE + window function to flag players above/below average dribbling per country.
select player, country, dribbling,
avg(dribbling) over (partition by country) as country_avg_dribbling,
case when dribbling > avg(dribbling) over (partition by country) then 'Above Average'
     else 'Below Average'
end as dribbling_flag
from player_stats
order by country, dribbling desc;

-- 90. Use CTE to identify the top scorer (finishing) per club and their rank globally.
with club_best as (
    select player, club, country, finishing,
    row_number() over (partition by club order by finishing desc) as club_rank
    from player_stats
),
global_rank as (
    select player, club, country, finishing,
    dense_rank() over (order by finishing desc) as global_rank
    from club_best
    where club_rank = 1
)
select player, club, country, finishing, global_rank
from global_rank
order by global_rank;

-- 91. Find the top 3 youngest players per country using CTE and DENSE_RANK.
with young_ranks as (
    select player, country, club, age,
    dense_rank() over (partition by country order by age asc) as age_rank
    from player_stats
)
select player, country, club, age
from young_ranks
where age_rank <= 3
order by country, age;

-- 92. Use CTE to find players whose vision is in the top 10 globally, and show their country rank too.
with top_vision as (
    select player, club, country, vision,
    dense_rank() over (order by vision desc) as global_rank,
    dense_rank() over (partition by country order by vision desc) as country_rank
    from player_stats
)
select player, club, country, vision, global_rank, country_rank
from top_vision
where global_rank <= 10
order by global_rank;

-- 93. Use a self-join subquery to find pairs of players from the same club with a dribbling difference < 2.
select a.player as player1, b.player as player2, a.club, a.dribbling as drib1, b.dribbling as drib2
from player_stats a
join player_stats b on a.club = b.club
where a.player < b.player
and abs(a.dribbling - b.dribbling) < 2
order by a.club;

-- 94. Use CTE to show each player's dribbling vs their club's max dribbling and the gap.
with club_max as (
    select club, max(dribbling) as max_drib
    from player_stats
    group by club
)
select p.player, p.club, p.dribbling, c.max_drib,
(c.max_drib - p.dribbling) as gap_from_best
from player_stats p
join club_max c on p.club = c.club
order by p.club, gap_from_best asc;

-- 95. Use CTE to find the country with the highest number of players with finishing > 80.
with high_finishers as (
    select country, count(*) as elite_finishers
    from player_stats
    where finishing > 80
    group by country
)
select country, elite_finishers
from high_finishers
where elite_finishers = (select max(elite_finishers) from high_finishers);

-- 96. Use window function to rank players by overall physical score (acceleration + sprint_speed + stamina + strength) per country.
select player, country, club,
(acceleration + sprint_speed + stamina + strength) as physical_score,
rank() over (partition by country order by (acceleration + sprint_speed + stamina + strength) desc) as physical_rank
from player_stats
order by country, physical_rank;

-- 97. Use CTE to find clubs where the average age is below 25 and average finishing is above 65.
with club_profile as (
    select club,
    round(avg(age), 2) as avg_age,
    round(avg(finishing), 2) as avg_finishing
    from player_stats
    group by club
)
select club, avg_age, avg_finishing
from club_profile
where avg_age < 25 and avg_finishing > 65
order by avg_finishing desc;

-- 98. Use CTE + CASE to classify each country's players as majority 'Attackers' or 'Defenders' based on finishing vs marking.
with player_role as (
    select country,
    sum(case when finishing > 60 then 1 else 0 end) as attackers,
    sum(case when stand_tackle > 60 then 1 else 0 end) as defenders
    from player_stats
    group by country
)
select country, attackers, defenders,
case when attackers > defenders then 'Attack-Heavy'
     when defenders > attackers then 'Defense-Heavy'
     else 'Balanced'
end as team_style
from player_role
order by country;

-- 99. Use CTE and window function to find the player with the best vision in each club and rank them globally.
with best_vision_per_club as (
    select player, club, country, vision,
    row_number() over (partition by club order by vision desc) as club_rank
    from player_stats
),
global_vision_rank as (
    select player, club, country, vision,
    dense_rank() over (order by vision desc) as global_rank
    from best_vision_per_club
    where club_rank = 1
)
select player, club, country, vision, global_rank
from global_vision_rank
order by global_rank
limit 20;


-- 100. Use CTE to find the top 3 well-rounded players (highest average of dribbling, finishing, vision, short_pass, sprint_speed) per country.
with overall_score as (
    select player, club, country,
    round((dribbling + finishing + vision + short_pass + sprint_speed) / 5.0, 2) as overall_skill,
    dense_rank() over (partition by country order by (dribbling + finishing + vision + short_pass + sprint_speed) desc) as rnk
    from player_stats
)
select player, club, country, overall_skill, rnk
from overall_score
where rnk <= 3
order by country, rnk;
