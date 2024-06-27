
# GPCNeT Benchmark

GPCNeT benchmark provides the following capabilities:

* Natural Ring Communication Pattern - all processors communicate with their neighbors simultaneously based on adjacent MPI ranks.
* Random Ring Communication Pattern - processors are paired with random nodes that do not live on a physical neighbor in the machine.
* Exercising the corners of spacial-temporal locality where spacial locality refers to the likelihood that adjacent memory addresses are referenced in a short period of time and temporal locality refers to the likelihood of a single memory address being referenced several times in a short period of time.