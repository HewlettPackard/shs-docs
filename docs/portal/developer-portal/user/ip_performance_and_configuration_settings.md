# IP performance and configuration settings

There are many recommended settings in the product documentation for configuring TCP/IP performance.
HPE Slingshot Host Software (SHS) does not set up these Linux settings.
Review the documentation to see if these are settings are in place if TCP/IP performance is a concern.

When measuring performance with IP, use the `iperf2` benchmark instead of `iperf3`. Because IP protocols run on the host to test the networking aspect, the `iperf2` benchmark allows scaling to many cores which is needed to drive the high bandwidth of the HPE Slingshot NIC; `iperf3` is more a single-threaded benchmark.
Because TCP is host dependent, when performance on `iperf2` is below expectations, there can be many host based contributing causes that are unrelated to the fabric or the NIC.
