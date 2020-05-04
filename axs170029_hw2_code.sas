

/*Q1*/
data earthquake;
	set '/folders/myfolders/HW2/earthquakes.sas7bdat';
run;

/*Part A*/
data CA_AK;
  set earthquake;
  where State = "California" or State = "Alaska";
run;

data CA_AK;
  set CA_AK;
  where Year > 2001 and Year < 2012;
run;


/*Part B*/
proc means data = CA_AK mean median stddev min max p25 p75 maxdec=2;
	class Year State;
	var Magnitude;
	title 'statestats';
run;

/*Part C*/
proc sort data = CA_AK;
	by Year;
run;

proc means data = CA_AK mean median stddev min max p25 p75 maxdec=2;
	by Year;
	class State;
	var Magnitude;
run;

/*Part D*/
proc tabulate data= CA_AK ;
 class Year State; *categorical variables for breakdown of variable summaries;
 var Magnitude; *variables described by the table; 
 table Year*(Magnitude),State*(mean median stddev min max p25 p75); 
 title 'Summary Statistics';
run;

/*Part E*/
proc sort data= CA_AK; 
 by Year,State;
 run;

proc means data= CA_AK mean maxdec= 2 noprint;
 by Year;
 class State;
 var Magnitude;
 output out=means 
 mean= AvgMagnitude;
run;


proc sgpanel  data= means;
 panelby State;
 series x=Year y=AvgMagnitude;
 title 'Avg Magnitude by Year';
run;

/*Part F*/

proc ttest data = eq_ca_ak;
class State;
var Magnitude;
run;
proc ttest data = eq_ca_ak;
 paired Magnitude*Magnitude;
 by State;
run;






/*Q2*/

data gpa;
	set '/folders/myfolders/HW2/study_gpa.sas7bdat';
run;

/*Part A*/
proc sgplot data = gpa;
 histogram AveTime / binstart = 0 binwidth = 5 ; 
 density AveTime / type = kernel; 
 density AveTime; 
 title 'Average Study Time';
run;

/*Part B*/
proc univariate data = gpa normal;
qqplot AveTime /Normal(mu=est sigma=est color=red l=1);
run;

/*Part C*/
proc corr data = gpa;
 var Units AveTime GPA;
 where Section = '01';
run;

proc corr data = gpa spearman;
 var Units AveTime GPA;
 where Section = '01';
run;





/*Q 3*/

data vitamin;
	set '/folders/myfolders/HW2/vite.sas7bdat';
run;

/*Part D*/

proc ttest data = vitamin;
 class Treatment;
 var Alcohol;
 title 'Alcohol Independence';
run;
proc ttest data = vitamin;
 class Treatment;
 var Smoke;
 title 'Smoking Independence';
run;
