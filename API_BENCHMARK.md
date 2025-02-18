```
$ docker-compose run --rm benchmark
This is ApacheBench, Version 2.3 <$Revision: 1826891 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking server (be patient)
Completed 10000 requests
Completed 20000 requests
Completed 30000 requests
Completed 40000 requests
Completed 50000 requests
Completed 60000 requests
Completed 70000 requests
Completed 80000 requests
Completed 90000 requests
Completed 100000 requests
Finished 100000 requests


Server Software:        WEBrick/1.9.1
Server Hostname:        server
Server Port:            3000

Document Path:          /api/robot/place
Document Length:        63 bytes

Concurrency Level:      200
Time taken for tests:   347.011 seconds
Complete requests:      100000
Failed requests:        0
Total transferred:      28900000 bytes
Total body sent:        18100000
HTML transferred:       6300000 bytes
Requests per second:    288.18 [#/sec] (mean)
Time per request:       694.023 [ms] (mean)
Time per request:       3.470 [ms] (mean, across all concurrent requests)
Transfer rate:          81.33 [Kbytes/sec] received
                        50.94 kb/s sent
                        132.27 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1  25.4      0    1037
Processing:    11  693 307.7    563    4764
Waiting:        4  692 307.7    562    4764
Total:         11  693 308.5    565    4764

Percentage of the requests served within a certain time (ms)
  50%    565
  66%    693
  75%    825
  80%    887
  90%   1094
  95%   1303
  98%   1618
  99%   1822
 100%   4764 (longest request)
```
