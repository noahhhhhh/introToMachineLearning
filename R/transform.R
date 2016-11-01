require(data.table)
require(caret)


# load --------------------------------------------------------------------

dt.all <- fread("data/baseball.txt")
setnames(dt.all, names(dt.all), c("Salary"
                                  , "Avg_Batting"
                                  , "Perc_OnBase"
                                  , "No_Runs"
                                  , "No_Hits"
                                  , "No_Doubles"
                                  , "No_Triples"
                                  , "No_HomeRuns"
                                  , "No_RunsBattedIn"
                                  , "No_Walks"
                                  , "No_StrikeOuts"
                                  , "No_StolenBases"
                                  , "No_Errors"
                                  , "Ind_FreeAgentEligibility"
                                  , "Ind_FreeAgent"
                                  , "Ind_ArbitrationEligibility"
                                  , "Ind_Arbitration"))


# transform ---------------------------------------------------------------

dt.all[, HighSalary := ifelse(Salary >= 3700, 1, 0)]
dt.all[, Salary := NULL]

# split -------------------------------------------------------------------

ind.train <- createDataPartition(dt.all$HighSalary, p = .8, list = F)
dt.train <- dt.all[ind.train]
dt.test <- dt.all[-ind.train]


