## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE, 
  message = FALSE,
  fig.align = "center",
  out.width = "90%",
  fig.width = 7,
  fig.height = 5
)

## ---- echo=F------------------------------------------------------------------
library(tidyverse)
library(modeltime)
modeltime_forecast_tbl <- read_rds("modeltime_forecast_tbl.rds")

modeltime_forecast_tbl %>%
  plot_modeltime_forecast(
    .facet_ncol   = 2, 
    .facet_scales = "free",
    .interactive  = FALSE
  )

## ----setup--------------------------------------------------------------------
library(modeltime.gluonts)
library(tidymodels)
library(tidyverse)
library(timetk)

## ---- eval=F------------------------------------------------------------------
#  install_gluonts()

## -----------------------------------------------------------------------------
data <- m4_hourly %>%
  select(id, date, value) %>%
  group_by(id) %>%
  mutate(value = standardize_vec(value)) %>%
  ungroup()

data

## -----------------------------------------------------------------------------
HORIZON <- 24*7

new_data <- data %>%
  group_by(id) %>%
  future_frame(.length_out = HORIZON) %>%
  ungroup()

new_data

## ---- eval = FALSE------------------------------------------------------------
#  model_fit_nbeats_ensemble <- nbeats(
#    id                    = "id",
#    freq                  = "H",
#    prediction_length     = HORIZON,
#    lookback_length       = c(HORIZON, 4*HORIZON),
#    epochs                = 5,
#    num_batches_per_epoch = 15,
#    batch_size            = 1
#  ) %>%
#    set_engine("gluonts_nbeats_ensemble") %>%
#    fit(value ~ date + id, data)

## ---- eval=F------------------------------------------------------------------
#  model_fit_nbeats_ensemble

## ---- echo=F------------------------------------------------------------------
knitr::include_graphics("nbeats_model.jpg")

## ---- eval=F------------------------------------------------------------------
#  modeltime_forecast_tbl <- modeltime_table(
#    model_fit_nbeats_ensemble
#  ) %>%
#    modeltime_forecast(
#      new_data    = new_data,
#      actual_data = data,
#      keep_data   = TRUE
#    ) %>%
#    group_by(id)

## -----------------------------------------------------------------------------
modeltime_forecast_tbl %>%
  plot_modeltime_forecast(
    .conf_interval_show = FALSE, 
    .facet_ncol         = 2, 
    .facet_scales       = "free",
    .interactive        = FALSE
  )

## ---- eval = FALSE------------------------------------------------------------
#  model_fit_nbeats_ensemble %>%
#    save_gluonts_model(path = "nbeats_ensemble_model", overwrite = TRUE)

## ---- eval=FALSE--------------------------------------------------------------
#  model_fit_nbeats_ensemble <- load_gluonts_model("nbeats_ensemble_model")

