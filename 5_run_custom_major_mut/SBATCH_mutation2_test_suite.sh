#!/bin/bash -l
#SBATCH --job-name=major_mutate

# speficity number of nodes 
#SBATCH -N 1

# specify number of tasks/cores per node required
#SBATCH --ntasks-per-node 3

# specify the walltime e.g 20 mins
#SBATCH -t 72:00:00

# set to email at start,end and failed jobs
#SBATCH --mail-type=NONE
#SBATCH --mail-user=stephen.gaffney@ucdconnect.ie

# run from current directory
cd $SLURM_SUBMIT_DIR

project="$1"
gen="$2"
seed="$3"
version="$4"

# Checkout project version temporarly to scratch space
tmp_dir=/home/people/12309511/scratch/temp_checkouts
defects4j checkout -p $project -v $version -w "${tmp_dir}/${project}_${version}_${gen}_${seed}"

# Switch to checkout as working directory
cd "${tmp_dir}/${project}_${version}_${gen}_${seed}"

# Compile project
defects4j compile

# Run d4j mutation2
(defects4j mutation2 -t testClass::testMethod -s /home/people/12309511/mutation_testing/cleaned_test_suites/$project/$gen/$seed/${project}-${version}-${gen}.${seed}.tar.bz2 && echo "${project}-${version}-${gen}.${seed}.tar.bz2" >> /home/people/12309511/logs/major_mutation/suites/completed_suites.log ) || echo "${project}-${version}-${gen}.${seed}.tar.bz2" >> /home/people/12309511/logs/major_mutation/suites/failed_mutation_suites.log

# Remove temporary checkout
rm -rf "${tmp_dir}/${project}_${version}_${gen}_${seed}"