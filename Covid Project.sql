Select *
From PortfolioProject..Coviddeath$
Where continent is not null
order by 3,4


--Select *
--From PortfolioProject..Covidvaccination$
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..Coviddeath$
order by 1,2

--Looking for Total Cases vs Total Deaths
--Show Likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (Convert(decimal(15,3),total_deaths)/Convert(decimal(15,3),total_cases))*100 as DeathPercentage
From PortfolioProject..Coviddeath$
Where location like '%India%' and continent is not null
order by 1,2

--Looking at Total Cases vs Population

Select location, date, population, total_cases, (Convert(decimal(15,3),total_cases)/Convert(decimal(15,3),population))*100 as DeathPercentage
From PortfolioProject..Coviddeath$
---Where location like '%India%' 
Where continent is not null
order by 1,2   

--Looking at countries with highest infection rate compare to population
 Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((Convert(decimal(15,3),total_cases)/Convert(decimal(15,3),population)))*100 as PercentPopulationInfected
From PortfolioProject..Coviddeath$
Group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest death count per population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..Coviddeath$
Where continent is not null
Group by location
order by TotalDeathCount desc



-- Showing conitents with highest death count per population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..Coviddeath$
Where continent is not null
Group by continent
order by TotalDeathCount desc


--- Global Number

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..Coviddeath$
where continent is not null 
--Group By date
order by 1,2


-- looking at total population vs vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From PortfolioProject..Coviddeath$ dea
Join PortfolioProject..Covidvaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

---Use CET to perform Calculation on Partition By in previous query
With PopvsVac (continent, loaction, date, population, new_vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From PortfolioProject..Coviddeath$ dea
Join PortfolioProject..Covidvaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100 as Vaccinatedpercent
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From PortfolioProject..Coviddeath$ dea
Join PortfolioProject..Covidvaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3
Select *, (RollingPeopleVaccinated/population)*100 as Vaccinatedpercent
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From PortfolioProject..Coviddeath$ dea
Join PortfolioProject..Covidvaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3


Select *
From PercentPopulationVaccinated



