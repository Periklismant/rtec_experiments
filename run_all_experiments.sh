#!/bin/bash

cd scripts
./run_naive_comparison.sh
./run_voting_fragment.sh
./run_immune_response.sh
./run_phage_infection.sh
./run_netbill_fragment_small.sh
./run_netbill_fragment_large.sh
./run_netbill_big.sh
./run_voting_big.sh
./run_maritime_no_fi.sh
./run_maritime_fi_only.sh
./run_maritime_europe.sh
cd ..
