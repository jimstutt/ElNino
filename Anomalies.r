y <- anomaliesSought<- TemperatureAnomaliesByYear.1880.2010.Relative.To.1950.1980.Baseline[Sought]

ly <- lowess(x=YearsToDo, y=y)
resids <- y-ly$y
sd.resids <- sd(resids)     
ylims <- c(-3*sd.resids, 3*sd.resids)
oldpar <- par(mfcol=c(3,1))
plot(1:length(y), rnorm(length(y),sd=sd.resids), ylim=ylims, type='l', xlab="Years", ylab="niorn")
plot(1:length(y), resids, type='l', xlab="Years", ylim=ylims, ylab="niorn")
plot(1:length(y), rnorm(length(y),sd=sd.resids), ylim=ylims, type='l', xlab="Years", ylab="niorn")
par(oldpar)