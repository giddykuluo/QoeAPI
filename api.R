# Load packages
library(plumber)
library(randomForest)  # needed by the saved RF model

# ---- API metadata (shows in Swagger) ----
#' @apiTitle QoE Prediction API
#' @apiDescription Predict QoE from network metrics

# ---- CORS so browsers, phones, Shiny can call this ----
#' @filter cors
function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods","GET, POST, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers","Content-Type, Authorization")
  if (req$REQUEST_METHOD == "OPTIONS") {
    return(PlumberResponse$new(status = 200))
  }
  forward()
}

# ---- Load trained model ----
best_model <- readRDS("best_model.rds")

# ---- Small validator ----
validate_input <- function(x, name, min, max) {
  if (is.null(x) || is.na(as.numeric(x))) stop(paste(name, "must be numeric"))
  x <- as.numeric(x)
  if (x < min || x > max) stop(paste(name, "out of range", min, "-", max))
  x
}

# ---- /predict endpoint ----
#' Predict QoE
#'
#' @param throughput:double Throughput (Mbps)
#' @param delay:double Delay (ms)
#' @param jitter:double Jitter (ms)
#' @param loss:double Packet loss (%)
#' @get /predict
function(throughput, delay, jitter, loss) {
  t <- validate_input(throughput, "throughput", 0, 1000)
  d <- validate_input(delay, "delay", 0, 5000)
  j <- validate_input(jitter, "jitter", 0, 1000)
  l <- validate_input(loss, "loss", 0, 100)
  
  newdata <- data.frame(
    Throughput_Mbps = t,
    Delay_ms        = d,
    Jitter_ms       = j,
    Packet_Loss_Pct = l
  )
  
  pred <- predict(best_model, newdata = newdata)
  
  list(
    input = as.list(newdata),
    prediction = as.character(pred)
  )
}

