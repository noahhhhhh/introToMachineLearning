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

# Feature       Gain      Cover Frequence
# 1:          No_RunsBattedIn 0.57999181 0.44112182 0.2352941
# 2: Ind_FreeAgentEligibility 0.23402302 0.02943097 0.2352941
# 3:                  No_Hits 0.13998788 0.41169083 0.2352941
# 4:                  No_Runs 0.04599729 0.11775638 0.2941176