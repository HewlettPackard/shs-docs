# Port Configuration

**Port Policies**

Fabric Manager commands and Slingshot Topology Tools can be used in combination to analyze verify the health of fabric any port policy mismatch that can cause fabric links to be down

The example below illustrates analyzing fabric links are down.

1. fmn-show-status is used to verify any links that are down.
2. There are two fabric links which are shown as down and this required further analysis.
3. The fabric policy is different for the port x3000c0r41j13p0 and x3001c0r41j31p0
4. The two ports that form the link has difference in the port policies as shown the fmctl command
5. The port policies have difference in the autoneg value causing the link to be down
6. STT show fabric show the two fabric ports that are "false" indicating problems
7. STT show links also shows the Fabric Link marked as "Downed
8. Port policy mismatch is rectified and port is  x3001c0r41j31p0 is updated with the correct port policy
9. All the links are online as shown by fmn-show-status.
10. cx6-port-policy  is created for this configuration as an example for illustration here.

**Note: Port policies are created based on the site specific configurations.
**

```screen
fm-1# fmn-show-status --details
```


```bash
Edge: 127 / 128
Fabric: 46 / 48
Ports Reported: 175 / 176
Fully Synchronized Switches: 4 / 4

Switches with Incomplete Configuration Synchronization Requiring Review:

Downed links:
Edge: x3001c0r42j15p1
Fabric: x3000c0r41j13p0
Fabric: x3001c0r41j31p0
```

```screen
fm-1# fmctl get ports/x3000c0r41j13p0

+------------------------------+----------------------------------------+
|             KEY              |                 VALUE                  |
+------------------------------+----------------------------------------+
| conn_port                    | x3000c0r41j13p0                        |
| documentEpoch                |                                      0 |
| documentExpirationTimeMicros |                                      0 |
| documentKind                 | com:services:fabric:models:PortState   |
| documentOwner                | 5849ea8c-a060-4496-8d8a-4f2495b04f74   |
| documentSelfLink             | /fabric/ports/x3000c0r41j13p0          |
| documentUpdateAction         | PATCH                                  |
| documentUpdateTimeMicros     | 1.616669889357003e+15                  |
| documentVersion              |                                      1 |
| id                           | x3000c0r41a0l29                        |
| portPolicyLinks              |[/fabric/port-policies/cx6-port-policy] |
+------------------------------+----------------------------------------+
fm-1# fmctl get ports/x3001c0r41j31p0
+------------------------------+---------------------------------------+
|             KEY              |                 VALUE                 |
+------------------------------+---------------------------------------+
| conn_port                    | x3001c0r41j31p0                       |
| documentAuthPrincipalLink    | /core/authz/system-user               |
| documentEpoch                |                                     0 |
| documentExpirationTimeMicros |                                     0 |
| documentKind                 | com:services:fabric:models:PortState  |
| documentOwner                | 5849ea8c-a060-4496-8d8a-4f2495b04f74  |
| documentSelfLink             | /fabric/ports/x3001c0r41j31p0         |
| documentUpdateAction         | POST                                  |
| documentUpdateTimeMicros     | 1.616639307727047e+15                 |
| documentVersion              |                                     0 |
| id                           | x3001c0r41a0l48                       |
| portPolicyLinks              | [/fabric/port-policies/fabric-policy] |
+------------------------------+---------------------------------------+

fm-1# fmctl get port-policies/cx6-port-policy
+------------------------------+--------------------------------------------+
|             KEY              |                   VALUE                    |
+------------------------------+--------------------------------------------+
| autoneg                      | false                                      |
| documentEpoch                |                                          0 |
| documentExpirationTimeMicros |                                          0 |
| documentKind                 | com:services:fabric:models:PortPolicyState |
| documentOwner                | 992ec582-e4ec-4428-9228-31133617069b       |
| documentSelfLink             | /fabric/port-policies/cx6-port-policy      |
| documentUpdateAction         | POST                                       |
| documentUpdateTimeMicros     | 1.616673000239e+15                         |
| documentVersion              |                                          0 |
| flowControl                  | map[rx:true tx:true]                       |
| loopback                     | NONE                                       |
| mac                          | 02:00:00:00:00:00                          |
| precode                      | AUTO                                       |
| speed                        | BS_200G                                    |
| state                        | ONLINE                                     |
+------------------------------+--------------------------------------------+
fm-1# fmctl get port-policies/fabric-policy
+------------------------------+--------------------------------------------+
|             KEY              |                   VALUE                    |
+------------------------------+--------------------------------------------+
| autoneg                      | true                                       |
| documentEpoch                |                                          0 |
| documentExpirationTimeMicros |                                          0 |
| documentKind                 | com:services:fabric:models:PortPolicyState |
| documentOwner                | 992ec582-e4ec-4428-9228-31133617069b       |
| documentSelfLink             | /fabric/port-policies/fabric-policy        |
| documentUpdateAction         | POST                                       |
| documentUpdateTimeMicros     | 1.616672532477001e+15                      |
| documentVersion              |                                          0 |
| flowControl                  | map[rx:true tx:true]                       |
| loopback                     | NONE                                       |
| mac                          | 02:00:00:00:00:00                          |
| precode                      | AUTO                                       |
| speed                        | BS_200G                                    |
| state                        | ONLINE                                     |
+------------------------------+--------------------------------------------+


(STT) show fabric
```


```bash
Working with 'default' topology and 'default' filter profile.
Collecting data using 'check-switches' script.
Collecting data using 'check-fabric' script.
..
dgrperfcheck  :  Start time: 03/25/2021, 11:22:29 , End time: 03/25/2021, 11:22:30
check-switches  :  Start time: 03/25/2021, 11:22:29 , End time: 03/25/2021, 11:22:33
dgrlinkstat  :  Start time: 03/25/2021, 11:22:29 , End time: 03/25/2021, 11:22:34
+-----------------+--------+---------------+----------+----------+--------+--------+---------+------+-------------------+-------------+---------+
|      xname      |  type  |      dst      | hostname | port_num | status | ptype  | subtype | mtu  |        mac        |   mactype   |  speed  |
+-----------------+--------+---------------+----------+----------+--------+--------+---------+------+-------------------+-------------+---------+
| x3000c0r41j11p0 | fabric | x3000c0r42j18 | unknown  |    10    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:00:0b | algorithmic | BS_200G |
| x3000c0r41j11p1 | fabric | x3000c0r42j18 | unknown  |    11    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:00:0a | algorithmic | BS_200G |
| x3000c0r41j12p0 | fabric | x3000c0r42j22 | unknown  |    26    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:00:1b | algorithmic | BS_200G |
| x3000c0r41j12p1 | fabric | x3000c0r42j22 | unknown  |    27    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:00:1a | algorithmic | BS_200G |
| x3000c0r41j13p0 | fabric | x3001c0r41j31 | unknown  |    28    | False  | Fabric |  Global | 9216 | 02:00:00:00:00:1d | algorithmic | BS_200G |
| x3001c0r41j14p1 | fabric | x3001c0r42j20 | unknown  |    13    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:08:0c | algorithmic | BS_200G |
| x3001c0r41j31p0 | fabric | x3000c0r41j13 | unknown  |    49    | False  | Fabric |  Global | 9216 | 02:00:00:00:08:30 | algorithmic | BS_200G |
| x3001c0r41j31p1 | fabric | x3000c0r41j13 | unknown  |    48    |  True  | Fabric |  Global | 9216 | 02:00:00:00:08:31 | algorithmic | BS_200G |
| x3001c0r41j32p0 | fabric | x3000c0r41j14 | unknown  |    33    |  True  | Fabric |  Global | 9216 | 02:00:00:00:08:20 | algorithmic | BS_200G |
| x3001c0r41j32p1 | fabric | x3000c0r41j14 | unknown  |    32    |  True  | Fabric |  Global | 9216 | 02:00:00:00:08:21 | algorithmic | BS_200G |
| x3001c0r42j16p0 | fabric |  x3000c0r42j2 | unknown  |    31    |  True  | Fabric |  Global | 9216 | 02:00:00:00:08:5e | algorithmic | BS_200G |
| x3001c0r42j16p1 | fabric |  x3000c0r42j2 | unknown  |    30    |  True  | Fabric |  Global | 9216 | 02:00:00:00:08:5f | algorithmic | BS_200G |
| x3001c0r42j18p0 | fabric | x3001c0r41j11 | unknown  |    47    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:08:6e | algorithmic | BS_200G |
| x3001c0r42j18p1 | fabric | x3001c0r41j11 | unknown  |    46    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:08:6f | algorithmic | BS_200G |
| x3001c0r42j20p0 | fabric | x3001c0r41j14 | unknown  |    60    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:08:7d | algorithmic | BS_200G |
| x3001c0r42j20p1 | fabric | x3001c0r41j14 | unknown  |    61    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:08:7c | algorithmic | BS_200G |
| x3001c0r42j21p0 | fabric | x3000c0r42j16 | unknown  |    58    |  True  | Fabric |  Global | 9216 | 02:00:00:00:08:7b | algorithmic | BS_200G |
| x3001c0r42j21p1 | fabric | x3000c0r42j16 | unknown  |    59    |  True  | Fabric |  Global | 9216 | 02:00:00:00:08:7a | algorithmic | BS_200G |
| x3001c0r42j22p0 | fabric | x3001c0r41j12 | unknown  |    42    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:08:6b | algorithmic | BS_200G |
| x3001c0r42j22p1 | fabric | x3001c0r41j12 | unknown  |    43    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:08:6a | algorithmic | BS_200G |
|  x3001c0r42j2p0 | fabric | x3001c0r41j13 | unknown  |    17    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:08:50 | algorithmic | BS_200G |
|  x3001c0r42j2p1 | fabric | x3001c0r41j13 | unknown  |    16    |  True  | Fabric |  Local  | 9216 | 02:00:00:00:08:51 | algorithmic | BS_200G |
+-----------------+--------+---------------+----------+----------+--------+--------+---------+------+-------------------+-------------+---------+
* The output has been truncated for readability.

(STT) show links health

dgrheadshellstat  :  Start time: 03/25/2021, 11:24:27 , End time: 03/25/2021, 11:24:28
check-fabric  :  Start time: 03/25/2021, 11:24:27 , End time: 03/25/2021, 11:24:29
check-switches  :  Start time: 03/25/2021, 11:24:27 , End time: 03/25/2021, 11:24:31
dgrlinkstat  :  Start time: 03/25/2021, 11:24:27 , End time: 03/25/2021, 11:24:33

Displaying the Downed Links and required diagnostics action for each link:
Querying downed links' link partners...

+------+-----------------------------------------+---------+--------+--------------+----------+------------+-----------+----------------+------------- +
| type |rosprt xname(pport)<->rosprt xname(pport)|rosswinfo|sC firmW|sw_medtype-pw |hdsh state|lp rosswinfo|lp sC firmW|lp sw_medtype-pw|lp hdsh state |
+------+-----------------------------------------+---------+--------+--------------+----------+------------+-----------+----------------+--------------+
|Fabric|x3000c0r41j13p0(28)<->x3001c0r41j31p0(49)|None S L |1.5.181 |electrical-N/A| ssh fail | None S L   | 1.5.abray | electrical-N/A |   ssh fail   |
+------+-----------------------------------------+---------+--------+--------------+----------+------------+-----------+----------------+--------------+
* The output has been truncated for readability.

```


```screen
fm-1# fmctl update ports/x3001c0r41j31p0 \
portPolicyLinks=/fabric/port-policies/cx6-port-policy

fm-1# fmctl get ports/x3000c0r41j13p0

+------------------------------+-----------------------------------------+
|             KEY              |                  VALUE                  |
+------------------------------+-----------------------------------------+
| conn_port                    | x3000c0r41j13p0                         |
| documentEpoch                |                                       0 |
| documentExpirationTimeMicros |                                       0 |
| documentKind                 | com:services:fabric:models:PortState    |
| documentOwner                | 992ec582-e4ec-4428-9228-31133617069b    |
| documentSelfLink             | /fabric/ports/x3000c0r41j13p0           |
| documentUpdateAction         | PATCH                                   |
| documentUpdateTimeMicros     | 1.616673730092003e+15                   |
| documentVersion              |                                       3 |
| id                           | x3000c0r41a0l29                         |
| portPolicyLinks              | [/fabric/port-policies/cx6-port-policy] |
+------------------------------+-----------------------------------------+
fm-1# fmctl get ports/x3001c0r41j31p0
+------------------------------+-----------------------------------------+
|             KEY              |                  VALUE                  |
+------------------------------+-----------------------------------------+
| conn_port                    | x3001c0r41j31p0                         |
| documentEpoch                |                                       0 |
| documentExpirationTimeMicros |                                       0 |
| documentKind                 | com:services:fabric:models:PortState    |
| documentOwner                | 992ec582-e4ec-4428-9228-31133617069b    |
| documentSelfLink             | /fabric/ports/x3001c0r41j31p0           |
| documentUpdateAction         | PATCH                                   |
| documentUpdateTimeMicros     | 1.616673983079003e+15                   |
| documentVersion              |                                       2 |
| id                           | x3001c0r41a0l48                         |
| portPolicyLinks              | [/fabric/port-policies/cx6-port-policy] |
+------------------------------+-----------------------------------------+


fm-1# fmn-show-status
Edge: 127 / 128
Fabric: 48 / 48
Ports Reported: 176 / 176
Fully Synchronized Switches: 4 / 4

```

