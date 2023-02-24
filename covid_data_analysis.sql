select * from portfolio_projects.dbo.coviddeaths$

-- Data we will be working with

Select Location, date, total_cases, new_cases, total_deaths, population
From portfolio_projects.dbo.coviddeaths$
Where continent is not null 
order by 1,2

-- Death Percentage 

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portfolio_projects.dbo.coviddeaths$
--Where location like '%states%'and 
Where continent is not null 
order by 1,2

-- Percentage of Population Infected by Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From portfolio_projects.dbo.coviddeaths$
--Where location like '%states%'
order by 1,2

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolio_projects.dbo.coviddeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From portfolio_projects.dbo.coviddeaths$
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Contintents with the highest death count 

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From portfolio_projects.dbo.coviddeaths$
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- Total cases, deaths, death percentage all over the world

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From portfolio_projects.dbo.coviddeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Percentage of Population that has recieved at least one Covid Vaccine

With PplVaccinated (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From portfolio_projects.dbo.coviddeaths$ dea
Join portfolio_projects.dbo.covidvaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as percentagevaccinated
From PplVaccinated
