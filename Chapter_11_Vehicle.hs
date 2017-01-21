data Price = 
    Price Integer
    deriving (Eq, Show)

data Manufacturer =
    Mini
  | Mazda
  | Tata
    deriving (Eq, Show)

data Airline = 
    PapuAir
  | CatapultsR'US
  | TakeYourChancesUnited
    deriving (Eq, Show)

data Vehicle = Car Manufacturer Price
             | Plane Airline
             deriving (Eq, Show)

myCar = Car Mini (Price 14000)
urCar = Car Mazda (Price 20000)
clownCar = Car Tata (Price 7000)
doge = Plane PapuAir

-- 1. What is the type of myCar?
-- :t myCar -> Vehicle

-- 2. define the functions:
isCar :: Vehicle -> Bool
isCar (Car _ _) = True
isCar _         = False

isPlane :: Vehicle -> Bool
isPlane (Plane _) = True
isPlane _         = False

areCars :: [Vehicle] -> [Bool]
areCars = map isCar

-- 3. Now we’re going to write a function to tell us the manufacturer
-- of a piece of data:
getManu :: Vehicle -> Manufacturer
getManu (Car m _) = m
getManu _         = error "Expect a car type"

-- 4. Given that we’re returning the Manufacturer, what will happen if
-- you use this on Plane data?
-- A: Exception: Expect a car type

-- 5. All right. Let’s say you’ve decided to add the size of the plane as
-- an argument to the Plane constructor. Add that to your datatypes
-- in the appropriate places and change your data and functions
-- appropriately.
-- A: Plane Airline Int
