# Covid 19 Data Exploration using SQL

The datasourse was collected from *ourworldindata.org* where the data was built on 207 country profiles which allows to explore the statistics on the coronavirus pandemic for every country in the world.

Covid19 datasource : https://ourworldindata.org/coronavirus

Date : 05,July,2021

![coronavirus-data-explorer2](https://user-images.githubusercontent.com/63396845/124471839-fb9da400-ddba-11eb-8110-7edb508b9138.png)

For sake of simplifing the operations on the dataset, it is divided into 2 parts, first *CovisDeaths* and second, *CovidVacc*. We have quiried these datasets seperately and later on joined them and to perform operations.

**The skills used in this data exploration are :** 
* Joins 
* CTE's
* Temp Tables
* Windows Functions
* Aggregate Functions
* Creating Views
* Converting Data Types

![SQL queries image](https://user-images.githubusercontent.com/63396845/124611698-4f79bd00-de8f-11eb-865c-cda4be6bb01f.jpg)


**The data that was aquired using different queries is :**

* Total Cases vs Total Deaths
* Total Cases vs Population
* Countries with Highest Infection Rate compared to Population
* Countries with Highest Death Count per Population
* Showing contintents with the highest death count per population
* Total Population vs Vaccinations
* Using *CTE* to perform Calculation on Partition By in previous query
* Using *Temp Table* to perform Calculation on Partition By in previous query 
* Creating *View* to store data for later uses analysis and visualizations
