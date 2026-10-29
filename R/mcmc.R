
# Adaptive RW Metropolis with parallel tempering ---------------

#' Calculate logarithmic probability density (log-likelihood + log-prior)
#'
#' Computes the unnormalized log-posterior probability density scaled by temperature
#' (used for parallel tempering / MCMC sampling), combining the log-prior and log-likelihood.
#'
#' @param loglik Function to calculate log-likelihood.
#' @param logprior Function to calculate log-prior.
#' @param response Numeric vector of response data (e.g., annual maximum series / specific discharge).
#' @param covariate Covariate data or additional predictors (can be \code{NA} or \code{NULL}).
#' @param params Numeric vector of current parameter values.
#' @param hyperparam List or object containing hyper-parameters for the prior.
#' @param T Numeric. Temperature parameter for parallel tempering (default usually 1).
#'
#' @return Numeric value representing the scaled log-probability, or a very small number
#'   (\code{-1e+200}) if probabilities are invalid or non-finite.
#' @export
logprob = function(loglik, logprior, response, covariate, params, hyperparam, T)
{
  p = logprior(params, hyperparam)
  if (p <= -1e+199 || is.na(p))
  {
    return(-1e+200)
  }

  l = loglik(response, covariate, params)
  if (l <= -1e+199 || is.na(l))
  {
    return(-1e+200)
  }

  ret = (l + p) / T

  return(ret)
}

# Single RW Metropolis sampling. ------------
# Uses tempering algorithm also
# params should be a collection of parameters, one for eahc value
# in the T array. Returns an object containing new parameter
# values for each T, an array of the new logprobs and updated
# acceptance numbers (for adaptive usages)
# rw is an array of random walk standard deviations for each parameter
# Acceptances and number of tests (number of possible acceptances)
# for each parameter, are also only for for the first chain
# (the chain which is the object of interest)
# Input: likelihood
#' Perform a single Metropolis random-walk step with parallel tempering
#'
#' Single RW Metropolis sampling utilizing a parallel tempering algorithm.
#' Returns an object containing new parameter values for each chain,
#' an array of updated log-probabilities, acceptance counts, test counts, and swap statistics.
#'
#' @param loglik Function to calculate log-likelihood.
#' @param logprior Function to calculate log-prior.
#' @param response Numeric vector of response data.
#' @param covariate Covariate data or additional predictors.
#' @param params Matrix or collection of parameters, one column for each value in the chain array \code{T}.
#' @param rw Numeric vector of random-walk standard deviations for each parameter.
#' @param logprobs Numeric vector of current log-probabilities for each chain.
#' @param acceptances Numeric vector of acceptance counts for each parameter (chain 1).
#' @param num.tests Numeric vector of total test counts for each parameter (chain 1).
#' @param hyperparam List or object containing hyper-parameters for the prior.
#' @param swaps Numeric vector of chain swap counts.
#' @param T Numeric vector of values for the parallel tempering chains.
#'
#' @return A list containing updated \code{logprobs}, \code{params}, \code{acceptances}, \code{num.tests}, and \code{swaps}.
#' @export
sample.once = function(loglik, logprior, response, covariate, params, rw, logprobs, acceptances, num.tests, hyperparam, swaps, T)
{
  numtemp = length(T) # fetch the number of tempering chains

  if (numtemp > 1 && stats::runif(1) < 0.5) # with probability 0.5, do parallel tempering
  {
    index = base::sample(1:(numtemp - 1), 1)
    new.logprob1 = logprob(loglik, logprior, response, covariate, params[, index], hyperparam, T[index + 1])
    new.logprob2 = logprob(loglik, logprior, response, covariate, params[, index + 1], hyperparam, T[index])

    # accept switching of tempering chains?
    if (is.finite(new.logprob1) & is.finite(new.logprob2))
      if (log(stats::runif(1)) < new.logprob1 + new.logprob2 - logprobs[index] - logprobs[index + 1])
      {
        swaps[index] = swaps[index] + 1

        param.buffer = params[, index]
        params[, index] = params[, index + 1]
        params[, index + 1] = param.buffer

        logprobs[index] = new.logprob2
        logprobs[index + 1] = new.logprob1
      }
  }
  else
  {
    for (t in 1:numtemp) # traverse the parallel tempering chains
    {
      rw = as.numeric(rw)

      pars = unlist(params[, t])
      for (i in 1:length(pars)) # traverse the parameters
      {
        # suggest a new parameter value:
        new.param = pars
        new.param[i] = as.numeric(new.param[i]) + sqrt(T[t]) * rw[i] * stats::rnorm(1)
        new.param = utils::relist(new.param, params[, t])

        # fetch the logprob:
        new.logprob = logprob(loglik, logprior, response, covariate,
                              new.param, hyperparam, T[t])

        # accept/reject:
        if (is.finite(new.logprob))
          if (log(stats::runif(1)) < new.logprob - logprobs[t])
          {
            logprobs[t] = new.logprob
            params[, t] = new.param
            pars = unlist(params[, t])
            if (t == 1)
            {
              acceptances[i] = acceptances[i] + 1
            }
          }

        # update the number of tests if this is the original chain:
        if (t == 1)
        {
          num.tests[i] = num.tests[i] + 1
        }
      }
    }
  }

  # return structure:
  ret = list(logprobs = logprobs, params = params,
             acceptances = acceptances, num.tests = num.tests, swaps = swaps)

  return(ret)
}

# Repeated sampling-------------
#
# INPUT:
# loglik - logarithmic likelihood, should take response,
#          covariates and parameters as input
# logprior - logarithmic prior, should take parameres and
#            hyperparameters as input
# response - response variable
# covariates - if applicable
# hyperparam - hyper parameters, used in the prior
# param.template - gives and indication of how the parameter
#                  vector should look like
# numsample - number of samples to be returned
# burnin - burnin period length
# indep - spacing between samples to be included in the output
# numtemp - number of "temperatures" (minimum 1)
#
# OUTPUT:
# Returns a numsamples x numparams array containing parameter samples

#' Perform MCMC sampling using Metropolis-Hastings with parallel tempering and adaptive random-walk
#'
#' Runs Markov Chain Monte Carlo (MCMC) sampling using a Metropolis algorithm
#' featuring parallel tempering, burn-in with adaptive random-walk step-length tuning,
#' and thinning.
#'
#' @param loglik Function to calculate log-likelihood.
#' @param logprior Function to calculate log-prior.
#' @param response Response variable vector.
#' @param covariate Covariate data or additional predictors.
#' @param hyperparam Hyper-parameters used in the prior.
#' @param param.template Template object giving an indication of how the parameter vector should look like.
#' @param numsamples Number of samples to be returned.
#' @param burnin Burn-in period length (default = 1000).
#' @param indep Spacing (thinning) between samples to be included in the output (default = 10).
#' @param numtemp Number of tempering chains (minimum 1, default = 1).
#' @param base.temp Base temperature for parallel tempering (default = 1.25).
#' @param talkative Logical. If \code{TRUE}, prints progress and debug info (default = \code{FALSE}).
#'
#' @return A matrix containing parameter samples.
#' @export
sample.mcmc = function(loglik, logprior, response,
                       covariate, hyperparam, param.template,
                       numsamples, burnin = 1000,
                       indep = 10, numtemp = 1,
                       base.temp = 1.25, talkative = FALSE)
{
  numparam = length(unlist(param.template))

  # initialization of tempering chains:
  T_vals = base.temp^(0:(numtemp - 1))
  params = cbind(param.template)
  if (numtemp >= 2)
  {
    for (t in 2:numtemp)
    {
      params = cbind(params, param.template)
    }
  }

  # initialization of random walk step lengths:
  rw = unlist(param.template)
  rw[1:length(rw)] = rep(1, length(rw))

  # Initialization of number of acceptances and tests:
  acc = rep(0, numparam)
  num = rep(0, numparam)
  swaps = rep(0, numtemp)

  # Initialization of logarithmic probability densities:
  lp = rep(0, numtemp)
  for (t in 1:numtemp)
  {
    lp[t] = logprob(loglik, logprior, response, covariate, params[, t], hyperparam, T_vals[t])
  }

  numburn = max(2, ceiling(burnin / 5000))
  # burnin:
  for (i in 1:numburn)
  {
    if (talkative)
      show(c("Burnin - non-adaptive rw steps", i, "of", numburn))
    # non-adaptive part:
    if (ceiling(burnin / numburn / 2) >= 1)
      for (j in 1:ceiling(burnin / numburn / 2))
      {
        res = sample.once(loglik, logprior, response, covariate,
                          params, rw, lp, acc, num,
                          hyperparam, swaps, T_vals)
        params = res$params
        acc = res$acceptances
        num = res$num.tests
        lp = res$logprobs
      }

    if (talkative)
      show(c("Burnin - adaptive rw steps", i, "of", numburn))
    # adaptive part:
    if (ceiling(burnin / numburn / 200) >= 1)
      for (k in 1:ceiling(burnin / numburn / 200))
      {
        # Run the chain 100 times, recording the number of acceptances
        # of each parameter:
        acc = rep(0, numparam)
        num = rep(0, numparam)
        for (j in 1:100)
        {
          res = sample.once(loglik, logprior, response, covariate, params,
                            rw, lp, acc, num, hyperparam, swaps, T_vals)
          params = res$params
          acc = res$acceptances
          num = res$num.tests
          lp = res$logprobs
        }

        # Update the random walk step lengths:
        for (i_param in 1:length(rw))
        {
          rw[i_param] = as.numeric(rw[i_param]) * exp((acc[i_param] / num[i_param] - 0.33) * 2)
        }

        # debug:
        if (talkative)
        {
          show("rw (debug):")
          show(as.numeric(rw))
          show("acc (debug):")
          show(as.numeric(acc))
          show(params[, 1])
        }
      }
  }

  if (talkative)
    show("start sampling...")

  # sampling:
  for (i in 1:numsamples)
  {
    # run the chain 'indep' number of times:
    for (j in 1:indep)
    {
      res = sample.once(loglik, logprior, response,
                        covariate, params, rw, lp, acc,
                        num, hyperparam, swaps, T_vals)
      params = res$params
      acc = res$acceptances
      num = res$num.tests
      lp = res$logprobs
      swaps = res$swaps
    }

    # add the current parameter to the set of samples:
    if (i == 1)
    {
      ret = cbind(params[, 1])
    }
    else
    {
      ret = cbind(ret, params[, 1])
    }

    if (i %% 10 == 0 & talkative)
    {
      show(i)
      show(params[, 1])
    }
  }

  if (numtemp > 1 & talkative)
  {
    show("Swaps:")
    show(swaps[1:(numtemp - 1)])
  }

  return(ret)
}


# Calculate marginal model likelihood  ---------------
#' Calculate marginal model likelihood (evidence) using importance sampling ---------------
#'
#' Computes the marginal log-likelihood (model evidence) for an MCMC sample
#' using a Gaussian mixture / importance sampling approximation based on the multivariate normal distribution.
#'
#' @param loglik Function to calculate log-likelihood.
#' @param logprior Function to calculate log-prior.
#' @param response Numeric vector of response data.
#' @param covariate Covariate data or additional predictors.
#' @param hyperparam Hyper-parameters used in the prior.
#' @param param.template Template object giving an indication of how the parameter vector should look like.
#' @param samples Matrix or data.frame of MCMC posterior parameter samples (parameters in rows, samples in columns).
#' @param num.iterations Integer. Number of importance sampling iterations (default usually large, e.g., 10000+).
#'
#' @return Numeric value representing the estimated marginal log-likelihood (log evidence).
#' @export
model.loglik = function(loglik, logprior, response, covariate,
                        hyperparam, param.template, samples, num.iterations)
{
  if (!requireNamespace("MASS", quietly = TRUE)) {
    stop("Pakken 'MASS' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
  }

  numparam = dim(samples)[1]
  numsamp = dim(samples)[2]

  samp = array(NA, c(numparam, numsamp))
  for (i in 1:numparam)
    samp[i, ] = as.numeric(samples[i, ])

  m = array(NA, numparam)
  for (i in 1:numparam)
    m[i] = stats::mean(samp[i, ])
  m = c(m)
  S = base::var(t(samp))
  Sinv = base::solve(S)
  logSdet = as.numeric(base::determinant(S, logarithm = TRUE)$modulus)

  param = param.template
  lx0 = -0.5 * numparam * log(2 * pi) - 0.5 * logSdet
  param[1:length(param)] = m
  lp0 = logprob(loglik, logprior, response, covariate, param, hyperparam, 1)

  mm = max(10, ceiling(num.iterations / 100))
  xp = MASS::mvrnorm(mm, m, S)

  for (i in 1:mm)
  {
    lx = -0.5 * numparam * log(2 * pi) - 0.5 * logSdet - 0.5 * (xp[i, ] - m) %*% Sinv %*% (xp[i, ] - m)
    param = param.template
    param[1:length(param)] = xp[i, ]
    lp = logprob(loglik, logprior, response, covariate, param, hyperparam, 1)
    if (!is.infinite(lx) & !is.infinite(lp) & lp + lx > lp0 + lx0)
    {
      lp0 = lp
      lx0 = lx
    }
  }

  m.lik = 0
  xp = MASS::mvrnorm(num.iterations, m, S)
  for (i in 1:num.iterations)
  {
    lx = -0.5 * numparam * log(2 * pi) - 0.5 * logSdet - 0.5 * (xp[i, ] - m) %*% Sinv %*% (xp[i, ] - m)
    param = param.template
    param[1:length(param)] = xp[i, ]
    lp = logprob(loglik, logprior, response, covariate, param, hyperparam, 1)
    w = (lp - lp0) - (lx - lx0)
    m.lik = m.lik + exp(w)
  }
  m.lik = m.lik / num.iterations

  log(m.lik) + lp0 - lx0
}



# Next is to calculate model likelihoods:-----------
#' Calculate marginal model likelihood using independent normal approximations
#'
#' Computes the marginal log-likelihood (model evidence) for MCMC samples
#' using importance sampling based on independent normal distributions for each parameter.
#'
#' @param loglik Function to calculate log-likelihood.
#' @param logprior Function to calculate log-prior.
#' @param response Numeric vector of response data.
#' @param covariate Covariate data or additional predictors.
#' @param hyperparam Hyper-parameters used in the prior.
#' @param param.template Template object giving an indication of how the parameter vector should look like.
#' @param samples Matrix or data.frame of MCMC posterior parameter samples (parameters in rows, samples in columns).
#' @param num.iterations Integer. Number of importance sampling iterations.
#'
#' @return Numeric value representing the estimated marginal log-likelihood (log evidence).
#' @export
model.loglik.indep = function(loglik, logprior, response, covariate,
                              hyperparam, param.template, samples, num.iterations)
{
  if (!requireNamespace("MASS", quietly = TRUE)) {
    stop("Pakken 'MASS' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
  }

  numparam = dim(samples)[1]
  numsamp = dim(samples)[2]

  samp = array(NA, c(numparam, numsamp))
  for (i in 1:numparam)
    samp[i, ] = as.numeric(samples[i, ])

  m = array(NA, numparam)
  s = array(NA, numparam)
  for (i in 1:numparam)
  {
    m[i] = stats::mean(samp[i, ])
    s[i] = stats::sd(samp[i, ])
  }

  param = param.template
  lx0 = sum(stats::dnorm(m, m, s, log = TRUE))
  param[1:length(param)] = m
  lp0 = logprob(loglik, logprior, response, covariate, param, hyperparam, 1)

  mm = max(1000, ceiling(num.iterations / 5))

  m.use = rep(1, mm) %*% t(m)
  s.use = rep(1, mm) %*% t(s)
  xp = base::matrix(stats::rnorm(mm * numparam), nrow = mm)
  xp = m.use + s.use * xp

  for (i in 1:mm)
  {
    lx = sum(stats::dnorm(xp[i, ], m, s, log = TRUE))
    param = param.template
    param[1:length(param)] = xp[i, ]
    lp = logprob(loglik, logprior, response, covariate, param, hyperparam, 1)
    if (!is.infinite(lx) & !is.infinite(lp) & lp - lx > lp0 - lx0)
    {
      lp0 = lp
      lx0 = lx
    }
  }

  m.lik = 0
  m.use = rep(1, num.iterations) %*% t(m)
  s.use = rep(1, num.iterations) %*% t(s)
  xp = base::matrix(stats::rnorm(num.iterations * numparam), nrow = num.iterations)
  xp = m.use + s.use * xp

  for (i in 1:num.iterations)
  {
    lx = sum(stats::dnorm(xp[i, ], m, s, log = TRUE))
    param = param.template
    param[1:length(param)] = xp[i, ]
    lp = logprob(loglik, logprior, response, covariate, param, hyperparam, 1)
    w = (lp - lp0) - (lx - lx0)
    m.lik = m.lik + exp(w)
  }
  m.lik = m.lik / num.iterations

  log(m.lik) + lp0 - lx0
}


