polynomial :: (Fractional a, Integral b) => a -> b -> a -> a
polynomial a b x = a * x ^ b

differential :: (Fractional a, Integral b) => (a -> b -> a -> a) -> a -> b -> a -> a
differential _ _ 0 _ = 0
differential p a b x = p (a * (fromIntegral b)) (b - 1) x

integral :: (Fractional a, Integral b) => (a -> b -> a -> a) -> a -> b -> a -> a
integral p a b x = p (a / (fromIntegral newB)) newB x
    where newB = b + 1

data Character a u s = Character a u s
    deriving Show
character = Character (-9.8) 10.0 0.0

moveCharacter :: Fractional a => a -> Character a a a -> Character a a a
moveCharacter t (Character a u s0) = Character a v s
    where v = u + integral polynomial a 0 t
          s = s0 + integral polynomial u 0 t + integral (integral polynomial) a 0 t

-- moveCharacter 1 character
-- moveCharacter 0.5 $ moveCharacter 0.5 character
-- both equal 5.1, which is what we expect