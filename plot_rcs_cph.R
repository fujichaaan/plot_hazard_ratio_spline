# install.packages("rms")
# install.packages("survival")
# install.packages("tidyverse")

library(rms); library(survival); library(tidyverse)


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
rcs(ds$age, 4)

# cutpoints are same as this
quantile(ds$age, c(.5, .35, .65, .95))

fit.cph <- cph(Surv(dt, e) ~ rcs(age, 4) + sex + smoking,
               data = ds, x = TRUE, y = TRUE)

est1 <- Predict(fit.cph, age, ref.zero = TRUE, fun = exp)

ggplot(est1, aes(age, yhat)) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_x_continuous(limits = c(30, 70),
                     breaks = seq(30, 70, 10)) +
  scale_y_continuous(limits = c(0.1, 8),
                     breaks = c(0.37, 0.61, 1.0, 1.6, 2.7, 4.5)) +
  coord_trans(y = "log10") +
  labs(x = "Age, yrs",
       y = "Hazard ratio (95% CI)") +
  theme_bw() +
  theme(axis.line = element_line(size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(colour = "gray98"),
        axis.title = element_text(size = 24),
        axis.text = element_text(size = 20),
        plot.caption = element_blank(),
        panel.background = element_rect(fill = "gray99",
                                        colour = "white", linetype = "twodash"),
        plot.background = element_rect(fill = "white"))


# 2. Change knots --------------------------------------------------------

dd <- datadist(ds)
options(datadist = 'dd')

# change the knots
k <- with(ds, quantile(age, c(.20, .40, .60, .80)))

fit.cph2 <- cph(Surv(dt, e) ~ rcs(age, k) + sex + smoking,
                data = ds, x = TRUE, y = TRUE)

est3 <- Predict(fit.cph2, age, ref.zero = TRUE, fun = exp)

ggplot(est3, aes(age, yhat)) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_x_continuous(limits = c(30, 70),
                     breaks = seq(30, 70, 10)) +
  scale_y_continuous(limits = c(0.1, 8),
                     breaks = c(0.37, 0.61, 1.0, 1.6, 2.7, 4.5)) +
  coord_trans(y = "log10") +
  labs(x = "Age, yrs",
       y = "Hazard ratio (95% CI)") +
  theme_bw() +
  theme(axis.line = element_line(size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(colour = "gray98"),
        axis.title = element_text(size = 24),
        axis.text = element_text(size = 20),
        plot.caption = element_blank(),
        panel.background = element_rect(fill = "gray99",
                                        colour = "white", linetype = "twodash"),
        plot.background = element_rect(fill = "white"))


# 3. Change ref = 60 --------------------------------------------------------

# change ref = 60 yrs
dd$limits[,"age"][2] <- 60

fit.cph1 <- update(fit.cph)
est2 <- Predict(fit.cph1, age, ref.zero = TRUE, fun = exp)

ggplot(est2, aes(age, yhat)) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_x_continuous(limits = c(30, 70),
                     breaks = seq(30, 70, 10)) +
  scale_y_continuous(limits = c(0.1, 8),
                     breaks = c(0.37, 0.61, 1.0, 1.6, 2.7, 4.5)) +
  coord_trans(y = "log10") +
  labs(x = "Age, yrs",
       y = "Hazard ratio (95% CI)") +
  theme_bw() +
  theme(axis.line = element_line(size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(colour = "gray98"),
        axis.title = element_text(size = 24),
        axis.text = element_text(size = 20),
        plot.caption = element_blank(),
        panel.background = element_rect(fill = "gray99",
                                        colour = "white", linetype = "twodash"),
        plot.background = element_rect(fill = "white"))


# 4. Final version --------------------------------------------------------

dd <- datadist(ds)
options(datadist = 'dd')

# change ref = 50 yrs
dd$limits[,"age"][2] <- 50

# change the knots
k <- c(35, 40, 60, 65)

fit.cph <- cph(Surv(dt, e) ~ rcs(age, k) + sex + smoking,
               data = ds, x = TRUE, y = TRUE)

est1 <- Predict(fit.cph, age, ref.zero = TRUE, fun = exp)

ggplot(est1, aes(age, yhat)) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_x_continuous(limits = c(30, 70),
                     breaks = seq(30, 70, 10)) +
  scale_y_continuous(limits = c(0.1, 10),
                     breaks = c(0.1, 0.25, 0.5, 1.0, 2.0, 4.0, 10.0)) +
  coord_trans(y = "log10") +
  labs(x = "Age, yrs",
       y = "Hazard ratio (95% CI)") +
  theme_bw() +
  theme(axis.line = element_line(size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(colour = "gray98"),
        axis.title = element_text(size = 24),
        axis.text = element_text(size = 20),
        plot.caption = element_blank(),
        panel.background = element_rect(fill = "gray99",
                                        colour = "white", linetype = "twodash"),
        plot.background = element_rect(fill = "white"))
