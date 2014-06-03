import CC2540ble as ble

def main():
    bt = ble.BTDongle(port='/dev/ttyACM0')
    devs = bt.discover()
    print devs
    print bt.link(devs[0])
    print bt.enableNotifications('0x002F')
    for evt in bt.pollNotifications():
        print evt

if __name__ == '__main__':
    main()
