
## Generating histogram and frequency weights for income distribution.

#Import CSV file
col = CSV.read("data/colinc.csv", DataFrame)

##Basics
typeof(col)

#Print dataframe column names.
names(col)

#Length of income vector.
length(col.income) # 577627

##Creating histogram

#Convert Colombian pesos to USD 2016 dollar.
col.incUSD = col.income/3000

#Max income
mxi = maximum(col.incUSD)

#Bins edges. Represents the bins size.
bedges = mxi/1000

#Create histogram using fit function from Distributions
#fields are the data to be fitted (col.incUSD)
#and the histogram increment ("0:bedges:mxi"). This means from 0 to max income, in inrements determined by bedges.
h = fit(Histogram, col.incUSD, 0:bedges:mxi)

#Graph the histogram.
#bar(h.weights)

#Creating fequency weights to be used in the sample function.
fw = FrequencyWeights(h.weights)
