.PHONY: clean

clean:
	rm -f derived_data/*.csv
	rm -f figures/*.png
  
derived_data/storms.csv derived_data/tracks.csv:\
 source_data/hurdat2-1851-2019-052520.csv\
 r_code/tidy_data.R
	Rscript r_code/tidy_data.R
	
figures/cyclone_count.png figures/storm_count.png:\
 derived_data/storms.csv\
 r_code/figures_over_time.R
	Rscript r_code/figures_over_time.R
	
assets/cyclone_count.png: figures/cyclone_count.png
	cp figures/cyclone_count.png assets/cyclone_count.png
	
assets/storm_count.png: figures/storm_count.png
	cp figures/storm_count.png assets/storm_count.png