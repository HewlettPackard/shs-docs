# Overview

The accelerated collectives feature uses special multicast trees within the HPE Slingshot fabric to accelerate collective operations.

These multicast trees utilize the fabric switches as reduce-and-hold storage for partial reductions that traverse the multicast tree from leaf endpoints to the root endpoint. Reduction is performed in-tree during the data transfer, and the count of the contributions is maintained.

Leaf endpoints compute their contribution to the collective operation and immediately send it upstream (rootward) on the multicast tree, where it is counted or reduced in switch hardware.
The root endpoint computes its contribution to the collective, and then waits for a full count of leaf contributions.
When the root endpoint receives the full count of N-1 contributions from the leaves, it completes the reduction in software with its own contribution, and broadcasts the result through the multicast tree downstream (leafward) to all the leaf endpoints.

When there are no complications, each endpoint sends and receives exactly one packet, and only one reduction is performed in software on the root endpoint. This avoids the delays associated with passing through NICs in a traditional radix-tree implementation of collectives. The benefit is that these accelerated collectives show better scaling performance as the number of endpoints increases.
