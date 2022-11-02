CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempt INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg DECIMAL NOT NULL
);
CREATE TABLE

ALTER TABLE animals ADD species char(50);


/* third day */

 CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    PRIMARY KEY(id)
);
CREATE TABLE


CREATE TABLE species(
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY(id) 
);

ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD species_id INT;
ALTER TABLE animals ADD owner_id INT;


/*Set relation between owners and animals*/
ALTER TABLE animals ADD CONSTRAINT fk_animals_owner FOREIGN KEY (owner_id) REFERENCES owners(id);


/*Set realtion between species and owners*/
ALTER TABLE animals ADD CONSTRAINT fk_animals_species FOREIGN KEY (species_id) REFERENCES species(id);



-- Create vets table----
CREATE TABLE vets (
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100),
    age INT NOT NULL,
    date_of_graduation DATE NOT NULL
);


-- Create many-to-many relationship between 'species' and 'vets' tables---
CREATE TABLE specializations (
    vet_id INT NOT NULL REFERENCES vets(id),
    species_id INT NOT NULL REFERENCES species(id),
    PRIMARY KEY (species_id, vet_id)
);


-- Create many-to-many relationship between 'animals' and 'vets' tables
CREATE TABLE visits (
    animal_id INT NOT NULL REFERENCES animals(id),
    vet_id INT NOT NULL REFERENCES vets(id),
    visit_date DATE NOT NULL
);

----increase speed----
 DELETE FROM visits ALTER TABLE visits
 ALTER COLUMN visit_date SET DATA TYPE TIMESTAMP WITH TIME ZONE;
 CREATE INDEX animal_id_desc ON visits(animal_id DESC);
 CREATE INDEX vet_id_desc ON visits(vet_id DESC);
 CREATE INDEX owners_email_desec ON owners(email DESC);
