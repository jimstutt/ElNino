> {-# LANGUAGE ScopedTypeVariables, DataKinds, TupleSections, FlexibleContexts #-}

> import Control.Applicative ((<$>))
> import Control.Monad
> import Data.Array.IO (Ix)
> import qualified Data.Array.IO
> import qualified Data.ByteString as B
> import qualified Data.ByteString.Lazy as L
> import Data.Array.Repa
>-- import Data.Array.Repa.IO
> import qualified Data.Vector.Unboxed as U
> import Prelude hiding (zipWith)
> import Statistics.Distribution hiding (stdDev)
> import Statistics.Sample
>-- import Statistics.Sample.KernelDensity (kde)
> import System.Environment
> import System.Random
> import Test.Tasty
>-- import Text.Hastache (MuType(..), defaultConfig, hastacheFile)
>-- import Text.Hastache.Context (mkStrContext)

> import ENParams
> import ENUtils


Compile the modules that use Repa with the following flags-Odph -rtsopts -threaded -fno-liberate-case -funfolding-use-threshold1000 -funfolding-keeness-factor1000 -fllvm -optlo-O3

* [NCAR Atmos](http://goo.gl/1PtQXG)

Visualize NCEP Reanalysis Daily Averages Surface Level Data (Specify dimension values)

ERROR: Could not extract file information for Air temperature

John Baez described the [brief](http://azimuth.mathforge.org/discussion/1348/azimuth-initiatives/#Item_18):

<quote>
  get ahold of daily temperature data for “14 grid points in the El Niño basin and 193 grid points outside this domain” from 1981 to 2014. That’s 207 locations and 34 years. This data is supposedly available from the National Centers for Environmental Prediction and the National Center for Atmospheric Research Reanalysis I Project.

DT:

Let T k(t)T_k(t) be the daily atmospheric temperature anomalies (actual temperature value minus climatological average for each calendar day).

> tAnom = undefined
> tObs = undefined

DT:

Recap: S(t)S(t) was defined as the mean of all the S ij(t)S_{ij}(t), where ii is a node inside the El Niño basin, and jj is outside of it.

Hence, S(t)S(t) is a measure of the “cooperativity” between the El Niño basin and its complement.

The claim made by the paper is that when S(t)S(t) rises from below to cross a certain threshold, then that is a predictive signal that an El Niño will occur next year.

To determine the threshold, the divide the historical data into two periods: first a learning phase, and then a prediction phase.

The learning phase is used to find that value of the threshold which gives the “best” performance in terms of minimizing false alarm rate and maximizing the hit rate.

(Note these are two conflicting goals, so I there must be some subjective judgement about what gives the best performance, no?)

This threshold is then used in the prediction phase.

    Josef Ludescher, Avi Gozolchiani, Mikhail I. Bogachev, Armin Bunde, Shlomo Havlin, and Hans Joachim Schellnhuber, Very early warning of next El Niño, Proceedings of the National Academy of Sciences, 30 May 2013.

With the threshhold that they obtained during the learning phase, they report that in the testing phase, alarms were correct in 76% and the nonalarms in 86% if all cases.

Furthermore, based on current values of S(t)S(t) between September 7 and September 17 of last year, their threshold predicts the return of El Niño in 2014 with a 3-in-4 likelihood.

They state that this is in contrast to the CPC/IRI consensus probabilistic ENSO forces yielding a 1-in-5 likelihood for an ENSO event next year, which increased to a 1-in-3 likelihood by November 2013.

ell, if it makes a testable prediction, which is borne out by empirical evidence, then it’s worthy of investigation and further development.

Here are my reservations about it:

    There’s no trace of a plausible explanation for why cooperativity would foreshadow El Niño the next year. Of course, if it’s a real empirical discovery, then the explanation could come later.

    The result could be fluke resulting from an arbitrary conjecture whose parameters were optimized using too small a dataset. The training and predictions periods are each about thirty years long. I saw it stated that during the training period there were ten El Niño events. Can statistics be applied here, to help address this concern? (Though we’d have to view statistical reassurances also with a grain of salt.)

In other words, I’m concerned that this is like applying machine learning to the predictions of a set of Tarot cards.

On the [project discussion](http://azimuth.mathforge.org/discussion/1358/project-using-climate-networks-for-el-nino-signal-processing/#Comment_10766) 

JB:

NCEP/NCAR Reanalysis 1: Surface.

More precisely, there’s a bunch of files [here](http://www.esrl.noaa.gov/psd/cgi-bin/db_search/DBSearch.pl?Dataset=NCEP+Reanalysis+Daily+Averages+Surface+Level&Variable=Air+Temperature&group=0&submit=Search) containing 

If you go [here](http://www.esrl.noaa.gov/psd/cgi-bin/DataAccess.pl?DB_dataset=NCEP+Reanalysis+Daily+Averages+Surface+Level&DB_variable=Air+temperature&DB_statistic=Mean&DB_tid=41710&DB_did=33&DB_vid=668) the website will help you get data from within a chosen rectangle in a grid, for a chosen time interval.

{JS: I couldn't save the selected box data! Urggh. TBD.}

Graham Jones wrote:

...

The reason I went looking for Nino3.4 data is that in this paper: Improved El Niño forecasting by cooperativity detection, Josef Ludescher et al, 2013, it provides what they are trying to predict,ie, El Niño events. The data contains one number per month back to 1870. 

An El Niño event is declared when the NINO3.4 index stays above 0.5C for 5 months. 

The index is defined as “the average of the sea-surface temperature (SST) anomalies at certain grid points in the Pacific (Fig. 1)”.

"30 days have September, April, June and July, all the rest have 31 except Feruary alone which has 29"

In order search each location for each day.

>-- avSSTAnom d basin
>--   | getDays temps > 0.5 && basin >=  150 = []:t -- 5 months = 150 days (29+(3*30)+(8*31)) = 367
>--   | otherwise = Nothing

So one game is to make better predictions than they did.

    one could make a model that correctly predicts all of those, yet is fundamentally stupid and fails the next time around.

The usual guard against that is to ’train’ the method on some of the data (eg 1948-1980) and evaluate it on the rest. With so few El Niños, that is not great. Making continuous predictions of the NINO3.4 index might be preferable.    one could make a model that correctly predicts all of those, yet is fundamentally stupid and fails the next time around.

The usual guard against that is to ’train’ the method on some of the data (eg 1948-1980) and evaluate it on the rest. With so few El Niños, that is not great. Making continuous predictions of the NINO3.4 index might be preferable.


And yes, I could draw a box, but I think subtracting the long-term means so differences show up better is the next thing to do.



>-- newtype Temp = Array  i e -- Int (Double,Double) Int Double

>-- newtype Coords = Coords Float Float


zipWith takes a function and 2 collections and emits the Cartesian product.

  zipWith :: (a->b) -> [a] -> [b] -> [a] or something like that

(,) is the tuple operator

  (,) :: a -> a -> (a,a)

Functions can be constrained to typeclasses. This is no the same as a Java typecass but is similar and can be used like mixins.

<codestuff>

  function :: (Typeclass a) => Type1 a -> ... -> TypeN a

>-- the table indices should add up to a list length

>-- counts_prop :: Int -> Int -> Int -> Bool
>-- counts_prop ly l d = length testLats + length testLongs == maxCoords 
>--   && length basin + length exbase == 207
>--   && length $ rows table!y!l!d + length $ cols table!y!l!d == 2568870
>--   && length randBndTemps == 2568870

  The paper starts by taking these temperatures, computing the average temperature at each day of the year at each location, 

What we need to do is construct a compound index.

IdxArray accumulator sort of thing.

>-- The "!" operator selects from an array; x!i!j selects from a 2D array

>-- avYrLocDayTemp :: Integer -> (Double,Double) -> Integer -> Array Int 
>--                     (Array (Double,Double) (Array Int [Double])) -> Double
>-- avYrLocDayTemp :: (Ix i2, Ix i1, Ix i) => i2 -> i1 -> i -> Array i2 (Array i1 (Array i e)) -> e
> avYrLocDayTemp y l d temps = temps!y!l!d

>-- avYrLocDayTemps :: (Fractional Int) => Loc -> Days -> Array U Int (Array U (Double,Double) (Array U Int [Double]))->[Double]
>-- avYrLocDayTemps l temps = do 
>--   let totalLocDaysTemp = [(sum avYrLocDayTemp y l d temps) | d <- days, y <- getYears]
>--      totalLocDaysCount = [fromIntegral (length ds) | ds <- getDays]

, ys <- getYears, locs <- (basin `elem` getLocs)]

>--   return totalLocDaysTemp/totalLocDaysCount

How do I add a tuple index? Can it be done? No! MD array now!

Can't select a tuple index with !. How about (! (fst loc))?

Repa version

> lys = length years
> llocs = length locs
> llas = length blats
> llos= length blongs
> lds = length days
> temps = undefined

fromListUnboxed (Z :.lys :. llocs :. llas :. (length days)) [1..[lys*llocs*llas*llos*lds*1] :: Array U DIM5 Double

For each location and each day, slice this as 1 location, 1 day, 9 locations and 34 years.

This should be a lens view. How about a prism? TBD.
This would recast arrays as records.
How can I have array lenses? Would I want them? TBD.


>-- locDaySlice :: (Ix Int) => Int -> Int -> Temps
>-- locDaySlice temps ixl ixd = temps!years!ixl!ixd : locDaySlice (tail temps)!ixl!ixd

>-- locBounds :: (Ix Locs) => (Double,Double)
>-- locBounds = (length $ fmap fst basin, length $ fmap snd basin)

and subtracting this from the actual temperatures to obtain “temperature anomalies”. In other words, we want a big array of numbers like this: the temperature on March 21st 1990 at some location, minus the average temperature on all March 21sts from 1981 to 2014 at that location.

>-- anomalies y l d temps = temps!y!l!d - avTempAllYearsLocDay

>-- avTempAllYearsLocDay l d temps = [sum temps!yrs!l!d/(length ds)|yrs = [1..34], ds <- days]]

  Then they process this array of numbers in various ways, which I can explain…

  They consider all pairs of locations, so at some point they are working with 207 × 207 × 365 × 34 numbers. Is that a lot of numbers these days?

Data sets

There are several El Nino data sets.

The format of air-sig1995.1971.nc to air-sig1995.2014.nc has
data for:

* 43 years
* 21 latitudes
* 444 longitudes
* 365 days
* 146,340,180 temperature measurements.

A table has bounds and indices.



Aargh. This works with a range of ('a'.'z') but not with numbers! TBD.

>-- table :: (Ix i, Num i) =>  Array i [Double]
>-- table = listArray (1,43*125*21*365) (take (125*21) randBndTemps)


>-- table2 :: Years -> Area -> Days -> Array i e
>-- table2  ys area ds = listArray bnds [ys,area,ds] where
>--   bnds  = (1,(14+193)*34)


Seasonal trends are detrended by subtracting the yearly mean temperature from the particular day's temperature.

>-- This tells you how much “hotter it is today than it usually is here at this time of year”.

>-- anoRectGrid = rectSquareGrid r c where
>--   r = length testLats
>--   c = length testLongs
 
>-- grid1 = listArray bnds [y,area,d] where
>--   bnds = (1,length y + length area + length d) 
>-- y = [1971..2014]  
>-- d = [1..365]

>-- meanAnnDiffTemp y area d = y!area!d - (sum area!l!y!d)/365

I assume that when d+τd+\tau exceeds 365 you go over to the next year, since that’s the reasonable thing to do.

The point is that X(ℓ,y,τ)X(\ell,y, \tau) tells you how much the temperature at grid point ℓ\ell is correlated to the temperature at grid point rr, τ\tau days later, during year yy.

where n = total number of years observed.

l and r are a pair of sites on the grid.

>-- tMax = 365
>-- tMin = -365
>-- tRange = [tMin..tMax] -- days

>-- tuple
> pairs :: ([Int],[Int]) -> [(Int,Int)]
> pairs area = [(l,r) |l <-[1..9324], r <- [1..9324]]

>-- temps = fmap pos d []

>-- a random series should have zero correlation

ElNino/ElNino.lhs:240:19:
    Couldn't match expected type ‘Double -> Double -> t’
                with actual type ‘[t5]’

>-- nocorr_prop :: Bool
>-- nocorr_prop = do
>--   let nearly = [crosscov (head r) ((head . tail) r) |r <- take (125*21) randBndTemps] 
>--   return $ nearly >= -0.1 && nearly <= 0.1

>-- crosscov :: Double -- Array i e -> Array i e -> Double
>-- crosscov l y r tau
>--   | tau <= 0 = crosscov l y r (-tau) 
>--   | otherwise = crosscov l y r tau


>-- crosscov l y r tau 
>--    | tau >= 0 = pick2
>--    | otherwise =(-1)*pick2

>-- pick2 :: [Double]
> pick2 = [temps!y!l!d * temps!y!r!(d+tShift) 
>         |y <- [1981..2014]
>         , l <- [1]
>         , r <- [1]
>         , d <- [1..365]
>         , tShift <- [2]]

 --  if crosscov < 0 then ((-)1)*tShift else ccor

tShifts are always positive.

So there's no difference between the cases!?

If the time shift (tShift) is zero or negative then its time shift of the cross correlation (crosscov) is taken to be positive.

I don't understand this! TBD.

How do we get zero or negative time shifts?

This does it.

>-- meanChanges :: [Double]
>-- meanChanges = fmap (/12) $ fmap ((-)5.0) zipWith (+) qs js where
>--                qs = [1..10::Double]
>--                js = [1..10::Double]

>-- cStrength :: Year -> Loc -> Loc -> Double
>-- cStrength yr l r = max (crosscov basin . stdDev . abs . crosscov pacific)


The time delay (tDelay) is the time shift with the maximal correlation.

Significant links are defined only as pairs l and r which have a link correlation strength (cStrength) greater than some constant. 

This is represented as a Heaviside function:

>{-
> rho y l r temps = theta (cStrength temps!y!l!r - threshStrength) where -- (1)
>   theta x = if x < 0 
>               then 0 
>               else 
>                 if x == 0 
>                   then 0.5 
>                   else 1 --  heaviside
>-}
> threshStrength = 2
>

For different years pairs might or might not be significant and thus "blink" as the appear and disappear.

Significant pairs are sensitive to initial choice of year  and noise.

Do not ask which pairs form a static network. Ask which ones change.

I do not understand, aren't they closed and complementary and thus mutually-defined?

Blinking links are taken as correlated with structural change.

For a currently existing (ie. significant) link ($$rho$$, was it significant in the past?


Util functions depending on data structure here

> getYears temps = temps
> getLocs  temps = temps!locs
> getBasin temps = temps!basin
> getDays  temps = temps!locs!years

> showYears temps = putStrLn $ getYears temps
> showLocs temps = putStrLn $ getLocs temps
> showDays temps = putStrLn $ getDays temps



Averages and crosses

References

[3] A. L. Baraba ́i, Linked: The New Science of Networks (Perseus Publishing, 2003).

[8]
[11] H. A. Dijkstra, Nonlinear Physical Oceanography (Kluwer Academic Publishers, 2000).


--## Normalised records

Temperatures indexed by day and location for 34 years and 207 locations.

Relations

year n <-> n (location 1 <-> 1 [(lat,long)]) n <-> 365 day <-> (locCount*365) temperature.



--## [R NetCDF](https://www.image.ucar.edu/GSP/Software/Netcdf/)


 The netCDF file can be broken down into logical parts. To that end, lets take a look at the header of a very simple netCDF file.

netCDF example {
dimensions:
        EW = 87 ;
        SN = 61 ;
variables:
        double EW(EW) ;
                EW:units = "meters" ;
        double SN(SN) ;
                SN:units = "meters" ;
        float Elevation(SN, EW) ;
                Elevation:units = "meters" ;
                Elevation:missing_value = -1.f ;
}

--## [NCAR CCSM One timestep](http://www.unidata.ucar.edu/software/netcdf/examples/files.html)

Cloud computing TBD
* http://cloudcomputing.sys-con.com/
* http://www.ibm.com/ibm/cloud/



