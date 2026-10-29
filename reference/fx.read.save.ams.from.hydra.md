# Read AMS data from a Hydra export, save as one_column text, and optionally plot

Leser dognverdier fra en Hydra_eksport (AMS), rydder formatet,
konverterer dato og verdi til riktig R_format, lagrer verdiene som en
en_kolonne tekstfil, og kan valgfritt plotte dataserien.

## Usage

``` r
fx.read.save.ams.from.hydra(
  ams.hydra.txt,
  ams.txt,
  plot = TRUE,
  title = "HYDRA2"
)
```

## Arguments

- ams.hydra.txt:

  Filsti til Hydra_eksporten (tekstfil med dognverdier).

- ams.txt:

  Filsti for lagring av en_kolonne AMS_verdier.

- plot:

  Logical. Hvis `TRUE`, returneres ogsaa et ggplot_objekt (default =
  TRUE).

- title:

  Tittel paa plottet/tabellen (default = "HYDRA2").

## Value

En liste med `ams` (data.frame), `DT` og eventuelt `plot`.
