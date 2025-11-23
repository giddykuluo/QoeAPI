# Dockerfile for running the Plumber API on Render
FROM rocker/r-ver:4.3.1

RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >> /usr/local/lib/R/etc/Rprofile.site

# Install system deps required to compile some R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev libssl-dev libxml2-dev zlib1g-dev libsodium-dev build-essential && \
    rm -rf /var/lib/apt/lists/*

# Install R packages required
RUN R -e "install.packages(c('plumber','randomForest','jsonlite'))"

WORKDIR /app
COPY . /app

EXPOSE 8000

CMD ["R", "-e", "port <- as.integer(Sys.getenv('PORT', '8000')); pr <- plumber::plumb('api.R'); pr$run(host='0.0.0.0', port=port)"]
