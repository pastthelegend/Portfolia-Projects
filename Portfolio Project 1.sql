-- Reviewing data we will work with 

select location, date, total_cases, new_cases, total_deaths, population
from
`trim-plexus-386107.Portfolio_Project1.Covid_Deaths`
order by 1,2


-- Looking at total cases vs Total Deaths 
-- Shows the likelihood of death if you contract COVID in your country.

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from
`trim-plexus-386107.Portfolio_Project1.Covid_Deaths`
order by 1,2

-- Looking at total cases vs population in Australia
-- Shows what percentage of population has gotten COVID in Australia 

select location, date, Population, total_cases, (total_cases/ population)*100 as Covid_Percentage_in_Population
from
`trim-plexus-386107.Portfolio_Project1.Covid_Deaths`
Where location = 'Australia'
order by 1,2

--Looking at countries with highest infection rate compared to population

select location, Population, MAX(total_cases) as Highest_Infection_Count, Max((total_cases/ population))*100 as Covid_Percentage_in_Population
from
`trim-plexus-386107.Portfolio_Project1.Covid_Deaths`
Group by Location, Population
order by Covid_Percentage_in_Population desc

--Showing Countries with highest death count per population

select location, MAX(cast(total_deaths as int)) as Total_deathcount,
from
`trim-plexus-386107.Portfolio_Project1.Covid_Deaths`
Where continent is not null
Group by Location
order by Total_DeathCount desc

-- Showing Continents with the highest death count per population 

select location, MAX(cast(total_deaths as int)) as Total_deathcount,
from
`trim-plexus-386107.Portfolio_Project1.Covid_Deaths`
Where continent is null
Group by location
order by Total_DeathCount desc

-- GLOBAL NUMBERS PER DAY

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(New_Deaths as int))/Sum(New_Cases))*100 as Death_Percentage
from
`trim-plexus-386107.Portfolio_Project1.Covid_Deaths`
Where continent is not null
Group by date
order by 1,2 desc

--Global Numbers Total

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(New_Deaths as int))/Sum(New_Cases))*100 as Death_Percentage
from
`trim-plexus-386107.Portfolio_Project1.Covid_Deaths`
Where continent is not null
order by 1,2 desc

--Looking at total population vs Vaccination 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
From `trim-plexus-386107.Portfolio_Project1.Covid_Deaths` dea
JOIN `trim-plexus-386107.Portfolio_Project1.Covid_Vaccinations` vac
On dea.location = vac.location 
Where dea.continent is not null
and dea.date = vac.date 
order by 2,3

-- Rolling count of people vaccinated 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as Rolling_Num_of_Vaccinated
From `trim-plexus-386107.Portfolio_Project1.Covid_Deaths` dea
JOIN `trim-plexus-386107.Portfolio_Project1.Covid_Vaccinations` vac
On dea.location = vac.location 
Where dea.continent is not null
and dea.date = vac.date 
order by 2,3
