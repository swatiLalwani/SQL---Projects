#testing is data is imported properly
    SELECT*
    FROM covidvaccinationdata
    ORDER BY 3,4
    SELECT*
    FROM coviddeathdata
    ORDER BY 3,4
    SELECT location,date,total_cases,new_cases,total_deaths,population
    FROM coviddeathdata
    WHERE continent is not NULL
    ORDER BY 1,2

#Looking at total_cases vs. total_deaths
#shows the likelihood of dying if contacted by covid in US
    SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
    FROM coviddeathdata
    WHERE Location Like '%states%'
    ORDER BY 1,2

 #What percentage of population was infected by covid?
    SELECT Location,date,total_cases,population,(total_cases/population)*100 AS PercentPopulationInfected
    FROM coviddeathdata
    WHERE Location Like '%states%'
    ORDER BY 1,2

#countries with highest infection rate compared to population
    SELECT Location,population,MAX(total_cases) AS HighestInfestionCount,MAX((total_cases/population))*100 AS PercentPopulationInfected
    FROM coviddeathdata
    GROUP BY population,Location
    ORDER BY PercentPopulationInfected DESC

#Countries showing highest death count per population
    SELECT Location, MAX(total_deaths) AS TotalDeathCounts
    FROM coviddeathdata
    WHERE continent is not NULL 
    GROUP BY Location
    ORDER BY TotalDeathCounts DESC

 #Global numbers
    SELECT SUM(new_cases) AS Total_cases,SUM(new_deaths) AS Total_deathrate,SUM(new_deaths)/SUM(new_cases)*100 AS Deathratepercentage
    FROM coviddeathdata
    Where continent is not NULL
    ORDER BY 1,2
#By Date
    SELECT date,SUM(new_cases) AS Total_cases,SUM(new_deaths) AS Total_deathrate,SUM(new_deaths)/SUM(new_cases)*100 AS Deathratepercentage
    FROM coviddeathdata
    Where continent is not NULL
    GROUP BY date
    ORDER BY 1,2 
#Joining two tables
    SELECT*
    FROM coviddeathdata death
    JOIN covidvaccinationdata vaccination
    ON death.location = vaccination.location
    AND death.date = vaccination.date
#Total population vs.vaccination(How many people in the world are vaccinated?)
    Select death.continent,death.location,death.date,death.population,vaccination.new_vaccinations,
    SUM(vaccination.new_vaccinations) OVER (Partition BY death.location ORDER BY death.location,death.date) AS RollingVaccinatedNumbers
    --, (RollingVaccinatedNumbers/population)*100
    FROM coviddeathdata death
    JOIN covidvaccinationdata vaccination
    ON death.location = vaccination.location
    AND death.date = vaccination.date
    WHERE death.continent is not NULL
    ORDER BY 2,3
#USE CTE

    WITH PopulationvsVaccination (continent,location,date,population,new_vaccinations,RollingVaccinatedNumbers)
    AS
    (
    Select death.continent,death.location,death.date,death.population,vaccination.new_vaccinations,
    SUM(vaccination.new_vaccinations) OVER (Partition BY death.location ORDER BY death.location,death.date) AS RollingVaccinatedNumbers
    --, (RollingVaccinatedNumbers/population)*100
    FROM coviddeathdata death
    JOIN covidvaccinationdata vaccination
    ON death.location = vaccination.location
    AND death.date = vaccination.date
    WHERE death.continent is not NULL
    )
    SELECT *,(RollingVaccinatedNumbers/population)*100 AS PopulationVaccinatedPercentage
    FROM PopulationvsVaccination

#Temptable

    DROP TABLE if exists #PercentageOfVaccinatedPeople
    CREATE TABLE #PercentageOfVaccinatedPeople
    (
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATETIME,
    population FLOAT,
    new_vaccinations FLOAT,
    RollingVaccinatedNumbers FLOAT
    )
    INSERT INTO #PercentageOfVaccinatedPeople

    Select death.continent,death.location,death.date,death.population,vaccination.new_vaccinations,
    SUM(vaccination.new_vaccinations) OVER (Partition BY death.location ORDER BY death.location,death.date) AS RollingVaccinatedNumbers
    --, (RollingVaccinatedNumbers/population)*100
    FROM coviddeathdata death
    JOIN covidvaccinationdata vaccination
    ON death.location = vaccination.location
    AND death.date = vaccination.date
    --WHERE death.continent is not NULL

    SELECT *,(RollingVaccinatedNumbers/population)*100 AS PopulationVaccinatedPercentage
    FROM #PercentageOfVaccinatedPeople










  