import Common
import qualified Data.Map as Map
import Data.Map (Map)

main :: IO ()
main = do
  let result = solution validPassport $ readLines "inputs/4.test.input"
  print result

  let result = solution validPassport $ readLines "inputs/4.input"
  print result

  let result = solution bonusValidPassport $ readLines "inputs/4.test.input"
  print result

  let result = solution bonusValidPassport $ readLines "inputs/4.input"
  print result

type Passport = Map String String

solution :: (Passport -> Bool) -> [String] -> Int
solution validator input = length $ filter validator $ parsePassports input

parsePassports :: [String] -> [Passport]
parsePassports lines = fmap parsePassportIds rawPassports
           where rawPassports = split "" lines

parsePassportIds :: [String] -> Passport
-- <$> is just alias for `fmap splitter ....`
parsePassportIds rawPassport = Map.fromList $ splitter <$> concatMap words rawPassport
              where splitter rawId = case split ':' rawId of (key:value:_) -> (key, value)

requiredFields :: [String]
requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
-- ignoredFields  = ["cid"]

validPassport :: Passport -> Bool
validPassport passport  = all (`elem` Map.keys passport) requiredFields

-- Bonus

bonusValidPassport :: Passport -> Bool
bonusValidPassport passport  = validByr && validIyr && validEyr && validHgt && validHcl && validEcl && validPid && validCid
        -- byr (Birth Year) - four digits; at least 1920 and at most 2002.
  where validByr = validateNumericRange [1920..2002] $ Map.lookup "byr" passport
        -- iyr (Issue Year) - four digits; at least 2010 and at most 2020.
        validIyr = validateNumericRange [2010..2020] $ Map.lookup "iyr" passport
        -- eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
        validEyr = validateNumericRange [2020..2030] $ Map.lookup "eyr" passport
        validHgt = validateHgt $ Map.lookup "hgt" passport
        validHcl = validateHcl $ Map.lookup "hcl" passport
        validEcl = validateEcl $ Map.lookup "ecl" passport
        validPid = validatePid $ Map.lookup "pid" passport
        -- cid (Country ID) - ignored, missing or not.
        validCid = True

validateNumericRange :: [Int] -> Maybe String -> Bool
validateNumericRange range (Just value) = read value `elem` range
validateNumericRange _ _ = False

-- hgt (Height) - a number followed by either cm or in:
-- If cm, the number must be at least 150 and at most 193.
-- If in, the number must be at least 59 and at most 76.
validateHgt :: Maybe String -> Bool
validateHgt (Just value) = case span (`elem` ['0'..'9']) value of
                                (height, "cm") -> read height `elem` [150..193]
                                (height, "in") -> read height `elem` [59..76]
                                _              -> False
validateHgt _ = False

-- hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
validateHcl :: Maybe String -> Bool
validateHcl (Just ('#':value)) = length value == 6 && all (`elem` "0123456789abcdef") value
validateHcl _ = False

-- ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
validateEcl :: Maybe String -> Bool
validateEcl (Just value) = value `elem` ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
validateEcl _ = False

-- pid (Passport ID) - a nine-digit number, including leading zeroes.
validatePid :: Maybe String -> Bool
validatePid (Just value) = length value == 9 && all (`elem` ['0'..'9']) value
validatePid _ = False
