# kdreg2 configuration

After installing kdreg2, you may want to further optimize its performance.
The following steps can help you fine-tune kdreg2 for your system:

1. Set the default memory monitor to kdreg2 using the Libfabric environment variable.
2. Increase the Libfabric environment variables for memory registration cache size if indicated, especially for applications that are not using Cray MPI.
