# Example for Jags-Ymet-Xnom1met1-MrobustHier-929.R 
#------------------------------------------------------------------------------- 
# Optional generic preliminaries:
graphics.off() # This closes all of R's graphics windows.
rm(list=ls())  # Careful! This clears all of R's memory!
#------------------------------------------------------------------------------- 
# Load The data file 

myDataFrame = read.csv( file="AmplPrePostABStimPerRMT.csv" )
# Specify the column names in the data file relevant to the analysis:
yName="LnAmpl" 
xNomName="Timepoint" 
xMetName="StimPerRMT"             # the covariate
sName="SubjID"
# Specify desired contrasts.
# Each main-effect contrast is a list of 2 vectors of level names, 
# a comparison value (typically 0.0), and a ROPE (which could be NULL):
xNomcontrasts = list( 
#  list( c("Pregnant1","Pregnant8") , c("None0") , compVal=0.0 , ROPE=c(-1.5,1.5) ) ,
#  list( c("Pregnant1","Pregnant8","None0") , c("Virgin1","Virgin8") , 
#        compVal=0.0 , ROPE=c(-1.5,1.5) ) ,
#  list( c("Pregnant1","Pregnant8","None0") , c("Virgin1") , 
#        compVal=0.0 , ROPE=c(-1.5,1.5) ) ,
  list( c("Pre") , c("Post") , compVal=0.0 , ROPE=c(-0.5,0.5) ) 
)
scontrasts = list( 
  #list( c("CHEM") , c("ENG") , compVal=0.0 , ROPE=c(-1000,1000) ) ,
  #list( c("CHEM") , c("PSY") , compVal=0.0 , ROPE=c(-1000,1000) ) ,
  list( c("BM17","BM18","BM21","BM23","BM24","BM26","BM30","BM31",
          "BM32","BM33","BMH01","BMH02","BMH05","BMH10","BMH14","BMH15") , 
        c("BM04","BM20","BM22","BM25","BM28","BM29","BM34","BM35",
          "BM36","BMH03","BMH04","BMH06","BMH07","BMH09","BMH13") , 
        compVal=0.0 , ROPE=c(-0.5,0.5) ) 
)
# Each interaction contrast is a list of 2 lists of 2 vectors of level names, 
# a comparison value (typically 0.0), and a ROPE (which could be NULL)::
xNomscontrasts = list( 
#  list( list( c("Full") , c("Assis") ) ,
#        list( c("CHEM") , c("ENG") ) ,
#        compVal=0.0 , ROPE=c(-1000,1000) ) ,
#  list( list( c("Full") , c("Assis") ) ,
#        list( c("CHEM") , c("PSY") ) ,
#        compVal=0.0 , ROPE=c(-1000,1000) ) ,
  list( list( c("Pre") , c("Post") ) ,
        list( c("BM17","BM18","BM21","BM23","BM24","BM26","BM30","BM31",
                 "BM32","BM33","BMH01","BMH02","BMH05","BMH10","BMH14","BMH15") , 
              c("BM04","BM20","BM22","BM25","BM28","BM29","BM34","BM35",
                "BM36","BMH03","BMH04","BMH06","BMH07","BMH09","BMH13") ) , 
        compVal=0.0 , ROPE=c(-0.5,0.5) )
) 

# Specify filename root and graphical format for saving output.
# Otherwise specify as NULL or leave saveName and saveType arguments 
# out of function calls.
fileNameRoot = "AmplPrePostABStimPerRMT-xNom1met1-930norm-" 
graphFileType = "jpg" 

#------------------------------------------------------------------------------- 
# Load the relevant model into R's working memory:
source("Jags-Ymet-Xnom1met1-MnormalHom.R")
#------------------------------------------------------------------------------- 
# Generate the MCMC chain:
mcmcCoda = genMCMC( datFrm=myDataFrame , 
                    yName=yName , xNomName=xNomName , xMetName=xMetName , sName=sName ,
                    numSavedSteps=11000 , thinSteps=10 , saveName=fileNameRoot )
#------------------------------------------------------------------------------- 
# Display diagnostics of chain, for specified parameters:
parameterNames = varnames(mcmcCoda) 
show( parameterNames ) # show all parameter names, for reference
for ( parName in parameterNames ) {
    diagMCMC( codaObject=mcmcCoda , parName=parName , 
            saveName=fileNameRoot , saveType=graphFileType )
}
#------------------------------------------------------------------------------- 
# Get summary statistics of chain:
summaryInfo = smryMCMC( mcmcCoda , 
                        datFrm=myDataFrame , xNomName=xNomName , xMetName=xMetName , sName=sName ,
                        xNomcontrasts=xNomcontrasts , 
                        scontrasts=scontrasts , 
                        xNomscontrasts=xNomscontrasts ,
                        saveName=fileNameRoot )
show(summaryInfo)
# Display posterior information:
plotMCMC( mcmcCoda , 
          datFrm=myDataFrame , yName=yName , xNomName=xNomName , xMetName=xMetName , sName=sName ,
          xNomcontrasts=xNomcontrasts , 
          scontrasts=scontrasts , 
          xNomscontrasts=xNomscontrasts ,
          saveName=fileNameRoot , saveType=graphFileType )
#------------------------------------------------------------------------------- 
