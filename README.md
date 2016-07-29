# ble-nano-dev
Development environment for the BLE Nano from Read Bear Lab using Vagrant.

# Instructions
- Download and install Vagrant
- Download and install Virtual Box

    $ git clone git@github.com:absolom/ble-nano-dev.git ble
    $ cd ble
    $ vagrant up

- Copy hrs.hex to your MK20's drive
- Open nRF Toolbox on your smart phone
- Select the HRS app, you should be able to connect to your
  BLE Nano and see the data it is sending

- Review bootstrap.sh to see how the build is done
- 'vagrant ssh' to ssh into the build system

