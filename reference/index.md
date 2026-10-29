# Package index

## All functions

- [`fx.build.klima.map()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.build.klima.map.md)
  : Build a two_panel Leaflet map with optional climate panel and
  click_to_zoom
- [`fx.compact_dt()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.compact_dt.md)
  : Create a compact, left-aligned DT table
- [`fx.compare.all.quantile.tables.by.plot()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.compare.all.quantile.tables.by.plot.md)
  : Compare quantile tables from multiple results objects using a
  two_panel plot
- [`fx.compare.two.quantile.tables.sidebyside()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.compare.two.quantile.tables.sidebyside.md)
  : Compare Two Quantile Tables Side by Side
- [`fx.extract.klima.from.shp()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.extract.klima.from.shp.md)
  : Extract climate statistics (1961-1990 and 1991-2020) from a NEVINA
  catchment shapefile
- [`fx.load_packages()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.load_packages.md)
  : Function: install missing packages and load all
- [`fx.plot.df.ams()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.plot.df.ams.md)
  : Plot AMS_data som stolpediagram
- [`fx.plot.quantile.curve.base()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.plot.quantile.curve.base.md)
  : Plot Bayesian flood frequency curve with extended NVE-style
  uncertainty
- [`fx.plot.quantile.curves.gg()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.plot.quantile.curves.gg.md)
  : Plot Bayesian flood quantile curves with PP uncertainty and
  observations
- [`fx.plot.res.mcmc()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.plot.res.mcmc.md)
  : Plot MCMC convergence and marginal distributions from GEV parameters
- [`fx.read.hydra.quantiles()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.read.hydra.quantiles.md)
  : Read quantile table from Hydra2/Flomanalyse output (daily values)
- [`fx.read.save.ams.from.hydra()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.read.save.ams.from.hydra.md)
  : Read AMS data from a Hydra export, save as one_column text, and
  optionally plot
- [`fx.sildre.timeseries.to.ams()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.sildre.timeseries.to.ams.md)
  : Read Sildre/Hydra time series, aggregate to daily values, extract
  AMS, save results, and optionally plot Leser en timesopplost eller
  dognopplost Sildre/Hydra_tidsserie, konverterer verdier, aggregerer
  til dognmiddel (og dognmaksimum hvis timesopplost), beregner aarlige
  maksimumsverdier (AMS), lagrer AMS_seriene som en_kolonne tekstfiler,
  og kan valgfritt generere plott. Hvis input allerede er dognopplost
  (dvs. ingen tidssteg \< 24 timer), beregnes kun dognmiddel og AMS for
  denne serien, og dognmaks_grenen utelates.
- [`get.climate.variables()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/get.climate.variables.md)
  : Read and check climate variables from a CSV file
- [`get.mean.samples()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/get.mean.samples.md)
  : Extract posterior mean samples from MCMC results
- [`get.pmoments()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/get.pmoments.md)
  : Calculate probability-weighted moments (PWMs)
- [`get.quantile.samples()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/get.quantile.samples.md)
  : Extract posterior quantile samples from MCMC results
- [`get.regional.params()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/get.regional.params.md)
  : Get hyper parameters from the regional model and climate variables
- [`gev.mean()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/gev.mean.md)
  : Calculate expected value (mean) of GEV distribution
- [`gev.quantile()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/gev.quantile.md)
  : Calculate GEV quantile for given probabilities
- [`log(`*`<lik>`*`)`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/log.lik.md)
  : Calculate log-likelihood for original GEV parameters
- [`log(`*`<prior>`*`)`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/log.prior.md)
  : Calculate log-prior for a given GEV parameter set
- [`logprob()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/logprob.md)
  : Calculate logarithmic probability density (log-likelihood +
  log-prior)
- [`lower()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/lower.md)
  : Calculate lower 95% credible interval bound (2.5% quantile)
- [`model.loglik()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/model.loglik.md)
  : Calculate marginal model likelihood (evidence) using importance
  sampling —————
- [`model.loglik.indep()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/model.loglik.indep.md)
  : Calculate marginal model likelihood using independent normal
  approximations
- [`perform.analysis()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/perform.analysis.md)
  : Perform Bayesian flood frequency analysis using MCMC
- [`plot(`*`<curve>`*`)`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/plot.curve.md)
  : Plot Bayesian flood quantile curves using base R graphics
- [`quantile(`*`<summary>`*`)`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/quantile.summary.md)
  : Compute posterior summary statistics for given return periods
- [`reg.alpha()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/reg.alpha.md)
  : Transformation to alpha
- [`reg.ksi()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/reg.ksi.md)
  : Transformation to ksi
- [`reg.logmedian()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/reg.logmedian.md)
  : Transformation to log.index.flood
- [`sample.mcmc()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/sample.mcmc.md)
  : Perform MCMC sampling using Metropolis-Hastings with parallel
  tempering and adaptive random-walk
- [`sample.once()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/sample.once.md)
  : Perform a single Metropolis random-walk step with parallel tempering
- [`upper()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/upper.md)
  : Calculate upper 95% credible interval bound (97.5% quantile)
