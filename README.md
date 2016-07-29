# ble-nano-dev

Development environment for the BLE Nano from Read Bear Lab using Vagrant.

# Instructions

1. Download and install Vagrant

2. Download and install Virtual Box

3. Clone repo

    ```sh
    $ git clone git@github.com:absolom/ble-nano-dev.git ble
    ```
4. Tell Vagrant to build the VM system

    ```sh
    $ cd ble && vagrant up
    ```

5. Copy hrs.hex to your MK20's drive

6. Open nRF Toolbox on your smart phone

7. Select the HRS app, you should be able to connect to your BLE Nano and verify that it is sending data.

8. Review bootstrap.sh to see how the build is done

9. ```$ vagrant ssh``` to ssh into the build system
