
-- PULL RPVs INTO TEMP TABLE BECAUSE TEMP'S ARE LIFE --

select * into ##rpvs
from dtodd_ragnar.dbo.voterfile
where state = 'nj' and congressionaldistrict = '2'
and ((vh18p in ('3', '4', '8') or vh16p in ('3', '4', '8') or vh14p in ('3', '4', '8') or vh12p in ('3', '4', '8'))
or registrationdate >= '06-11-2018')

--91109

-- PULL LVs INTO TEMP TABLE BECAUSE TEMP'S ARE LIFE --

select count(*) from dtodd_ragnar.dbo.voterfile
where state = 'nj' and CongressionalDistrict = '3' and ((
vh18g !='' or vh16g !='' or vh14g !='' or vh12g != '') or RegistrationDate >= '11-09-2018')

--434166

-- RPVs/LVs = PERCENTAGE OF LVs THAT ARE RPVs --

-- O.20

-- FIND THE OVER-SAMPLE OF THE CORE -- 

select 0.2 * 400

--80 RPVs OUT OF THE 400 CORE

-- WHAT'S THAT DIFFERENCE? NEED 120 MORE INTERVIEWS FOR THE 200 OVER-SAMPLE -- 

	-- FIND THE CPI FOR THE PROJECT -- $54.44

select 54.44 * 120

-- COST OF THE ADDITIONAL OVER-SAMPLE = $6,532.8