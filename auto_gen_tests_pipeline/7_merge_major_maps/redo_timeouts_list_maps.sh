#!/bin/bash

while read -r line; do
	pid=$(echo $line | cut -d"-" -f1)
	vid=$(echo $line | cut -d"-" -f2)
	
	job_name="${pid}-${vid}-merge_major_maps_redo_TOs"
	#out_dir="/home/people/12309511/logging/7_merge_major_maps/out/${job_name}"

	sbatch -J ${job_name} -o /dev/null -e /dev/null ./SBATCH_list_merge_maps.sh $pid $vid

done < timeout_merges.log
