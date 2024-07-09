# Explicit Congestion Notification

Standard Ethernet uses Explicit Congestion Notification (ECN) to signal to applications that congestion may be occurring within a network. The ECN is a field within the IP header that first signals an application is capable of responding to congestion and can be modified by an Ethernet switch/router to signal that congestion is occurring. 

Usually the bit is modified when an input buffer is becoming full. Many TCP stacks can respond to forward ECN (FECN) marking in a similar way to a packet being dropped by signaling with the backwards TCP acknowledgment the transmitter to slow down. Often this is called the backwards ECN (BECN).
