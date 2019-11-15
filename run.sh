#!/bin/bash

run() {
    if [[ ! -f $config ]]; then
        echo "No configuration file at the give path."
        exit -1
    fi
    fio $config > sample.data
    cat sample.data | grep -e "IOPS" -e "lat" -e "99.00th"
    rm -f sample.data
}

run_with_perf() {
    sudo perf stat -e context-switches fio configs/ssd-test.fio > sample.data
    cat sample.data | grep -e "IOPS" -e "lat" -e "99.00th"
    rm -f sample.data
}

display_help() {
    echo "Usage: $0 {option config_file}" >&2
    echo ""
    echo "option: no_perf|perf"
    echo "no_perf: Runs fio for the given configuration file."
    echo "perf: Runs fio for the given configuration file and also runs perf."
    exit 1
}

if [ $# -ne 2 ]; then
    display_help
    exit -1
fi

config=$2

case "$1" in
    no_perf)
        run
        ;;
    perf)
        run_with_perf
        ;;
    *)
        display_help
esac
