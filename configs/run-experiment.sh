#!/bin/bash

SCRIPTPATH="$(cd "$(dirname "$0")"; pwd -P)"
cd $SCRIPTPATH

FIO_FILE="fixed-rate-submission.fio"

PROCS=(1) # 2 3 4 5 6) # numjobs
IO_DEPTH=(1 2 4 6 8 10)
IOPS=(100000 200000 300000 400000 500000 600000 700000)
MODES=(polling blocking)

for MODE in ${MODES[@]}; do
	for IOD in ${IO_DEPTH[@]}; do
		for P in ${PROCS[@]}; do
			for IOP in ${IOPS[@]}; do
				results=$MODE-$IOD-$P-$IOP.json
				echo "Running $DNAME with $IOD iodepth, $P procs"
				if [[ -f "$results" ]]; then
				  echo $results already exists. Skipping.
				  continue
				fi
				
				if [[ $MODE == 'polling' ]]; then
					sed -i "s/sqthread_poll=[0-1]/sqthread_poll=1/g" $FIO_FILE
				fi

				if [[ $MODE == 'blocking' ]]; then
					sed -i "s/sqthread_poll=[0-1]/sqthread_poll=0/g" $FIO_FILE
				fi

				rate=$(( $IOP/$P ))
				echo $rate

				sed -i "s/iodepth=[0-9]*/iodepth=$IOD/g" $FIO_FILE
				sed -i "s/numjobs=[0-9]*/numjobs=$P/g" $FIO_FILE
				sed -i "s/nrfiles=[0-9]*/nrfiles=$P/g" $FIO_FILE
				sed -i "s/rate_iops=[0-9]*/rate_iops=$rate/g" $FIO_FILE

			        sudo fio $FIO_FILE --idle-prof=percpu > $results  2>&1
			done
		done
		wait
	done
done
