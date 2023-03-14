

----------Queries used for Tableau Project
------- Make spread excel file for each, it will be easy to analyse data


--1. Viewing Death percentage
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..Coviddeath$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--2 Removing unwanted location data and getting location data
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..Coviddeath$
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'High income', 'Upper middle income', 'Lower middle income', 'European Union', 'Low income')
Group by location
order by TotalDeathCount desc


--3 Highest infection rate vs Death percentage
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..Coviddeath$
Group by Location, Population
order by PercentPopulationInfected desc

--4
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..Coviddeath$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc
