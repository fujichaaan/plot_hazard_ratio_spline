# install.packages("rms")
# install.packages("survival")
# install.packages("tidyverse")
# install.packages("splines")
# install.packages("ggrepel")

library(rms); library(survival); library(tidyverse); library(splines); library(ggrepel)


# Data preparation --------------------------------------------------------

n <- 1000
set.seed(731)

age <- round(50 + 12*rnorm(n), 1)
label(age) <- "Age"

sex <- factor(sample(c('Male','Female'), n, 
                     rep=TRUE, prob=c(.6, .4)))
cens <- 15*runif(n)

smoking <- factor(sample(c('Yes','No'), n, 
                         rep=TRUE, prob=c(.2, .75)))

h <- .02*exp(.02*(age-50)+.1*((age-50)/10)^3+.8*(sex=='Female')+2*(smoking=='Yes'))
dt <- -log(runif(n))/h
label(dt) <- 'Follow-up Time'

e <- ifelse(dt <= cens,1,0)
dt <- pmin(dt, cens)
units(dt) <- "Year"

# Add missing data to smoking
smoking[sample(1:n, round(n*0.05))] <- NA

# Create a data frame since plotHR will otherwise
# have a hard time getting the names of the variables
ds <- data.frame(
  dt      = dt,
  e       = e,
  age     = age, 
  smoking = smoking,
  sex     = sex)


# 1. Original version --------------------------------------------------------

dd <- datadist(ds)
options(datadist = 'dd')

# check the ref (48.8 yrs)
dd$limits[,"age"][2]

# check the cutoff points
attr(rcs(ds$age, 4), "parms")

# cutpoints are same as this
quantile(ds$age, c(.05, .35, .65, .95))

fit.cph1 <- cph(Surv(dt, e) ~ rcs(age, 4) + sex + smoking,
               data = ds, x = TRUE, y = TRUE)

est1 <- Predict(fit.cph1, age, ref.zero = TRUE, fun = exp) |>
  as_tibble()

ggplot(est1, aes(age, yhat)) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_line(aes(x = age, y = yhat),
            color = "Black", linewidth = 0.9) +
  geom_ribbon(aes(x = age, y = yhat, 
                  ymin = lower, ymax = upper),
              alpha = 0.2, fill = "Black") +
  scale_x_continuous(limits = c(30, 70),
                     breaks = seq(30, 70, 10)) +
  scale_y_continuous(limits = c(0.1, 8),
                     breaks = c(0.37, 0.61, 1.0, 1.6, 2.7, 4.5),
                     trans = "log") +
  labs(x = "Age, yrs",
       y = "Hazard ratio (95% CI)") +
  theme_bw() +
  theme(axis.line = element_line(size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(colour = "gray98"),
        axis.title = element_text(size = 24),
        axis.text = element_text(size = 20),
        plot.caption = element_blank(),
        panel.background = element_rect(fill = "gray99",
                                        colour = "white",
                                        linetype = "twodash"),
        plot.background = element_rect(fill = "white"))


# 2. Change knots --------------------------------------------------------

dd <- datadist(ds)
options(datadist = 'dd')

# change the knots
k <- with(ds, quantile(age, c(.20, .40, .60, .80)))

fit.cph2 <- cph(Surv(dt, e) ~ rcs(age, k) + sex + smoking,
                data = ds, x = TRUE, y = TRUE)

est2 <- Predict(fit.cph2, age, ref.zero = TRUE, fun = exp) |>
  as_tibble()

ggplot(est2, aes(age, yhat)) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_line(aes(x = age, y = yhat),
            color = "Black", linewidth = 0.9) +
  geom_ribbon(aes(x = age, y = yhat, 
                  ymin = lower, ymax = upper),
              alpha = 0.2, fill = "Black") +
  scale_x_continuous(limits = c(30, 70),
                     breaks = seq(30, 70, 10)) +
  scale_y_continuous(limits = c(0.1, 10),
                     breaks = c(0.1, 0.25, 0.5, 1.0, 2.0, 4.0, 10.0),
                     trans = "log") +
  labs(x = "Age, yrs",
       y = "Hazard ratio (95% CI)") +
  theme_bw() +
  theme(axis.line = element_line(size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(colour = "gray98"),
        axis.title = element_text(size = 24),
        axis.text = element_text(size = 20),
        plot.caption = element_blank(),
        panel.background = element_rect(fill = "gray99",
                                        colour = "white",
                                        linetype = "twodash"),
        plot.background = element_rect(fill = "white"))


# 3. Change ref = 60 --------------------------------------------------------

# change ref = 60 yrs
dd$limits[,"age"][2] <- 60

fit.cph3 <- update(fit.cph1)
est3 <- Predict(fit.cph3, age, ref.zero = TRUE, fun = exp) |>
  as_tibble()

ggplot(est3, aes(age, yhat)) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_line(aes(x = age, y = yhat),
            color = "Black", linewidth = 0.9) +
  geom_ribbon(aes(x = age, y = yhat, 
                  ymin = lower, ymax = upper),
              alpha = 0.2, fill = "Black") +
  scale_x_continuous(limits = c(30, 70),
                     breaks = seq(30, 70, 10)) +
  scale_y_continuous(limits = c(0.1, 10),
                     breaks = c(0.1, 0.25, 0.5, 1.0, 2.0, 4.0, 10.0),
                     trans = "log") +
  labs(x = "Age, yrs",
       y = "Hazard ratio (95% CI)") +
  theme_bw() +
  theme(axis.line = element_line(size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(colour = "gray98"),
        axis.title = element_text(size = 24),
        axis.text = element_text(size = 20),
        plot.caption = element_blank(),
        panel.background = element_rect(fill = "gray99",
                                        colour = "white",
                                        linetype = "twodash"),
        plot.background = element_rect(fill = "white"))


# 4. Final version --------------------------------------------------------

dd <- datadist(ds)
options(datadist = 'dd')

# change ref = 50 yrs
dd$limits[,"age"][2] <- 50

# change the knots
k <- c(35, 40, 60, 65)

fit.cph4 <- cph(Surv(dt, e) ~ rcs(age, k) + sex + smoking,
               data = ds, x = TRUE, y = TRUE)

est4 <- Predict(fit.cph4, age, ref.zero = TRUE, fun = exp) |>
  as_tibble()

ggplot(est4, aes(x = age, y = yhat)) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_line(aes(x = age, y = yhat),
            color = "Black", linewidth = 0.9) +
  geom_ribbon(aes(x = age, y = yhat, 
                  ymin = lower, ymax = upper),
              alpha = 0.2, fill = "Black") +
  scale_x_continuous(limits = c(30, 70),
                     breaks = seq(30, 70, 10)) +
  scale_y_continuous(limits = c(0.1, 10),
                     breaks = c(0.1, 0.25, 0.5, 1.0, 2.0, 4.0, 10.0),
                     trans = "log") +
  labs(x = "Age, yrs",
       y = "Hazard ratio (95% CI)") +
  theme_bw() +
  theme(axis.line = element_line(size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(colour = "gray98"),
        axis.title = element_text(size = 24),
        axis.text = element_text(size = 20),
        plot.caption = element_blank(),
        panel.background = element_rect(fill = "gray99",
                                        colour = "white",
                                        linetype = "twodash"),
        plot.background = element_rect(fill = "white"))


# 5. Additional practice --------------------------------------------------

dd <- datadist(ds)
options(datadist = 'dd')

# change ref = 50 yrs
dd$limits[,"age"][2] <- 50

# define the number of knots
k <- c(35, 40, 60, 65)

# Linear
fit.cph5 <- cph(Surv(dt, e) ~ age + sex + smoking,
                data = ds, x = TRUE, y = TRUE)

est5 <- Predict(fit.cph5, age, ref.zero = TRUE, fun = exp) |>
  as_tibble()

# Using restricted cubic spline
fit.cph6 <- cph(Surv(dt, e) ~ rcs(age, k) + sex + smoking,
                data = ds, x = TRUE, y = TRUE)

est6 <- Predict(fit.cph6, age, ref.zero = TRUE, fun = exp) |>
  as_tibble() |>
  rename(yhat_rcs = yhat,
         lower_rcs = lower,
         upper_rcs = upper) |>
  select(yhat_rcs, lower_rcs, upper_rcs)

# Combined results
fig_table <- cbind(est5, est6)

ggplot(fig_table) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_line(aes(x = age, y = yhat),
            color = "#dc143c", linewidth = 0.9) +
  geom_ribbon(aes(x = age, y = yhat, 
                  ymin = lower, ymax = upper),
              alpha = 0.2, fill = c("#db7093")) +
  geom_line(aes(x = age, y = yhat_rcs),
            color = "#191970", linewidth = 0.9) +
  geom_ribbon(aes(x = age, y = yhat_rcs,
                  ymin = lower_rcs, ymax = upper_rcs),
              alpha = 0.2, fill = c("#4169e1")) +
  scale_x_continuous(limits = c(30, 70),
                     breaks = seq(30, 70, 10)) +
  scale_y_continuous(limits = c(0.1, 10),
                     breaks = c(0.1, 0.25, 0.5, 1.0, 2.0, 4.0, 10.0),
                     trans = "log") +
  annotate("text", label = "Restricted \n cubic spline",
           x = 38, y = 1.6, size = 5, colour = "#191970") +
  annotate("text", label = "Linear",
           x = 47.5, y = 0.5, size = 5, colour = "#dc143c") +
  labs(x = "Age, yrs",
       y = "Hazard ratio (95% CI)") +
  theme_bw() +
  theme(axis.line = element_line(linewidth = 0.5, linetype = "solid"),
        panel.grid.major = element_line(colour = "gray98"),
        axis.title = element_text(size = 24),
        axis.text = element_text(size = 20),
        plot.caption = element_blank(),
        panel.background = element_rect(fill = "gray99",
                                        color = "white",
                                        linetype = "twodash"),
        plot.background = element_rect(fill = "white"))
