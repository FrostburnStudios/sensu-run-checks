# sensu-run-checks
A ruby script to execute sensu checks as if sensu was running them and display their output. Great for testing/debugging.

## Examples
Sadly you can't see the very helpful color highlighting in this preview. Trust me, it's gorgeous! Give it a whirl, it won't disappoint.

### Run a named check
```shell
[ root@server (:) ~ :) ] ./sensu_checks.rb check_ntp
No checks in /etc/sensu/conf.d/client.json... ignored
Running check_ntp...
  /etc/sensu/plugins/system/check-ntp.rb -w 100 -c 500
  CheckNTP OK
Done
No checks in /etc/sensu/conf.d/common.json... ignored
```

### Run a check script
```shell
[ root@server (:) ~ :) ] ./sensu_checks.rb /etc/sensu/plugins/system/check-ntp.rb -w 100 -c 500
Running check_ntp...
  /etc/sensu/plugins/system/check-ntp.rb -w 100 -c 500
  CheckNTP OK
Done
```

### Run all checks
```shell
[ root@server (:) ~ :) ] ./sensu_checks.rb
Running check_cpu...
  /etc/sensu/plugins/system/check-cpu.rb -w 80 -c 100
  CheckCPU TOTAL OK: total=1.5 user=0.0 nice=0.0 system=0.5 idle=98.5 iowait=1.0 irq=0.0 softirq=0.0 steal=0.0 guest=0.0
Done
Running check_load...
  /etc/sensu/plugins/system/check-load.rb -p true -w 3,2,1 -c 5,4,3
  CheckLoad OK: Load average: 0.13, 0.08, 0.07
Done
Running check_disk_fail...
  /etc/sensu/plugins/system/check-disk-fail.rb
  CheckDiskFail OK
Done
Running check_memcached_stats...
  /etc/sensu/plugins/memcached/check-memcached-stats.rb -h 192.168.1.35 -p 11211
  MemcachedStats OK: memcached stats protocol responded in a timely fashion
Done
Running check_ntp...
  /etc/sensu/plugins/system/check-ntp.rb -w 100 -c 500
ntpq: read: Connection refused
  CheckNTP UNKNOWN: NTP command Failed
Done
Running check_entropy...
  /etc/sensu/plugins/system/check-entropy.rb
  CheckEntropy OK
Done
No checks in /etc/sensu/conf.d/common.json... ignored
```
