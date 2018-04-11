output=`python -c 'from functions import *; print " ".join([item[0] for item in get_nodes()])'`
for i in ${output[@]}
do
    fab update -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running
done

