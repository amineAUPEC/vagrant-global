from scapy.all import *


def send_file_over_icmp(ip,filename):
    with open(filename, 'rb') as f:
        data = f.read()

        chunks = [data[i:i+48] for i in range(0, len(data), 48)]

        for chunk in chunks:
            send(IP(dst=ip)/ICMP()/chunk)

            packet= IP(dst=ip)/ICMP()/chunk
            send(packet)

send_file_over_icmp('192.168.100.51', 'test.txt')


# 