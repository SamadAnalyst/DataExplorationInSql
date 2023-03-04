select *
from PortfolioProject..CovidDeaths
order by 3,4;


--select *
--from PortfolioProject..CovidVaccination
--order by 3,4;


select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2;


--Total cases vs Total death

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercentageOfDeath
from PortfolioProject..CovidDeaths 
order by 1,2;


--Total cases vs total deaths of Bangladesh

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercentageOfDeath
from PortfolioProject..CovidDeaths 
where location like '%desh%'
order by 1,2;


--Percentage of population got covid-19

select location, date,population, total_cases, (total_cases/population)*100 as PercentageOfAffected
from PortfolioProject..CovidDeaths 
--where location like '%desh%'
order by 1,2;


--Countries with highest infection rate 

select location,population, max(total_cases) as MaximumInfection, max((total_cases/population))*100 as PercentageOfAffected
from PortfolioProject..CovidDeaths 
--where location like '%desh%'
group by location,population
order by PercentageOfAffected desc;


--Countries with highest Death count

select location, max(cast(total_deaths as int)) as MaximumDeath
from PortfolioProject..CovidDeaths 
--where location like '%desh%'
where continent is not null
group by location
order by MaximumDeath desc;



--Continent with highest death count

select continent, max(cast(total_deaths as int)) as MaximumDeath
from PortfolioProject..CovidDeaths 
--where location like '%desh%'
where continent is not null
group by continent
order by MaximumDeath desc;


--Global numbers

select date, sum(new_cases) as Total_NewCases,sum(cast(new_deaths as int)) as Total_NewDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths 
--where location like '%desh%'
where continent is not null
group by date
order by 1,2;


--total new cases,deaths and percentage of deaths

select sum(new_cases) as Total_NewCases,sum(cast(new_deaths as int)) as Total_NewDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths 
--where location like '%desh%'
where continent is not null
--group by date
order by 1,2;




--Covid vaccination


select * 
from PortfolioProject..CovidVaccination


select *
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date


--total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--toal population vs rolling vaccination count

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.date, dea.location) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--use CTE (common table expression)

With PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.date, dea.location) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

)
select *,(RollingPeopleVaccinated/population)*100 as TotalPercentageVaccinated from
PopvsVac


--Creating view 

Create View PercentPeopleVaccinated As
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.date, dea.location) as PercentPeopleVaccinated
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


select * from
PercentPeopleVaccinated