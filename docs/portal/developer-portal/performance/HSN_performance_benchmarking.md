# HSN performance benchmarking

The performance benchmarking exercise for HSN fabric is an exercise to verify that the HSN is able to deliver the required performance level so that HPC Applications can run with the desired performance and produce the expected outcome

It is required to progress in a systematic and hierarchical way to validate the HSN fabric health prior to performance benchmarking. Here is a pre-flight checklist that can be used towards the same

* All Edge links are up and able to achieve line rate with the loopback tests. HSN (hsn_traffic roce_perf_check_loopback command in STT can be used)
* All Nodes are able to successfully ping each other through the HSN (how hsn_traffic ping-all-to-all can be used to validate the same)
* All Nodes are rightly sized for the ARP Table Cache
* All the Local and Global Fabric Links are up and healthy.
* Health of Compute node HSN NICs has been verified. `fmn-update-compute-hsn-health` command can be used to verify HSN NICs of all compute nodes. This command will verify the following aspects:

  1. Compute node has valid lldp configuration
  2. HSN NIC has Algorithmic MAC (AMA) configured as the MAC address
  3. HSN NIC has the right MTU size set
  4. HSN NIC state is in desired configuration (UP)
  5. IP Address is assigned for HSN NIC
  6. `nslookup` for the IP address is verified
  7. nodes management network reachable/unreachable

## Edge performance (test between compute Nodes connected the same switch)

The following is an example test that provides a sample OSU one-side Performance results between two nodes with HSN Fabric in same group and connected to the same switch. The actual results expected results.

```screen
mpirun --host <system_name>n001,<system_name>n003 ./one-sided/osu_get_bw
# OSU MPI_Get Bandwidth Test v5.7
# Window creation: MPI_Win_allocate
# Synchronization: MPI_Win_flush
# Size      Bandwidth (MB/s)
1                       1.41
2                       2.88
4                       5.73
8                      11.47
16                     22.75
32                     45.43
64                     90.16
128                   179.71
256                   351.77
512                   686.54
1024                 1287.91
2048                 2325.71
4096                 3745.44
8192                 4833.46
16384                8414.83
32768               10065.90
65536               11764.25
131072              12057.05
262144              11955.63
524288              12206.38
1048576             12230.73
2097152             12232.51
4194304             12248.76
```

## Local performance test (tests between nodes in the same group)

The following is an example test that provides a sample OSU pt2pt mbw  performance results between two nodes with HSN Fabric in same group and connected to the same switch. The actual results expected results. In this Particular topology there are 2 Switches in the Groups and 2 groups in this topology. The tests  verifies the health of the local links and performance between the nodes within the group

**Group 1**

```screen
mpirun -npernode 20 -np 1240  --hostfile <system_name>_group_1  ./pt2pt/osu_mbw_mr
# OSU MPI Multiple Bandwidth / Message Rate Test v5.7
# [ pairs: 620 ] [ window size: 64 ]
# Size                  MB/s        Messages/s
1                    1348.55     1348549706.72
2                    2779.51     1389756693.60
4                    5462.90     1365724294.86
8                   10351.34     1293917208.56
16                  22662.77     1416422921.03
32                  45220.76     1413148717.65
64                  84665.37     1322896425.33
128                116830.53      912738492.29
256                165858.65      647885348.70
512                239033.01      466861341.64
1024               307188.16      299988438.15
2048               363376.43      177429895.22
4096               367815.47       89798698.53
8192               371290.34       45323528.38
16384              374076.93       22831844.00
32768              375698.58       11465410.78
65536              376478.72        5744609.37
131072             376848.80        2875128.14
262144             378906.21        1445412.50
524288             377962.17         720905.62
1048576            378021.20         360509.11
2097152            378051.17         180268.85
4194304            378065.80          90137.91
```

Total Number of Node pairs 31
Peak BW/Node : 12195 MB/s

**Group 2**

```screen
# OSU MPI Multiple Bandwidth / Message Rate Test v5.7
# [ pairs: 60 ] [ window size: 64 ]
# Size                  MB/s        Messages/s
1                     134.07      134071145.16
2                     236.08      118039935.80
4                     580.23      145058211.44
8                    1125.55      140693176.60
16                   2345.65      146603132.87
32                   4714.58      147330575.24
64                   9547.02      149172226.22
128                 16973.34      132604203.59
256                 27427.30      107137901.82
512                 52111.44      101780154.34
1024                92203.37       90042351.21
2048               155700.72       76025740.68
4096               199095.54       48607309.04
8192               216607.24       26441313.14
16384              225813.45       13782559.15
32768              234345.71        7151663.43
65536              238047.06        3632309.87
131072             239762.01        1829238.94
262144             240205.85         916312.59
524288             240673.36         459048.00
1048576            240826.85         229670.38
2097152            241611.18         115209.19
4194304            241629.03          57608.85
```

Total Number of Node pairs 20
Peak BW/Node : 12081 MB/

## Global performance test (tests between nodes in the different group)

The following is an example test that provides a sample OSU pt2pt mbw  performance results between two nodes with HSN Fabric in same group and connected to the same switch. The actual results expected results. In this Particular topology there are 2 Switches in the Groups and 2 groups in this topology. The tests  verifies the health of the local links, global links and performance between the nodes in different group

```screen
# OSU MPI Multiple Bandwidth / Message Rate Test v5.7
# [ pairs: 256 ] [ window size: 64 ]
# Size                  MB/s        Messages/s
1                     568.09      568087397.77
2                    1191.65      595826601.66
4                    2399.29      599823560.54
8                    4506.64      563330319.72
16                   9654.10      603381324.54
32                  19380.67      605645943.55
64                  38383.85      599747637.51
128                 66610.79      520396828.98
256                 99187.54      387451331.76
512                159925.89      312355258.29
1024               215245.81      210200987.94
2048               264641.30      129219385.19
4096               280174.52       68401982.88
8192               285509.67       34852255.07
16384              291997.31       17822101.18
32768              294014.51        8972610.80
65536              294566.71        4494731.32
131072             294984.45        2250552.75
262144             295044.92        1125507.04
524288             294992.21         562652.98
1048576            296658.75         282915.83
2097152            296694.47         141474.95
4194304            296699.17          70738.59
```

Number of Node pairs : 32
Performance per Node (Global BW): 9271 MB/s

## Running MPI tests in a Slurm Workload Manager environment

Admin can automate the tests (osu) that can be run on all nids connected to a switch (edge) or at
local level or at global level. This automation enables efficient performance benchmarking and also to quickly isolate and rectify performance related problems in
fabric.

1. Create a host file with compute nodes connected to switch.

   ```screen
   #!/bin/bash
   # for the given nids and switch this script will get all nids connected to a switch
   #input switch start-nid end-nid hsn-dev
   #example ./nids-switch.sh 1000 1063 x1000c1r5b0 hsn1
   print_usage() {
            echo "Usage:
            ARG1 [start nid]
            ARG2 [end nid]
            ARG3 [switch xname]
            ARG4 [HSN device]
            example ./nids-switch.sh 1000 1063 x1000c1r5b0 hsn1"
   }
   fail_with_usage() {
            echo "ERROR: $*. Exiting." >&2
               print_usage
               exit 1
         }
   if [ $# -ne 4 ] ; then
      fail_with_usage
   fi
   rm -f nid-switch-$1-$2.txt  $3-nids.txt
   pdsh -w  nid00[$1-$2]-nmn lldptool -i  $4  -t -n >> nid-switch-$1-$2.txt
   grep $3 nid-switch-$1-$2.txt >> $3-nids.txt
   sed -e s/$3//g -e s/://g -i $3-nids.txt
   echo "Check $3-nids.txt"
   ```

2. Execute MPI benchmark programs using Slurm workload manager.

   The host file produced in step 1 can be used to run MPI integrating with slurm workload manager
   to identify a set of free nodes and allocating them and trigger the MPI tests

   ```screen
   #!/bin/bash
   # This script takes the input of a host file that consists of nids connected to a switch
   # Run nids-switch.sh to produce this host file for a switch
   # the script will look for free nodes and prepare a node list of osu_mbw_mr
   print_usage() {
         echo "Usage:
         ARG1 [hostfile]
         ARG2 [osu test program with]
         example ./ check_nodes_osu.sh x1000c1r5b0-nids.txt /opt/osu/osu-micro-benchmarks-5.7/mpi/pt2pt/osu_mbw_mr"
   }
   fail_with_usage() {
   echo "ERROR: $*. Exiting." >&2
   print_usage
   exit 1
   }
   if [ $# -ne 2 ] ; then
      fail_with_usage
   fi
   input=$1
   i=0
   while IFS= read -r line
   do
   echo "$line"
   avail=$(sinfo -n ${line} | grep idle)
   if [ $? -eq 0 ]; then
      nodes[$i]=$(echo $line | tr -d 'nid')
      ((i=i+1))
   fi
   done < "$input"
   echo "Available nodes"
   input=$2
   while IFS= read -r line
   do
   echo "$line"
   avail=$(sinfo -n ${line} | grep idle)
   if [ $? -eq 0 ]; then
      nodes[$i]=$(echo $line | tr -d 'nid')
      ((i=i+1))
   fi
   done < "$input"
   echo "Available nodes"
   node_list=""
   for (( j=0 ; j<$i; j++))
   do
      echo ${nodes[$j]}
      if [ $j -eq 0 ] ; then
         node_list="[${nodes[$j]}"
      else
         node_list="${node_list},${nodes[$j]}"
      fi
   done
   node_list="${node_list}]"
   echo $node_list
   srun -w  nid${node_list} $2
   ```

## MPI example programs (tests between nodes)

The following is a sample program that can be used to run MPI tests between two nodes.

```screen
/*******************************************************************
 * Copyright 2021 Hewlett Packard Enterprise Development LP
 * MPI Bisectional Bandwidth Test
 *
 *  Starts up an even number of processes (n), which use MPI_Isend
 *  and MPI_Recv to exchange data with their counterpoint processes.
 *  Process 0 transfers data to and from process n/2, process 1
 *  transfers data to and from process n/2 + 1, *  etc.  Elapsed
 *  time is captured on a per-process basis, and a total elapsed
 *  time is measured to compute an aggregate bandwidth in MB/sec.
 *
 *  This test uses MPI_Isend/MPI_Recv, which results is an aggregate
 *  bi-directional bisectional bandwidth.
 *
 *
 *******************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <mpi.h>
#include <malloc.h>
#include <strings.h>

#include <ctype.h>
#include <string.h>

static int my_rank;         // Rank of process

static void
print_usage()
{
   if (my_rank == 0) {
        printf("  Usage: bisec_bw2 ppn num_reps\n");
        printf("         ppn (number of processes per node) must be specified\n");
        printf("         num_reps must be specified\n");
        //printf("         -v indicates verbose output (optional)\n");
   }
   MPI_Finalize();
   exit(0);
}

static long
get_num(char *str)
{
   register int i;
   int val;
   char buf[128];

   buf[0] = '\0';
   if (str == NULL) return -1;

   for (i=0;i<strlen(str);i++) {
        if ((str[i]) == ' ') continue;   // ignore whitespace
        if(!isdigit(str[i])) return -1;  // an error
        strncat(buf,&str[i],1);
   }
   val = atol(buf);
   return val;
}


int main(int argc, char **argv) {

   char *c;
   int my_partner;      // Rank of partner process
   int num_procs;       // Total number of processes
   int tag = 42;        // Tag for messages
   int num_reps;        // Number of repetitions to run
   long byte_size;      // Message size in bytes
   int m_size;          // Message size in ints
   long start_size,stop_size;
   int i,j,k,half,num_nodes,ppn;
   int verbose=0;
   int *sendbuf, *recvbuf;
   double mbytes_xfered;
   MPI_Status status;
   MPI_Status stat;
   MPI_Request req;
   double short_time, long_time, ave_time, tot_time;  // timing variables
   double my_time, begin_time, final_time;
   double *start_time, *end_time, *elap_time;


   MPI_Init(&argc, &argv);
   MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
   MPI_Comm_size(MPI_COMM_WORLD, &num_procs);

   if ((num_procs%2) != 0) {
        printf("Error: Must have an even number of processes. \n");
        //print_usage();
   }


   ppn = -1;
   num_nodes = -1;
   num_reps  = -1;

   printf("\n Number of Process %d",num_procs);
   if (argc == 3) {
       ppn = get_num(*++argv);
       num_reps = get_num(*++argv);
       num_nodes = num_procs/ppn;
       if (my_rank == 0) {
           printf("PPN: %d, Number of nodes: %d, Num_reps = %d\n",
                  ppn,num_nodes,num_reps);
       }
   } else {
      print_usage();
   }




   // allocate timing structures
   start_time = (double *) malloc(num_procs * sizeof(double));
   end_time   = (double *) malloc(num_procs * sizeof(double));
   elap_time  = (double *) malloc(num_procs * sizeof(double));
   if ((start_time == 0) || (end_time == 0) || (elap_time == 0)) {
       printf("Error obtaining memory for timing structures.\n");
               exit(1);
   }

   // figure out who my partner is
   half = num_procs/2;
   my_partner = (my_rank < half ) ? my_rank+half : my_rank-half;

   start_size=1024;
   stop_size=1024*1024*2;

   for (j=start_size;j<=stop_size;j*=2) {

       byte_size = j;

        // allocate data buffers
        m_size=byte_size / sizeof(int);
        sendbuf = (int *) memalign(getpagesize(),m_size * sizeof(int));
        recvbuf = (int *) memalign(getpagesize(),m_size * sizeof(int));

        if ((sendbuf == 0) || (recvbuf == 0)) {
                 printf("Error obtaining memory for data transfers. \n");
             exit(1);
        }

        // initialize the send/recv buffers
        memset(sendbuf,42,m_size * sizeof(int));
        memset(recvbuf,-1,m_size * sizeof(int));

        // warmup - this one is not timed
        if (my_rank < half ) {
              MPI_Send(sendbuf, m_size, MPI_INT, my_partner,tag, MPI_COMM_WORLD);
              MPI_Recv(recvbuf, m_size, MPI_INT, my_partner,tag, MPI_COMM_WORLD, &status);
        } else {  /* my_rank >= half */
              MPI_Recv(recvbuf, m_size, MPI_INT, my_partner,tag, MPI_COMM_WORLD, &status);
              MPI_Send(sendbuf, m_size, MPI_INT, my_partner,tag, MPI_COMM_WORLD);
        }


       // Set Barrier here - we are ready to go!
       MPI_Barrier(MPI_COMM_WORLD);

       // Start the main overall timer
       if (my_rank == 0) begin_time = MPI_Wtime();

       // Capture time for each rank...since we may want to look at that as well
       start_time[my_rank] = MPI_Wtime();

       // Main timed loop
       for (i=0;i<num_reps;i++) {

           MPI_Isend(sendbuf, m_size, MPI_INT, my_partner, tag, MPI_COMM_WORLD, &req);
           MPI_Recv(recvbuf, m_size, MPI_INT, my_partner, tag, MPI_COMM_WORLD, &status);
           MPI_Wait(&req, &stat);
       }

       end_time[my_rank] = MPI_Wtime();
       my_time = end_time[my_rank] - start_time[my_rank];

       MPI_Barrier(MPI_COMM_WORLD);

       // End the main overall timer
       if (my_rank == 0) final_time = MPI_Wtime();

       // Compute the BW numbers
       if (my_rank == 0) {

           mbytes_xfered = (((double)(((double)num_procs * (double)num_reps *
                             (double)byte_size) /(double)(1000.0*1000.0))));

           double t = (final_time-begin_time);

           printf("%d Ranks, Msg Size: %9.2d bytes, Node BW: %9.2f MB/sec/node,  Aggregate BW: %6.2f GB/sec\n",
                   num_procs, j, (mbytes_xfered/t/num_nodes), (mbytes_xfered/1000)/t);



           fflush(0);
       }

   if (verbose) {    // Gather all the individual times
        if (my_rank == 0) {
            elap_time[0] = my_time;
            for (i=1;i<num_procs;i++) {
                MPI_Recv(&(elap_time[i]), 1, MPI_DOUBLE, i ,tag,
                        MPI_COMM_WORLD, &status);
            }
        } else {
            MPI_Send(&my_time, 1, MPI_DOUBLE, 0, tag, MPI_COMM_WORLD);
        }

        if (my_rank == 0) {
            for (i=0;i<num_procs/2;i++) {
                printf("\
Pair (%d<->%d) Elapsed time = %9.2f sec (%9.2f MB/sec)\n",
                        i,i+half,elap_time[i],
                        ((mbytes_xfered/(num_procs/2))/elap_time[i]));
            }
        }
    }

   // Free the resources
   free(sendbuf);
   free(recvbuf);
 }

   free(start_time);
   free(end_time);
   free(elap_time);

   MPI_Finalize();
}

mpicc  bisec_bw.c -o bisec_bw

[root@apollo-1 perf_tests]# /opt/openmpi-4.1.0/bin/mpirun --allow-run-as-root -np 4  --host 192.168.0.92:4,192.168.0.221:4 bisec_bw 4 2

 Number of Process 4PPN: 4, Number of nodes: 1, Num_reps = 2



4 Ranks, Msg Size:      1024 bytes, Node BW:    381.77 MB/sec/node,  Aggregate BW:   0.38 GB/sec
4 Ranks, Msg Size:      2048 bytes, Node BW:   1202.58 MB/sec/node,  Aggregate BW:   1.20 GB/sec
4 Ranks, Msg Size:      4096 bytes, Node BW:   1118.63 MB/sec/node,  Aggregate BW:   1.12 GB/sec
4 Ranks, Msg Size:      8192 bytes, Node BW:   3570.47 MB/sec/node,  Aggregate BW:   3.57 GB/sec
4 Ranks, Msg Size:     16384 bytes, Node BW:   4153.11 MB/sec/node,  Aggregate BW:   4.15 GB/sec
4 Ranks, Msg Size:     32768 bytes, Node BW:   6232.32 MB/sec/node,  Aggregate BW:   6.23 GB/sec
4 Ranks, Msg Size:     65536 bytes, Node BW:   7157.52 MB/sec/node,  Aggregate BW:   7.16 GB/sec
4 Ranks, Msg Size:    131072 bytes, Node BW:   9065.00 MB/sec/node,  Aggregate BW:   9.07 GB/sec
4 Ranks, Msg Size:    262144 bytes, Node BW:  11074.42 MB/sec/node,  Aggregate BW:  11.07 GB/sec
4 Ranks, Msg Size:    524288 bytes, Node BW:  12083.22 MB/sec/node,  Aggregate BW:  12.08 GB/sec
4 Ranks, Msg Size:   1048576 bytes, Node BW:  12569.01 MB/sec/node,  Aggregate BW:  12.57 GB/sec
4 Ranks, Msg Size:   2097152 bytes, Node BW:  12966.72 MB/sec/node,  Aggregate BW:  12.97 GB/sec
```

## Fabric diagnostics during performance benchmarks

Some of the problems that can impact the performance of OSU pt2pt performance include at Local and Global Level

* Incorrect AMA
* ARP Issue
* Local Links Flapping
* Global Link Flapping
* Hardware Cable Issues
* Global Bundle Sizing (Pairs of cables used for Connectivity between groups)
* Congestion in the network

It is recommended to use Slingshot Topology Tool (STT) and refer to the sections that describes on analyzing link flaps and Cable Hardware problems.

The following commands are recommended for analyzing the performance variations:

* `show switches`
* `show switch ports`
* `show fabric`
* `show flaps`
