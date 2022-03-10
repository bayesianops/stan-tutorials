## This script is meant to be used interactively

library(ggplot2)
library(cmdstanr)
library(posterior)
library(bayesplot)
color_scheme_set("brightblue")


############################################################
## No ODE


## Simulate data

alpha = rnorm(1, 0, 1)
beta = rnorm(1, -2, 0.5)
sigma = rgamma(1, 3, 2)

N = 25
t = seq(0, 5, length.out = N)
y = alpha + beta * t + rnorm(N, 0, sigma)


plot(t, y)
ggplot(data.frame(t, y), aes(t, y)) + geom_point()


no_ode_mod = cmdstanr::cmdstan_model("stan/1-no-ode.stan")
no_ode_mod$print()

data_list = list(N = N, x = x, y = y)

fit_no_ode = no_ode_mod$sample(data = data_list)

fit_no_ode

fit_no_ode$summary()


mcmc_hist(fit_no_ode$draws("alpha")) + vline_at(alpha, size = 1.5)
mcmc_hist(fit_no_ode$draws("beta")) + vline_at(beta, size = 1.5)
mcmc_hist(fit_no_ode$draws("sigma")) + vline_at(sigma, size = 1.5)



############################################################
## ODE

N = 100
x = rnorm(N, 0, 1)
y = alpha * exp(beta * x)

plot(x, y)
ggplot(data.frame(x, y), aes(x, y)) + geom_point()


data_list = list(N = N, x = x, y = y)
fit_no_ode = no_ode_mod$sample(data = data_list)
fit_no_ode
fit_no_ode$summary()

mcmc_hist(fit_no_ode$draws("alpha")) + vline_at(alpha, size = 1.5)
mcmc_hist(fit_no_ode$draws("beta")) + vline_at(beta, size = 1.5)
mcmc_hist(fit_no_ode$draws("sigma")) + vline_at(sigma, size = 1.5)


ode_mod = cmdstanr::cmdstan_model("stan/2-ode.stan")
ode_mod$print()



analytic_mod = cmdstanr::cmdstan_model("stan/3-ode-analytic.stan")
analytic_mod$print()

analytic_ode = analytic_mod$sample(data = data_list)
analytic_ode
analytic_ode$summary()



