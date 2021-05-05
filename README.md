### Changer

#### Install 
Install using `gem install changer`
Register with Rapidapi.com and set your ENV variable 'RAPID_API_KEY' to your
X-RapidAPI-Key value.

#### Currency Objects
Currency objects are created using Currency.new(:sym, amount)
where :sym is the type (:usd) and amount is the value (2.99)

#### Conversion
Conversion can be done in place with the bang methods, or return 
new objects with the regular methods convert, and convert_at.  Convert will
fetch the rate from exchangerates API, while convert_at will use the rate
given in the parameter

#### Currency Math
The math operator methods will handle conversion prior to completing the math
operation, and return a value in the type of the calling object.  For instance,
adding US Dollars and Canadian Dollars will return a value in US Dollars, while
adding Canadian Dollars to US Dollars will return Canadian Dollars.  These 
methods can be chained ie; USD 3.00 + GBP 2.90 - CAD 6.00 = USD xx.xx
