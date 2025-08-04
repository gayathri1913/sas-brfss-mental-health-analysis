LIBNAME proj "/home/u63752988/BS723/PROJECT 2"; 
Proc import out= brfss18
Datafile= "/home/u63752988/BS723/PROJECT 2/brfss.csv" 
DBMS= csv replace; 
Getnames=yes;    

data proj.brfss18;
set brfss18; 

if SO in (7,9) then SO =.;
if SEX1 in (7,9) then SEX1 =.;
if ADDEPEV2 in (7,9) then ADDEPEV2=.; 
if GENHLTH in (7,9) then GENHLTH = .;
if HLTHPLN1 in (7,9) then HLTHPLN1=.;
if INCOME2 in (77,99) then INCOME2=.;
if MENTHLTH in (77,99) then MENTHLTH =.;
if POORHLTH in (77,99) then POORHLTH =.; 

if AGE in (1,2) then agecat=1;
else if AGE in (3,4) then agecat=2;
else if AGE in(5,6,7,8) then agecat=3;
else if AGE in (9,10,11,12,13)then agecat=4;  

if income2 le 6 then incomecat=0;
else if income2 in (7,8) then incomecat=1;

if SO = 2 then so_dichot = 1;
else so_dichot = 0; 

if MENTHLTH = 88 then MENTHLTH=0; 
if POORHLTH = 88 then POORHLTH =0; 
 
label so_dichot="dicotamised sexual orintation"; 
label ADDEPEV2 ="Diagnosed depressive disorder"; 
format SO SOf. SEX1 SEX1f. RACE RACEf. agecat agecatf. incomecat incomecatf. 
bmicat bmicatf. GENHLTH GENHLTHf. so_dichot so_dichotf. SMOKER SMOKERf. ADDEPEV2 HLTHPLN1 ynf.; 
 
if SO =. then delete ; 
if SEX1 =. then delete; 
if INCOME2=. then delete; 
if ADDEPEV2 =. then delete;
if HLTHPLN1 =. then delete ; 
 
proc format; 
value SOf 1 = "Lesbian or Gay" 
         2 = "Straight, that is, not gay"
         3 = "Bisexual"
         4 = "Something else"; 
value SEX1f 1 = "Male" 
           2 = "Female"; 
value RACEf 1 = "White, Non-Hispanic" 
           2 = "Black, Non-Hispanic" 
           3 = "Asian, Non-Hispanic" 
           4 = "American Indian/Alaskan Native, Non-Hispanic" 
           5 = "Hispanic"
           6 = "Other race, Non-Hispanic"; 
value agecatf 1 = "Age 18 to 29"
             2 = "Age 30 to 39"
             3 = "Age 40 to 59"
             4 = "Age 60 and older"; 
value incomecatf 1 = "Earn at least $50,000 or more" 
                0 = "Earn less than $50,000"; 
value bmicatf 1 = "Underweight" 
             2 = "Normal Weight" 
             3 = "Overweight"
             4 = "Obese";   
value GENHLTHf 1 = "Excellent" 
              2 = "Very good" 
              3 = "Good" 
              4 = "Fair" 
              5 = "Poor"; 
value ynf     1 = "Yes" 
              2 = "No";  
value so_dichotf 1 = "straight"
                 0 = "other"; 
value SMOKERf 1 = "Current smoker - now smokes every day" 
             2 = "Current smoker - now smokes some days" 
             3 = "Former smoker" 
             4 = "Never smoked";  
 
 
 /*q2*/ 
proc freq data=proj.brfss18 ;
  tables SEX1*SO/ chisq;
  tables RACE*SO / chisq;
  tables agecat*SO / chisq;
  tables incomecat*SO/ chisq;
  tables bmicat*SO / chisq;
  tables ADDEPEV2*SO / chisq;
  tables GENHLTH*SO / chisq;
  tables HLTHPLN1*SO/ chisq;
  tables SMOKER*SO/ chisq;


/*q2 CONTINOUS VARIABLE*/  
proc anova data= proj.brfss18;	
  class SO;   
  model MENTHLTH = SO;
  means SO; 
run;

proc anova data= proj.brfss18;	
  class SO;   
  model POORHLTH  = SO;
  means SO; 
run;


/*q3 a*/ 
proc glm data=proj.brfss18;
    class SO ( ref='Straight, that is, not gay')  SEX1 ( ref='Male') RACE ( ref='White, Non-Hispanic') agecat (ref='Age 18 to 29') bmicat (ref='Normal Weight') incomecat ( ref='Earn less than $50,000') HLTHPLN1 ( ref='No') SMOKER (ref='Never smoked') ;
	model   MENTHLTH = SO SEX1 RACE agecat bmicat incomecat HLTHPLN1 SMOKER/solution clparm; 
run;  

/*q4 a*/ 
proc logistic data=proj.brfss18;
    class SO (param=ref ref='Straight, that is, not gay')  SEX1 (param=ref ref='Male') RACE (param=ref ref='White, Non-Hispanic') agecat (param=ref ref='Age 18 to 29') bmicat (param=ref ref='Normal Weight') incomecat (param=ref ref='Earn less than $50,000') HLTHPLN1 (param=ref ref='No') SMOKER (param=ref ref='Never smoked') ;
	model  ADDEPEV2 = SO  SEX1 RACE agecat bmicat incomecat HLTHPLN1 SMOKER; 
run;  

/*q5*/  
Proc sort data=proj.brfss18; 
by agecat; 
proc glm data=proj.brfss18;
class SO; 
  model MENTHLTH = SO|agecat SEX1 RACE agecat bmicat incomecat HLTHPLN1 SMOKER /solution clparm; ;  
by agecat;   
run; 

   
