
FROM rocker/r-ver:4.2.1

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('plumber', 'caret', 'dplyr', 'ggplot2'), repos='http://cran.us.r-project.org')"

# Copy the API script and model files into the Docker image
COPY api_model.R /app/api_model.R
COPY docs/random_forest.RData /app/random_forest.RData  

# Expose the port that the API will run on
EXPOSE 8000

# Set the working directory and start the plumber API
WORKDIR /app
CMD ["R", "-e", "pr <- plumber::plumb('api_model.R'); pr$run(host='0.0.0.0', port=8000)"]
