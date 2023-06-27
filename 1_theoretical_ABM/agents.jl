## Contains:
# Struct definitions for all entities in the model
# Constructors
# Auxiliary functions

## Datatypes

# Person struct
@enum Status potential intention migrant
mutable struct Person
   id :: Int64
   status :: Status
   family :: Vector{Person}
   community :: Vector{Person}
   totsav :: Float64 #Cumulative savings
   ainc :: Float64 #Agents' income in each step. It represents a fixed income multiplied by a random proportion.
   gain :: Float64
   loss :: Float64
end

Person() = Person(1, potential, [], [], 0, 0, 1, 1) # Default person is potential and has no contacts
Person(id :: Int64) = Person(id, potential, [], [], 0, 0, 1, 1)
Person(state :: Status) = Person(1, state, [], [], 0, 0, 1, 1) # Default person has no contacts and 0 income.
Person(totsav, ainc) = Person(1, potential, [], [], totsav, ainc, 1, 1)
Person(gain :: Float64) = Person(1, potential, [], [], 0, 0, gain, 1)
Person(loss :: Float64) = Person(1, potential, [], [], 0, 0, 1, loss)
methods(Person) # Check the constructors created for Person.

# Household struct
@enum statusHH potential_hh intention_hh

mutable struct Household
  members :: Vector{Person}
  status_hh :: statusHH
  vuln :: Float64 #Household vulnerability
end

Household() = Household([], potential_hh, 0)
Household(status_hh :: statusHH) = Household([], status_hh, 0)
Household(vuln :: Float64) = Household([], potential_hh, vuln)
