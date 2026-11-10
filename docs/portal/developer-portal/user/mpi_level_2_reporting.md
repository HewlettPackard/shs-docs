# Level 2 reporting

Level 2 reporting summarizes the selected list of counters aggregated
over all the NICs in addition to the counter report. They are summarized
into the total samples (the number of endpoints reporting non-zero
data), the minimum quantity and rate (quantity divided by execution
time), the mean and mean rate, and the maximum and max rate. Counters
are listed alphabetically.

There are many ways to use this level of reporting.

Example excerpt from a Level 2 report:

```text
PE 0: MPICH Slingshot CXI Counter Summary:
PE 0: Counter Samples Min (/s) Mean (/s) Max (/s)
PE 0: pct_trs_rsp_nack_drops 1 3 0.0 3 0.0 3 0.0
```

For example, to understand if a job is running slow:

- Look at the retry handler counter group for indications of high levels
  of retry activity that might impact performance, especially if as an
  outlier

- Look at the PARB counters to see if there are outliers indicating a
  node with an issue

- Look at the HNI counters to see if there are indications of network
  congestion
