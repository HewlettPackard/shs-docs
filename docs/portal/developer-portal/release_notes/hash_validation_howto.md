
# Validate HPE Slingshot Software/Firmware using HPE GPG or RPM Signature Verification

## HPE Code Signing Website

https://myenterpriselicense.hpe.com/cwp-ui/free-software/HPLinuxCodeSigning

## How to download HPE GPG Public Key Archive

https://downloads.hpe.com/pub/keys/HPE-GPG-Public-Keys.tar.gz

# Validate the SHA-256 checksum of HPE Slingshot Software/Firmware

## Before you begin

Check the `sha256.manifest` file which is uploaded with HPE Slingshot Software.

After downloading the HPE Slingshot Software, validate the SHA-256 checksum value
on TAR archive. Depending on operating system, use following procedure to
verify the SHA-256 checksum value for every software component inside the archive.

## Windows

1. Open a command prompt.

2. Type the following command to generate the checksum value:

   ```bash
   certutil -hashfile <file name> SHA256
   ```

   where `<file name>` is full path to RPM package.

3. Verify the checksum result is matched with SHA-256 value in sha256.manifest file.

## Mac

1. Open a terminal window.

2. Type the following command to generate the checksum value:

   ```bash
   shasum -a 256 <file name>
   ```

   where `<file name>` is full path to RPM package.

3. Verify the checksum result is matched with SHA-256 value in sha256.manifest file.

## Linux

1. Acquire the shell.

2. Type the following command to generate the checksum value:

   ```bash
   sha256sum <file name>
   ```

   where `<file name>` is full path to RPM package.

3. Verify the checksum result is matched with SHA-256 value in sha256.manifest file.
