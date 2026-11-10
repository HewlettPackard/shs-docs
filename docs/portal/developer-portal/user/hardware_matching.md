# Hardware-matching overflow buffer for unexpected messages (`FI_CXI_OFLOW_BUF_SIZE`)

`FI_CXI_OFLOW_BUF_SIZE` specifies the size of the overflow buffers.

Increasing the overflow-buffer size allows more unexpected-message eager data to be held in a single overflow buffer.
Applications with many unexpected messages or a large rendezvous threshold may perform better with a larger overflow-buffer size.

The default is **12 MB**.
