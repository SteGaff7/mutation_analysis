#!/bin/bash -l

# speficity number of nodes 
#SBATCH -N 1

# specify number of tasks/cores per node required
#SBATCH --ntasks-per-node 1

# specify the walltime e.g 20 mins
#SBATCH -t 48:00:00

# set to email at start,end and failed jobs
#SBATCH --mail-type=NONE
#SBATCH --mail-user=stephen.gaffney@ucdconnect.ie

# run from current directory
cd $SLURM_SUBMIT_DIR

pid=$1
vid=$2

major_dir="/home/people/12309511/scratch/major_mutation_results/${pid}/${vid}"
out_dir="/home/people/12309511/scratch/merged_major_maps/${pid}"
merged_map="${out_dir}/${pid}-${vid}-mergedMap.csv"

mkdir -p ${out_dir}
rm -f ${merged_map}

# Get number of mutants
num_mutants=$(tail -n1 ${major_dir}/mutants.log | cut -d':' -f1)
#num_mutants=$(cat ${major_dir}/mutants.log | wc -l)

# Set up merged map
echo "Mutant ID; Killing tests" >> ${merged_map}
for (( i = 1; i <= $num_mutants; i++ )); do
	echo "${i}," >> ${merged_map}
done

# Iterate through each kill map in major results for project-vid
for file in ${major_dir}/kill_maps/*; do
	if [[ $file == *-killMap.csv ]]; then

		test_name=$(echo "$file" | rev | cut -d'/' -f1 | rev)
		test_name=${test_name%-killMap.csv}

		# Read kill map, skipping header
		sed -e 1d $file | while read -r line; do
			
			mut=$(echo $line | cut -d"," -f2)
			sed -i '/'\^${mut}\,'/s/$/'${test_name}\,'/' ${merged_map}
		done
	fi
done

# Copy mutants log
cp ${major_dir}/mutants.log ${out_dir}/${pid}-${vid}-mutants.log
