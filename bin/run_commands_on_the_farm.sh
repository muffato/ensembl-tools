#!/bin/bash

[ $# -lt 2 -o $# -gt 3 ] && { echo "Usage: $0 mysql-server command_file [capacity]"; exit 1; }

server="$1"
cmd_file=$(realpath "$2")
cmd_name=$(basename "$cmd_file")
timestamp="$(date '+%Y-%m-%d_%H-%M-%S')"
pipeline_name="cmd_${cmd_name}_${timestamp}"
pipeline_url="$("$server" details url "$USER_$pipeline_name")"
capacity=${3:-5}

module unload hive
module load hive
init_pipeline.pl Bio::EnsEMBL::Hive::Examples::Factories::PipeConfig::RunListOfCommandsOnFarm_conf -capacity $capacity -inputfile "$cmd_file" -pipeline_url "$pipeline_url"
runWorker.pl -url "$pipeline_url" -job_id 1

