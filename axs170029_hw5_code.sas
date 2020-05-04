


*Q 1;
data crackers;
set '/folders/myfolders/HW5/crackers_hw5.sas7bdat';
run;

proc surveyselect data=crackers out=crackers_sampled outall samprate=0.8 seed=100;
run;


*Q 3;

data crackers_splitrows;
 array pricearr[4] pricePrivate priceKeebler priceSunshine priceNabisco;
 array featarr[4] featPrivate featKeebler featSunshine featNabisco;
 array displarr[4] displPrivate displKeebler displSunshine displNabisco;
 array allmodes[4] $ _temporary_ ('Private' 'Keebler' 'Sunshine' 'Nabisco');
 set crackers_sampled;
 Subject = _n_;
 do i = 1 to 4;
 	Mode = allmodes[i];
	Price = pricearr[i];
	Display = displarr[i];
	Feature = featarr[i];
	if Private=1 then Choice = 'Private';
	else if Keebler=1 then Choice = 'Keebler';
	else if Sunshine=1 then Choice = 'Sunshine';
	else if Nabisco=1 then Choice = 'Nabisco'; 
	else Choice = 'NA';
	if i=1 AND Private=1 then choicedigit = 1;
	else if i=2 AND Keebler=1 then  choicedigit = 1;
	else if i=3 AND Sunshine=1 then  choicedigit = 1;
	else if i=4 AND Nabisco=1 then  choicedigit = 1;
	else choicedigit = 0;
	output;
 end;
run;

*Q 4;

data crackers_splitrows_training crackers_splitrows_test;
 set crackers_splitrows;
 if selected then output crackers_splitrows_training; 
 else output crackers_splitrows_test;
run;

proc logistic data=crackers_splitrows_training;
 strata subject;
 class mode (ref = 'Private') / param=glm;
 model choicedigit (event='1') = mode price mode*display mode*feature;
run;

*Q 5;

proc mdc data = crackers_splitrows_training;
  id subject;
  class mode;
  model choicedigit = mode price mode*display mode*feature / type = clogit nchoice = 4;
 restrict MODEprivate=0;
 run;

 *Q 6;
 data crackers_splitrows_test;
 set crackers_splitrows;
 if selected = 0 then choicedigit = .;
run;

proc mdc data = crackers_splitrows;
  id subject;
  class mode;
  model choicedigit = mode price mode*display mode*feature / type = clogit nchoice = 4;
 restrict MODEprivate=0;
 output out=probdata pred=p;
 run;

 proc print data=probdata( where=( selected= 0  ) );
  var Subject p choicedigit Choice Mode   ;
run;

*Q 7;
proc sql;
create table answer as
select a.Subject as Subject, a.p as p, a.choicedigit as choicedigit, a.Choice as Choice, a.Mode as Mode FROM PROBDATA a
inner join 
(
	select Subject, max(p) as maxp
	from PROBDATA
	group by subject 
) b
on a.subject = b.subject and a.p = b.maxp
where a.SELECTED = 0;
quit;

proc sql;
select
	choice, 
	sum(case when mode = 'Keebler' then  1 else 0 end) as keebler_pred ,
	sum(case when mode = 'Nabisco' then  1 else 0 end) as nabisco_pred ,
	sum(case when mode = 'Private' then  1 else 0 end) as private_pred ,
	sum(case when mode = 'Sunshine' then  1 else 0 end) as sunshine_pred
from answer
group by choice
order by choice;
quit;
