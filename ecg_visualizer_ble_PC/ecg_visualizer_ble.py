import CC2540ble as ble

def main():
    print "Connecting to BLE Dongle . . ."
    bt = ble.BTDongle(port='/dev/ttyACM0')

    print "Discovering BLE devices in the vicinity . . ."
    devs = bt.discover()
    print "BLE Devices found: ", devs

    print "Establishing link to the first device found . . ."
    print bt.link(devs[0])

    print "Enabling notifications . . ."
    print bt.enableNotifications('0x002F')

    for evt in bt.pollNotifications():
        print evt

if __name__ == '__main__':
    main()
