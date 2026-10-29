# Plot AMS_data som stolpediagram

Lager et tydelig stolpediagram av AMS_data (dato og verdi), med aarlige
datoetiketter, roterte aksetekster og uten luft mellom y = 0 og x_aksen.

## Usage

``` r
fx.plot.df.ams(ams, fontsize = 12, title = "", label_offset = 0.05)
```

## Arguments

- ams:

  En data.frame med kolonnene `date` (Date) og `value` (numeric).

- fontsize:

  Tall som angir skriftstorrelse for aksetekst (default = 12).

- title:

  Tekst/streng som legges til i tittelen (default = "").

- label_offset:

  Prosentvis forskyvning av tekstetiketter over soylene (default =
  0.05).

## Value

En ggplot_figur.
