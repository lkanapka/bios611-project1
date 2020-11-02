.PHONY: clean storms_shiny

clean:
	rm -f derived_data/*.csv
	rm -f figures/*.png
	rm -f fragments/*.Rmd 
	rm -f report.pdf
	
storms_shiny:\
 derived_data/tracks.csv\
 derived_data/storms.csv
	Rscript r_code/rshiny.R ${PORT}
	
report.pdf:\
 report.Rmd\
 derived_data/decade_summary.csv\
 derived_data/pValues.csv\
 fragments/descriptive_dataA.fragment.Rmd\
 fragments/descriptive_dataB.fragment.Rmd\
 fragments/frequency.fragment.Rmd\
 fragments/intensity.fragment.Rmd
	Rscript -e 'rmarkdown::render("report.Rmd",output_format="pdf_document")'
 
derived_data/storms.csv derived_data/tracks.csv:\
 source_data/hurdat2-1851-2019-052520.csv\
 r_code/tidy_data.R
	Rscript r_code/tidy_data.R
	
derived_data/decade_summary.csv:\
 derived_data/storms.csv\
 r_code/descriptive_data.R
	Rscript r_code/descriptive_data.R
	
derived_data/pValues.csv:\
 derived_data/storms.csv\
 r_code/linear_model.R
		Rscript r_code/linear_model.R
	
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

fragments/intensity.fragment.Rmd:\
 derived_data/storms.csv\
 figures/cyclone_count.png\
 r_code/intensity_over_time.R
	Rscript r_code/intensity_over_time.R
	
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