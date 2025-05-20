library(quantmod)

tickers <- c("SAP.DE", "BAYN.DE", "BMW.DE", "ALV.DE", "DTE.DE", "VOW3.DE", "ADS.DE", "FRE.DE", "DBK.DE", "MUV2.DE")
start_date <- as.Date("2019-01-01")
end_date <- as.Date("2023-12-31")

preus_ajustats <- NULL

for (ticker in tickers) {
  dades <- try(getSymbols(ticker, src = "yahoo", from = start_date, to = end_date, auto.assign = FALSE), silent = TRUE)
  if (inherits(dades, "try-error")) next
  preus <- Ad(dades)
  colnames(preus) <- ticker
  if (is.null(preus_ajustats)) {
    preus_ajustats <- preus
  } else {
    preus_ajustats <- merge(preus_ajustats, preus)
  }
}

preus_ajustats <- na.omit(preus_ajustats)
write.zoo(preus_ajustats, file = "dades_borses.csv", sep = ",")