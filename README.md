# Supplementary Material

This repository contains a technical appendix and the scripts for reproducing the experiments presented in the paper "Reasoning over Events with Delayed Effects", which is currently under review.

The technical appendix of the paper can be found in: [technical_appendix.pdf](technical_appendix.pdf).

## Reproducing our Experiments

We provide the code for reproducing our experiments in the form of a Docker image.

First, clone this repository and move to its root directory:

	git clone https://github.com/Periklismant/rtec_experiments
	cd rtec_experiments

The easiest way to reproduce our experiments is through a Docker image. Install Docker by following the instruction on the [official website](https://docs.docker.com/engine/install/), and then follow these steps:

	sudo docker build -t experiments . # Build a Docker image named experiments based on Dockerfile.
	sudo docker run -it experiments # Run the Docker image in iteractive mode.
	./run_all_experiments.sh # Execute the script the runs all experiments.

In order to run a specific set of experiments of the paper, you may run the corresponding execution script as follows:
	
	cd scripts
	ls # See the available scripts.
	./run_script_of_your_choice.sh


## Organisation

- /systems: Source code and/or executables for the systems used in the experimental comparison.
- /datasets: The datasets used in the experiments. Note that some of the datasets are *not* packed with the repository, due to their size. For these datasets, we provide external download links (see, e.g., datasets/maritime/brest/download_dataset.log). The maritime dataset including vessels sailing in all European seas is not publicly available.
- /logs: Log files generated by system executions.
- /scripts: Bash scripts for reproducing the experiments in the paper. We provide the following scripts:
	* run_naive_comparison.sh: Runs RTEC-> and RTEC->-naive on example event narrative for voting and netbill, with an increasing window size (see Figure 3 of the paper).
	* run_voting_fragment.sh: Given a small fragment of the event description of voting, we run RTEC->, s(CASP) and jRECfi on small event narratives of increasing size (see Figure 4 (left) of the paper).
	* run_feedback_loops.sh: Runs RTEC-> and GKL-EC on the immune response and phage infection feedback loops along timelines of increasing size (see Figure 4 (middle and right)).
	* run_quote_small.sh: Given the quote definition (without fi) of NetBill, we run RTEC->, s(CASP), Ticker, Fusemate, Logica, jRECfi and jRECrbt on small event narratives of increasing size (see Figure 5 (left)).
	* run_quote_large.sh: Given the aforementioned quote definition, we run RTEC-> and jRECrby on event narratives including thousands of events and of increasing size (see Figure 5 (right)).
	* run_maritime_no_fi.sh: Given an event description of the maritime domain without fi facts, we run RTEC-> and RTEC on the dataset of Brest, using windows of increasing size (see Figure 6 (left)).
	* run_maritime_with_fi.sh: Given an event description of the maritime domain with fi facts, we run RTEC-> on the dataset of Brest, using windows of increasing size (see Figure 6 (middle)).
