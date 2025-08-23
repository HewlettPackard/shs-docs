# Ethernet tuning

The Slingshot Host Software (SHS) Ethernet tuning utility script (`slingshot-eth-tuning.sh`) is designed to optimize network interface parameters for high-performance networking, particularly for High-Speed Network (HSN) interfaces.
It provides a comprehensive set of tools to get, set, and recommend optimal network parameters for both system-wide TCP settings and device-specific configurations.

The script helps achieve optimal TCP performance through the following capabilities:

1. **System-wide TCP Buffer Optimization**

   - Configures optimal TCP receive and send buffer sizes
   - Sets appropriate TCP memory limits for both minimum and maximum values
   - Ensures proper memory allocation for network operations

2. **Device-specific Optimizations**

   - Configures optimal MTU (Maximum Transmission Unit) settings
   - Sets appropriate ring buffer sizes based on link speed (200G/400G)
   - Manages pause parameters for flow control
   - Optimizes queue lengths and number of queues
   - Implements XPS (Transmit Packet Steering) for efficient CPU utilization

3. **CPU Affinity and IRQ Management**

   - Distributes network processing across available CPU cores
   - Implements smart CPU core selection based on NUMA node locality
   - Manages IRQ balancing for optimal interrupt handling

For more detail on these capabilities, see the [Key features](./slingshot-eth-tuning_features.md#key-features) section.
