## Linear models

During this project I worked with data on the cost of housing in Boston in the 1970s and 80s built into the MASS package (Boston dataframe). It was necessary to see how the average cost of home-occupied houses depends on various factors (proximity to the river, the number of teachers in schools, etc.). A detailed description of the task can be found [here](https://github.com/danon6868/BI_Stat_2020/blob/main/project_lm/project_lm.pdf) 

The main part of the work consisted of the following steps:

1. Building a complete linear model with standardized predictors without interaction
2. Diagnostics of the resulting model:
  1. Checking the linearity of the relationship
  2. Checking for the absence of influential observations
  3. Normal distribution of the residuals of the model
  4. Homoscedasticity
3. Plotting cost predictions from the largest variable by absolute value

The model with all features turned out to be rather bad, almost all conditions of applicability of linear models were violated.

During the additional part, it was necessary to try to understand which aspects to improve and what aspects to focus on in order to maximize the price of the house for sale and try to describe the ideal area to build a house.

In this part, I removed some predictors as they introduced multicollinearity to the data. I did this on the basis of VIF (variance inflation factor) calculation, the threshold value was 2. After that, I left in the model only those predictors that significantly affect the dependent variable. As a result, the model turned out to be not perfect, but much better than in the first step. As a result, I formulated a number of recommendations for choosing an area for building houses. 

A detailed report in format [Rmd](https://github.com/danon6868/BI_Stat_2020/blob/main/project_lm/project_lm_Rmd) и [html](https://danon6868.github.io/BI_Stat_2020/project_lm).
