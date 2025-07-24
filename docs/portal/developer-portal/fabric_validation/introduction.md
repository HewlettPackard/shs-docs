# Introduction

This document covers aspects that are required to validate HPE Slingshot fabric connectivity and performance between different types of nodes.
For example, the ability to validate the following different combinations for connectivity and performance.

- Compute node to gateway node to external storage
- Compute node with compute node
- Nodes that are part of the storage group

The document illustrates the process flow with examples on how to use the basic HPE Slingshot utilities that are provided along with HPE Slingshot Host Software (SHS).

In addition, the examples in this guide show the usage of industry-standard HPC benchmark tools and standard Ethernet tools.
It also covers HPE Slingshot fabric validation for compute (For example, MPI) environment with different benchmarks.
Use this document as a supplement to the standard documentation released with SHS.

The scope of the document is performance and connectivity validation of different endpoints in HPE Slingshot benchmarks with troubleshooting examples.
The document is intended for a dragonfly topology of any scale. The document uses an example fabric topology for reference.

## Command prompt conventions

The following table lists the common command prompts in this document and their meanings.

**Table:** Command prompt conventions

| **Prompt**  | **Description**                                   |
|:------------|:--------------------------------------------------|
| `#`         | Run the command as `root` on a gateway node.      |
| `nidXXXXX#` | Run the command as `root` on a compute node.      |
| `uan-0001#` | Run the command as `root` on hostname `uan-0001`. |

## Reference system: Elbert

Throughout this document, an example system named `Elbert` is referenced to help illustrate various scenarios.

The following figure shows the topology for the `Elbert` system at a high level.

![System topology overview](../images/fabric_topology.png)

**Table:** HPE Slingshot group mapping for the various entities

| **Entity**              | **Slingshot Group** | **MPI** | **Functionality**                                      |
|-------------------------|---------------------|---------|--------------------------------------------------------|
| Service group (gateway) | 0                   | No      | Connection to external storage through another network |
| Storage                 | 1–8                 | No      | Lustre, DAOS                                           |
| Compute                 | 9–88                | Yes     | Compute nodes                                          |
