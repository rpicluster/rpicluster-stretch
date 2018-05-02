#!/bin/bash
cd /rpicluster/config
action="Updating "
count=0
total=0
output=`python -c 'from functions import *; print " ".join([item[1] for item in get_nodes()])'`
output=(${output[@]} rpicluster)
for i in ${output[@]}
do
    total=$(( $total + 1))
done

for i in ${output[@]}
do
    white=$(($total-$count))
    python progress_bar.py $count $white $action $i
    count=$(( $count + 1 ))
    fab update -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running
done
action="Updating completed."
python progress_bar.py $count 0 $action
echo ""
