
# GPU libraries

When using GPU buffers, the diagnostics attempt to dynamically link the
appropriate runtime library, HIP for AMD or CUDA for NVIDIA or Level-zero for INTEL.
If the library has not been installed, the following error occurs:

```screen
Get device count request failed
Failed to init GPU lib: Operation not permitted
```

If both HIP and CUDA libraries are installed and NVIDIA GPUs are being used, HIP is used
by default. This error indicates that the HIP library has not been compiled for NVIDIA.
Add `-g` NVIDIA to the command to change to the CUDA library.
