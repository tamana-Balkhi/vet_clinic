CREATE TABLE animals (
id INT,
name VARCHAR(15) not null,
date_of_birth date,
escape_attempt INT,
neutered BOOLEAN DEFAULT false,
weight_kg FLOAT DEFAULT 0
);
CREATE TABLE