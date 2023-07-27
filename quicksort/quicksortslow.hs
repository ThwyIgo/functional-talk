import System.IO

quicksort :: Ord a => [a] -> [a]
quicksort [] = []
quicksort (p:xs) = lesser ++ [p] ++ greater
  where
    lesser = quicksort $ filter (< p) xs
    greater = quicksort $ filter (>= p) xs

main = do
  numstxt <- openFile "nums.txt" ReadMode
  nums :: [Int] <- fmap read . words <$> hGetContents numstxt
  print $ quicksort nums
