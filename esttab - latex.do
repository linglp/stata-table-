sysuse census.dta, clear 

//change this file path to your own file path 
global output "/Users/linglingpeng/Downloads/FreshEBT/Lingling/blog - output"

//run a list of regressions 
eststo reg1: qui reg death marriage pop 
eststo reg2: qui reg death popurban 
eststo reg3: qui reg divorce marriage pop

local regressions reg1 reg2 reg3

//a basic version of Latex table: 
esttab `regress' using "$output/reg_1.tex", replace 


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////


*** Latex table 

//table with three panels 
//NE region only 
qui reg death marriage if region == 1
est store ne1

qui reg divorce marriage pop if region == 1
est store ne2

//South region only 
qui reg death marriage if region == 3
est store s1

qui reg divorce marriage pop if region ==3
est store s2

//West region only 
qui reg death marriage if region == 4
est store w1

qui reg divorce marriage pop if region ==4
est store w2

//top panel 
esttab ne1 ne2 using "$output/panel.tex", ///
    prehead("\begin{table}[htbp]\centering \\  \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \\ \caption{Title of your table} \\ \begin{tabular}{l*{2}{c}} \hline\hline") ///
	posthead("\hline \\ \multicolumn{2}{c}{\textbf{Panel A: NE Region}} \\\\[-1ex]") ///
	fragment ///
	mtitles("Num of Death" "Num of Divorces") stats(r2 N, labels(R-squared "N. of cases")) b(%8.3f) se(%8.3f) replace
eststo clear

//middle panel 
esttab s1 s2 using "$output/panel.tex", ///
    posthead("\hline \\ \multicolumn{2}{c}{\textbf{Panel B: South Region}} \\\\[-1ex]") ///
	fragment ///
	append ///
	r2 b(%8.3f) se(%8.3f) stats(r2 N, labels(R-squared "N. of cases")) nomtitles nonumbers
eststo clear

//bottom panel 
esttab w1 w2 using "$output/panel.tex", ///
   	posthead("\hline \\ \multicolumn{2}{c}{\textbf{Panel C: West Region}} \\\\[-1ex]") ///
	fragment ///
	append ///
	r2 b(%8.3f) se(%8.3f) stats(r2 N, labels(R-squared "N. of cases")) nomtitles nonumbers  ///
	prefoot("\hline") ///
	postfoot("\hline\hline \multicolumn{5}{l}{\footnotesize Standard errors in parentheses}\\\multicolumn{2}{l}{\footnotesize \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\)}\\ \end{tabular} \\ \end{table}")

	






