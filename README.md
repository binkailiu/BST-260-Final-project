# BST 260 Final Project: What should we care about? Contraceptive Use and Health!
### Authors: Binkai (Cathy) Liu, Karla Flores Guzman, Xinhui (Kiera) Zhang, Yichi Zhang, Jiabao (Lily) Zhong
#### December 12, 2021

This Readme.md file contains a catelog of data sources and files on our github repository. It also includes a brief overview of our study backgrounds, objectives, and methods. Note that all original datasets used for our analysis are accessible through both our github repository and website links in later sections. 

# Catelogs
### Catelog of files in github repository
* "Part1_data_cleaning.rmd" *Project overview, data read-in and wrangling* 
* "Part2_exploratory_analysis_linear_regression.rmd" *Exploratory analysis (univariate analysis) & Linear regression model* 
* "Part3_decision_tree_knn.rmd" *Machine learning models (decision tree & kNN)* 
* "Part4_shiny.rmd" *Shiny Apps* 


### Variables, Data sources, and Data descriptions
#### *Outcome 1: Infant mortality rate*
* Data source: [World Health Organization, The Global Health Observatory, Infant mortality rate (probability of dying between birth and age 1 per 1000 live births)](https://www.who.int/data/gho/data/indicators/indicator-details/GHO/infant-mortality-rate-(probability-of-dying-between-birth-and-age-1-per-1000-live-births))
* Data description: This dataset from WHO presents infant mortality rate (probability of dying between birth and age 1 per 1000 live births) in each country. We used the most recent year data for all countries (up to 2019).

#### *Outcome 2: Crude birth rate*
* Data source: [United Nations, Department of Economic and Social Affairs
Population Dynamics, World Population Prospects 2019, Births.xslx](https://population.un.org/wpp/Download/Standard/Fertility/)
* Data description: This dataset presents number of births over 5 years in each country. We used the crude birth rate of 2015-2020 for each country. The 5-year period refers to 1 July, 2015 to 30 June, 2020. Data are presented in thousands.

#### *Outcome 3: HIV prevalence*
* Data source: [Gapminder](https://www.gapminder.org/data/)  Path: Health → HIV → Prevalence of HIV among adults age 15-49 
* Data description: This dataset presents the estimated percentage of adults aged 15-49 that are affected by HIV, including those without symptoms, those sick from AIDS, and those healthy due to treatment of the HIV infection. We used the most recent year data (up to 2010), and excluded countries with only data before 2020.

#### *Predictor: Contraceptive use*
* Data source: [United Nations, Population Division, World Contraceptive Use 2021](https://www.un.org/development/desa/pd/data/world-contraceptive-use)
* Data description: According to UN, the World Contraceptive Use 2021, includes country-specific survey-based observations of key family planning indicators, based on survey data available as of January 2021. We used the data of the most recent year for each country, and excluded countries with the most recent year before 2000. Contraceptive use prevalence is used for model building. We also display prevalence of different subtypes of contraceptives use in different countries in world map using Shiny App.

#### *Predictor: Geographic region*
* Data source: [United Nations, Department of Economic and Social Affairs
Population Dynamics, World Population Prospects 2019, Births.xslx](https://population.un.org/wpp/Download/Standard/Fertility/)
* Data description: We adopted official classification of countries and geographic regions based on the birth rate dataset downloaded from the United Nations website. There are 8 regions in total. This dataset needs to be loaded and cleaned first because we need to incorporate geographic region data into other dataset loaded later.

#### *Predictor: GDP*
* Data source: [Gapminder](https://www.gapminder.org/data/) Path: Economy→Income & Growth → GDP/Capita (US$, inflation adjusted)
* Data description: GDP per capita (divided by midyear population), calculated in constant 2010 US dollars. We used the most recent year (up to 2019) data for all countries.

#### *Predictor: Education level*
* Data source: [Gapminder](https://www.gapminder.org/data/)  Path: Education → Mean years in school → % people 15 years or older
* Data description: Average years in school for women of reproductive age 15 to 44, including primary, secondary and tertiary education. Since gapminder did not have a data for both sexes and our interest is reproductive health, we chose female gender group for this predictor. We used the most recent year data (up to 2010) for all countries.

#### *Predictor: Mean age of childbearing*
* Data source: [United Nations, Department of Economic and Social Affairs
Population Dynamics, World Population Prospects 2019, Mean Age of Childbearing.xslx](https://population.un.org/wpp/Download/Standard/Fertility/)
* Data description: According to UN, this dataset represents the average age of mothers at the birth of their children if women were subject throughout their lives to the age-specific fertility rates observed in a given year. We used data of year `2015-2020` for all countries.

#### *Predictor: Abortion law score*
* Data source: [Wikipedia: Abortion Law. Table. Legal grounds on which abortion is permitted in independent countries](https://en.wikipedia.org/wiki/Abortion_law)
* Data description: This dataset was "web-scrapped" from Wikipedia (Contributer: Binkai (Cathy) Liu), which summarizes the legal grounds for abortion in all United Nations member states and United Nations General Assembly observer states and some countries with limited recognition (202 countries/regions). The data from Wikipedia is mostly based on data compiled by the United Nations up to 2019. We cleaned the dataset and further calculated `Abortion law score` for each country based on the numbers of times that abortion being prohibited in the 6 situations presented in the table, including "Risk to life, risk to health, rape, fetal impairment, economic or social, and on request". The `Abortion law score` ranges from 0-6, with 6 being the most strict on abortion law.

# Project overview
## Overview and Motivation
In 2019, over 1 out of 1.9 billion Women of the Reproductive Age group (15-49 years old) worldwide need family planning, according to WHO; of these, around 800 million use contraceptive methods. Unfortunately, almost 300 million have an unmet need for contraception (WHO). Access to contraceptives is heterogeneous around the world. There could be many reasons for the variation in contraceptives use: taboos, lack of sexual education, armed conflicts, to name a few. Also, women’s acceptance could be diminished by religious opposition, fear of side effects, and poor quality of medical counseling and service.
It is a human right to decide the number and spacing of their children; contraceptives play a crucial role in helping to achieve that right. Moreover, it is well documented that the use of condoms helps to reduce the risk of getting sexually transmitted diseases.
Our team comprises five women interested in different aspects of human health using epidemiological approaches. Motivated by our identities as women scholars from different parts of the world, we were inspired to explore more about how contraceptive uses are associated with different health outcomes across countries, and to build predictive models to predict important outcomes at country level.  

Reference: [WHO. Family planning/contraception methods](https://www.who.int/news-room/fact-sheets/detail/family-planning-contraception)

## Related Work
During the time when we were deciding topics to choose for our project, we brought up recent discussions about [abortion law in Texas](https://www.texastribune.org/2021/10/29/texas-abortion-law-supreme-court/). As women scholars from different regions of the world, we thought it would be interesting to look into how abortion law in different countries affects reproductive health worldwide. As we explored more into different dataset available online, we specified our outcomes to be birth rate, infant mortality rate, and HIV prevalence, and decided to explore associations between various socioeconomic factors and outcomes through statistical models. 

## Initial Questions
Our study objectives are assessing associations between contraceptive use and our outcomes (birth rate, infant mortality rate, and HIV prevalence), respectively. We further built predictive models with important candidate predictors using linear regression, K-nearest neighbors (kNN), and decision tree models. We also present an interactive surface through Shiny App to display different contraceptives uses in different countries in the world, and to let our readers explore the associations between contraceptive use and health together with us.

## Data
A big strength of our project is rich data from different credible sources, including World Health Organization, other departments of the United Nations, and Gapminder. Each group member was responsible for at least some parts of data obtaining, cleaning, and compiling. In the following sections, we will be loading in dataset we used, and presenting data source, brief description of the dataset, and data wrangling we conducted on each dataset obtained.





## Exploratory Analysis
For the first model, we wanted to predict the birth rate in a country using Years in school, Gross domestic product, Use of a contraceptive method, Mean age of childbearing, Region, and score based on abortion legality. We performed univariate linear association with the outcome and created a correlation matrix to see how our variables correlate with birth rate and between themselves. We fitted a linear regression model that predicts birth rate using predictors with significant coefficients at a 0.05 threshold. Residual plots were used to examine the performance of the final model.
For the second model, we wanted to predict infant mortality rate in a country using Years in school, Gross domestic product, Use of a contraceptive method, Mean age of childbearing, Region, and score based on abortion legality. We performed univariate linear association with the outcome to see how our variables correlate with infant mortality rate. We fitted a linear regression model that predicts infant mortality rate using predictors with significant coefficients at a 0.05 threshold. Residual plots were used to examine the performance of the final model.
For the third model, we wanted to predict the HIV prevalence in a country using Years in school, Gross domestic product, Use of a contraceptive method, Use of a barrier method, Region, and score based on abortion legality. We performed univariate linear association with the outcome to see how our variables correlate with HIV prevalence. We fitted a linear regression model that predicts HIV prevalence using predictors with significant coefficients at a 0.05 threshold. Residual plots were used to examine the performance of the final model.


## Final Analysis



