# `slstat` link diagnostics

Use `slstat` to print information about the HPE Slingshot link driver for a target link device (switch or NIC), link group, or link.

## Syntax

```screen
slstat ldev_num[:lgrp_num][:link_num] [option]
    target:
        ldev_num = link device number (0-1)
        lgrp_num = link group number (0-63)
        link_num = link number (0-3)
    option: (omitted option will print all available info for target)
        state        = print state for the target
        link         = print all link info for the target
        mac          = print mac info for the target
        llr          = print llr info for the target
        pmi          = print pmi info for the target
        sbus         = print sbus info for the target
        sbus_pmi     = print sbus_pmi info for the target
        serdes       = print all serdes info for the target
        fec          = print fec info for the target
        cable        = print cable info for the target
        counters     = print non-zero counters for a link target (requires #:#:#)
        counters_all = print all counters for a link target (requires #:#:#)
        show_db      = print supported cable database"
        use_test     = use the "test_port" directory
```

## Examples

Show all available information for link device 0:

```screen
slstat 0
```

Show state for link group 12 on link device 0:

```screen
slstat 0:12 state
```

Show SerDes details for link 1 in link group 12 on link device 0:

```screen
slstat 0:12:1 serdes
```

Show only non-zero counters for a specific link:

```screen
slstat 0:12:1 counters
```

Show all counters for a specific link:

```screen
slstat 0:12:1 counters_all
```
