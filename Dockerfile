FROM rocker/verse
MAINTAINER Lauren Kanapka <lkanapka@email.unc.edu>
RUN R -e "install.packages('lubridate')"
RUN R -e "install.packages('kableExtra')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('MLmetrics')"