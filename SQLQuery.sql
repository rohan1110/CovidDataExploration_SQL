/*
Covid 19 Data Exploration using SQL
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

datasource : https://ourworldindata.org/coronavirus */

-- select *
-- from coviddeaths
-- where continent is not null
-- order by 3,4


-- (01) Select Data that we are going to be starting with

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
where continent is not null;

-- (02) Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in India

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where continent is not null 
and location like '%India%';

-- (03) Total Cases vs Population
-- Shows what percentage of population infected with Covid in India

select location, date, population, total_cases, (total_cases/population)*100 as PopulationAffectedPercentage
from coviddeaths
where continent is not null 
and location like '%India%';

-- (04) Countries with Highest Infection Rate compared to Population

select location, population, max(total_cases) as HighestInfection, Max(total_cases/population)*100 as PopulationAffectedPercentage
from coviddeaths
-- where location like '%India%' 
group by location, population
order by PopulationAffectedPercentage desc ;

-- (05) Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%India%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc ;

-- BREAKING THINGS DOWN BY CONTINENT

-- (06) Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From coviddeaths
--Where location like '%India%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- (07) GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
--Where location like '%India%'
where continent is not null 
--Group By date
order by 1,2

-- (08) Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths as dea
join covidvacc as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 1,2,3

-- (09) Using CTE to perform Calculation on Partition By in previous query no.(08)

WITH PopVsVac(continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths as dea
join covidvacc as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 1,2,3
)
select *, (RollingPeopleVaccinated/population)*100 as TotalPopulationVaccPercentage
from PopVsVac

-- (10) Using Temp Table to perform Calculation on Partition By in previous query no.(08)

DROP Table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated 
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths as dea
join covidvacc as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 1,2,3

select *, (RollingPeopleVaccinated/population)*100 as TotalPopulationVaccPercentage
from #PercentPopulationVaccinated

-- (11) Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select *
from PercentPopulationVaccinated
