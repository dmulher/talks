identity :: a -> a
identity x = x

square :: Num a => a -> a
square x = x^2

cube :: Num a => a -> a
cube x = x^3

summation :: (Num a, Ord a) => (a -> a) -> a -> a -> a
summation f a b = if a > b
                  then 0
                  else f(a) + summation f (a + 1) b

summationFold :: (Num a, Enum a) => (a -> a) -> a -> a -> a
summationFold f a b = foldl (\acc x -> acc + f(x)) 0 [a..b]

summationHigher :: (Num a, Enum a) => (a -> a) -> a -> a -> a
summationHigher f a b = foldl (+) 0 (map f [a..b])
