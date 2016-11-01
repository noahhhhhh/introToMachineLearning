require(xgboost)

###########################################################################
## red ####################################################################
###########################################################################
# 1. xgb DMatrix ----------------------------------------------------------

mx.train <- as.matrix(dt.train[, !c("HighSalary"), with = F])
mx.test <- as.matrix(dt.test[, !c("HighSalary"), with = F])

dmx.train <- xgb.DMatrix(data = mx.train, label = dt.train$HighSalary)
dmx.test <- xgb.DMatrix(data = mx.test, label = dt.test$HighSalary)


# 2. params ---------------------------------------------------------------

watchlist <- list(test = dmx.test, train = dmx.train)
params <- list(objective = "binary:logistic"
               , booster = "gbtree"
               , eval_metric = "auc"
               , eta = 0.02
               , max_depth = 4
               , subsample = 1
)


# 3. model ----------------------------------------------------------------

set.seed(1)
mod <- xgb.train(params = params
                 , data = dmx.train
                 , watchlist = watchlist
                 , nrounds = 10
                 , verbose = 1
                 , print.every.n = 1
                 , early.stop.round = 3
                 , maximize = F)


# 4. importance -----------------------------------------------------------

importance <- xgb.importance(names(dt.test[, !c("HighSalary"), with = F])
                             , model = mod)

# Feature        Gain       Cover  Frequence
# 1:          No_RunsBattedIn 0.831879870 0.511443436 0.34482759
# 2: Ind_FreeAgentEligibility 0.112880532 0.021119876 0.17241379
# 3:               No_Doubles 0.032278718 0.015840950 0.17241379
# 4:              No_HomeRuns 0.009273722 0.349833503 0.13793103
# 5:                No_Errors 0.005391903 0.007034047 0.06896552
# 6:                  No_Runs 0.002854036 0.087688408 0.03448276
# 7:           No_StolenBases 0.002721812 0.003519355 0.03448276
# 8:            No_StrikeOuts 0.002719406 0.003520425 0.03448276