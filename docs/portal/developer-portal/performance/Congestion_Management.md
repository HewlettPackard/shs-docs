# Congestion Management

The HPE Slingshot network uniquely addresses the congestion challenges of short-lived, small packet flows typical in HPC applications. Several hardware mechanisms are utilized to significantly reduce congestion within the network as well as to limit the saturation tree within the network when problems arise.

In hardware, each switch detects congestion, identifies its causes, and provides real-time feedback to its peers. The system distinguishes perpetrators from victims of injection and limits the injection rate from the perpetrator until congestion clears. 

## Causes for Congestion

* Congestion can be caused by the underlying architecture of the network. Very few, if any, systems are configured with maximum global bandwidth. As a result of the global network taper, there is inherently more injection bandwidth into the network than can be globally consumed. As a result, global congestion results when applications provide a heavy global communication load.
* Congestion can also be caused by interactions between jobs. Various traffic patterns can have negative impact on concurrent jobs resulting in reduced performance for those jobs competing for the congested resources.
* Congestion can also be caused by poor programming practices. All-to-one communication inherently causes congestion as the injection bandwidth far exceeds the ejection bandwidth. In these cases, the aim is to limit the congestion damage to only those processes involved in the all-to-one communication and not allow that congestion to propagate and affect other jobs in the system.
* Congestion can be caused by hardware failures which reduce the network's bandwidth capacities in a limited area of the system.

## Congestion Measurement

Measuring congestion is therefore critical in determining the course of action. HPE Slingshot adopts multiple techniques to internally measure and dynamically adapt to congestion.
HPE Slingshot adopts real-time measurements of the congestion parameters mentioned. Appropriate actions are taken to avoid further congestion or to eliminate the congestion entirely.

* Local congestion. This is congestion within a switch chip that can be observed through buffer utilization. It is also an indication of the link utilization of that local port.
* Global congestion. This is understanding the global congestion picture and the “hot spots” that the traffic encountered on its path to the destination

## Congestion Information Distribution

* Local congestion (that within a switch itself) is distributed to all the local inputs through on-board hardware. HPE Slingshot adopts highly dynamic, low latency distribution mechanisms and allows for the route pipe to select a lightly loaded port for its egress when appropriate.
* Switch to switch congestion information relays congestion of adjoining devices. This allows for a next-hop view of congestion to allow the adaptive routing mechanism to select a lightly loaded adjoining switch.
* Global congestion information is relayed through the back-channel acknowledgments that accompany the flow channels. This information notifies the flow that congestion was encountered along the path.
* In the case of inject vs. eject bandwidth mis-matches, the NIC itself must be throttled. This back pressure is a result of the back-channel acknowledgments and results in slowing the injection rate by the NIC to a suitable rate for the network to handle without congestion.

