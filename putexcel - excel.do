sysuse census.dta, clear 

//change this file path to your own file path 
global output "/Users/linglingpeng/Downloads/FreshEBT/Lingling/blog - output"


*** Excel table 

putexcel set "$output/example.xls", replace 

//set up the format of Excel table
putexcel A1 = "Title of tables: "
putexcel B2 = "Number of observations"
putexcel C2 = "Mean"
putexcel D2 = "Number of Death"
putexcel E2 = "P-value"


//store all variable names (only use labels)
local varlist marriage pop popurban divorce


local numexcel = 3

foreach X of varlist `varlist' {
              local x : variable label `X'
              putexcel A`numexcel' = "`x'"
			  local numexcel = `numexcel' + 3
}

//run a random regression 
reg death marriage pop popurban divorce 

mat reg_table = r(table)


//if you run "return list", you can see that stata stores the regression above to r(table)


//store all coefficients and p-value in Matrix A

matselrc reg_table A, r(1 4) c(1/4) //select only No.1 and No.4 row and only column 1 to 4


local length = 4 //length of varlist 
local rownum = 3 //where do you want to start in Excel spreadsheet? I want to start from row 3 

forvalues num = 1/`length' {
	local coef = A[1,`num']
	local coef_val = round(`coef', 0.001) //keep only three decimal places
	
	local p_val  = A[2,`num']
	local p_val = round(`p_val', 0.001)
	
	//hard code * into excel spreadsheet 

   if `p_val' <0.01 {
	  local coef_val = "`coef_val''"+"***"
	}
	else if `p_val' <0.05 {
	  local coef_val = "`coef_val''"+"**"
	}
	else if `p_val' <0.10 {
	  local coef_val = "`coef_val'"+"*"
	}
	
	putexcel D`rownum' = "`coef_val'" //remember to add the "" 
	putexcel E`rownum' = `p_val'
	
	local num = `num' + 1
	local rownum = `rownum' +3
}



//store all standard errors in Matrix B

matselrc reg_table B, r(2) c(1/4) //select only the second row and only column 1 to 4

local se_row = 4 //we have to start from one row below coefficient. In my excel spreadsheet, it's row 34

forvalues num = 1/`length' {
	local se = B[1,`num']
	local se_val = round(`se', 0.001) //keep only three decimal places
	local se = string(`se_val',"%8.3f") //turn it into string before put in on Excel 
	
	
	putexcel D`se_row' = "(`se')" //add () around standard error 
	local num = `num' + 1
	local se_row = `se_row' +3
}


//use sum command to store number of observations and mean 
local sumnum = 3

foreach var in `varlist' {
	sum `var'
	putexcel B`sumnum'= (r(N))
	putexcel C`sumnum' = (r(mean))
	
	local sumnum = `sumnum' + 3
	
}
