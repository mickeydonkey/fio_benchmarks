import os
import re
with open("polling-1-1-100000.json") as fd:
    aa = fd.read()
    print(aa)
    P99_lat = re.findall("\|*99.0th=\[(\d+)\]", aa)
    assert len(P99_lat) = 1
    P99_lat = P99_lat[0]

    cpu_utilization = re.findall("system: (\d+.\d+)%", aa)
    assert len(cpu_utilization) = 1
    cpu_utilization = cpu_utilization[0]


    

    actual_iops = re.findall("iops.+avg=(\d+)", aa)
    assert len(actual_iops) = 1
    actual_iops = actual_iops[0]