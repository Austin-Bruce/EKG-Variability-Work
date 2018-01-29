#This code is for Ascii Format 
#Set the appropriate file path after setwd()
setwd("H:\\MTBI Sleep Study\\Actiwave and Cognitive\\ACTIWAVE CARDIO\\Final_HRV\\POST2")

#Run this before each session to generate the data structure
hrv.data = CreateHRVData()
hrv.data = SetVerbose(hrv.data, TRUE)

#Set the appropriate file name as second arguement in load beat askii
hrv.data = LoadBeatAscii(hrv.data, "Final_1030_PRE2_SegB1_128.rri", "H:\\MTBI Sleep Study\\Actiwave and Cognitive\\ACTIWAVE CARDIO\\Final_HRV\\PRE2\\INTERPOLATIONS_PRE2", scale = .001)
plot(hrv.data$Beat$Time)

#NIHR is non-interpolated heart rate
#Plot to confirm the right data is being used
hrv.data = BuildNIHR(hrv.data)
PlotNIHR(hrv.data)

#Applies a filter to niHR data---use if you wish
hrv.data.bak = hrv.data 
hrv.data = FilterNIHR(hrv.data, long=50, last=10, minbpm=25, maxbpm=180)
PlotNIHR(hrv.data)
#There is also manual addition/subtraction
#maxbpm and minbpm can be physiologically justified
#Long-->use the last 50 heart beats to calculate heart rate
#Last-->permit a variation of 10pct in heart rate
#the default values are based on healthy humans; animals, pathologies, infants need their own 

##hrv.data = EditNIHR(hrv.data)

hrv.data = CreateFreqAnalysis(hrv.data)
hrv.data = CalculatePowerBand(hrv.data, indexFreqAnalysis = 1, size = 24900, shift = 30)
PlotPowerBand(hrv.data, indexFreqAnalysis = 1, ymax = 2500, ymaxratio =  1.4) 

#cubic spline and storing results into value cubic.spline
cubic.spline <- InterpolateNIHR(hrv.data, freqhr = 4.67, method = c("spline"), verbose = NULL)
PlotHR(cubic.spline)

#exporting spline results to text file
#converting seconds to milliseconds for compatibility with Navrokard
spline.results <- data.frame(cubic.spline$Beat$Time, cubic.spline$Beat$RR)
names(spline.results) <- c("Time", "IBI")
spline.results$Time <- (spline.results$Time * 1000)
#Change file name that is generated before creating text file
write.table(spline.results, file = "Final_1030_PRE2_SegB1_256.txt")


##### This is the HRV Recovery Code
hrv.data = CreateHRVData()
hrv.data = SetVerbose(hrv.data, TRUE)
#Set the appropriate file name as second arguement in load beat in edf format
hrv.data = LoadBeatEDFPlus(hrv.data, "Final_1030_PRE2_SegB1_128.rri", "H:\\MTBI Sleep Study\\Actiwave and Cognitive\\ACTIWAVE CARDIO\\Final_HRV\\PRE2\\INTERPOLATIONS_PRE2", scale = .001)
plot(hrv.data$Beat$Time)
hrv.data = BuildNIHR(hrv.data)
PlotNIHR(hrv.data)
write.table(hrv.data, file = "Final_1030_PRE2_SegB1_256.txt")