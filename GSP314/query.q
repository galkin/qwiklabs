fetch gce_instance
| metric 'compute.googleapis.com/instance/cpu/utilization'
| filter (metric.instance_name == 'kraken-admin')
| group_by 1m, [value_utilization_mean: mean(value.utilization)]
| every 1m
| condition val() > 0.5 '10^2.%'