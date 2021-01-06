## Currency gem

##### Purpose
- To create a currency object that can be used to convert, display and use currency values in calculations

##### Dependencies
- Net/http
  - For accessing a forex API to covert at live rates
- Possibly a helper class for doing the exchange rate stuff?

### Class

##### Data Structure
- Currency object
  - Hash
    - Type
    - Value

##### Types
- Start with worlds top 10 most-used currencies

##### Behavior
- initialize (to_type, value)
  - type
  - value
- convert (to_type)
  - convert using live rates
  - return currency object or nil if invalid
- convert_at (to_type, rate)
  - convert using argument rate
  - return currency object or nil if invalid
- to_f
  - return a type-relevant formatted floating-point Float object
- to_s 
  - return a type-relevant string representation of Currency object

###### private behavior
- format_string
  - make proper string adjustment depending on currency type
- verify_valid?
  - check array of valid types to verify symbol arguments to convert methods
- fetch_rate
  - call API for forex rate

##### Class Constants
- Currency types
  - array of valid types
    - symbols

##### Notes
- combine convert methods into one or use two separate?
- make forex API a separate class or just a private method within the currency class?

##### Process
1.  Create the class and basic methods/structure
2.  Introduce the valid data types
3.  Create the string/numberic formatting methods and test them
4.  Find a valid (free!) forex API
5.  Introduce a means of fetching live exchange rate using that API
  - convert the Currency.type value into something that can be used by the API
  - convert the data returned by the API into something that can be used by ruby
6.  Verify the conversion functionality
7.  Write a test suite using multiple currency types and values
  - Happy path
  - Invalid data type
  - Invalid values (negative, out of range)
8.  Publish to rubygems