

/*Q1*/
data heinz_processed;
set '/folders/myfolders/HW4/heinzhunts.sas7bdat';
LogPriceRatio = log (PriceHeinz/PriceHunts);
run;

/*Q2*/
proc surveyselect data=heinz_processed out=heinz_processed_sampled outall samprate=0.8 seed=10;
run;

data heinz_processed_training heinz_processed_test;
 set heinz_processed_sampled;
 if selected then output heinz_processed_training; 
 else output heinz_processed_test;
run;


/*Q3*/
/*predictions on test*/
proc logistic data=heinz_processed_sampled ;
 logit: model Heinz (event='1') = LogPriceRatio DisplHeinz|FeatHeinz DisplHunts|FeatHunts ;
 score data=heinz_processed_test out=heinz_processed_logit_predict; /* predictions are made only for the dataset specified*/
run;

/*roc on test*/
proc logistic data=heinz_processed_logit_predict plots=roc(id=prob);
 model Heinz (event='1') = LogPriceRatio DisplHeinz|FeatHeinz DisplHunts|FeatHunts / nofit;
 roc pred=p_1;
run;

/*Q6*/

proc logistic data=heinz_processed_training outmodel=heinz_processed_Logitmodel;
logit: model heinz (event='1') = LogPriceRatio DisplHeinz|FeatHeinz DisplHunts|FeatHunts ;
run;
proc logistic inmodel=heinz_processed_Logitmodel;
score data=heinz_processed_test outroc=heinz_processed_logit_roc;
run;
data heinz_processed_cost;
set heinz_processed_logit_roc;
total_cost = _FALNEG_*1 + _FALPOS_*0.25 ;
run;
proc sort data=heinz_processed_cost out=heinz_processed_cost_sorted;
by total_cost;
run;
