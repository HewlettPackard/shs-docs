# High rate puts and internal-loopack

A Slingshot switch acknowledges the high rate puts, not the target NIC, so
they do not work when the NIC is configured in internal-loopback mode. The
`--no-hrp` option can be used to disable high rate puts.