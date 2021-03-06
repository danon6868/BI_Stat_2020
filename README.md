## Projects on statistics at the Bioinformatics Institute 2020/21


### Content
1. [Project № 1 &ndash; Exploratory data analysis (EDA)](#eda)
2. [Project № 2 &ndash; Linear models](#lm)
3. [Project № 3 &ndash; Analysis of variance (ANOVA)](#anova)
4. [Project № 4 &ndash; Protein expression analysis](#mouse)
5. [Project № 5 &ndash; Survival analysis](#survival)

### Exploratory data analysis (EDA) <a name="eda"></a>

During this project, it was proposed to work with [data](https://github.com/danon6868/BI_Stat_2020/tree/main/project_eda/Data) about molluscs: their age, sex and different sizes. This data was collected by ten people and was located in different files.

The first thing to do was writing a custom function to merge these files and match the data with the tidy data confession. Then I made a short EDA, counted various descriptive statistics, compared some groups of mussels with each other, etc. A more detailed description of the tasks can be found [here](https://github.com/danon6868/BI_Stat_2020/blob/main/project_eda/Project_1.pdf). 

In the course of an additional part, I decided to look at how the person collecting the data affects the distribution of various variables. As a result, it turned out that often the sex and age composition of mollusks is very different in the data of different people. This could be associated with different places where the material was collected, but I did not have additional information.

If you wish, you can familiarize yourself with the report on the work done in the format [Rdm](https://github.com/danon6868/BI_Stat_2020/blob/main/project_eda/project_eda.rmd) or [html](https://danon6868.github.io/BI_Stat_2020/project_eda). 

### Linear models <a name="lm"></a>
During this project I worked with data on the cost of housing in Boston in the 1070s and 80s built into the MASS package (Boston dataframe). It was necessary to see how the average cost of home-occupied houses depends on various factors (proximity to the river, the number of teachers in schools, etc.). A detailed description of the task can be found [here](https://github.com/danon6868/BI_Stat_2020/blob/main/project_lm/project_lm.pdf) 

The main part of the work consisted of the following steps:

1. Building a complete linear model with standardized predictors without interaction
2. Diagnostics of the resulting model:
  1. Checking the linearity of the relationship
  2. Checking for the absence of influential observations
  3. Normal distribution of the residuals of the model
  4. Homoscedasticity
3. Plotting cost predictions from the largest variable by absolut value

The complete model turned out to be rather bad, almost all conditions of applicability of linear models were violated.

During the additional part, it was necessary to try to understand which aspects to improve and what aspects to focus on in order to maximize the price of the house for sale and try to describe the ideal area to build a house.

In this part, I removed some predictors as they introduced multicollinearity to the data. I did this on the basis of VIF (variance inflation factor) calculation, the threshold value was 2. After that, I left in the model only those predictors that significantly affect the dependent variable. As a result, the model turned out to be not perfect, but much better than in the first step. As a result, I formulated a number of recommendations for choosing an area for building houses. 

A detailed report in format [Rmd](https://github.com/danon6868/BI_Stat_2020/blob/main/project_lm/project_lm_Rmd) и [html](https://danon6868.github.io/BI_Stat_2020/project_lm).

### Analysis of variance (ANOVA) <a name="anova"></a>

In this project I analyse [data set](https://github.com/danon6868/BI_Stat_2020/blob/main/project_anova/project_anova.pdf), which was collected by twenty different doctors. I had information on two hundred patients for whom the sex, age, number of days spent in the hospital, the presence of a relapse, and the type of medicine with which the patient was treated was known. 

It was necessary to do the following:

1. Create a custom function to combine files of the same extension into a common dataframe. This function takes the path to the data folder, as well as the type of files that it will parse.
2. Check the correctness of the data and bring it into line with the tidy data concept. Conduct an EDA.
3. Conduct a two-way ANOVA (by type of drug and gender) for the number of days in the hospital.
4. Check the conditions of applicability of the analysis of variance.
5. Interpret the results of the model.
6. Perform post-hoc tests and describe the results obtained.

Основной вывод работы состоит в том, что людям разного пола необходимо выписывать разные типы лекарств. Неверно подобранный препарат может даже увеличить время восстановления по сравнению с плацебо.

Вы можете посмотреть подробный отчет с формате [rmd](https://github.com/danon6868/BI_Stat_2020/blob/main/project_anova/project_anova.Rmd) и [html](https://danon6868.github.io/BI_Stat_2020/project_anova).

### Protein expression analysis <a name="mouse"></a>.

In this project, I analyzed [data] (https://archive.ics.uci.edu/ml/datasets/Mice+Protein+Expression#) about the expression of proteins in different classes of mice. The data set consisted of the expression levels of 77 proteins/protein modifications that produced detectable signals in the nuclear fraction of cortex. The eight classes of mice were described based on features such as genotype, behavior and treatment. According to genotype, mice can be control or trisomic. According to behavior, some mice have been stimulated to learn (context-shock) and others have not (shock-context) and in order to assess the effect of the drug memantine in recovering the ability to learn in trisomic mice, some mice have been injected with the drug and others have not. The aim is to identify subsets of proteins that are discriminant between the classes.

[here](https://danon6868.github.io/BI_Stat_2020/project_mouse)

### Survival analysis <a name="survival"></a>

You can find my report in html [here](https://danon6868.github.io/BI_Stat_2020/project_survival)
