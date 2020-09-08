FROM rocker/verse
MAINTAINER Lauren Kanapka <lkanapka@email.unc.edu>
RUN R -e "install.packages('lubridate')"