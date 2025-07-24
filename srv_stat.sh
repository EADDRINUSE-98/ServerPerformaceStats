#!/bin/bash

#Print CPU Info
cpuinfo () {
  awk '
    NR ==1 {
      total_cpu_time = $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10 + $11
      total_non_idle_time = total_cpu_time - $5
      total_cpu_usage_in_percentage = (total_non_idle_time / total_cpu_time) * 100
      print "TOTAL CPU USAGE:", total_cpu_usage_in_percentage"%"
    }
  ' /proc/stat
}

# Print Memory Info
memoryinfo () {
  total_mem=$(grep "MemTotal" /proc/meminfo | awk '{print $2}' )
  available_mem=$(grep "MemAvailable" /proc/meminfo | awk '{print $2}' )
  occupied_mem=$(( total_mem - available_mem ))
  awk -v t_mem="$total_mem" -v occu_mem="$occupied_mem" '
    BEGIN {
      occupied_mem_in_percentage = (occu_mem / t_mem) * 100
      print "TOTAL MEMROY USAGE:", occupied_mem_in_percentage"%"
    }
  '
}

diskinfo () {
  df --block-size=KB --local | grep "/home" | awk '
    {
      disk_usage = ($3 / $2) * 100 
      print "TOTAL DISK USAGE:", disk_usage"%"
    }
  '
}

# Print Top 5 Processes by CPU Usage
ps_by_cpu () {
  ps_list=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6)
  printf "TOP 5 PROCESSES BY CPU\:\n"
  echo "$ps_list"
}

# Print Top 5 Processes by Memory Usage
ps_by_mem () {
  ps_list=$(ps -eo pid,comm,%mem --sort=-%mem | head -n 6)
  printf "TOP 5 PROCESSES BY MEMORY\:\n"
  echo "$ps_list"
}

cpuinfo
memoryinfo
diskinfo
ps_by_cpu
ps_by_mem
