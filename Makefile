.PHONY: clean

clean:
	rm derived_data/*
  
derived_data/hurricane.csv:\
 source_data/hurdat2-1851-2019-052520.csv\
 tidy_data.R
	Rscript tidy_data.R