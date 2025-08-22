module CompFuncs(
    zero, pred, succ, sum, monus, mult
) where
    
zero :: Int -> Int
zero n = 0

pred :: Int -> Int -> Int
pred n
    | n > 0 = n - 1
    | otherwise = 0

succ :: Int -> Int -> Int
succ n
    | n >= 0 = n + 1
    | otherwise = 0

sum :: Int -> Int -> Int 
sum x y 
    | y == 0 = x
    | y /= x = sum (succ x) (pred y)

monus :: Int -> Int -> Int
monus x y
    | x==0 = 0
    | y==0 = x
    | otherwise = monus (pred x) (pred y)

mult :: Int -> Int -> Int 
mult x y 
    | x==0 = 0
    | y==0 = 0
    | y==1 = x
    | otherwise = multHelp x y x

multHelp :: Int -> Int -> Int -> Int 
multHelp x y s 
    | y==1 = s
    | multHelp x (pred y) (sum x s) 

div x y
    | y == 0 = 0
    | otherwise = divHelp x y (0,0)

divHelp :: Int -> Int -> (Int, Int) -> Int
divHelp x y (r,s)
    | (monus x y) <= 0 = r
    | otherwise = div (monus x y) y (succ r, (monus x y))

mod :: Int -> Int -> Int
mod x y 
    | y == 0 = x
    | otherwise mod (monus x y) y