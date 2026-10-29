# Read Sildre/Hydra time series, aggregate to daily values, extract AMS, save results, and optionally plot Leser en timesopplost eller dognopplost Sildre/Hydra_tidsserie, konverterer verdier, aggregerer til dognmiddel (og dognmaksimum hvis timesopplost), beregner aarlige maksimumsverdier (AMS), lagrer AMS_seriene som en_kolonne tekstfiler, og kan valgfritt generere plott. Hvis input allerede er dognopplost (dvs. ingen tidssteg \< 24 timer), beregnes kun dognmiddel og AMS for denne serien, og dognmaks_grenen utelates.

Read Sildre/Hydra time series, aggregate to daily values, extract AMS,
save results, and optionally plot Leser en timesopplost eller
dognopplost Sildre/Hydra_tidsserie, konverterer verdier, aggregerer til
dognmiddel (og dognmaksimum hvis timesopplost), beregner aarlige
maksimumsverdier (AMS), lagrer AMS_seriene som en_kolonne tekstfiler, og
kan valgfritt generere plott. Hvis input allerede er dognopplost (dvs.
ingen tidssteg \< 24 timer), beregnes kun dognmiddel og AMS for denne
serien, og dognmaks_grenen utelates.

## Usage

``` r
fx.sildre.timeseries.to.ams(
  file,
  sep = ";",
  ams.qdogn.txt,
  ams.qmom.txt,
  plot = TRUE,
  title = "AMS SILDRE",
  fontsize = 12,
  start_year = NULL,
  end_year = 2025
)
```

## Arguments

- file:

  Filsti til Sildre/Hydra tidsseriefilen.

- sep:

  Feltseparator i filen (default `";"`).

- ams.qdogn.txt:

  Filsti for lagring av AMS basert paa dognmiddel.

- ams.qmom.txt:

  Filsti for lagring av AMS basert paa dognmaksimum (kun hvis
  timesopplost input).

- plot:

  Logical. Hvis `TRUE`, inkluderes ggplot_objekter i returstrukturen.

- title:

  Tittel paa plott/tabeller (default = "AMS SILDRE").

- fontsize:

  Skriftstorrelse for tabell (default = 12).

- start_year:

  NULL eller et tall som angir startaar (default = NULL, bruker forste
  aar i data).

- end_year:

  Tall som angir sluttaar (default = 2025, NULL bruker siste aar i
  data).

## Value

En liste med en eller to hovedkomponenter:

- `daily_mean`:

  Liste med `ams`, `plot`, og `DT`.

- `daily_max`:

  Kun hvis timesopplost input: liste med `ams`, `plot`, og `DT`.
