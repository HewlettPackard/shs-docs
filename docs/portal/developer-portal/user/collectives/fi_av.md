# `fi_av`

Any `libfabric` application requires an `fi_av` structure to convert endpoint hardware addresses to `libfabric` addresses.
There can be multiple `fi_av` structures used for different purposes.
It is also common to have a single `fi_av` structure representing all endpoints in a job. This follows the standard `libfabric` documentation.
