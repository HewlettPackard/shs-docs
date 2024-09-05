# Validate HPE Slingshot Software/Firmware using HPE GPG or RPM Signature Verification

## HPE Code Signing Website

The HPE Code Signing website can be found [here](https://myenterpriselicense.hpe.com/cwp-ui/free-software/HPLinuxCodeSigning).

## How to download HPE GPG Public Key Archive

The HPE GPG Public Key Archive can be downloaded [here](https://downloads.hpe.com/pub/keys/HPE-GPG-Public-Keys.tar.gz).

## Validate the SHA-256 checksum of HPE Slingshot Software/Firmware

_**Before you begin**_

Check the `sha256.manifest` file, which is uploaded with HPE Slingshot Software. After downloading the HPE Slingshot Software, validate the SHA-256 checksum value on TAR archive. Depending on operating system, use following procedure to verify the SHA-256 checksum value for every software component inside the archive.

_**Windows**_

1. Open a command prompt.

2. Type the following command to generate the checksum value:

   ```screen
   certutil -hashfile <file name> SHA256
   ```

   where `<file name>` is full path to RPM package.

3. Verify the checksum result is matched with SHA-256 value in sha256.manifest file.

_**Mac**_

1. Open a terminal window.

2. Type the following command to generate the checksum value:

   ```screen
   shasum -a 256 <file name>
   ```

   where `<file name>` is full path to RPM package.

3. Verify the checksum result is matched with SHA-256 value in sha256.manifest file.

_**Linux**_

1. Acquire the shell.

2. Type the following command to generate the checksum value:

   ```screen
   sha256sum <file name>
   ```

   where `<file name>` is full path to RPM package.

3. Verify the checksum result is matched with SHA-256 value in sha256.manifest file.
