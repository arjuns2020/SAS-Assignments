
data sales;
	set '/folders/myfolders/Hw3/videogamesales_main.sas7bdat';
	user_score_count = (user_score*User_count);
	critic_score_count = (critic_score*critic_count);
run;


/*regression without observation*/

proc reg data = sales;
model global_sales = critic_score critic_count user_score user_count user_score_count critic_score_count;
run;


/*aggregating the data to the year level and grouping it for platform and genre*/

proc sql; 
create table sales_agg as
select sum(global_sales) as global_sales, genre, platform, year_of_release, sum(critic_count) as critic_count, sum(user_count) as user_count, sum(user_score_count) as user_score_count, sum(critic_score_count) as critic_score_count 
from sales
group by year_of_release, platform, genre;
run;


/*data prep for regression on genre*/

data sales_agg_reg;
set sales_agg;
user_score = log(user_score_count/user_count);
critic_score = log (critic_score_count/critic_count);
log_global_sales = log(global_sales);

/*genre*/
if genre = "Action" then act = 1; else act = 0;
if genre = "Adventure" then adv = 1; else adv = 0;
if genre = "Fighting" then fig = 1; else fig = 0;
if genre = "Misc" then misc = 1; else misc = 0;
if genre = "Platform" then plat = 1; else plat = 0;
if genre = "Puzzle" then puz = 1; else puz = 0;
if genre = "Racing" then race = 1; else race = 0;
if genre = "Role-Playing" then rp = 1; else rp = 0;
if genre = "Shooter" then fps = 1; else fps = 0;
if genre = "Simulation" then sim = 1; else sim = 0;
if genre = "Sports" then sport = 1; else sport = 0;
log_user_score_count=log(user_score_count);
log_critic_score_count=log(critic_score_count);
log_critic_count= log(critic_count);
log_user_count= log(user_count);
run;

/*regression run*/

proc reg data = sales_agg_reg plots = none;
model log_global_sales = act adv fig misc plat puz race rp fps sim sport critic_score critic_count user_score user_count log_user_score_count log_critic_score_count;
output out = regdata cookd = cookd student = sresiduals; 
run;

/*removing outliers*/

proc reg data=regdata  ;
model log_global_sales = act adv fig misc plat puz race rp fps sim sport critic_score critic_count user_score user_count log_user_score_count log_critic_score_count;
where Cookd < 4 / 724;
run;

/*finding weights*/

proc robustreg data = regdata method = mm;
model log_global_sales = act adv fig misc plat puz race rp fps sim sport critic_score critic_count user_score user_count log_user_score_count log_critic_score_count;
output out = robregmm weight = wgt outlier = ol r = residual p = predicted;
run;

/*weight adjustments to optimize model*/
proc reg data = robregmm;
weight wgt;
model log_global_sales = act adv fig misc plat puz race rp fps sim sport critic_score critic_count user_score user_count log_user_score_count log_critic_score_count;
run;


/*multicollinearity check*/
proc reg data = robregmm;
weight wgt;
model log_global_sales = act adv fig misc plat puz race rp fps sim sport critic_score critic_count user_score user_count log_user_score_count log_critic_score_count / collinoint vif;
run;



/*heteroskedasticity check*/
proc sgplot data = robregmm;
scatter x = predicted y = residual;
run;

