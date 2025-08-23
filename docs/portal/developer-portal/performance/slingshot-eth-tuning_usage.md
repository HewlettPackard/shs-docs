# Usage

The script provides three main modes of operation.

1. **Get mode:**

   - Retrieves current network settings
   - Shows recommended values for optimal performance

   ```bash
   slingshot-eth-tuning.sh --get value [--device <network_device>]
   slingshot-eth-tuning.sh --get recommendation
   ```

2. **Set mode:**

   - Applies specific network settings
   - Can set recommended values automatically

   ```bash
   slingshot-eth-tuning.sh --set value [--device <network_device>] [options]
   slingshot-eth-tuning.sh --set recommendation [--device <network_device>]
   ```

3. **Dry-run mode:**

   - Shows commands that will be executed
   - Useful for previewing changes

   ```bash
   slingshot-eth-tuning.sh --set value [options] --dry-run
   ```
