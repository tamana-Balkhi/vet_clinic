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
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
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



/* What animals belong to Melody Pond? */

SELECT animals FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Melody Pond';

/* List of all animals that are pokemon (their type is Pokemon). */

SELECT animals FROM animals JOIN species ON animals.species_id = species.id WHERE species.name = 'Pokemon';


/* List all owners and their animals, remember to include those that don't own any animal. */

SELECT animals, owners.full_name FROM animals JOIN owners ON animals.owner_id = owners.id;


/* How many animals are there per species? */

SELECT species.name, COUNT(animals.name) AS count_animals FROM animals JOIN species ON animals.species_id = species.id GROUP BY species.name;

/* List all Digimon owned by Jennifer Orwell. */

SELECT animals.name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Jennifer Orwell' AND animals.name LIKE '%mon';

/* List all animals owned by Dean Winchester that haven't tried to escape. */

SELECT animals.name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempt = 0;


/* Who owns the most animals? */

SELECT owners.full_name, COUNT(animals.name) AS count_animals FROM animals JOIN owners ON animals.owner_id = owners.id GROUP BY owners.full_name ORDER BY COUNT(animals.name) DESC;


-- Who was the last animal seen by William Tatcher:
SELECT animals.name AS animals_seen, vets.name AS vet, visits.visit_date AS date FROM animals
JOIN visits ON animal_id = visits.animal_id 
JOIN vets ON visits.vet_id = vets.id 
WHERE vets.name = 'William Tatcher' 
ORDER BY visits.visit_date 
DESC LIMIT 1;


---echo How many different animals did Stephanie Mendez see
SELECT COUNT(DISTINCT animals.name) AS total_animals, 
COUNT(DISTINCT animals.species_id) AS types_seen, vets.name AS vet FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez' 
GROUP BY vets.name;

-- List all vets and their specialties, including vets with no specialties
SELECT vets.name AS vet_name, species.name FROM vets 
LEFT JOIN specializations ON specializations.vet_id = vets.id 
LEFT JOIN species ON specializations.species_id = species.id;

--echo List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020
SELECT animals.name AS animals, vets.name As vet_name FROM animals 
JOIN visits ON visits.animal_id = animals.id 
JOIN vets ON visits.vet_id = vets.id 
WHERE visit_date BETWEEN DATE '2020-04-01' AND '2020-08-30' AND vets.name = 'Stephanie Mendez';


----What animal has the most visits to vets
SELECT animals.name, COUNT(visit_date) AS number_of_visits FROM visits 
JOIN animals ON visits.animal_id = animals.id 
GROUP BY animals.name 
ORDER BY number_of_visits 
DESC LIMIT 1;

---Who was Maisy Smiths first visit
SELECT animals.name AS animal, visits.visit_date AS v_date FROM animals 
JOIN visits ON visits.animal_id = animals.id 
JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'Maisy Smith' 
ORDER BY visit_date 
ASC LIMIT 1;

--- Details for most recent visit animal information, vet information, and date of visit
SELECT animals.name, vets.name, visit_date FROM animals 
JOIN visits ON animal_id = animals.id 
JOIN vets ON vet_id = vets.id 
ORDER BY visit_date 
DESC LIMIT 1;

--- How many visits were with a vet that did not specialize in that animals species
SELECT COUNT(*) FROM visits JOIN animals 
ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vet_id
WHERE animals.species_id NOT IN (
    SELECT species_id FROM specializations 
    WHERE vet_id = vets.id
    );

    
--- What specialty should Maisy Smith consider getting? Look for the species she gets the most
SELECT species.name, COUNT(*) FROM visits
JOIN animals ON animals.id = visits.animal_id
JOIN species ON species.id = animals.species_id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY COUNT(*) 
DESC LIMIT 1;