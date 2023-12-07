# edit here the three arguments of the script as follows:
# first argument: ground truth file; second argument: predictions file; third argument: f1-score

yap -l f1-score-computation.prolog -g "compare_all_events,halt." -- ../../examples/caviar/experiments/execution\ log\ files/results_ground_truth.txt ../../examples/caviar/experiments/execution\ log\ files/log-YAP-csv-caviar-100K-100K-recognised-intervals.txt ../../examples/caviar/experiments/execution\ log\ files/f1-score.csv
