## Analysis of variance (ANOVA)

In this project I analyze [data set](https://github.com/danon6868/BI_Stat_2020/blob/main/project_anova/project_anova.pdf), which was collected by twenty different doctors. I had information on two hundred patients for whom the sex, age, number of days spent in the hospital, the presence of a relapse, and the type of medicine with which the patient was treated was known. 

It was necessary to do the following:

1. Create a custom function to combine files of the same extension into a common dataframe. This function takes the path to the data folder, as well as the type of files that it will parse.
2. Check the correctness of the data and bring it into line with the tidy data concept. Conduct an EDA.
3. Conduct a two-way ANOVA (by type of drug and gender) for the number of days in the hospital.
4. Check the conditions of applicability of the analysis of variance.
5. Interpret the results of the model.
6. Perform post-hoc tests and describe the results obtained.

The main conclusion of the work is that people of different sexes need to prescribe different types of drugs. The wrong drug can even increase recovery time compared to placebo.

You can view a detailed report with the format [rmd](https://github.com/danon6868/BI_Stat_2020/blob/main/project_anova/project_anova.Rmd) and [html](https://danon6868.github.io/BI_Stat_2020/project_anova).
