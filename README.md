Hurricane Data Analysis
=======================

Analysis
--------
This repo will contain an analysis of hurricane data.

Usage
-----
You'll need Docker and the ability to run Docker as your current user.

This Docker container is based on rocker/verse. To run rstudio server:

    > docker run -v `pwd`:/home/rstudio -p 8787:8787\
      -e PASSWORD=analysis -t project1-env
    
Then connect to the machine on port 8787.