#!/bin/bash -i

sql1='SELECT COUNT(*) FROM job'
sql2='SELECT ROUND(SUM(runtime_msec/1000)/3600/24,1) FROM job'
sql3='SELECT COUNT(*) FROM worker'
sql4='SELECT ROUND(SUM(TIMESTAMPDIFF(SECOND, when_born, when_died))/3600/24,1) FROM worker'
sql5='SELECT ROUND((TIMESTAMPDIFF(SECOND, MIN(min_when_submitted), MAX(max_when_died))-SUM(g))/3600/24,1) FROM (SELECT GREATEST(TIMESTAMPDIFF(SECOND, MAX(w2.when_died), w1.when_submitted),0) AS g, MIN(w1.when_submitted) AS min_when_submitted, MAX(w1.when_died) AS max_when_died FROM worker w1 JOIN worker w2 ON w2.worker_id < w1.worker_id AND w2.when_submitted < w1.when_submitted GROUP BY w1.when_submitted) _t'

while read -r server dbname
do
    if $server $dbname -e 'SELECT 1 FROM job LIMIT 1' > /dev/null 2> /dev/null
    then
        #sql6="SELECT '$server', '$dbname', logic_name, mem_megs, swap_megs, submission_cmd_args, name FROM worker JOIN worker_resource_usage USING (worker_id) JOIN role USING (worker_id) JOIN (SELECT MAX(role_id) AS role_id FROM role GROUP BY worker_id) _t USING (role_id) JOIN resource_description USING (meadow_type, resource_class_id) JOIN resource_class USING (resource_class_id) JOIN analysis_base USING (analysis_id) LEFT JOIN dataflow_rule ON analysis_id = from_analysis_id AND branch_code = -1 WHERE cause_of_death = 'MEMLIMIT' AND dataflow_rule_id IS NULL"
        #$server $dbname -ANsqe "$sql6"
        (echo $server; echo $dbname; $server $dbname -ANsqe "$sql1; $sql2; $sql3; $sql4; $sql5") | xargs echo | sed 's/ /\t/g'
    fi
done
#| awk '{n++;s3+=$3;s4+=$4;s5+=$5;s6+=$6;s7+=$7} END {print n, "databases"; print s3, "jobs"; print s5, "workers"; print s6*24*3600/s3, "seconds per job"; print s3/s5, "jobs per worker"; print s6*24*60/s5, "minutes per worker"; print s6, "CPU days"; print s6/365.242, "CPU years"; print s7, "days (summed wall-time)"; print s7/(365.242/12), "months (summed wall-time)"; print s6/s7, "average capacity"}'

