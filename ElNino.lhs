> {-# LANGUAGE ScopedTypeVariables #-}

> import Control.Applicative ((<$>))
> import Data.Array
> import Statistics.Distribution hiding (stdDev)
> import Statistics.Sample
>-- import Statistics.Sample.KernelDensity (kde)
>-- import Text.Hastache (MuType(..), defaultConfig, hastacheFile)
>-- import Text.Hastache.Context (mkStrContext)
> import qualified Data.Attoparsec as B
> import qualified Data.Attoparsec.Char8 as A
> import qualified Data.ByteString as B
> import qualified Data.ByteString.Lazy as L
> import qualified Data.Vector.Unboxed as U
> import System.Random

* [NCAR Atmos](http://goo.gl/1PtQXG)

Visualize NCEP Reanalysis Daily Averages Surface Level Data (Specify dimension values)

ERROR: Could not extract file information for Air temperature

John Baez described the [brief](http://azimuth.mathforge.org/discussion/1348/azimuth-initiatives/#Item_18):

<quote>
  get ahold of daily temperature data for “14 grid points in the El Niño basin and 193 grid points outside this domain” from 1981 to 2014. That’s 207 locations and 34 years. This data is supposedly available from the National Centers for Environmental Prediction and the National Center for Atmospheric Research Reanalysis I Project.

  The paper starts by taking these temperatures, computing the average temperature at each day of the year at each location, and subtracting this from the actual temperatures to obtain “temperature anomalies”. In other words, we want a big array of numbers like this: the temperature on March 21st 1990 at some location, minus the average temperature on all March 21sts from 1981 to 2014 at that location.

  Then they process this array of numbers in various ways, which I can explain…

  They consider all pairs of locations, so at some point they are working with 207 × 207 × 365 × 34 numbers. Is that a lot of numbers these days?



* K. Yamasaki, A. Gozolchiani and S. Havlin, [Climate networks around the globe are significantly effected by El Nino (2013)]

/affected/effected/!

Temperature grid

Seasonal trends are detrended by subtracting the yearly mean temperature from the particular day's temperature.

>-- This tells you how much “hotter it is today than it usually is here at this time of year”.

> l = array ((1,20),(1,20)) [i,j|i<-[-5.0,-2.5,0,2.5,5.0],j<-[-5.0,-2.5,0,2.5,5.0]]
> temps = array ((1,365),(1,207),(1,207) [1..365]

> temp l y d temps = temps l y d - (sum temps l y d)/n where
>   temp' l y d where
>     ds = [1..365] 

I assume that when d+τd+\tau exceeds 365 you go over to the next year, since that’s the reasonable thing to do.

The point is that X(ℓ,y,τ)X(\ell,y, \tau) tells you how much the temperature at grid point ℓ\ell is correlated to the temperature at grid point rr, τ\tau days later, during year yy.

> temp1 day =  temp' yr day - fmap $ sum [temp' (head yrs) day : temp' (tail yrs)]/yrs where
>   temp' yr day = 
>   yrs = [1971..2014]
>   days = [1..365] 

where n = total number of years observed.

l and r are a pair of sites on the grid.

> tMax = 365
> tMin = -365
> tRange = [tMin..tMax] -- days

> ccorr yr l r = do
>   let sh = (temp yr l day)*(temp yr r (day+tShift) where
>     tShift = if tShift < 0 then ((-)1)*tShift else tShift
>   return tShift 

tShifts are always positive.

So there's no difference between the cases!?

If the time shift (tShift) is zero or negative then its time shift of the cross correlation (ccorr) is taken to be positive.

I don't understand this! TBD.

How do we get zero or negative time shifts?

>{-
> meanChanges :: [Double]
> meanChanges = fmap (/12) $ fmap ((-)5.0) (zipWith (+) qs js) where
>                qs = [1..10::Double]
>                js = [1..10::Double]
>-}

> cStrength yr l r = max (ccorr yr l r . stdDev . abs . ccorr yr l r)
>

The time delay (tDelay) is the time shift with the maximal correlation.

Significant links are defined only as pairs l and r which have a link correlation strength (cStrength) greater than some constant. 

This is represented as a Heaviside function:

> rho yr l r = theta  (cStrength yr l r - threshStrength) where -- (1)
>   theta = heaviside
>   threshStrength = 2

For different years pairs might or might not be significant and thus "blink" as the appear and disappear.

Significant pairs are sensitive to initial choice of year  and noise.

Do not ask which pairs form a static network. Ask which ones change.

I do not understand, aren't they closed and complementary and thus mutually-defined?

Blinking links are taken as correlated with structural change.

For a currently existing (ie. significant) link ($$rho$$, was it significant in the past?

>-- table = new Array (3,3) [1891..2014]








