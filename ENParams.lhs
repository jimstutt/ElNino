Start with comprehensible names using type aliases with a comprehensible type vocabulary. The aliased types will make coordinate conversions easier.


worldwide daily average temperatures on a 

> globTemp62YrBand = undefined

2.5 degree latitude × 2.5 degree longitude grid (144 × 73 grid points), 

> band = [144*73] -- 2.5 x 2.5 deg. grid

{JS.

The 144 lats cover 350 deg. arc. 
The 73 longs cover 182.5 deg. arc.
}

from 1948 to 2010. 

> years = [1948..2010]

* [P. 4, Fig. 1]

4 areas by inspection - where's the data set?

Labelled from top left to bottom right:

> south :: Locs
> south = zipWith (,) slats slongs
> slats :: Lats
> slats = [(-60)..(-90)]
> slongs :: Longs
> slongs = [120..330]
> pacific :: [(Lat,Long)] -- exbasin + basin
> pacific = zipWith (,) plats plongs
> plats = [30..(-30)]
> plongs = [120..330]

The image of the basin has only 9 grid points coloured in. If we include the apparent extent of latitudes this would be 27 grid points?


> locs  :: Locs
> locs = zipWith (,) testLats testLongs
> basin :: Locs
> basin = zipWith (,) blats blongs
> blats :: Lats
> blats = [15..(-15)]
> blongs :: Longs
> blongs = [240..300] -- 30 short of the east pacific rim.
> atlantic :: Locs
> atlantic = zipWith (,) alats alongs
> alats  = [30..(-30)]
> alongs = [(-90)..90]
> testLocs :: Locs
> testLocs = zipWith (,) testLats testLongs
> testLocCount :: Int
> testLocCount = 14+193 -- 207

> maxCoords = 207 -- (14,183)
> timeShift = [-200,-201..200] -- originally tau

Unfortunately we do need absolute positions because of different angles of insolation at different positions

> maxLat = 125
> maxLong = 21
> minTemp = 248
> maxTemp = 323

total grid size == 6,146,287,560

lats longs where

coords = coords {lat::Double}


>-- lats,longs :: U.Vector a
> testLats  = [45.0,47.5..165.0] -- 125 points. Sanity check circum = 40000 km => 111.1111 km/deg
> testLongs = [-20.0,-17.5..30.0] -- 21 points



Graham Jones wrote:

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
  120W == 240E

Graham had:
  
  300E - 190E = 110 deg long.
  300E == 60W
  190E == 170W

But:

  240E = 120W not 60.

* John Denker has a great argument for using the geometric algebra to avoid the inclinometer problem in aerobatics when you loop the loop. (He's an advisor the the US Aero Admin on aerobatics and his technical book is great fun even for a non-pilot.


> type Years = [Int]
> years :: Years
> years = [2013]
> type Days = [Int]
> days :: Days
> days = [1..365]

> type Lats = [Lat]
> type Lat = Float
> type Longs = [Long]
> type Long = Float
> type Locs = [Loc]
> type Loc = (Float,Float)
>-- type Temps = Array U (Z :. ) Temp
> type Temp = Double

