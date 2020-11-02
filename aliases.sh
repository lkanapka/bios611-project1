start_shiny(){
    docker run -p $2:$2 \
 -v `pwd`:/home/rstudio \
 -e PASSWORD=analysis \
 -it project1-env sudo -H -u rstudio /bin/bash -c "cd ~/; PORT=$2 make $1"
}