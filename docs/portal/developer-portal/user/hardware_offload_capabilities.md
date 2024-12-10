# Hardware offload capabilities

Some key features of the HPE Slingshot NICs include offload capabilities for the following:

- **Asynchronous Message Progression Offload:** HPE Slingshot NICs provide offloading and asynchronous progression of both send and receive messages to improve system performance by enabling the overlap of communications and computation and reducing the use of memory (and memory bandwidth) by the MPI stack. When sending a message, commands are added to a command queue and progress by the NIC without CPU involvement. Large numbers of non-blocking commands can be queued by any process (up to 65,536 if the maximum size of queue is used). Small MPI messages (those with up to 192 bytes of payload data) can be written directly to a command queue, avoiding a round trip across the host interface.
- **Tag Matching:** When receiving a message, MPI point-to-point messages are directed to a list processing engine (LPE) that matches sends to receives. The LPE supports both eager and rendezvous protocols. For small messages, the LPE can match a message to receive request and stream the payload data directly to a user buffer. For large messages, the LPE will match the message to a receive request and then issue a Get request to fetch the payload data directly to a user buffer. Tag-matching offloads are used for both expected and unexpected messages. For unexpected messages, “eager data” that is sent before a receive buffer that is allocated is held in overflow buffers and hardware will match these messages against subsequently posted receive buffers.
- **Completion Events and Triggered Operations:** HPE Slingshot network adapters support counting events and triggered operations that allow complex synchronizations and completion of one or more operations to trigger the issuing of other operations. For example, triggered operations can be used to offload progression of bulk data collectives to the NIC. Counting events and triggered operations are used to implement with low overhead complex CPU and GPU operations using HPE Slingshot-based communications.