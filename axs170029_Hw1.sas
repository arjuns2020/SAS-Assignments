ODS HTML CLOSE; ODS HTML;

/*Q1*/

DATA q1;
INFILE 	'SwineFlu2009.dat';
INPUT 	firstcase_ID 1-12 
		firstcase_location $ 14-17 
		firstcase_country $ 32. @ '2' 
		firstcase_date YYMMDD10. 	
		cum_cases_April 79-86 
		cum_cases_May 89-96 
		cum_cases_June 99-106 
		cum_cases_July 109-116 
		cum_cases_Aug 119-126 
		cum_cases_Aug9 129-136 	
		firstdeath_ID 145-149 
		firstdeath_location $ 155-168 
		firstdeath_date YYMMDD10. 
		cum_deaths_May 194-197 
		cum_deaths_June 204-210
		cum_deaths_July 214-220 
		cum_deaths_Aug 224-230 
		cum_deaths_Sep 234-240 
		cum_deaths_Oct 244-250 
		cum_deaths_Nov 254-260 
		cum_deaths_Dec;
FORMAT	First_Case_Date yymmdd10. 
		First_Death_date yymmdd10.;
LABEL		firstcase_ID = 'Ranks of First cases reported'
		firstcase_location = 'Country Rank of first case reported'
		firstcase_country = 'Country of first case' 
		firstcase_date = 'Date of first case' 
		cum_cases_April = 'Total no of cases in April'
		cum_cases_May = 'Total no of cases in May' 
		cum_cases_June = 'Total no of cases in June' 
		cum_cases_July = 'Total no of cases in July'
		cum_cases_Aug = 'Total no of cases in August' 
		cum_cases_Aug9 = 'Last case reported to WHO on August 9'				
		firstdeath_ID = 'Rank of first death reported'
		firstdeath_location = 'Rank of country where first death reported in continent' 
		firstdeath_date = 'Date of first death reported'
		cum_deaths_May = 'Total no of deaths in May' 
		cum_deaths_June = 'Total no of deaths in June' 
		cum_deaths_July = 'Totalno of  deaths in July'
		cum_deaths_Aug = 'Total no of deaths in August' 
		cum_deaths_Sep = 'Total no of deaths in September' 
		cum_deaths_Oct = 'Total no of deaths in October'
		cum_deaths_Nov = 'Total no of deaths in November' 
		cum_deaths_Dec = 'Total no of deaths in December';

PROC PRINT data=q1;
PROC CONTENTS;
RUN;




/*Q 2*/

PROC IMPORT DATAFILE = "/folders/myfolders/Hw1/Pizza.csv" 
OUT = work.pizza 
DBMS = csv;
PROC PRINT DATA = pizza;
PROC CONTENTS;
RUN;

/*Part D*/
DATA pizza_2;
INFILE "Pizza.csv" DLM = ',' FIRSTOBS = 2 TRUNCOVER DSD;
INPUT SurveyNum Arugula PineNut Squash Shrimp Eggplant;
PROC PRINT DATA = pizza_2;
PROC CONTENTS;
RUN;

/*Part E*/
PROC MEANS MEAN;
VAR Arugula PineNut Squash Shrimp Eggplant;
ODS OUTPUT SUMMARY = pizza_m;
RUN;
PROC PRINT DATA = pizza_m;
RUN;




/*Q 3*/

/*Part A*/
DATA 	h1;
INFILE	"/folders/myfolders/Hw1/Hotel.dat" TRUNCOVER;
INPUT	Room_Number 1-7 
		No_Of_Guests 8-12 
		Check_In_Month 13-15 
		Check_In_Day 16-18 
		Check_In_Year 19-26 
		Check_Out_Month 27-29 
		Check_Out_Day 30-33 
		Check_Out_Year 34-41 
		Internet_Flag $ 42-48 
		Internet_Days 49-52 
		Room_Type $ 53-68 
		Room_Rate 69-72;
PROC PRINT DATA = h1;
RUN;


/*Part B, C and D*/
DATA 	h2;
INFILE	"/folders/myfolders/Hw1/Hotel.dat" TRUNCOVER;
INPUT	Room_Number 1-7 
		No_Of_Guests 8-12 
		Check_In_Month 13-15 
		Check_In_Day 16-18 
		Check_In_Year 19-26 
		Check_Out_Month 27-29 
		Check_Out_Day 30-33 
		Check_Out_Year 34-41 
		Internet_Flag $ 42-48 
		Internet_Days 49-52 
		Room_Type $ 53-68 
		Room_Rate 69-72;
Check_In_Date = INPUT(CATX("/",Check_In_Month,Check_In_Day,Check_In_Year),mmddyy10.);
FORMAT 	Check_In_Date mmddyy10.;
Check_Out_Date = INPUT(CATX("/",Check_Out_Month,Check_Out_Day,Check_Out_Year),mmddyy10.);
FORMAT 	Check_Out_Date mmddyy10.;
Stay_Count = Check_Out_Date - Check_In_Date;
IF Internet_Flag = "NO" THEN Internet_Flag=0;
IF Internet_Flag = "YES" THEN Internet_Flag=1;
IF Internet_Days ="." THEN Internet_Days=0;
Sub_total = (Stay_Count * Room_Rate)  + (((No_Of_Guests-1)* 10)* Stay_Count) + (9.95 * Internet_Flag)+ 
(4.95 * Internet_Days);
Grand_Total = 1.0775 * Sub_Total;
PROC PRINT DATA = h2;
RUN;

/*Part E*/
/*Grand total for room 211 = 1357.65*/



 