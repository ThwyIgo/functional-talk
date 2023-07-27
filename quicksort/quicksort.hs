import Control.Monad (when, forM_)
import Control.Monad.ST (ST, runST)
import Data.STRef (newSTRef, modifySTRef', readSTRef)
import Data.Array.ST (STArray, newListArray, readArray, writeArray, getElems)
import Data.List (length)
import System.IO

quicksort :: Ord a => [a] -> [a]
quicksort xs = runST $ do
    let n = length xs
    -- New array from xs with 0 as the lowest index and n-1 as the highest
    arr <- newListArray (0, n-1) xs
    quicksort' arr 0 (n-1)
    -- Convert array back to a list
    getElems arr

quicksort' :: Ord a
           => STArray s Int a -- Array of a, where indexes are Int
           -> Int -- Lower bound index
           -> Int -- High bound index
           -> ST s () -- Returns nothing, but we need to specify the ST monad,
                      -- similar to IO ()
quicksort' arr lo hi
  | lo < hi = do
      -- all elements to the left of p are smaller than arr[p]
      -- all elements to the right of p are greater than arr[p]
      p <- partition arr lo hi
      quicksort' arr lo (p - 1)
      quicksort' arr (p + 1) hi
  | otherwise = return ()

partition :: Ord a
          => STArray s Int a -- Array
          -> Int -- Lower bound index
          -> Int -- High bound index
          -> ST s Int -- Pivot's last index
partition arr lo hi = do
  -- Pivot is alwaysthe value of the last element
  pivot <- readArray arr hi -- pivot = arr[hi]
  -- Pointer for greater element
  ip <- newSTRef (lo - 1) -- int *i = new int(lo-1) // ip aka "i pointer"
  -- for (int j=lo; j<hi; j++)
  forM_ [lo..hi-1] $ \j -> do
    aj <- readArray arr j -- aj = arr[j]
    when (aj <= pivot) $ do
      modifySTRef' ip (+1) -- i++
      i <- readSTRef ip -- int i = *ip
      swap arr i j -- swap(arr[i], arr[j])

  i <- (+1) <$> readSTRef ip -- int i = 1 + *ip
  swap arr i hi
  return i

swap :: STArray s Int a -> Int -> Int -> ST s ()
swap arr i j
  | i == j = return ()
  | otherwise = do
      vi <- readArray arr i
      vj <- readArray arr j
      writeArray arr i vj
      writeArray arr j vi

main = do
  numstxt <- openFile "nums.txt" ReadMode
  nums :: [Int] <- fmap read . words <$> hGetContents numstxt
  print $ quicksort nums
