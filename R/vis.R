require(ggplot2)
require(RColorBrewer)
require(plotly)

dt.plot <- dt.train
dt.plot[, Salary := ifelse(HighSalary == 1, "High", "Not High")]
dt.plot[, HighSalary := NULL]

dt.plot[, Ind_FreeAgentEligibility := as.factor(Ind_FreeAgentEligibility)]
dt.plot[, Ind_FreeAgent := as.factor(Ind_FreeAgent)]
dt.plot[, Ind_ArbitrationEligibility := as.factor(Ind_ArbitrationEligibility)]
dt.plot[, Ind_Arbitration := as.factor(Ind_Arbitration)]

# No_RunsBattedIn ---------------------------------------------------------

g.No_RunsBattedIn <- ggplot(dt.plot, aes(x = Salary, y = No_RunsBattedIn, fill = Salary)) +
    scale_fill_brewer(palette = "Set1") +
    theme_bw() +
    geom_tile()
g.No_RunsBattedIn

g.No_RunsBattedIn.hist <- ggplot(dt.plot, aes(x = No_RunsBattedIn, fill = Salary)) +
    scale_fill_brewer(palette = "Set1") +
    theme_bw() +
    geom_histogram(position = "dodge")
g.No_RunsBattedIn.hist

# No_RunsBattedIn & Ind_FreeAgentEligibility ------------------------------

g.No_RunsBattedIn_Ind_FreeAgentEligibility <- ggplot(dt.plot, aes(x = Ind_FreeAgentEligibility, y = No_RunsBattedIn, fill = Salary)) +
    scale_fill_brewer(palette = "Set1") +
    theme_bw() +
    geom_tile()
g.No_RunsBattedIn_Ind_FreeAgentEligibility

# No_RunsBattedIn & No_Hits -----------------------------------------------

g.No_RunsBattedIn_No_Hits <- ggplot(dt.plot, aes(x = No_Hits, y = No_RunsBattedIn, color = Salary)) +
    scale_color_brewer(palette = "Set1") +
    theme_bw() +
    geom_jitter()
g.No_RunsBattedIn_No_Hits


# pairs -------------------------------------------------------------------
cols <- character(nrow(dt.train))
cols[] <- "black"

cols[dt.train$HighSalary == 1] <- "red"
cols[dt.train$HighSalary == 0] <- "#0066CC"
pairs(dt.train[, !c("HighSalary"), with = F], col = cols, pch = 20, upper.panel = NULL)


# 3d ----------------------------------------------------------------------

plot_ly(dt.plot, x = ~No_RunsBattedIn, y = ~No_Hits, z = ~Ind_FreeAgentEligibility
        , color = ~Salary
        , colors=c("#0066CC","red")) %>% add_markers()

