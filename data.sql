/* inserted data on animals table */

INSERT INTO animals (name, date_of_birth, escape_attempt, neutered, weight_kg) VALUES ('Agumon', '2020-02-03', 0, true, 10.23);
INSERT INTO animals (name, date_of_birth, escape_attempt, neutered, weight_kg) VALUES ('Gabumon', '2018-11-15', 2, true, 8);
INSERT INTO animals (name, date_of_birth, escape_attempt, neutered, weight_kg) VALUES ('Pikachu', '2021-01-07', 1, false, 15.04);
INSERT INTO animals (name, date_of_birth, escape_attempt, neutered, weight_kg) VALUES ('Devimon', '2017-05-12', 5, true, 11);
INSERT INTO animals (name, date_of_birth, escape_attempt, neutered, weight_kg) VALUES ('Charmander', '2020-02-08', 0, false, -11);
INSERT INTO animals (name, date_of_birth, escape_attempt, neutered, weight_kg) VALUES ('plantmon', '2021-11-15', 2, true, -5.7);
INSERT INTO animals (name, date_of_birth, escape_attempt, neutered, weight_kg) VALUES ('Squirtle', '1993-04-02', 3, false, -12.13);
INSERT INTO animals (name, date_of_birth, escape_attempt, neutered, weight_kg) VALUES ('Angemon', '2005-06-12', 1, true, -45);
INSERT INTO animals (name, date_of_birth, escape_attempt, neutered, weight_kg) VALUES ('Boarmon', '2005-06-07', 7, true, 20.4);
INSERT INTO animals (name, date_of_birth, escape_attempt, neutered, weight_kg) VALUES ('Blossom', '1998-10-13', 3, true, 17);
INSERT INTO animals (name, date_of_birth, escape_attempt, neutered, weight_kg) VALUES ('Ditto', '2022-05-14', 4, true, 22);


/* inserted data on owners table */
INSERT INTO owners (full_name, age) VALUES ('Sam Smith', 34);
INSERT INTO owners (full_name, age) VALUES ('Jennifer Orwell', 19);
INSERT INTO owners (full_name, age) VALUES ('Bob', 45);
INSERT INTO owners (full_name, age) VALUES ('Melody Pond', 77);
INSERT INTO owners (full_name, age) VALUES ('Dean Winchester', 14);
INSERT INTO owners (full_name, age) VALUES ('Jodie Whittaker', 38);

/* inserted data on species table */
INSERT INTO species (name) VALUES ('Pokemon');
INSERT INTO species (name) VALUES ('Digimon');


UPDATE animals SET species_id = 2 WHERE name LIKE '%mon';
UPDATE animals SET species_id = 1 WHERE species_id IS NULL;


UPDATE animals
    SET owner_id = (SELECT id FROM owners WHERE full_name = 'Sam Smith')
    WHERE  name = 'Agumon';

/* Jennifer Orwell owns Gabumon and Pikachu. */
UPDATE animals
    SET owner_id = (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
    WHERE name = 'Gabumon'
		OR name =  'Pikachu';

/* Bob owns Devimon and Plantmon. */
UPDATE animals
    SET owner_id = (SELECT id FROM owners WHERE full_name = 'Bob')
    WHERE name = 'Devimon' OR name =  'Plantmon';

/* Melody Pond owns Charmander, Squirtle, and Blossom. */
UPDATE animals
    SET owner_id = (SELECT id FROM owners WHERE full_name = 'Melody Pond')
    WHERE name = 'Charmander' OR name =  'Squirtle' OR name =  'Blossom';

/* Dean Winchester owns Angemon and Boarmon. */
UPDATE animals
    SET owner_id = (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
    WHERE name = 'Angemon' OR name =  'Boarmon';

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
