#!/bin/bash

projects=(
        Chart
        Cli
        Closure
        Codec
        Collections
        Compress
        Csv
        Gson
        JacksonCore
        JacksonDatabind
        JacksonXml
        Jsoup
        JxPath
        Lang
        Math
        Mockito
        Time
)


projects_dir="/home/people/12309511/defects4j/framework/projects"

# Iterate through projects in framework/projects folder
for project in "${projects[@]}"; do
	p_dir="${projects_dir}/${project}"
	
        if [ -d "$p_dir" ]; then

                #Iterate through each active bug ID
                bugs_file="${p_dir}/commit-db"
		
		proj_log_dir=/home/people/12309511/logging/1_gen_test_suites/${project}
		mkdir -p "${proj_log_dir}/outputs"
		mkdir -p "${proj_log_dir}/errors"

                while read -r line || [[ -n $line ]]; do
                        
                        bug_id=$(echo "$line" | cut -d, -f1)
                        
                        #Loop how many different versions we need

			for seed in {1..5..1}; do
				job_name=${project}_${bug_id}_evosuite_${seed}
                        	sbatch -J ${job_name}_gen -o "${proj_log_dir}/outputs/${job_name}.out" -e "${proj_log_dir}/errors/${job_name}.error" SBATCH_gen_test_suite.sh evosuite $project $bug_id $seed
				job_name=${project}_${bug_id}_randoop_${seed}
				sbatch -J ${job_name}_gen -o "${proj_log_dir}/outputs/${job_name}.out" -e "${proj_log_dir}/errors/${job_name}.error" SBATCH_gen_test_suite.sh randoop $project $bug_id $seed
			done
                done < "$bugs_file"
        fi
done
