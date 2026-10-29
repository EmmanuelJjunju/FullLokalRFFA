# Get MCMC motor:
#source("mcmc.R")

# Read and check the climate file------------------------------------------------
#' Read and check climate variables from a CSV file
#'
#' Read and check the climate file. Rearrange and relabel, in order
#' to standardize the content before returning it
#' @param filename.csv Character. Path to the climate CSV file.
#'
#' @return A standardized data.frame containing the extracted climate variables,
#'   or NULL if required columns are missing or unreadable.
#' @export
get.climate.variables = function(filename.csv)
{
  tab = utils::read.csv(filename.csv, sep = ";", header = TRUE)
  if (!exists("tab"))
    return(NULL)

  names = names(tab)

  area.index = which(substr(names, 1, 4) == "area")[1]
  if (length(area.index) == 0 | sum(is.na(area.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"area\"")
    return(NULL)
  }
  if (length(area.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"area\"")
    return(NULL)
  }

  avr.index = which(substr(names, 1, 3) == "avr")[1]
  if (length(avr.index) == 0 | sum(is.na(avr.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"avr\"")
    return(NULL)
  }
  if (length(avr.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"avr\"")
    return(NULL)
  }

  efflake.index = intersect(which(substr(names, 1, 3) == "eff"),
                            grep("lake", names, ignore.case = TRUE))
  if (length(efflake.index) == 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"eff\" og \"lake\"")
    return(NULL)
  }
  if (length(efflake.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"eff\" og \"lake\"")
    return(NULL)
  }

  riverlen.main.index = intersect(intersect(which(substr(names, 1, 5) == "river"),
                                            grep("len", names, ignore.case = TRUE)),
                                  grep("main", names, ignore.case = TRUE))
  if (length(riverlen.main.index) == 0 | sum(is.na(riverlen.main.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"river\", \"len\" og \"main\"")
    return(NULL)
  }
  if (length(riverlen.main.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"river\", \"len\" og \"main\"")
    return(NULL)
  }

  temp.feb.index = intersect(which(substr(names, 1, 4) == "temp"),
                             grep("feb", names, ignore.case = TRUE))
  if (length(temp.feb.index) == 0 | sum(is.na(temp.feb.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"temp\" og \"feb\"")
    return(NULL)
  }
  if (length(temp.feb.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"temp\" og \"feb\"")
    return(NULL)
  }

  temp.mar.index = intersect(which(substr(names, 1, 4) == "temp"),
                             grep("mar", names, ignore.case = TRUE))
  if (length(temp.mar.index) == 0 | sum(is.na(temp.mar.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"temp\" og \"mar\"")
    return(NULL)
  }
  if (length(temp.mar.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"temp\" og \"mar\"")
    return(NULL)
  }

  prec.melt.may.index = intersect(intersect(grep("prec", names, ignore.case = TRUE),
                                            grep("melt", names, ignore.case = TRUE)),
                                  grep("may", names, ignore.case = TRUE))
  if (length(prec.melt.may.index) == 0 | sum(is.na(prec.melt.may.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"prec\", \"melt\" og \"may\"")
    return(NULL)
  }
  if (length(prec.melt.may.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"prec\", \"melt\" og \"may\"")
    return(NULL)
  }

  glac.index = which(substr(names, 1, 7) == "glacier")[1]
  if (length(glac.index) == 0 | sum(is.na(glac.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"glacier\"")
    return(NULL)
  }
  if (length(glac.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"glacier\"")
    return(NULL)
  }

  forest.index = which(substr(names, 1, 6) == "forest")[1]
  if (length(forest.index) == 0 | sum(is.na(forest.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"forest\"")
    return(NULL)
  }
  if (length(forest.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"forest\"")
    return(NULL)
  }

  height10.index = intersect(grep("height", names, ignore.case = TRUE),
                             grep("10", names, ignore.case = TRUE))
  if (length(height10.index) == 0 | sum(is.na(height10.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"height\" og \"10\"")
    return(NULL)
  }
  if (length(height10.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"height\" og \"10\"")
    return(NULL)
  }

  prec.july.index = intersect(grep("prec", names, ignore.case = TRUE),
                              grep("jul", names, ignore.case = TRUE))
  if (length(prec.july.index) == 0 | sum(is.na(prec.july.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"prec\" og \"jul\"")
    return(NULL)
  }
  if (length(prec.july.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"prec\" og \"jul\"")
    return(NULL)
  }

  prec.melt.june.index = intersect(intersect(grep("prec", names, ignore.case = TRUE),
                                             grep("melt", names, ignore.case = TRUE)),
                                   grep("jun", names, ignore.case = TRUE))
  if (length(prec.melt.june.index) == 0 | sum(is.na(prec.melt.june.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"prec\", \"melt\" og \"jun\"")
    return(NULL)
  }
  if (length(prec.melt.june.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"prec\", \"melt\" og \"jun\"")
    return(NULL)
  }

  riverlen.all.index = intersect(intersect(grep("river", names, ignore.case = TRUE),
                                           grep("len", names, ignore.case = TRUE)),
                                 grep("all", names, ignore.case = TRUE))
  if (length(riverlen.all.index) == 0 | sum(is.na(riverlen.all.index)) > 0)
  {
    print.srcref("Fant ingen kolonne som startet med \"river\", \"len\" og \"all\"")
    return(NULL)
  }
  if (length(riverlen.all.index) > 1)
  {
    print.srcref("Fant mer enn en kolonne som startet med \"river\", \"len\" og \"all\"")
    return(NULL)
  }

  tab3 = tab[, c(area.index, avr.index, efflake.index, riverlen.main.index,
                 temp.feb.index, temp.mar.index, prec.melt.may.index, glac.index, forest.index,
                 height10.index, prec.july.index, prec.melt.june.index, riverlen.all.index)]

  names(tab3) = c("area", "avr", "efflake", "riverlen.main", "temp.feb",
                  "temp.mar", "prec.melt.may", "glacier", "forest", "height10", "prec.july",
                  "prec.melt.june", "riverlen.all")

  return(tab3)
}

# Get hyper parameters from the regional modeland climate values------------------------------------------------
#' Get hyper parameters from the regional model and climate variables
#'
#' Get hyper parameters from the regional model and the given climate variable values.
#' Parameter set for regional analysis is re-parametrized to log-index flood
#' (index flood for log-transformed specific discharges), alpha = log(scale/log.index.flood),
#' and ksi = -0.5 + 1 / (1 + exp(-k)).
#'
#' @param clim A data.frame containing the standardized climate variables.
#' @param new.reg.coef Logical. If \code{TRUE}, uses updated regression coefficients (default = FALSE).
#'
#' @return A list containing the estimated means and standard deviations for
#'   log-index flood, alpha, and ksi.
#' @export
get.regional.params = function(clim, new.reg.coef = FALSE)
{
  # Start off using old regression coefficients:
  log.index.flood.est = 4.196 + 0.473 * (clim$avr^(1.0 / 3.0)) -
    0.0632 * sqrt(clim$riverlen.main) - 0.0520 * clim$efflake -
    0.00751 * clim$temp.feb^2 -
    0.000942 * clim$temp.mar^3 +
    0.0376 * sqrt(clim$prec.melt.may)
  log.index.flood.sd = 0.262

  alpha.est = -1.562 - 0.00361 * clim$glacier + 0.00227 * clim$forest +
    0.000238 * clim$height10 + 0.00157 * clim$prec.july - 0.000580 * clim$prec.melt.june
  alpha.sd = 0.164

  ksi.est = 0.111 - 0.0173 * clim$efflake - 5.79e-5 * clim$riverlen.all
  ksi.sd = 0.165

  if (new.reg.coef)
  {
    # Reset using new regression coefficients:
    log.index.flood.est = 3.7258 + 0.577 * (clim$avr^(1.0 / 3.0)) -
      0.0507 * sqrt(clim$riverlen.main) - 0.0560 * clim$efflake -
      0.00577 * clim$temp.feb^2 -
      0.000978 * clim$temp.mar^3 +
      0.0263 * sqrt(clim$prec.melt.may)
    log.index.flood.sd = 0.237

    alpha.est = -1.522 - 0.00631 * clim$glacier + 0.00313 * clim$forest +
      0.000211 * clim$height10 + 0.000599 * clim$prec.july -
      0.000426 * clim$prec.melt.june
    alpha.sd = 0.178

    ksi.est = 0.0573 - 0.00857 * clim$efflake - 6.17e-5 * clim$riverlen.all
    ksi.sd = 0.162
  }

  return(list(
    log.index.flood.est = log.index.flood.est,
    log.index.flood.sd = log.index.flood.sd,
    alpha.est = alpha.est,
    alpha.sd = alpha.sd,
    ksi.est = ksi.est,
    ksi.sd = ksi.sd
  ))
}

# Reparametrization------------------------------------------------
# Reparametrization from standard GEV parameters to
# log.index.flood, alpha and ksi

#' Transformation to log.index.flood
#'
#' Computes the log-median (log.index.flood) from standard GEV parameters.
#'
#' @param mu Numeric. Location parameter.
#' @param logsigma Numeric. Log-transformed scale parameter.
#' @param k Numeric. Shape parameter.
#'
#' @return Numeric value representing the estimated log-index flood.
#' @export
reg.logmedian = function(mu, logsigma, k) {
  return(log(mu + exp(logsigma) / k * ((log(2.0)^(-k) - 1.0))))
}

#' Transformation to alpha
#'
#' Computes the reparameterized scale parameter alpha from standard GEV parameters.
#'
#' @param mu Numeric. Location parameter.
#' @param logsigma Numeric. Log-transformed scale parameter.
#' @param k Numeric. Shape parameter.
#'
#' @return Numeric value representing alpha.
#' @export
reg.alpha = function(mu, logsigma, k) {
  return(logsigma - reg.logmedian(mu, logsigma, k))
}

#' Transformation to ksi
#'
#' Computes the reparameterized shape parameter ksi from standard GEV parameters.
#'
#' @param mu Numeric. Location parameter.
#' @param lsigma Numeric. Log-transformed scale parameter.
#' @param k Numeric. Shape parameter.
#'
#' @return Numeric value representing ksi.
#' @export
reg.ksi = function(mu, lsigma, k) {
  return(log((k + 0.5) / (0.5 - k)))
}


# Log-prior for a given parameter set-------------------------------------
# Log-prior for a given parameter set. Hyper-parameters come from
# regional analysis for the given climate dataset. Note that
# in the prior, the parameter set is re-parametrized to
# log-index flood (index flood for log-transformed specific discharges)
# alpha=log(scale/log.index.flood) and
# ksi=-0.5+1/(1+exp(-k))

#' Calculate log-prior for a given GEV parameter set
#'
#' Computes the log-prior for a given parameter set. Hyper-parameters come from
#' regional analysis for the given climate dataset. Note that in the prior,
#' the parameter set is re-parametrized to log-index flood, alpha, and ksi.
#'
#' @param par Numeric vector of length 3: \code{mu} (location), \code{ls} (log-sigma), \code{k} (shape).
#' @param hyper List of regional hyper-parameters (\code{log.index.flood.est}, \code{log.index.flood.sd},
#'   \code{alpha.est}, \code{alpha.sd}, \code{ksi.est}, \code{ksi.sd}).
#'
#' @return Numeric value representing the log-prior probability.
#' @export
log.prior = function(par, hyper)
{
  mu = par[1] # mu (location parameter)
  ls = par[2] # log sigma (scale)
  k  = par[3] # shape parameter

  # Check that the parameter values are legal:
  # Non-negative median?
  if (mu + exp(ls) / k * ((log(2.0)^(-k) - 1.0)) <= 0.0)
    return(-1e+200)
  # -0.5 < k < +0.5?
  if (k <= -0.5 | k >= 0.5)
    return(-1e+200)

  # Make a Jacobi matrix (for reparametrization) based on numeric derivatives
  dx = 0.0001 # numeric derivative displacement

  # Store transformed variables (var 1 = log.index.flood, 2 = alpha, 3 = ksi)
  q1.curr = reg.logmedian(mu, ls, k)
  q2.curr = reg.alpha(mu, ls, k)
  q3.curr = reg.ksi(mu, ls, k)

  # Make Jacobi matrix:
  theta = base::matrix(c(
    q1.curr - reg.logmedian(mu - dx, ls, k),
    q1.curr - reg.logmedian(mu, ls - dx, k),
    q1.curr - reg.logmedian(mu, ls, k - dx),
    q2.curr - reg.alpha(mu - dx, ls, k),
    q2.curr - reg.alpha(mu, ls - dx, k),
    q2.curr - reg.alpha(mu, ls, k - dx),
    0,
    0,
    q3.curr - reg.ksi(mu, ls, k - dx)
  ) / dx, nrow = 3)

  logdet = as.numeric(base::determinant(theta, logarithm = TRUE))[1]

  # Check if determinant was well-formed:
  if (!is.numeric(logdet))
    return(-1e+200)

  # Prior = jacobi-matrix * product of normal distributions for
  # each re-parametrized parameter value
  ret = logdet +
    stats::dnorm(q1.curr, hyper$log.index.flood.est, hyper$log.index.flood.sd, log = TRUE) +
    stats::dnorm(q2.curr, hyper$alpha.est, hyper$alpha.sd, log = TRUE) +
    stats::dnorm(q3.curr, hyper$ksi.est, hyper$ksi.sd, log = TRUE)

  # Check that return value makes sense:
  if (!is.numeric(ret))
    return(-1e+200)

  return(ret)
}


# Log-likelihood operates on original GEV parameters and---------------------
# is thus fairly simple:

#' Calculate log-likelihood for original GEV parameters
#'
#' Operates on original GEV parameters and computes the log-likelihood
#' for the observed data.
#'
#' @param data Numeric vector of annual maximum series (AMS).
#' @param cov Covariate data (included for interface consistency).
#' @param par Numeric vector of length 3: \code{mu}, \code{ls} (log-sigma), \code{k}.
#'
#' @return Numeric value representing the log-likelihood.
#' @export
log.lik = function(data, cov, par)
{
  mu = par[1] # mu (location parameter)
  ls = par[2] # log sigma (scale)
  k  = par[3] # shape parameter
  sigma = exp(ls)

  if (k == 0)
    return(sum(-exp(-(data - mu) / sigma)))
  if (k > 0 & min(data) < mu - sigma / k)
    return(-1e+200)
  if (k < 0 & max(data) > mu - sigma / k)
    return(-1e+200)

  return(sum(-ls + (-1 / k - 1) * log(1 + k * (data - mu) / sigma) - (1 + k * (data - mu) / sigma)^(-1 / k)))
}


# Pmoments---------------------------------

#' Calculate probability-weighted moments (PWMs)
#'
#' Computes probability-weighted moments (PWMs / P-moments) from AMS data.
#' Code originally developed by Lars Roald.
#'
#' @param ams Numeric vector of annual maximum series (AMS).
#'
#' @return A list containing moments \code{a0}, \code{a1}, \code{a2}, \code{b0}, \code{b1}, \code{b2}.
#' @export
get.pmoments = function(ams)
{
  # Code from Lars Roald

  a0 = a1 = a2 = b0 = b1 = b2 = 0.0

  a0 = b0 = mean(ams)

  x = sort(ams)
  n = length(x)
  j = 1
  for (i in 0:(n - 1))
  {
    a1 = a1 + (n - j) * x[i + 1] / ((n - 1) * n)
    a2 = a2 + (n - j) * (n - j - 1) * x[i + 1] / ((n - 2) * (n - 1) * n)
    b1 = b1 + (j - 1) * x[i + 1] / ((n - 1) * n)
    b2 = b2 + (j - 1) * (j - 2) * x[i + 1] / ((n - 2) * (n - 1) * n)

    j = j + 1
  }

  return(list(a0 = a0, a1 = a1, a2 = a2, b0 = b0, b1 = b1, b2 = b2))
}

#' Perform Bayesian flood frequency analysis using MCMC
#'
#' Fetches climate data and annual maximum series (AMS), sets initial parameter values
#' using probability-weighted moments (P-moments), and performs MCMC sampling for
#' GEV parameters incorporating regional prior information.
#'
#' @param ams.file Character. Path to the AMS data file (one-column text or similar readable via \code{scan}).
#' @param climate.file.csv Character. Path to the CSV file containing climate variables.
#' @param is.specific.discharge Logical. \code{TRUE} if units are specific discharge (l/km^2/s),
#'   \code{FALSE} for total discharge (m^3/s) (default = \code{FALSE}).
#' @param num.mcmc Integer. Number of MCMC samples to keep (default = 1000).
#' @param spacing Integer. Thinning interval for MCMC sampling (default = 10).
#' @param burnin Integer. Number of burn-in iterations (default = 10000).
#' @param num.temp Integer. Number of temperatures for parallel tempering (default = 1).
#' @param new.reg.coef Logical. If \code{TRUE}, uses updated regression coefficients (default = \code{FALSE}).
#'
#' @return A list containing:
#'   \describe{
#'     \item{\code{ams}}{Numeric vector of original annual maxima.}
#'     \item{\code{clim}}{Data frame of standardized climate variables.}
#'     \item{\code{spec}}{Numeric vector of specific discharges.}
#'     \item{\code{scale}}{Scaling factor applied based on catchment area.}
#'     \item{\code{mcmc}}{A \code{coda::mcmc} object containing the posterior parameter samples.}
#'     \item{\code{is.specific.discharge}}{Logical indicator.}
#'   }
#' @export
perform.analysis = function(ams.file, climate.file.csv,
                            is.specific.discharge = FALSE, # specific discharge or DISCHARGE
                            num.mcmc = 1000, spacing = 10, burnin = 10000, num.temp = 1,
                            new.reg.coef = FALSE)
{
  if (!requireNamespace("coda", quietly = TRUE)) {
    stop("Pakken 'coda' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
  }

  # Fetch climate data:
  clim = get.climate.variables(climate.file.csv)
  if (is.null(clim))
  {
    print.srcref("Kunne ikke lese klimafil!")
    return(NULL)
  }

  # Fetch AMS content:
  ams = scan(ams.file, quiet = TRUE)
  if (is.null(ams))
  {
    print.srcref("Kunne ikke lese AMS-fil (Annual Maximums)!")
    return(NULL)
  }

  # Fetch hyper-parameters for re-parametrized GEV parameters
  # from the regional model and the climate data:
  hyper.params = get.regional.params(clim, new.reg.coef)

  pmom = get.pmoments(ams)
  c_val = (2 * pmom$b1 - pmom$b0) / (3 * pmom$b2 - pmom$b0) - log(2) / log(3)

  # P-moment estimates of GEV parameters:
  k.pmom = -7.8590 * c_val - 2.9554 * c_val^2
  sigma.pmom = mu.pmom = 0
  if (k.pmom == 0)
  {
    sigma.pmom = (2 * pmom$b1 - pmom$b0) / log(2)
    mu.pmom = pmom$b0 - 0.57721566 * sigma.pmom
  }
  else
  {
    sigma.pmom = -(2 * pmom$b1 - pmom$b0) * k.pmom / (gamma(-k.pmom + 1) * (1 - 2^k.pmom))
    mu.pmom = pmom$b0 - sigma.pmom * (gamma(-k.pmom + 1) - 1) / k.pmom
  }

  # Initial values needs to be set using p-moments!
  par0 = c(mu.pmom, log(sigma.pmom), k.pmom)
  lp = log.prior(par0, hyper.params)
  ll = log.lik(ams, NULL, par0)

  # If p.moments do not work, sample around them and try again!
  while (!is.numeric(lp) || !is.finite(lp) || lp == -1e+200 || !is.numeric(ll) || !is.finite(ll) || ll == -1e+200)
  {
    par0 = c(mu.pmom, log(sigma.pmom), k.pmom) + stats::rnorm(3)
    lp = log.prior(par0, hyper.params)
    ll = log.lik(ams, NULL, par0)
  }

  # Rescale discharge, not specific discharge:
  scale = 1
  if (!is.specific.discharge)
    scale = clim$area / 1000

  # Specific discharge from ams-data:
  spec = ams / scale

  # Perform MCMC:
  par.samples = sample.mcmc(log.lik, log.prior, spec, NA, hyper.params, par0,
                            num.mcmc, burnin, spacing, num.temp)

  mcmc.samples = coda::mcmc(t(par.samples))
  mcmc.samples[, 1] = mcmc.samples[, 1] * scale
  mcmc.samples[, 2] = mcmc.samples[, 2] + log(scale)

  # Return data, meta-data and results:
  return(list(
    ams = ams,
    clim = clim,
    spec = spec,
    scale = scale,
    mcmc = mcmc.samples,
    is.specific.discharge = is.specific.discharge
  ))
}

# gev quantile ----------------------

#' Calculate GEV quantile for given probabilities
#'
#' Computes the GEV quantile corresponding to cumulative probabilities \code{p}
#' given the parameter vector (location, log-scale, shape).
#'
#' @param p Numeric vector of cumulative probabilities.
#' @param par Numeric vector of length 3: \code{mu} (location), \code{ls} (log-sigma), \code{k} (shape).
#'
#' @return Numeric vector of GEV quantiles.
#' @export
gev.quantile = function(p, par)
{
  mu = par[1] # mu (location parameter)
  ls = par[2] # log sigma (scale)
  k  = par[3] # shape parameter
  sigma = exp(ls)

  if (k == 0)
    return(mu - sigma * log(-log(p)))

  return(mu + sigma / k * ((-log(p))^(-k) - 1))
}


# gev mean ----------------------

#' Calculate expected value (mean) of GEV distribution
#'
#' Computes the theoretical mean of the Generalized Extreme Value (GEV) distribution
#' for a given parameter set.
#'
#' @param par Numeric vector of length 3: \code{mu} (location), \code{ls} (log-sigma), \code{k} (shape).
#'
#' @return Numeric value representing the GEV mean, or \code{NA} if the shape parameter is out of bounds.
#' @export
gev.mean = function(par)
{
  mu = par[1] # mu (location parameter)
  ls = par[2] # log sigma (scale)
  k  = par[3] # shape parameter
  sigma = exp(ls)

  if (k <= -1 | k >= +1)
    return(NA)
  if (k == 0)
    return(mu + sigma * 0.5772156649)
  return(mu + sigma * (exp(base::lgamma(1 - k)) - 1) / k)
}


# gev quantile samples ----------------------

#' Extract posterior quantile samples from MCMC results
#'
#' Computes GEV quantiles across all MCMC posterior parameter samples for a given probability.
#'
#' @param p Numeric probability value.
#' @param analysis A result list returned by \code{perform.analysis()}.
#'
#' @return Numeric vector of quantile samples corresponding to each MCMC iteration.
#' @export
get.quantile.samples = function(p, analysis)
{
  n_iter = dim(analysis$mcmc)[1]
  ret = numeric(n_iter)
  for (i in seq_len(n_iter))
    ret[i] = gev.quantile(p, analysis$mcmc[i, ])
  return(ret)
}


# gev mean samples----------------------

#' Extract posterior mean samples from MCMC results
#'
#' Computes the GEV mean across all MCMC posterior parameter samples.
#'
#' @param analysis A result list returned by \code{perform.analysis()}.
#'
#' @return Numeric vector of mean samples corresponding to each MCMC iteration.
#' @export
get.mean.samples = function(analysis)
{
  n_iter = dim(analysis$mcmc)[1]
  ret = numeric(n_iter)
  for (i in seq_len(n_iter))
    ret[i] = gev.mean(analysis$mcmc[i, ])
  return(ret)
}

# lower -------------

#' Calculate lower 95% credible interval bound (2.5% quantile)
#'
#' Computes the 2.5% sample quantile for a numeric vector, typically
#' used for lower credible interval bounds on posterior samples.
#'
#' @param x Numeric vector of values.
#'
#' @return Numeric value representing the 2.5% quantile.
#' @export
lower = function(x) {
  stats::quantile(x, 0.025)
}


# upper ---------------------

#' Calculate upper 95% credible interval bound (97.5% quantile)
#'
#' Computes the 97.5% sample quantile for a numeric vector, typically
#' used for upper credible interval bounds on posterior samples.
#'
#' @param x Numeric vector of values.
#'
#' @return Numeric value representing the 97.5% quantile.
#' @export
upper = function(x) {
  stats::quantile(x, 0.975)
}

# quantile.summary ---------------------------

#' Compute posterior summary statistics for given return periods
#'
#' Calculates posterior mean, lower bound (2.5%), and upper bound (97.5%)
#' for a given set of return periods (or the mean if \code{T.ret = 0}) based on MCMC samples.
#'
#' @param T.ret Numeric vector of return periods. A value of 0 indicates the mean estimate.
#' @param analysis A result list returned by \code{perform.analysis()}.
#'
#' @return A data.frame with columns \code{Name}, \code{Post.mean}, \code{Lower}, and \code{Upper}.
#' @export
quantile.summary = function(T.ret, analysis) # T.ret=0 means MEAN estimate
{
  n.ret = length(T.ret)

  ret = array(NA, c(n.ret, 3))
  t.names = rep("", n.ret)
  for (i in 1:n.ret)
  {
    x = 0
    {if (T.ret[i] == 0)
    {
      x = get.mean.samples(analysis)
      t.names[i] = "Mean"
    }
      else
      {
        p = 1 - 1 / T.ret[i]
        x = get.quantile.samples(p, analysis)
        if (T.ret[i] == round(T.ret[i]))
        {
          t.names[i] = sprintf("T%d", round(T.ret[i]))
        }
        else
        {
          t.names[i] = sprintf("T%7.3f", T.ret[i])
        }
      }}

    ret[i, ] = c(mean(x), lower(x), upper(x))
  }

  ret = as.data.frame(ret)
  ret$Name = t.names
  ret = ret[, c(4, 1:3)]
  names(ret) = c("Name", "Post.mean", "Lower", "Upper")

  return(ret)
}


# quantile.summary(c(2,10,100,1000), res)-----------------

#' Plot Bayesian flood quantile curves using base R graphics
#'
#' Produces a log-log return period plot showing posterior mean curves,
#' credibility intervals, and observed plotting positions.
#'
#' @param analysis A result list returned by \code{perform.analysis()}.
#' @param T.start Minimum return period for the curve (default = 1.01).
#' @param T.end Maximum return period for the curve (default = 1000).
#' @param plotting.formula Plotting-position constant(s) for observed points (default = 0.44).
#' @param add Logical. If \code{TRUE}, adds curves to an existing plot (default = \code{FALSE}).
#'
#' @return A base R plot is produced as a side effect.
#' @export
plot.curve = function(analysis, T.start = 1.01, T.end = 1000, plotting.formula = 0.44,
                      add = FALSE)
{
  a = plotting.formula
  T.ret = exp(seq(log(T.start), log(T.end), length.out = 200))

  res2 = quantile.summary(T.ret, analysis)
  T.ret = T.ret[res2$Post.mean > 0.9 * min(analysis$ams) & res2$Lower > 0]
  res2 = res2[res2$Post.mean > 0.9 * min(analysis$ams) & res2$Lower > 0, ]

  y.title = "Discharge (m/s)"
  if (analysis$is.specific.discharge)
    y.title = "Specific discharge (l/km^2/s)"

  if (!add)
    graphics::plot(T.ret, res2$Post.mean, log = "xy", ylim = c(min(res2$Lower), max(res2$Upper)),
                   type = "l", lwd = 3, xlab = "Return period (years)", ylab = y.title, col = "blue")
  if (add) {
    graphics::lines(T.ret, res2$Post.mean, col = "grey50")
    graphics::lines(T.ret, res2$Lower, col = "pink", lty = 2 + 1 * (add == TRUE))
    graphics::lines(T.ret, res2$Upper, col = "pink", lty = 2 + 1 * (add == TRUE))
  } else {
    graphics::lines(T.ret, res2$Lower, col = "red", lty = 2 + 1 * (add == TRUE))
    graphics::lines(T.ret, res2$Upper, col = "red", lty = 2 + 1 * (add == TRUE))
  }

  if (!add)
  {
    cols = c("black", grDevices::rainbow(length(a)))
    for (j in 1:length(a))
    {
      n = length(analysis$ams)
      i = 1:n
      p = (i - a[j]) / (n + 1 - 2 * a[j])
      T.ret.obs = 1 / (1 - p)
      graphics::points(T.ret.obs, sort(analysis$ams), pch = j, col = cols[j])
    }
  }
}
