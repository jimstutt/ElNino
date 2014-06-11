> module ENUtils where

> import Data.Array.Repa
> import System.Random

> import ENParams

Start with a random array of temperatures from a first cut range of -20 deg.C to 60 deg.C.

>-- randData = mkArray U DIM5 Double

> randBndTemps :: IO ()
> randBndTemps = do
>   g <- newStdGen
>   print $ take (125*21) (randomRs (253.0,333.0) g ::[Double])

Sensitivity to initial conditions possibilities tell me to be as exact as possible: enough instabilties already; and matching a model to time series with a missing day seems more convoluted. 

Leap-adjusted standard years and months can be matched to actual days and months by interpolation from the common ends:

> months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
> monthDays = [30,28,31,30,31,30,31,31,30,31,30,31]
> stdMonth = take 12 $ repeat 30


* Graham Jones wrote:

NOAA seem to use the convention of heading east from Greenwich. But I see John says El Nino is area 5°S-5°N and 170°-120°W. That’s 190°E- 300°E. I think.

{JS.

  5-(-5) = 10 deg lat

          0EW 
       /      \
     90W  ==   90E
       \       /
         180WE

  170W - 120W = 50 deg long.
  170W == 190E

Graham had 300E - 190E but:

  300E == 60W
  120W == 240E
 
  240E = 120W not 60.

> eOrW a -- or wOr E
>   | a < 180 = a
>   | a == 180 = 180
>   | a > 180 = a -180


The interval is 110 deg. for both.

> we1 = eOrW (170-120)

> ew1 = eOrW (300 - 190)  
> ew2= eOrW (240 - 190)


* "30 days hath April, Jun, Sep and Nov, all the rest have 31 except for February alone which has 28 and 29 on a leap year."


