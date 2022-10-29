/*  first day   */

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempt < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempt FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/*  second day------ */

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon%';
UPDATE animals SET species = 'pokemon' WHERE species = '';
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

/* delete an rollback */

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

/*Delete all animals born after Jan 1st, 2022. Create a savepoint for the transaction.*/

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SELECT * FROM animals;
SAVEPOINT SV;
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT * FROM animals;
ROLLBACK TO SV;
UPDATE animals SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT;

/* Analytical questions starts here */

/* How many animals are there? */
SELECT COUNT(*) FROM animals;
/*How many animals have never tried to escape?*/
SELECT COUNT(*) FROM animals WHERE escape_attempt=0;
/*What is the average weight of animals?*/
SELECT AVG(weight_kg) FROM animals;
/*Who escapes the most, neutered or not neutered animals?*/
SELECT neutered, AVG(escape_attempts) FROM animals GROUP BY neutered ORDER BY AVG DESC LIMIT 1;
/*What is the minimum and maximum weight of each type of animal?*/
SELECT MIN(weight_kg) as min_weight, MAX(weight_kg) as max_weight, species FROM animals GROUP BY species;
/*What is the average number of escape attempts per animal type of those born between 1990 and 2000?*/
SELECT AVG(escape_attempt) as escape_AVG, species FROM animals WHERE date_of_birth BETWEEN '01-01-1990' AND '31-12-2000' GROUP BY species;
