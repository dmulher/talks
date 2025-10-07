polynomial :: (Fractional a, Integral b) => a -> b -> a -> a
polynomial a b x = a * x ^ b

differential :: (Fractional a, Integral b) => (a -> b -> a -> a) -> a -> b -> a -> a
differential _ _ 0 _ = 0
differential p a b x = p (a * (fromIntegral b)) (b - 1) x

integral :: (Fractional a, Integral b) => (a -> b -> a -> a) -> a -> b -> a -> a
integral p a b x = p (a / (fromIntegral newB)) newB x
    where newB = b + 1

