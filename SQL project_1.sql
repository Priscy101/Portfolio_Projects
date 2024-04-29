SELECT *
FROM [PortfolioProject]..[Coviddeath]
order by 3,4


--SELECT *
--FROM PortfolioProject..Covidvaccination
--order by 3,4

--Select Data that we are going to be using

 

SELECT Location, date, total_cases, total_deaths, new_cases, population_density
from PortfolioProject..Coviddeath
order by 1,2


--Total cases vs total deaths

select * 
from PortfolioProject..Coviddeath
where total_cases IS NOT NULL 
AND total_deaths IS NOT NULL 


SELECT location, date, total_cases, total_deaths, (total_cases/population_density)*100 as Deathpercentage 
from PortfolioProject..Coviddeath
where total_cases IS NOT NULL
AND total_deaths IS NOT NULL
AND location like '%Nigeria%'
order by 1,2

--Looking at Total cases vs Population

select location, date, population_density, total_cases, (total_cases/population_density)*100 as Deathpercentage
from PortfolioProject..Coviddeath
where total_cases IS NOT NULL
AND total_deaths IS NOT NULL
AND location like '%Nigeria%'
order by 1,2





--Countries with highest infection rates

select location, population_density, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population_density))*100 as PercentagePopulationInfected
from PortfolioProject..Coviddeath
where population_density IS NOT NULL
--AND PercentagePopulationInfected IS NOT NULL
--AND location like '%Nigeria%'
Group by location, population_density
order by PercentagePopulationInfected desc




--Countries with highest Death Count per Population_density


select location, MAX(cast(Total_deaths as INT)) as TotalDeathcount
from PortfolioProject..Coviddeath
where continent is not null
Group by location
order by TotalDeathCount desc



-- Breaking down by continent

select continent, MAX(cast(Total_deaths as INT)) as TotalDeathcount
from PortfolioProject..Coviddeath
where continent is not null
Group by continent
order by TotalDeathCount desc


-- Continent with the Highest death count per population


select continent, MAX(cast(Total_deaths as INT)) as TotalDeathcount
from PortfolioProject..Coviddeath
where continent is not null
Group by continent
order by TotalDeathCount desc


--Global Data


SELECT SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/nullif(sum(new_cases),0)*100 as DeathPercentage 
from PortfolioProject..Coviddeath 
where continent is not null
and total_cases is not null
and total_deaths is not null
--Group by date
order by 1,2



select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
    sum(convert(bigint, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
from PortfolioProject..Coviddeath dea
Join PortfolioProject..Covidvaccination vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- USE CTE

with PopvsVac (Continent, location, date, population_density, new_vaccinations, RollingPeopleVaccinationed)
as
(
select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
    sum(convert(bigint, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
from PortfolioProject..Coviddeath dea
Join PortfolioProject..Covidvaccination vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinationed/population_density)*100
from PopvsVac



-- TEMP TABLE



Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population_density numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)


INSERT INTO #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
    sum(convert(bigint, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
from PortfolioProject..Coviddeath dea
Join PortfolioProject..Covidvaccination vac
    on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/ NULLIF(population_density, 0))*100
from #PercentPopulationVaccinated



-- Create View to store data for later visualization

drop view if exists PercentagePopulationVaccinated
create view PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
    sum(convert(bigint, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
from PortfolioProject..Coviddeath dea
Join PortfolioProject..Covidvaccination vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentagePopulationVaccinated