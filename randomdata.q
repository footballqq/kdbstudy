/ Generate some random computer statistics (cpu usage only)
/ You can modify n (number of unique computers), timerange (how long the data is for)
/ freq (how often a computer publishes a statistic) and calls (the number of logged calls)
n:1000; timerange:5D; freq:0D00:01; calls:3000;
depts:`finance`packing`logistics`management`hoopjumping`trading`telesales; startcpu:(til n)!25+n?20; fcn:n*fc:`long$timerange%freq;

computer:([]time:(-0D00:00:10 + fcn?0D00:00:20)+fcn#(.z.p - timerange)+freq*til fc; id:raze fc#'key startcpu)
computer:update `g#id from `time xasc update cpu:{100&3|startcpu[first x]+sums(count x)?-2 -1 -1 0 0 1 1 2}[id] by id from computer

/ And generate some random logged calls
calls:([] time:(.z.p - timerange)+asc calls?timerange; id:calls?key startcpu; severity:calls?1 2 3)

/ create a lookup table of computer information
computerlookup:([id:key startcpu] dept:n?depts; os:n?`win7`win8`osx`vista)

select from computer where cpu = '33
computerlookup
calls
computer

select mxc:max cpu,mnc:min cpu,avc:avg cpu by id from computer  
select mxc:max cpu,mnc:min cpu,avc:avg cpu by id,time.date from computer                                                                                                          
select mxc:max cpu,mnc:min cpu,avc:avg cpu by id,0D01:00:00.0 xbar time from computer 


timeofday:{`0earlymorn`1midmorn`2lunch`3afternoon`4evening 00:00 07:00 12:00 13:30 17:00 bin x}
select mxc:max cpu,mnc:min cpu,avc:avg cpu by id,time.date,tod:timeofday[time.minute] from computer                                                                               
select avc:sum[cpu]%sum samplecount by tod from select sum cpu,samplecount:count cpu by time.date,tod:timeofday[time.minute] from computer                                      

calls lj computerlookup
select callcount:count i by severity,dept from calls lj computerlookup 
aj[`id`time;calls;computer]