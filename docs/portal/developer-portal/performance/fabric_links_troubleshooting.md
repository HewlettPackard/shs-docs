
# Fabric Links Troubleshooting

All the fabric links (local and global) should be properly verified for their status. Any fabric links that are down can impact HSN performance.

* There should not be any link flaps
* Link flaps are typically caused by hardware errors/SerDes/cable faults
* Captured by Slingshot Drivers and notified by the Switch Service to Fabric Manager
* Fabric Manager produces updated routes based on the new topology
* New routes pushed to switches
* Excessive Link flaps can result in performance degradation
* Preamble for any performance tests - A stable fabric without link flaps
* Port Policies should match between the fabric ports

## Link Flaps

`show flaps` can be used to analyze any links flaps that can significantly impact the HSN performance.

* Flaps Ranked from 0-6
* Score 0 is good
* Score 6 is bad - Impacts performance (needs attention)

```screen
fm-1# show-flaps
STT diags log directory -  /root/resiliency_tests/stt_diags_logs/newtopo
Showing links with a flap score of 3 or greater
            xname A<->B            |total flaps A/B|time since last flap A/B |flap period A/B  |flap score A/B|combined score
-----------------------------------+---------------+-------------------------+-----------------+--------------+--------------
 x3000c0r41j13p0<->x3001c0r41j31p0 |0     /     0  |   0:16:00 / 0:16:00     |0:32:00 / 0:32:00|    6/6       |    12
 x3000c0r41j11p0<->x3000c0r42j18p0 |2     /     0  |   20:59:47 / 20:59:46   |0:02:10 / 0:02:10|    2/2       |    4


(STT) show links health

dgrheadshellstat  :  Start time: 03/25/2021, 11:24:27 , End time: 03/25/2021, 11:24:28
check-fabric  :  Start time: 03/25/2021, 11:24:27 , End time: 03/25/2021, 11:24:29
check-switches  :  Start time: 03/25/2021, 11:24:27 , End time: 03/25/2021, 11:24:31
dgrlinkstat  :  Start time: 03/25/2021, 11:24:27 , End time: 03/25/2021, 11:24:33

Displaying the Downed Links and required diagnostics action for each link:
Querying downed links' link partners...

+------+-------------------------------------------+---------+--------+-------------+----------+------------+----------+----------------+------------+
| type |rosprt xname (pport)<->rosprt xname (pport)|rosswinfo|sC firmW|sw_medtype-pw|hdsh state|lp rosswinfo|lp sCfirmW|lp sw_medtype-pw|lphdsh state|
+------+-------------------------------------------+---------+--------+-------------+----------+------------+----------+----------------+------------+
|Fabric|x3000c0r41j13p0 (28)<->x3001c0r41j31p0 (49)|None S L |1.5.181|electrical-N/A|  ssh fail|   None S L |1.5.abray | electrical-N/A|  ssh fail   |
+------+-------------------------------------------+---------+-------+--------------+----------+------------+----------+----------------+------------+

Note that the command output has been truncated for readability.
```
