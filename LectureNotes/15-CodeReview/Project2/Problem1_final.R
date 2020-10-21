library(quantmod)
library(TSA)
library(forecast)
library(TTR)
library(readr)
options(warn=-1)
###################### LOADING DATA ###############################

stock_list <- c("FB", "AAPL", "GOOG","INTC","IBM","NVDA","SIRI","SPOT","AMZN","WFC","GE","EBAY","S","VZ","DIS","NKE","WMT","TSLA","TGT","NFLX")
start_date <- Sys.Date()-1820
end_date <- Sys.Date()
master_df <- NULL
for (idx in seq(length(stock_list))){
  stock_index = stock_list[idx]
  getSymbols(stock_index, verbose = TRUE, src = "yahoo",
             from=start_date,to=end_date)
  temp_df = as.data.frame(get(stock_index))
  temp_df$Date = row.names(temp_df)
  temp_df$Index = stock_index
  row.names(temp_df) = NULL
  colnames(temp_df) = c("Open", "High", "Low", "Close", 
                        "Volume", "Adjusted", "Date", "Index")
  temp_df = temp_df[c("Date", "Index", "Open", "High", 
                      "Low", "Close", "Volume", "Adjusted")]
  master_df = rbind(master_df, temp_df)
}
S[is.na(S)] <- mean(S,na.rm = TRUE)
AAPL <- ts(AAPL$AAPL.Close)
AMZN <- ts(AMZN$AMZN.Close)
DIS <- ts(DIS$DIS.Close)
EBAY <- ts(EBAY$EBAY.Close)
FB <- ts(FB$FB.Close)
GE <- ts(GE$GE.Close)
GOOG <- ts(GOOG$GOOG.Close)
IBM <- ts(IBM$IBM.Close)
INTC <- ts(INTC$INTC.Close)
NKE <- ts(NKE$NKE.Close)
NVDA <- ts(NVDA$NVDA.Close)
S <- ts(S$S.Close)
SIRI <- ts(SIRI$SIRI.Close)
SPOT <- ts(SPOT$SPOT.Close)
TGT <- ts(TGT$TGT.Close)
TSLA <- ts(TSLA$TSLA.Close)
VZ <- ts(VZ$VZ.Close)
WFC <- ts(WFC$WFC.Close)
WMT <- ts(WMT$WMT.Close)
NFLX <- ts(NFLX$NFLX.Close)

#################### PREDICTION FUNCTION ########################

get_prediction = function(name,symbol){
  w_length = 100             #sliding window length
  final = list();
  final["symbol"] = name
  arma_good_count = 0
  hw_good_count = 0
  arma_poor_count = 0
  hw_good_count = 0
  hw_poor_count = 0
  good_count = 0
  poor_count = 0
  for(i in 0:399){
    
    w_start = nrow(symbol)-500+i #prerdict windows start index
    arma_forecast = forecast(auto.arima(symbol[w_start:(w_start+w_length)]),h=1)$mean[1]
    Btest = Box.test(symbol[w_start:(w_start+w_length)])
    
    if (Btest$p.value <= 0.05){
      good_count = good_count+1
      
      if((((symbol[(w_start+w_length)] - symbol[(w_start+w_length+1)]) >= 0) == ((symbol[(w_start+w_length)] - arma_forecast) >= 0))){
        arma_good_count = arma_good_count + 1;
      }
      
      tryCatch({
        hw_forecast = forecast(HoltWinters(symbol[w_start:(w_start+w_length)],gamma=FALSE,),h=1)$mean[1]
      }, error=function(e){})
      
      
      
      
      if((((symbol[(w_start+w_length)] - symbol[(w_start+w_length+1)]) >= 0) == ((symbol[(w_start+w_length)] - hw_forecast) >= 0))){
        hw_good_count = hw_good_count + 1;
      }
    }else{
      poor_count = poor_count+1
      
      if((((symbol[(w_start+w_length)] - symbol[(w_start+w_length+1)]) >= 0) == ((symbol[(w_start+w_length)] - arma_forecast) >= 0))){
        arma_poor_count = arma_poor_count + 1;
      }
      
      tryCatch({
        hw_forecast = forecast(HoltWinters(symbol[w_start:(w_start+w_length)],gamma=FALSE,),h=1)$mean[1]
      }, error=function(e){})
      
      
      
      
      if((((symbol[(w_start+w_length)] - symbol[(w_start+w_length+1)]) >= 0) == ((symbol[(w_start+w_length)] - hw_forecast) >= 0))){
        hw_poor_count = hw_poor_count + 1;
      }
      
    }
  }
  final["ARMA-good"] = arma_good_count/good_count;
  final["HW_good"] = hw_good_count/good_count;
  final["ARMA-poor"] = arma_poor_count/poor_count;
  final["HW_poor"] = hw_poor_count/poor_count;
  final["GOOD_PERCENT"] = good_count/400
  final
}



final = data.frame()



final <- rbind(final,as.data.frame(get_prediction("AAPL",AAPL)))
final <- rbind(final,as.data.frame(get_prediction("DIS",DIS)))
final <- rbind(final,as.data.frame(get_prediction("EBAY",EBAY)))
final <- rbind(final,as.data.frame(get_prediction("FB",FB)))
final <- rbind(final,as.data.frame(get_prediction("GE",GE)))
final <- rbind(final,as.data.frame(get_prediction("GOOG",GOOG)))
final <- rbind(final,as.data.frame(get_prediction("IBM",IBM)))
final <- rbind(final,as.data.frame(get_prediction("INTC",INTC)))
final <- rbind(final,as.data.frame(get_prediction("NKE",NKE)))
final <- rbind(final,as.data.frame(get_prediction("NVDA",NVDA)))
final <- rbind(final,as.data.frame(get_prediction("S",S)))
final <- rbind(final,as.data.frame(get_prediction("SIRI",SIRI)))
final <- rbind(final,as.data.frame(get_prediction("TGT",TGT)))
final <- rbind(final,as.data.frame(get_prediction("TSLA",TSLA)))
final <- rbind(final,as.data.frame(get_prediction("WFC",WFC)))
final <- rbind(final,as.data.frame(get_prediction("WMT",WMT)))
final <- rbind(final,as.data.frame(get_prediction("VZ",VZ)))
final <- rbind(final,as.data.frame(get_prediction("NFLX",NFLX)))
final <- rbind(final,as.data.frame(get_prediction("SPOt",SPOT)))
final <- rbind(final,as.data.frame(get_prediction("AMZN",AMZN)))


