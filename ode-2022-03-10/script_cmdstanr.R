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

data_list = list(N = N, t = t, y = y)

fit_no_ode = no_ode_mod$sample(data = data_list)
fit_no_ode$output(1)

fit_no_ode
fit_no_ode$summary()


mcmc_hist(fit_no_ode$draws("alpha")) + vline_at(alpha, size = 1.5)
mcmc_hist(fit_no_ode$draws("beta")) + vline_at(beta, size = 1.5)
mcmc_hist(fit_no_ode$draws("sigma")) + vline_at(sigma, size = 1.5)



############################################################
## Simulate ODE

alpha = abs(rnorm(1, 0, 1))
beta = rnorm(1, -2, 0.5)
sigma = rgamma(1, 5, 3)  # note: different sigma

N = 25
t = seq(0, 5, length.out = N)

## simulate y using a simple ode

sim_ode_mod = cmdstanr::cmdstan_model("stan/2-sim-ode.stan")
sim_ode_mod$print()


sim_data_list = list(N = N, t = t, alpha = alpha, beta = beta, sigma = sigma)
fit_sim_ode = sim_ode_mod$sample(data = sim_data_list,
                                 fixed_param = TRUE,
				 iter_warmup = 0, iter_sampling = 1, chains = 1)
fit_sim_ode
fit_sim_ode$summary()

y = as.vector(fit_sim_ode$draws('y', format = "draws_matrix"))
y_true = as.vector(fit_sim_ode$draws('y_true', format = "draws_matrix"))

plot(x, y)
ggplot(data.frame(x, y), aes(x, y)) + geom_point() + geom_point(aes(x, y_true), col='blue', alpha = 0.5)



############################################################
## Estimate ODE


data_list = list(N = N, t = t, y = y)


ode_mod = cmdstanr::cmdstan_model("stan/3-ode.stan")
ode_mod$print()


fit_ode = ode_mod$sample(data = data_list)

fit_no_ode$output(1)

mcmc_hist(fit_ode$draws("alpha")) + vline_at(alpha, size = 1.5)
mcmc_hist(fit_ode$draws("beta")) + vline_at(beta, size = 1.5)
mcmc_hist(fit_ode$draws("sigma")) + vline_at(sigma, size = 1.5)

ppc_intervals(y = y, yrep = fit_ode$draws('y_rep', format = "draws_matrix"))
ppc_intervals(y = y_true, yrep = fit_ode$draws('y_hat', format = "draws_matrix"))

