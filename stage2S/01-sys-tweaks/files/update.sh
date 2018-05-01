cd /rpicluster/config
barsm="|||||-"
barsf="|||||"
last=0
output=`python -c 'from functions import *; print " ".join([item[0] for item in get_nodes()])'`
for i in ${output[@]}+1
do
    if[ i -eq ${output[@]} ]
    then
        i="rpicluster"
        last=1
    fi
    fab update -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running
    printf "\r[" + barsm*i + barsf*last + "]\e[K"
done