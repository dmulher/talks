data PiiData = PiiData {pid :: Int, name :: String}
    deriving (Show)

data HashedPiiData = HashedPiiData {pii :: PiiData, hash :: Int}
    deriving (Show)

instance Eq HashedPiiData where
    x == y = hash x == hash y

hashPii :: PiiData -> HashedPiiData
hashPii a = HashedPiiData a ((pid a) * (length (name a)))

retrieveFromCache :: [HashedPiiData] -> HashedPiiData -> HashedPiiData
retrieveFromCache [] a = a  -- Send to decryption service
retrieveFromCache (c:cs) a
    |c == a = c
    |otherwise = retrieveFromCache cs a

encryptedPiiData = [
    hashPii $ PiiData 1 "A=xi",
    hashPii $ PiiData 2 "dasPa",
    hashPii $ PiiData 3 "2lA/Cs",
    hashPii $ PiiData 4 "a=+edac"]

decryptedPiiData = [
    hashPii $ PiiData 1 "Bill",
    hashPii $ PiiData 2 "Sarah",
    hashPii $ PiiData 3 "Argyle",
    hashPii $ PiiData 4 "Elizabeth"]

decryptFromCache = retrieveFromCache decryptedPiiData
-- map decryptFromCache encryptedPiiData
-- we can successfully use map with a partially applied function