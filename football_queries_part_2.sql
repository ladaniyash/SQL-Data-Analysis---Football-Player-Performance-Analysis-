use football;

-- EASY (Q101 – Q130)

-- 101. Show all players using a table alias 'p'.
select p.player, p.club, p.country
from player_stats p;

-- 102. List player name and club for players from England using a table alias.
select p.player, p.club
from player_stats p
where p.country = 'England';

-- 103. List all players from Germany using equi-style filter with alias.
select p.player, p.country, p.age
from player_stats p
where p.country = 'Germany';

-- 104. Show all players from France or Italy using UNION.
select player, club, country from player_stats where country = 'France'
union
select player, club, country from player_stats where country = 'Italy';

-- 105. Show all players from France or Italy using UNION ALL (including duplicates).
select player, club, country from player_stats where country = 'France'
union all
select player, club, country from player_stats where country = 'Italy';

-- 106. Find players who appear in both: sprint_speed > 88 AND acceleration > 88 using INTERSECT.
select player, club
from player_stats
where sprint_speed > 88
and player in (
    select player
    from player_stats
    where acceleration > 88
);

-- 107. Find players with dribbling > 85 but NOT finishing > 80 using EXCEPT.
select player, club, dribbling
from player_stats
where dribbling > 85
and player not in (
    select player
    from player_stats
    where finishing > 80
);

-- 108. List all countries that have players with sprint_speed > 90 using UNION ALL with labels.
select 'sprint > 90' as category, country from player_stats where sprint_speed > 90
union all
select 'sprint <= 90' as category, country from player_stats where sprint_speed <= 90
order by country;

-- 109. Show players with high vision (>80) INTERSECT players with high short_pass (>80).
select player, club
from player_stats
where vision > 80 and short_pass > 80;

-- 110. Find players with stamina > 85 EXCEPT players with strength > 85.
select player, club
from player_stats
where stamina > 85 and strength <= 85;

-- 111. Count total players per country using window COUNT() over the full dataset.
select player, country,
count(*) over () as total_players_in_dataset
from player_stats
limit 20;

-- 112. Show each player's dribbling alongside the maximum dribbling in the whole dataset using MAX() window.
select player, club, dribbling,
max(dribbling) over () as global_max_dribbling
from player_stats
order by dribbling desc
limit 20;

-- 113. Show each player's finishing alongside the minimum finishing using MIN() window.
select player, club, finishing,
min(finishing) over () as global_min_finishing
from player_stats
limit 20;

-- 114. Show each player's sprint_speed alongside the average sprint_speed using AVG() window.
select player, club, sprint_speed,
round(avg(sprint_speed) over (), 2) as global_avg_sprint
from player_stats
limit 20;

-- 115. Show each player's vision with the SUM of all vision scores using SUM() window.
select player, club, vision,
sum(vision) over () as total_vision_score
from player_stats
limit 10;

-- 116. Show players from Brazil alongside count of Brazilian players using COUNT() window.
select player, club,
count(*) over (partition by country) as players_in_country
from player_stats
where country = 'Brazil';

-- 117. Use LEFT JOIN style logic: show all players and their club (self-reference check).
select p.player, p.club, p.country, p.age
from player_stats p
order by p.club, p.age;

-- 118. Show each player with the highest dribbling in their club using MAX() window partitioned by club.
select player, club, dribbling,
max(dribbling) over (partition by club) as club_max_dribbling
from player_stats
order by club;

-- 119. Show each player's finishing vs average finishing of their country using AVG() window.
select player, country, finishing,
round(avg(finishing) over (partition by country), 2) as country_avg_finishing
from player_stats
order by country;

-- 120. Show each player's sprint_speed vs minimum sprint_speed of their club using MIN() window.
select player, club, sprint_speed,
min(sprint_speed) over (partition by club) as club_min_sprint
from player_stats
order by club;

-- 121. Use SUM() window to compute total stamina per country alongside each player.
select player, country, stamina,
sum(stamina) over (partition by country) as country_total_stamina
from player_stats
order by country;

-- 122. Show count of players per club alongside each row using COUNT() window partitioned by club.
select player, club,
count(*) over (partition by club) as players_in_club
from player_stats
order by club;

-- 123. Find the next player's dribbling value using LEAD() ordered by dribbling descending.
select player, club, dribbling,
lead(dribbling) over (order by dribbling desc) as next_lower_dribbling
from player_stats
limit 20;

-- 124. Find the previous player's sprint_speed using LAG() ordered by sprint_speed descending.
select player, club, sprint_speed,
lag(sprint_speed) over (order by sprint_speed desc) as prev_higher_sprint
from player_stats
limit 20;

-- 125. Use FIRST_VALUE() to show the player with the highest finishing in the dataset alongside every row.
select player, club, finishing,
first_value(player) over (order by finishing desc) as top_finisher
from player_stats
limit 20;

-- 126. Use LAST_VALUE() to show the player with the lowest finishing alongside every row.
select player, club, finishing,
last_value(player) over (order by finishing desc rows between unbounded preceding and unbounded following) as lowest_finisher
from player_stats
limit 20;

-- 127. Use LEAD() to see the next player's age when ordered by age ascending.
select player, club, age,
lead(age) over (order by age asc) as next_player_age
from player_stats
limit 20;

-- 128. Use LAG() to compare each player's height with the previous player's height ordered by height.
select player, club, height,
lag(height) over (order by height asc) as prev_height,
height - lag(height) over (order by height asc) as height_diff
from player_stats
limit 20;

-- 129. Show FIRST_VALUE of sprint_speed per country (fastest sprinter in each country).
select player, country, sprint_speed,
first_value(player) over (partition by country order by sprint_speed desc) as fastest_in_country
from player_stats
order by country;

-- 130. Use LAST_VALUE to find the least agile player per club.
select player, club, agility,
last_value(player) over (
    partition by club
    order by agility desc
    rows between unbounded preceding and unbounded following
) as least_agile_in_club
from player_stats
order by club;

-- MEDIUM (Q131 – Q170)

-- 131. Use a self join to find pairs of players from the same country with close ages (age diff <= 1).
select a.player as player1, b.player as player2, a.country, a.age as age1, b.age as age2
from player_stats a
inner join player_stats b
on a.country = b.country
where a.player < b.player
and abs(a.age - b.age) <= 1
order by a.country
limit 30;

-- 132. Use a self join to find pairs of players from the same club with finishing difference < 3.
select a.player as player1, b.player as player2, a.club, a.finishing as fin1, b.finishing as fin2
from player_stats a
inner join player_stats b
on a.club = b.club
where a.player < b.player
and abs(a.finishing - b.finishing) < 3
order by a.club
limit 30;

-- 133. Use a self join (equi join style) to find players in the same club with the same age.
select a.player as player1, b.player as player2, a.club, a.age
from player_stats a, player_stats b
where a.club = b.club
and a.age = b.age
and a.player < b.player
order by a.club
limit 30;

-- 134. Use a self join to find players from the same country where one has higher dribbling than the other.
select a.player as better_dribbler, b.player as worse_dribbler,
a.country, a.dribbling as drib_a, b.dribbling as drib_b
from player_stats a
inner join player_stats b
on a.country = b.country
where a.dribbling > b.dribbling
and a.player != b.player
order by a.country, a.dribbling desc
limit 30;

-- 135. Use a subquery in FROM (inner query style) to find clubs with average dribbling > 70.
select club, round(avg_drib, 2) as avg_dribbling
from (
    select club, avg(dribbling) as avg_drib
    from player_stats
    group by club
) club_avg
where avg_drib > 70
order by avg_dribbling desc;

-- 136. Use a subquery in FROM to find countries with more than 100 players.
select country, total
from (
    select country, count(*) as total
    from player_stats
    group by country
) country_count
where total > 100
order by total desc;

-- 137. Use a subquery in FROM to get the top 5 clubs by average sprint_speed.
select club, round(avg_sprint, 2) as avg_sprint_speed
from (
    select club, avg(sprint_speed) as avg_sprint
    from player_stats
    group by club
) t
order by avg_sprint_speed desc
limit 5;

-- 138. Use LEFT JOIN concept via subquery: show all countries and their player count, including zero-count simulation.
select country_list.country, coalesce(counts.total, 0) as player_count
from (select distinct country from player_stats) country_list
left join (
    select country, count(*) as total
    from player_stats
    group by country
) counts
on country_list.country = counts.country
order by player_count desc;

-- 139. Use INNER JOIN of two subqueries: join top dribblers (dribbling > 85) with top finishers (finishing > 80).
select d.player, d.club, d.dribbling, f.finishing
from (
    select player, club, dribbling from player_stats where dribbling > 85
) d
inner join (
    select player, club, finishing from player_stats where finishing > 80
) f
on d.player = f.player and d.club = f.club
order by d.dribbling desc;

-- 140. Use a subquery in FROM with an alias to find avg stamina per club, then filter clubs above 70.
select t.club, t.avg_stamina
from (
    select club, round(avg(stamina), 2) as avg_stamina
    from player_stats
    group by club
) t
where t.avg_stamina > 70
order by t.avg_stamina desc;

-- 141. Use running SUM() window: show cumulative dribbling scores ordered by dribbling descending.
select player, club, dribbling,
sum(dribbling) over (order by dribbling desc rows between unbounded preceding and current row) as running_total_dribbling
from player_stats
limit 30;

-- 142. Use running AVG() window: rolling average of finishing ordered by finishing desc.
select player, club, finishing,
round(avg(finishing) over (order by finishing desc rows between unbounded preceding and current row), 2) as rolling_avg_finishing
from player_stats
limit 30;

-- 143. Use SUM() window partitioned by country to show cumulative stamina per country.
select player, country, stamina,
sum(stamina) over (partition by country order by stamina desc) as cumulative_stamina
from player_stats
order by country, stamina desc
limit 30;

-- 144. Use AVG() window partitioned by club to show rolling avg of sprint_speed per club.
select player, club, sprint_speed,
round(avg(sprint_speed) over (partition by club order by sprint_speed desc), 2) as rolling_avg_sprint
from player_stats
order by club, sprint_speed desc
limit 30;

-- 145. Show each player's dribbling vs the FIRST_VALUE (best dribbler) in their club.
select player, club, dribbling,
first_value(player) over (partition by club order by dribbling desc) as best_dribbler_in_club,
first_value(dribbling) over (partition by club order by dribbling desc) as best_dribbling_score
from player_stats
order by club, dribbling desc;

-- 146. Use LAST_VALUE to show the weakest finisher in each country alongside every player.
select player, country, finishing,
last_value(player) over (
    partition by country
    order by finishing desc
    rows between unbounded preceding and unbounded following
) as weakest_finisher_in_country
from player_stats
order by country, finishing desc
limit 30;

-- 147. Use LEAD() with offset 2 to compare a player's vision with the player 2 rows ahead.
select player, club, vision,
lead(vision, 2) over (order by vision desc) as vision_2_rows_ahead,
vision - lead(vision, 2) over (order by vision desc) as difference
from player_stats
limit 30;

-- 148. Use LAG() with offset 3 to compare sprint_speed with 3 rows behind.
select player, club, sprint_speed,
lag(sprint_speed, 3) over (order by sprint_speed desc) as sprint_3_rows_ago,
sprint_speed - lag(sprint_speed, 3) over (order by sprint_speed desc) as difference
from player_stats
limit 30;

-- 149. Use LEAD() partitioned by country to compare each player's finishing with the next player in same country.
select player, country, finishing,
lead(finishing) over (partition by country order by finishing desc) as next_finishing_in_country,
finishing - lead(finishing) over (partition by country order by finishing desc) as gap
from player_stats
order by country, finishing desc
limit 30;

-- 150. Use LAG() partitioned by club to compare stamina with previous player in same club.
select player, club, stamina,
lag(stamina) over (partition by club order by stamina desc) as prev_stamina_in_club,
stamina - lag(stamina) over (partition by club order by stamina desc) as diff
from player_stats
order by club, stamina desc
limit 30;

-- 151. Use UNION to list all distinct clubs from players with dribbling > 85 OR finishing > 85.
select distinct club from player_stats where dribbling > 85
union
select distinct club from player_stats where finishing > 85;

-- 152. Use UNION ALL to combine player names from top sprinters (>90) and top agility (>90).
select player, 'Top Sprinter' as category from player_stats where sprint_speed > 90
union all
select player, 'Top Agility' as category from player_stats where agility > 90
order by player;

-- 153. Use INTERSECT to find players who are both fast (sprint_speed > 85) and agile (agility > 85).
select player, club
from player_stats
where sprint_speed > 85 and agility > 85;

-- 154. Use EXCEPT to find players with high shot_power (>85) but low finishing (<60).
select player, club
from player_stats
where shot_power > 85 and finishing < 60;

-- 155. Use EXCEPT to find fast players (sprint_speed > 88) who are NOT in the high-stamina group (stamina > 80).
select player, club
from player_stats
where sprint_speed > 88 and stamina <= 80;

-- 156. Use a subquery in FROM with table alias to find players above their club's average vision.
select p.player, p.club, p.vision, club_avg.avg_vision
from player_stats p
inner join (
    select club, round(avg(vision), 2) as avg_vision
    from player_stats
    group by club
) club_avg
on p.club = club_avg.club
where p.vision > club_avg.avg_vision
order by p.club, p.vision desc;

-- 157. Use a subquery join to find players above their country's average sprint_speed.
select p.player, p.country, p.sprint_speed, country_avg.avg_sprint
from player_stats p
inner join (
    select country, round(avg(sprint_speed), 2) as avg_sprint
    from player_stats
    group by country
) country_avg
on p.country = country_avg.country
where p.sprint_speed > country_avg.avg_sprint
order by p.country, p.sprint_speed desc;

-- 158. Use a subquery join to find clubs where the max dribbling exceeds 90.
select p.player, p.club, p.dribbling, club_max.max_drib
from player_stats p
inner join (
    select club, max(dribbling) as max_drib
    from player_stats
    group by club
) club_max
on p.club = club_max.club
where club_max.max_drib > 90
order by p.club, p.dribbling desc;

-- 159. Use LEFT JOIN of two subqueries to match high dribblers with their club's average finishing.
select d.player, d.club, d.dribbling, coalesce(f.avg_finishing, 0) as club_avg_finishing
from (
    select player, club, dribbling from player_stats where dribbling > 85
) d
left join (
    select club, round(avg(finishing), 2) as avg_finishing
    from player_stats
    group by club
) f
on d.club = f.club
order by d.dribbling desc;

-- 160. Use COUNT() window to count how many players share the same age (birthday group size).
select player, age,
count(*) over (partition by age) as players_of_same_age
from player_stats
order by age;

-- 161. Use MIN() and MAX() window together to show dribbling range per country.
select player, country, dribbling,
min(dribbling) over (partition by country) as country_min_drib,
max(dribbling) over (partition by country) as country_max_drib,
max(dribbling) over (partition by country) - min(dribbling) over (partition by country) as drib_range
from player_stats
order by country, dribbling desc
limit 30;

-- 162. Show running COUNT() of players ordered by sprint_speed desc (how many faster players exist above).
select player, club, sprint_speed,
count(*) over (order by sprint_speed desc rows between unbounded preceding and current row) as rank_by_speed
from player_stats
order by sprint_speed desc
limit 30;

-- 163. Use self join to find players in the same club with sprint_speed difference less than 2.
select a.player as p1, b.player as p2, a.club, a.sprint_speed as s1, b.sprint_speed as s2
from player_stats a
inner join player_stats b
on a.club = b.club
where a.player < b.player
and abs(a.sprint_speed - b.sprint_speed) < 2
order by a.club
limit 30;

-- 164. Use a self join to find players from the same country with the same height.
select a.player as player1, b.player as player2, a.country, a.height
from player_stats a, player_stats b
where a.country = b.country
and a.height = b.height
and a.player < b.player
order by a.country
limit 30;

-- 165. Combine UNION with window function: rank players from top-5 countries by dribbling.
select player, country, dribbling,
rank() over (partition by country order by dribbling desc) as country_drib_rank
from player_stats
where country in (
    select country from (
        select country, count(*) as cnt from player_stats group by country order by cnt desc limit 5
    ) t
)
order by country, dribbling desc;

-- 166. Use LEAD() to see if next player (by age) is older, and by how much.
select player, age,
lead(age) over (order by age asc) as next_age,
lead(age) over (order by age asc) - age as age_gap
from player_stats
limit 30;

-- 167. Use a subquery in FROM joined to main table to compare each player's dribbling to national average.
select p.player, p.country, p.dribbling,
n.national_avg,
p.dribbling - n.national_avg as diff_from_national_avg
from player_stats p
join (
    select country, round(avg(dribbling), 2) as national_avg
    from player_stats
    group by country
) n on p.country = n.country
order by diff_from_national_avg desc
limit 30;

-- 168. Use SUM() window partitioned by club to show each player's contribution % to club total dribbling.
select player, club, dribbling,
sum(dribbling) over (partition by club) as club_total_dribbling,
round(dribbling * 100.0 / sum(dribbling) over (partition by club), 2) as contribution_pct
from player_stats
order by club, contribution_pct desc
limit 30;

-- 169. Use FIRST_VALUE and LAG together to show best and previous finisher per country.
select player, country, finishing,
first_value(player) over (partition by country order by finishing desc) as best_finisher,
lag(finishing) over (partition by country order by finishing desc) as prev_finishing
from player_stats
order by country, finishing desc
limit 30;

-- 170. Use INTERSECT to find players who are in both the top vision group and top composure group (both > 80).
select player, club
from player_stats
where vision > 80 and composure > 80;


-- HARD (Q171 – Q200)

-- 171. Use a self join with table aliases (equi join style) to find players from same club with dribbling within 5 of each other.
select a.player as player_a, b.player as player_b, a.club, a.dribbling, b.dribbling as drib_b
from player_stats a, player_stats b
where a.club = b.club
and a.player < b.player
and abs(a.dribbling - b.dribbling) <= 5
and a.dribbling > 80
order by a.club, a.dribbling desc
limit 30;

-- 172. Use inner join of two subqueries to find players who are both top dribblers and top sprinters per country.
select d.player, d.country, d.dribbling, s.sprint_speed
from (
    select player, country, dribbling,
    rank() over (partition by country order by dribbling desc) as drib_rank
    from player_stats
) d
inner join (
    select player, country, sprint_speed,
    rank() over (partition by country order by sprint_speed desc) as sprint_rank
    from player_stats
) s
on d.player = s.player and d.country = s.country
where d.drib_rank <= 3 and s.sprint_rank <= 3
order by d.country;

-- 173. Use a left join of two subqueries: all clubs and their top finisher (if any above 80).
select all_clubs.club, coalesce(top_fin.player, 'None above 80') as top_finisher, coalesce(top_fin.finishing, 0) as finishing
from (select distinct club from player_stats) all_clubs
left join (
    select player, club, finishing
    from player_stats
    where finishing > 80
    and (club, finishing) in (
        select club, max(finishing) from player_stats where finishing > 80 group by club
    )
) top_fin
on all_clubs.club = top_fin.club
order by finishing desc
limit 30;

-- 174. Combine UNION ALL + window function: show all players from Brazil and Argentina with their country rank by dribbling.
select player, country, dribbling,
rank() over (partition by country order by dribbling desc) as country_rank
from player_stats
where country in ('Brazil', 'Argentina')
order by country, country_rank;

-- 175. Use LAG() with partition to detect dribbling improvement/drop between consecutive players per country.
select player, country, dribbling,
lag(dribbling) over (partition by country order by dribbling asc) as prev_dribbling,
dribbling - lag(dribbling) over (partition by country order by dribbling asc) as improvement
from player_stats
where country in ('Spain', 'France', 'Germany')
order by country, dribbling asc;

-- 176. Use LEAD() to flag if the next player (by sprint_speed) within the same club is significantly slower (diff > 5).
select player, club, sprint_speed,
lead(sprint_speed) over (partition by club order by sprint_speed desc) as next_sprint,
case
    when sprint_speed - lead(sprint_speed) over (partition by club order by sprint_speed desc) > 5
    then 'Big Drop'
    else 'Close'
end as drop_flag
from player_stats
order by club, sprint_speed desc
limit 30;

-- 177. Use a subquery joined to itself (join subquery in FROM) to compare club average vs country average dribbling.
select club_avg.club, club_avg.avg_club_drib,
country_avg.country, country_avg.avg_country_drib,
round(club_avg.avg_club_drib - country_avg.avg_country_drib, 2) as diff
from (
    select p.club, p.country, round(avg(p.dribbling), 2) as avg_club_drib
    from player_stats p
    group by p.club, p.country
) club_avg
inner join (
    select country, round(avg(dribbling), 2) as avg_country_drib
    from player_stats
    group by country
) country_avg
on club_avg.country = country_avg.country
order by diff desc
limit 20;

-- 178. Use EXCEPT to find clubs that have top dribblers (>85) but NOT top finishers (>80).
select distinct club
from player_stats
where dribbling > 85
and club not in (
    select club
    from player_stats
    where finishing > 80
);

-- 179. Use INTERSECT to find clubs that produce both top sprinters (sprint_speed > 88) and top passers (short_pass > 82).
select distinct club
from player_stats
where sprint_speed > 88
and club in (
    select club
    from player_stats
    where short_pass > 82
);

-- 180. Use UNION with window functions to rank top players across two skill sets: dribbling and finishing.
select player, club, dribbling as skill_score, 'Dribbling' as skill_type,
rank() over (order by dribbling desc) as skill_rank
from player_stats where dribbling > 85
union
select player, club, finishing, 'Finishing',
rank() over (order by finishing desc)
from player_stats where finishing > 85
order by skill_rank, skill_type
limit 30;

-- 181. Use SUM() window with FIRST_VALUE to show each player's share of their club's total finishing score.
select player, club, finishing,
first_value(player) over (partition by club order by finishing desc) as club_top_finisher,
sum(finishing) over (partition by club) as club_total_finishing,
round(finishing * 100.0 / sum(finishing) over (partition by club), 2) as pct_of_club_total
from player_stats
order by club, finishing desc
limit 30;

-- 182. Use a self join with inner join syntax to find players who share both the same club AND same country.
select a.player as player1, b.player as player2, a.club, a.country
from player_stats a
inner join player_stats b
on a.club = b.club
and a.country = b.country
where a.player < b.player
order by a.club
limit 30;

-- 183. Use a subquery in FROM to join top-5 clubs (by player count) with avg finishing of those clubs.
select t.club, t.player_count, round(f.avg_finishing, 2) as avg_finishing
from (
    select club, count(*) as player_count
    from player_stats
    group by club
    order by player_count desc
    limit 5
) t
inner join (
    select club, avg(finishing) as avg_finishing
    from player_stats
    group by club
) f
on t.club = f.club
order by t.player_count desc;

-- 184. Use LEAD() offset 2 partitioned by country to compare finishing with 2 players ahead in same country.
select player, country, finishing,
lead(finishing, 2) over (partition by country order by finishing desc) as finishing_2_ahead,
finishing - lead(finishing, 2) over (partition by country order by finishing desc) as gap
from player_stats
where country in ('Brazil', 'England', 'Spain')
order by country, finishing desc;

-- 185. Use LAG() offset 2 partitioned by club to compare dribbling with 2 players behind in same club.
select player, club, dribbling,
lag(dribbling, 2) over (partition by club order by dribbling desc) as drib_2_behind,
dribbling - lag(dribbling, 2) over (partition by club order by dribbling desc) as gap
from player_stats
order by club, dribbling desc
limit 30;

-- 186. Use a right join via subquery: clubs that have at least one player with sprint_speed > 90, and ALL their players.
select all_p.player, all_p.club, all_p.sprint_speed
from player_stats all_p
inner join (
    select distinct club from player_stats where sprint_speed > 90
) fast_clubs
on all_p.club = fast_clubs.club
order by all_p.club, all_p.sprint_speed desc;

-- 187. Use UNION ALL to list countries with avg dribbling above and below 65, with labels.
select country, round(avg(dribbling), 2) as avg_drib, 'Above 65' as category
from player_stats
group by country
having avg(dribbling) > 65
union all
select country, round(avg(dribbling), 2), 'Below or Equal 65'
from player_stats
group by country
having avg(dribbling) <= 65
order by avg_drib desc;

-- 188. Use FIRST_VALUE and LAST_VALUE window to show best and worst sprinter per country side by side.
select player, country, sprint_speed,
first_value(player) over (partition by country order by sprint_speed desc) as fastest_in_country,
last_value(player) over (
    partition by country
    order by sprint_speed desc
    rows between unbounded preceding and unbounded following
) as slowest_in_country
from player_stats
order by country, sprint_speed desc
limit 30;

-- 189. Use an inner join of a subquery and main table to show players ranked top 3 globally in each skill.
with ranked_players as (
    select player,club,country,dribbling,finishing,sprint_speed,
        ntile(100) over (order by dribbling desc) as dribbling_rank,
        ntile(100) over (order by finishing desc) as finishing_rank,
        ntile(100) over (order by sprint_speed desc) as speed_rank
    from player_stats
)
select *
from ranked_players
where dribbling_rank <= 3
   or finishing_rank <= 3
   or speed_rank <= 3
order by dribbling desc;

-- 190. Use a self join with left join style to find players with no peer in same club (lone player in their club).
select a.player, a.club, a.country
from player_stats a
left join player_stats b
on a.club = b.club and a.player != b.player
where b.player is null
order by a.club;

-- 191. Use LEAD() + CASE to flag whether the next player (by finishing, within country) is a significant upgrade (diff > 10).
select player, country, finishing,
lead(finishing) over (partition by country order by finishing asc) as next_finishing,
case
    when lead(finishing) over (partition by country order by finishing asc) - finishing > 10
    then 'Big Jump'
    else 'Gradual'
end as jump_flag
from player_stats
where country in ('Brazil', 'France', 'Spain')
order by country, finishing asc;

-- 192. Use EXCEPT + window to find players with above-average dribbling who are NOT top-5 in their country's finishing.
select player, club, country
from player_stats
where dribbling > (select avg(dribbling) from player_stats)
and player not in (
    select player
    from (
        select player,
               rank() over (partition by country order by finishing desc) as fin_rank
        from player_stats
    ) t
    where fin_rank <= 5
);

-- 193. Use INTERSECT + subquery to find countries that have BOTH players with age < 20 and players with age > 35.
select distinct country
from player_stats
where age < 20
and country in (
    select country
    from player_stats
    where age > 35
);

-- 194. Use a self join to recommend players from the same country with similar dribbling (within 3) but different clubs.
select a.player as seeker, b.player as recommendation,
a.country, a.club as seeker_club, b.club as rec_club,
a.dribbling as seeker_drib, b.dribbling as rec_drib
from player_stats a
inner join player_stats b
on a.country = b.country
and a.club != b.club
and abs(a.dribbling - b.dribbling) <= 3
and a.dribbling > 80
where a.player != b.player
order by a.country, a.dribbling desc
limit 30;

-- 195. Use SUM() window + LEAD() to show cumulative sprint_speed and next player's value per club.
select player, club, sprint_speed,
sum(sprint_speed) over (partition by club order by sprint_speed desc) as cumulative_club_sprint,
lead(sprint_speed) over (partition by club order by sprint_speed desc) as next_player_sprint
from player_stats
order by club, sprint_speed desc
limit 30;

-- 196. Use a complex UNION ALL to build a leaderboard combining top dribblers, finishers, and sprinters.
select player, club, country, dribbling as score, 'Dribbler' as category
from player_stats
where dribbling = (select max(dribbling) from player_stats)
union all
select player, club, country, finishing, 'Finisher'
from player_stats
where finishing = (select max(finishing) from player_stats)
union all
select player, club, country, sprint_speed, 'Sprinter'
from player_stats
where sprint_speed = (select max(sprint_speed) from player_stats);

-- 197. Use LEAD() + LAG() together to show previous and next finishing score per country.
select player, country, finishing,
lag(finishing) over (partition by country order by finishing desc) as prev_finishing,
lead(finishing) over (partition by country order by finishing desc) as next_finishing
from player_stats
where country in ('England', 'Germany', 'Brazil')
order by country, finishing desc;

-- 198. Use inner join of three subqueries: clubs that are top-5 in avg dribbling, avg finishing, and avg sprint_speed.
select d.club
from (
    select club from (
        select club, avg(dribbling) as avg_d from player_stats group by club order by avg_d desc limit 5
    ) t
) d
inner join (
    select club from (
        select club, avg(finishing) as avg_f from player_stats group by club order by avg_f desc limit 5
    ) t
) f on d.club = f.club
inner join (
    select club from (
        select club, avg(sprint_speed) as avg_s from player_stats group by club order by avg_s desc limit 5
    ) t
) s on d.club = s.club;

-- 199. Use FIRST_VALUE() + SUM() window + self join concept to find the best all-round player per club and compare with club total.
select player, club,
(dribbling + finishing + sprint_speed + vision + short_pass) as overall_score,
first_value(player) over (partition by club order by (dribbling + finishing + sprint_speed + vision + short_pass) desc) as club_best_player,
sum(dribbling + finishing + sprint_speed + vision + short_pass) over (partition by club) as club_total_score,
round((dribbling + finishing + sprint_speed + vision + short_pass) * 100.0
    / sum(dribbling + finishing + sprint_speed + vision + short_pass) over (partition by club), 2) as pct_of_club_total
from player_stats
order by club, overall_score desc
limit 30;

-- 200. Full pipeline query: use a subquery join + UNION ALL + window function to rank top 3 players per country
--      across two combined skill metrics (attack: finishing + shot_power) and (speed: sprint_speed + acceleration).
select player, country, club, combined_score, skill_type,
dense_rank() over (partition by country, skill_type order by combined_score desc) as country_rank
from (
    select player, country, club,
    (finishing + shot_power) as combined_score,
    'Attack' as skill_type
    from player_stats
    union all
    select player, country, club,
    (sprint_speed + acceleration),
    'Speed'
    from player_stats
) all_skills
where country in (
    select country from (
        select country, count(*) as cnt from player_stats group by country order by cnt desc limit 10
    ) top_countries
)
order by country, skill_type, country_rank
limit 60;
