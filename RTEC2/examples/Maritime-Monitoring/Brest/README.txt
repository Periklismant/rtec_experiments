The maritime example for the area of Brest contains:

 The maritime patterns: 
   Maritime_Patterns.prolog
 
 A link to download the enriched/critical datasets of the original Brest dataset:
   data/dynamic/dataset_download.txt
 Note that the datasets have to be placed in the data/dynamic folder.
 
 A prolog file that loads all the necessary data:
   data/load.prolog
 
 A results folder, that's where the results will be printed
   data/results

 The areaIDs used in recognition in prolog format and csv format:
   data/static/areaIDs (prolog)
   data/static/converted (csv)
 
 The pattern thresholds:
   data/static/patternsParameters/thresholds.prolog
 
 A set of predicates used for static data
   data/static/staticDataPredicates.prolog

 Vessel static information such as speed per vessel type and vessel types:
   data/static/vesselInformation/typeSpeeds.prolog
   data/static/vesselInformation/vesselStaticInfo.prolog
   

EXECUTION INSTRUCTIONS: 
1. Set the AIS dataset as: 
	Brest/experiments/data/dynamic/preprocessed_dataset_RTEC_critical_nd.csv

2. Fix the execution parameters in /data/run.prolog

3. Load /data/run.prolog and type run.

