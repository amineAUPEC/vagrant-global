from scapy.all import *
def receive_file_over_icmp():
    def process_packet(packet):
            data = packet[Raw].load

            with open(filename, 'ab') as f:
                f.write(data)
    sniff(filter='icmp', prn=process_packet)

receive_file_over_icmp('receive.txt')