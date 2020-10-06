.PHONY: clean

clean:
	rm -f derived_data/*.csv
	rm -f figures/*.png
  
derived_data/storms.csv derived_data/tracks.csv:\
 source_data/hurdat2-1851-2019-052520.csv\
 r_code/tidy_data.R
	Rscript r_code/tidy_data.R
	
derived_data/decade_summary.csv:\
 derived_data/storms.csv\
 r_code/descriptive_data.R
	Rscript r_code/descriptive_data.R
	
fragments/descriptive_dataA.fragment.Rmd:\
 derived_data/storms.csv\
 r_code/descriptive_data.R
	Rscript r_code/descriptive_data.R
	
fragments/descriptive_dataB.fragment.Rmd:\
 derived_data/storms.csv\
 figures/wind_boxplot.png\
 r_code/descriptive_data.R
	Rscript r_code/descriptive_data.R

fragments/frequency.fragment.Rmd:\
 derived_data/storms.csv\
 figures/storm_count_avg.png\
 r_code/frequency_over_time.R
	Rscript r_code/frequency_over_time.R

figures/wind_boxplot.png:\
 derived_data/storms.csv\
 r_code/descriptive_data.R
	Rscript r_code/descriptive_data.R
	
figures/storm_count.png:\
 derived_data/storms.csv\
 r_code/frequency_over_time.R
	Rscript r_code/frequency_over_time.R
	
figures/storm_count_avg.png:\
 derived_data/storms.csv\
 r_code/frequency_over_time.R
	Rscript r_code/frequency_over_time.R

figures/cyclone_count.png:\
 derived_data/storms.csv\
 r_code/intensity_over_time.R
	Rscript r_code/intensity_over_time.R
	
assets/cyclone_count.png: figures/cyclone_count.png
	cp figures/cyclone_count.png assets/cyclone_count.png
	
assets/storm_count.png: figures/storm_count.png
	cp figures/storm_count.png assets/storm_count.png