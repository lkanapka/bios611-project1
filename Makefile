.PHONY: clean

clean:
	rm derived_data/*
  
derived_data/storms.csv derived_data/tracks.csv:\
 source_data/hurdat2-1851-2019-052520.csv\
 tidy_data.R
	Rscript tidy_data.R
	
figures/cyclone_count.png figures/storm_count.png:\
 derived_data/storms.csv\
 analysis.R
	Rscript analysis.R
	
assets/cyclone_count.png: figures/cyclone_count.png
	cp figures/cyclone_count.png assets/cyclone_count.png
	
assets/storm_count.png: figures/storm_count.png
	cp figures/storm_count.png assets/storm_count.png