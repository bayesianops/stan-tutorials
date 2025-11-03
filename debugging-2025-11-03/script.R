################################################################################
## November 3, 2025
## Daniel Lee; daniel@bayesianops.com
##
## Workshop: 
## Debugging Stan Programs
##
## Having trouble getting your Stan models to behave? This
## hands-on workshop will explore practical strategies for debugging Stan
## code, from identifying non-identifiable parameters to improving
## runtime performance. Participants will gain tools and intuition for
## building more robust models—skills that extend to a wide range of
## statistical and stochastic programming tasks. 
## Prerequisite: Familiarity with Stan is recommended.
##
################################################################################


library(cmdstanr)
library(dplyr)
library(bayesplot)
library(ggplot2)

color_scheme_set("brightblue")


################################################################################
## Example 1: Debug by Print
## 
## * Run the model
## * Understand the output
## * Identify issues
## * Debug by print
## * Understand how often different blocks execute

mod <- cmdstan_model("example_01.stan")
fit <- mod$sample()

## Look at the error message.
## * What line is the error?
## * What is the error?

## Debug by print (don't "fix" the problem):
## * Add a print statement to trap the error.
## * Where should the print statement go?
##
## Familiarity with CmdStanR / Stan:
## * Reducing chains to 1, sampling draws to 1, warmup to 1
## * Why is the error message repeated so many times?
## * Where is the output printed?

mod <- cmdstan_model("example_01.stan")
fit <- mod$sample(chains = 1, iter_sampling = 1, iter_warmup = 1)


## Replace L3 "vector[N] y;" with:
##   vector[N] y = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
##
## * Read the error message.
## * What is the issue?
## * What's the fix?

mod <- cmdstan_model("example_01.stan")
fit <- mod$sample(parallel_chains = 4)
fit_optim <- mod$optimize()

## Why is sigma not close to sd(1:10)?
## Why is it close to sd(1:10) * sqrt(10 * (10 - 1) / (10 * 10 - 1))?


################################################################################
## Example 2: Error in a different place

mod <- cmdstan_model("example_02.stan")
fit <- mod$sample()


## What's the error?
## * Why is it different than Example 1?
## * What can we do to trap it?
## * Add a print for target()


fit <- mod$sample(chains = 1, iter_sampling = 1, iter_warmup = 1)


## What is a divergence?



################################################################################
## Example 3: non-identifiability
##
## * Write data as JSON
## * Easy example of non-identifiability

set.seed(20251103)
N <- 10
y <- rnorm(N, 0, 1)

cmdstanr::write_stan_json(list(N = N, y = y), "example_03.json")

stan_data <- jsonlite::fromJSON("example_03.json")


mod <- cmdstan_model("example_03.stan")
fit <- mod$sample()

## What is this error?


fit <- mod$sample(stan_data, parallel_chains = 4)

## Look at output, what's going on?

bayesplot::mcmc_hist(fit$draws("a"))
bayesplot::mcmc_hist(fit$draws("b"))
bayesplot::mcmc_hist(fit$draws(c("a", "b")))

## What does the data look like?

ggplot(data.frame(y = y), aes(y)) + geom_histogram()




################################################################################
## Example 4: speed
##
## HAVING TROUBLE WITH INSTALL. Will need to skip parts.


##mod <- cmdstan_model("example_04.stan", compile_model_methods = TRUE) #, force_recompile = TRUE)

mod <- cmdstan_model("example_04.stan")

set.seed(20251103)
N <- 50
y <- rnorm(N, 0, 1)

cmdstanr::write_stan_json(list(N = N, y = y), "example_04.json")

stan_data <- jsonlite::fromJSON("example_04.json")


fit <- mod$sample(stan_data)

fit$profiles()





################################################################################
## Example 5: simulate data
##

set.seed(20251103)
a <- -0.3
b <- -2
sigma <- 0.3

N <- 100
x <- abs(rnorm(N, 0, 0.5))
y <- rlnorm(N, log(exp(-a * x) + exp(-b * x)), sigma)


stan_data <- list(N = N, x = x, y = y)

mod <- cmdstan_model("example_05.stan")


fit <- mod$sample(stan_data, parallel_chains = 4)



set.seed(20251103)
a <- -0.3
b <- -2
sigma <- 0.01

N <- 100
x <- abs(rnorm(N, 0, 0.5))
y <- rlnorm(N, log(exp(-a * x) + exp(-b * x)), sigma)


stan_data <- list(N = N, x = x, y = y)

mod <- cmdstan_model("example_05.stan")


fit <- mod$sample(stan_data, parallel_chains = 4)



bayesplot::mcmc_hist(fit$draws(c("a", "b")))



set.seed(20251103)
a <- -0.3
b <- -2
sigma <- 1

N <- 100
x <- abs(rnorm(N, 0, 0.5))
y <- rlnorm(N, log(exp(-a * x) + exp(-b * x)), sigma)


stan_data <- list(N = N, x = x, y = y)

mod <- cmdstan_model("example_05.stan")


fit <- mod$sample(stan_data, parallel_chains = 4)


bayesplot::mcmc_hist(fit$draws(c("a", "b")))


