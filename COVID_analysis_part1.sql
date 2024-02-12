Select * From coviddeaths
order by location;

-- Select Data that we are going to be using 

select location, population, date_d, total_cases, new_cases, total_deaths
From coviddeaths;

-- Looking at Total Cases vs Total Deaths 
-- Shows likelihood of dying if you get infected with COVID-19 in your country 

select location, population, date_d, total_cases, total_deaths,
(total_deaths/total_cases)*100 as death_percentage
From coviddeaths
Where location like '%States%';

-- Looking at the Total Cases vs Population 
-- Shows infection rate in your country 

select location, population, date_d, total_cases, total_deaths, 
(total_cases/population)*100 as infection_percentage
From coviddeaths
Where location like '%States%';

select location, population, date_d, total_cases, total_deaths, 
(total_cases/population)*100 as infection_percentage
From coviddeaths
Where location like '%India%';

-- Looking at countries with highest infection rate compared to population

select location, population, MAX(total_cases) as max_infection_count, 
MAX((total_cases/population))*100 as infection_percentage
From coviddeaths
GROUP BY location, population
Order by infection_percentage desc;

-- Looking at Countries with Highest Death Rate compared to population

select location, MAX(total_deaths) as max_death_count
--MAX((total_deaths/population))*100 as death_percentage
From coviddeaths
--Where location like '%State%'
Where continent is not null
GROUP BY location
ORDER BY max_death_count desc;
--Order by death_percentage desc;

--Let's look at the numbers by continent

select location, MAX(total_deaths) as max_death_count
--MAX((total_deaths/population))*100 as death_percentage
From coviddeaths
--Where location like '%State%'
Where continent is null
GROUP BY location
ORDER BY max_death_count desc;
--Order by death_percentage desc;

--Showing the continents with highest death count

select continent, MAX(total_deaths) as max_death_count
--MAX((total_deaths/population))*100 as death_percentage
From coviddeaths
--Where location like '%State%'
Where continent is not null
GROUP BY continent
ORDER BY max_death_count desc;

 -- Global numbers 

select continent, MAX(total_deaths) as max_death_count,
MAX((total_deaths/population))*100 as death_percentage
From coviddeaths
Where continent is not null
GROUP BY continent
ORDER BY max_death_count desc;

Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
(sum(new_deaths)/sum(new_cases))*100 as death_percentage
from coviddeaths
where continent is not null;

-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date_d, dea.population,
vac.new_vaccinations, SUM(vac.new_vaccinations) OVER 
(Partition by dea.location order by dea.location, dea.date_d) as RollingVacCount
--(RollingVacCount/population)
From coviddeaths as dea
join covidvaccinations as vac 
	on dea.location = vac.location 
	and dea.date_d = vac.date
where dea.continent is not null 
--where dea.continent like 'Europe'
order by 1,2;

-- creating view to store data for later visualizations 

create view percentpopvaccinated as 
select dea.continent, dea.location, dea.date_d, dea.population,
vac.new_vaccinations, SUM(vac.new_vaccinations) OVER 
(Partition by dea.location order by dea.location, dea.date_d) as RollingVacCount
--(RollingVacCount/population)
From coviddeaths as dea
join covidvaccinations as vac
	on dea.location = vac.location 
	and dea.date_d = vac.date
where dea.continent is not null;

-- USE CTE 
with popvsvac (continent,location,date_d,population,new_vaccinations, RollingVacCount)
as
(
select dea.continent, dea.location, dea.date_d, dea.population, vac.new_vaccinations
	,SUM(vac.new_vaccinations) OVER 
(Partition by dea.location order by dea.location, dea.date_d) as RollingVacCount
--(RollingVacCount/population)
From coviddeaths as dea
join covidvaccinations as vac
	on dea.location = vac.location 
	and dea.date_d = vac.date
where dea.continent is not null
--where dea.continent like 'Europe'
--order by 1,2
)
select *,(RollingVacCount/population)*100
From popvsvac