import sys, struct, array
import streamplot
from bluetooth import *

SAMPLING_RATE_500 = 0x02

def wait_for_ack():
   ddata = ""
   ack = struct.pack('B', 0xff) 
   while ddata != ack:
      ddata = sock.recv(1)
   return

def enquire():
   sock.send(struct.pack('B',0x01))
   wait_for_ack()

   ddata = ""
   ddata += sock.recv(8)

   Ptype,Rate,Accelrange,Config0,Chans,Buffsize,chan1,chan2 = struct.unpack('!BBBBBBBB',ddata)
   print "Packtype:%x Rate:%x Chans:%x Buffsize:%x Chan1:%x Chan2:%x" % (Ptype,Rate,Chans,Buffsize,chan1,chan2)
   return

if len(sys.argv) < 2:
    print "no device specified"
    print "You need to specifiy the MAC address of the shimmer you wish to connect to"
    print "example:"
    print "  BtStreamAccel_Linux.py 00:06:66:42:24:18"
    print
else: 
    port = 1;
    host = sys.argv[1]

    sock = BluetoothSocket( RFCOMM )
    sock.connect((host, port))

# send the set sensors command 
    sock.send(struct.pack('BBB', 0x08, 0x10, 0x00))    # ECG only
    wait_for_ack()

# send the set sampling rate command
   #sock.send(struct.pack('BB', 0x05, 0x14))           # 51.2Hz
    sock.send(struct.pack('BB', 0x05, 0x02))           # 500Hz
    wait_for_ack()

# send the set buffer size command
    sock.send(struct.pack('BB', 0x34, 0x01))           # Buffer size=1
    wait_for_ack()

#   enquire()

# send start streaming command
    sock.send(struct.pack('B', 0x07))
    wait_for_ack()

    ecgPlot = streamplot.StreamPlot(saveFileNameStart = "shimmer_ecg_plot",lines = [('l','r','ecg')], exitforce=True)
    ecgPlot.addDataPoint(0, [0])
    Tsample = 1/(1000.0/SAMPLING_RATE_500) # in seconds
    t = 0

    # read incoming data       
    ddata = ""
    numbytes = 0
    framesize = 7  #default. i.e. Packet type (1), TimeStamp (2), RA-LL (2), LA-LL(2)
    oldtimestamp = 0

    try:
        while True:
          while numbytes < framesize:
            ddata += sock.recv(framesize)
            numbytes = len(ddata)

          data = ddata[0:framesize]
          ddata = ddata[framesize:]
          numbytes = len(ddata)
           
          #data = sock.recv(framesize)
          packettype = struct.unpack('B', data[0:1])
          (timestamp, ecgRALL, ecgLALL) = struct.unpack('<HHH', data[1:framesize])
          
          if timestamp > oldtimestamp:
            t += (timestamp - oldtimestamp)/32768.0
            #print timestamp - oldtimestamp
          else:
            t += timestamp/32768.0

          print ecgRALL
          oldtimestamp = timestamp
          ecgPlot.addDataPoint(t, [ecgRALL])
    except KeyboardInterrupt:
        # send stop streaming command
        sock.send(struct.pack('B', 0x20));
        wait_for_ack()
	# close the socket
    sock.close()
    print
    print "All done"
