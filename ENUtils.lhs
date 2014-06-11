> module ENUtils where

> import ENParams
> import System.Random

Start with a random array of temperatures from a first cut range of -20 deg.C to 60 deg.C.

> randBndTemps :: IO ()
> randBndTemps = do
>   g <- newStdGen
>   print $ take (125*21) (randomRs (253.0,333.0) g ::[Double])

> getYears temps = temps
> getLocs  temps = temps!locs
> getBasin temps = temps!basin
> getDays  temps = temps!locs!years

> showYears temps = putStrLn $ getYears temps
> showLocs temps = putStrLn $ getLocs temps
> showDays temps = putStrLn $ getDays temps

