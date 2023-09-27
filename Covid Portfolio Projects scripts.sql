
Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths
From PortfolioProject..CovidDeaths
order by 1,2

  --Looking at Total Cases vs Total Deaths
  --Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths
From PortfolioProject..CovidDeaths
Where location like '%state%'
order by 1,2
    
   --Lokking at Total cases vs Population

Select Location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where loaction like '%state%'
order by 1,2


  --Looking at Countries with Highest Infection Rate compared to Population 

  Select Location, Population, Max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where loaction like '%state%'
Group by Location, Population
order by PercentPopulationInfected 


--LET'S BREAK THIS DOWN BY CONTINENT

 Select continent, Max(cast(Total_deaths as int)) as TotalDeathcount
From PortfolioProject..CovidDeaths
--where loaction like '%state%'
Where continent is not null
Group by continent 
order by TotalDeathCount desc

--Showing continents with the highest death count per population
Select continent, Max(cast(Total_deaths as int)) as TotalDeathcount
From PortfolioProject..CovidDeaths
--where loaction like '%state%'
Where continent is not null
Group by continent 
order by TotalDeathCount desc


--Global Numbers

Select date, SUM(new_cases), SUM(cast(new_deaths as int)) , SUM(cast(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where loaction like '%state%'
Where continent is not null
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(Convert(int,vac.new_vaccinations) OVER (Partition by dea.location), ddea.Data) as RollingpeopleVaccinated
From PortfolioProject.. CovidDeaths dea
Join PortfolioProject.. CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
Where continent is not null
order by 2,3

--Temp Table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Loaction nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
dea.Data) as RollingpeopleVaccinated
  --(RollingPeopleVaccinated/population)*100
From PortfolioProject.. CovidDeaths dea
Join PortfolioProject.. CovidVaccinations vac
On dea.location = vac.location
On dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating View to store Data for later Visualization

Create View