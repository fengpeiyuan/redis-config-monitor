#!/usr/bin/env python
import redis
import httplib,urllib

rdshost="10.209.32.38"
rdsport="10520"
rdsdomain="w10520.wdds.redis.com"
httphost="localhost"
httpport=8086

##input
rds=redis.Redis(host=rdshost,port=rdsport,db=0)
rds_config=rds.config_get('*')
params='i'+rdsport+',host='+rdshost+',role=m,domain='+rdsdomain+' '
for key in rds_config: 
  print "%s: %s" % (key, rds_config[key])
  params=params+key+"=\""+rds_config[key]+"\","
#print "%s" % params

##output
try:
  headers={"Content-type":"application/x-www-form-urlencoded","Accept":"text/plain"}
  httpcli=httplib.HTTPConnection(httphost,httpport, timeout=30)
  httpcli.request("POST", "/write?db=redis_config_monitor", params[:-1], headers)
  response=httpcli.getresponse()
  print response.status
  print response.reason
except Exception, e:
    print e
finally:
    if httpcli:
        httpcli.close()
