// Andrew McCartney
// 4/25/2018
// Washington Post School Shootings Dataset Clean
// Via Jeremy Singer-Vine
// Dataset Authors: 
///// Research and Reporting: John Woodrow Cox, Steven Rich and Allyson Chiu
///// Production and Presentation: John Muyskens and Monica Ulmanu





// change to your working directory
cd "V:\datasets\data-school-shootings-master\"
// and import CSV
import delimited school-shootings-data.csv, clear


// label variables
label var uid "Unique identifier"
label var nces_school_id "National Center for Education Statistics unique school ID"
label var school_name "Name of school"
label var nces_district_id "National Center for Education Statistics unique district ID"
label var district_name "Name of school district"
label var date "Date of shooting"
label var school_year "School year of shooting"
label var year "Year of shooting"
label var time "Approximate time of shooting"
label var day_of_week "Day of week of shooting"
label var city "City where school is located"
label var state "State where school is located"
label var school_type "Type of school (public or private)"
label var enrollment "Enrollment at school at time of shooting"
label var killed "Number killed in shooting (excludes shooter)"
label var injured "Number injured in shooting (excludes shooter)"
label var casualties "Number killed and injured in shooting (excludes shooter)"
label var shooting_type "Type of shooting"
label var age_shooter1 "Age of first shooter"
label var gender_shooter1 "Gender of first shooter"
label var race_ethnicity_shooter1 "Race or ethnicity of first shooter"
label var shooter_relationship1 "First shooter's relationship to school"
label var shooter_deceased1 "Flag indicating whether first shooter died in shooting"
label var deceased_notes1 "If first shooter deceased, how first shooter died"
label var age_shooter2 "Age of second shooter"
label var gender_shooter2 "Gender of second shooter"
label var race_ethnicity_shooter2 "Race or ethnicity of second shooter"
label var shooter_relationship2 "Second shooter's relationship to school"
label var shooter_deceased2 "Flag indicating whether second shooter died in shooting"
label var deceased_notes2 "If second shooter deceased, how first shooter died"
label var white "Enrollment of white students at time of shooting"
label var black "Enrollment of black students at time of shooting"
label var hispanic "Enrollment of Hispanic students at time of shooting"
label var asian "Enrollment of Asian students at time of shooting"
label var american_indian_alaska_native "Enrollment of American Indian and Alaskan native students at time of shooting"
label var hawaiian_native_pacific_islander "Enrollment of Hawaiian native and Pacific islander students at time of shooting (unavailable prior to 2009)"
label var two_or_more "Enrollment of students of two or more races at time of shooting (unavailable prior to 2009)"
label var resource_officer "Flag indicating presence of school resource officer or security guard on school grounds at time of shooting"
label var weapon "Weapon(s) used in shooting"
label var weapon_source "Where shooter acquired weapon(s) used in shooting"
label var lat "Latitude of school"
rename v42 longitude
label var longitude "Longitude of school"
label var staffing "Full-time equivalent teachers at school at time of shooting"
label var low_grade "Lowest grade-level offered by school"
label var high_grade "Highest grade-level offered at time of shooting"
label var lunch "Number of students at school eligible to receive a free or reduced-price lunch"
label var county "County name where school is located"
label var state_fips "Two-digit state Federal Information Processing Standards code"
label var county_fips "Five-digit county Federal Information Processing Standards code"
label var ulocale "National Center for Education Statistics urban-centric locale code"
label define locale 11 "City, Large Territory inside an urbanized area and inside a principal city with population of 250,000 or more." 12	"City, Mid-size Territory inside an urbanized area and inside a principal city with a population less than 250,000 and greater than or equal to 100,000." 13	"City, Small Territory inside an urbanized area and inside a principal city with a population less than 100,000." 21	"Suburb, Large Territory outside a principal city and inside an urbanized area with population of 250,000 or more." 22	"Suburb, Mid-size Territory outside a principal city and inside an urbanized area with a population less than 250,000 and greater than or equal to 100,000." 23	"Suburb, Small Territory outside a principal city and inside an urbanized area with a population less than 100,000." 31	"Town, Fringe Territory inside an urban cluster that is less than or equal to 10 miles from an urbanized area." 32	"Town, Distant Territory inside an urban cluster that is more than 10 miles and less than or equal to 35 miles from an urbanized area." 33	"Town, Remote Territory inside an urban cluster that is more than 35 miles from an urbanized area." 41	"Rural, Fringe Census-defined rural territory that is less than or equal to 5 miles from an urbanized area, as well as rural territory that is less than or equal to 2.5 miles from an urban cluster." 42	"Rural, Distant Census-defined rural territory that is more than 5 miles but less than or equal to 25 miles from an urbanized area, as well as rural territory that is more than 2.5 miles but less than or equal to 10 miles from an urban cluster." 43	"Rural, Remote Census-defined rural territory that is more than 25 miles from an urbanized area and is also more than 10 miles from an urban cluster." 
label values ulocale locale


// Label Values
capture label define yesno 1 yes 0 no
label values shooter_deceased1 resource_officer yesno

replace gender_shooter1 = "0" if gender_shooter1 == "m"
replace gender_shooter1 = "1" if gender_shooter1 == "f"
replace gender_shooter2 = "0" if gender_shooter2 == "m"
replace gender_shooter2 = "1" if gender_shooter2 == "f"
destring(gender*), replace // why no dynamic typing?
capture label define gndr 1 female 0 male
label values gender* gndr

replace race_ethnicity_shooter1 = "1" if race_ethnicity_shooter1 == "a" // Asian
replace race_ethnicity_shooter1 = "2" if race_ethnicity_shooter1 == "ai" // American Indian
replace race_ethnicity_shooter1 = "3" if race_ethnicity_shooter1 == "b" // Black
replace race_ethnicity_shooter1 = "4" if race_ethnicity_shooter1 == "h" // Hispanic
replace race_ethnicity_shooter1 = "5" if race_ethnicity_shooter1 == "w" // White
replace race_ethnicity_shooter2 = "1" if race_ethnicity_shooter2 == "a" // Asian
replace race_ethnicity_shooter2 = "2" if race_ethnicity_shooter2 == "ai" // American Indian
replace race_ethnicity_shooter2 = "3" if race_ethnicity_shooter2 == "b" // Black
replace race_ethnicity_shooter2 = "4" if race_ethnicity_shooter2 == "h" // Hispanic
replace race_ethnicity_shooter2 = "5" if race_ethnicity_shooter2 == "w" // White
destring(race_ethnicity*), replace // seriously stata is the worst
capture label define race 1 "Asian" 2 "American Indian" 3 "Black" 4 "Hispanic" 5 "White" 
label values race_ethnicity* race



replace shooting_type = "1" if shooting_type == "accidental"
replace shooting_type = "2" if shooting_type == "accidental or targeted"
replace shooting_type = "3" if shooting_type == "hostage suicide"
replace shooting_type = "4" if shooting_type == "indiscriminate"
replace shooting_type = "5" if shooting_type == "public suicide"
replace shooting_type = "6" if shooting_type == "public suicide (attempted)"
replace shooting_type = "7" if shooting_type == "targeted"
replace shooting_type = "8" if shooting_type == "targeted and indiscriminate"
replace shooting_type = "9" if shooting_type == "unclear"
destring(shooting_type), replace
capture label define type 1 "accidental" 2 "accidental or targeted" 3 "hostage suicide" 4 "indiscriminate" 5 "public suicide" 6 "public suicide (attempted)" 7 "targeted" 8 "targeted and indiscriminate" 9 "unclear"
label values shooting_type type







// fix assorted typing issues
replace enrollment=subinstr(enrollment,",","",.)
destring(enrollment), replace
replace white = subinstr(white,",","",.)
destring(white), replace
destring(high_grade), replace

split date, p("/") destring
rename date1 month
rename date2 day
drop date3
label define mo 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values month mo
order uid-district_name month day year time day_of_week school_year-ulocale
drop date

replace school_type = "1" if school_type == "private"
replace school_type = "0" if school_type == "public"
destring(school_type), replace
label define schtype 1 "private" 0 "public"
label values school_type schtype

save school-shootings-data-clean, replace


