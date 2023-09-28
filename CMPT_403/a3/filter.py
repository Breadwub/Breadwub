import sys
import ipaddress

def collect_malicious_packet_numbers(connections, src_ip):
    packet_number_list = []
    for item in connections[src_ip]:
        packet_number_list.append(item[0])
    return packet_number_list

def is_tcp_syn(protocol, SYN_value):
    return (protocol == "06" and SYN_value == "02")

def filter_packets_syn(filename):
    # Open file containing the packets
    file = open(filename, 'r')
    file_lines = file.readlines()

    # Put packets' packet number their data into corresponding lists.
    packet_numbers = []
    packet_data = []
    current_packet_data = ""
    for file_line in file_lines:
        # Obtain packet number if current file line contains it.
        # .strip() to clear any trailing whitespaces(' ', \t, \n)
        if file_line.strip().isdigit():
            packet_numbers.append(int(file_line.strip()))
            # Append all currently processed data into list, and clear out the variable.
            insert_packet_data(packet_data, current_packet_data)
            current_packet_data = ""
        else:
            # Process data to remove unnecessary information and whitespaces.
            processed_line = file_line.strip().replace(' ', '')
            index = processed_line.find(':')
            current_packet_data += processed_line[index+1:]

    # Insert last set of packet data into the packet_data list.
    insert_packet_data(packet_data, current_packet_data)

    # Dictionary for connections -> ip_address : [port_number]
    connections = {}
    malicious_packets = []
    malicious_src_ip = []
    for packet_number, data in zip(packet_numbers, packet_data):
        protocol = data[18:20]
        SYN_value = data[66:68]
        src_ip = data[24:32], 16
        dest_ip = data[32:40]
        dest_port = data[44:48]
        if (is_tcp_syn(protocol, SYN_value)):
            if src_ip not in connections:
                connections[src_ip] = [(packet_number, dest_port)]
            else:
                if(len(connections[src_ip]) < 10):
                    connections[src_ip].append((packet_number, dest_port))
                else:
                    packet_list = collect_malicious_packet_numbers(connections, src_ip)
                    if (src_ip not in malicious_src_ip):
                        malicious_src_ip.append(src_ip)
                        malicious_packets += packet_list
    
    for packet_number in packet_numbers:
        if packet_number in malicious_packets:
            print(str(packet_number) + ' ' + "yes")
        else:
            print(str(packet_number) + ' ' + "no")

def is_smurf_attack(src_ip, dest_ip):
    subnet = ipaddress.IPv4Network("142.58.22.0/24")
    source_ip = ipaddress.IPv4Address(src_ip)
    destination_ip = ipaddress.IPv4Address(dest_ip)
    return (source_ip in subnet) and (destination_ip == subnet.broadcast_address)

def is_ping_of_death(fragment_offset_size, packet_length):
    return packet_length + fragment_offset_size * 8 > 65535

def convert_to_dec(hex_bits):
    bin_bits = bin(int(hex_bits, 16))[2:]
    dec_value = int(bin_bits, 2)
    return dec_value

def extract_fragment_bin_bits(hex_bits):
    bits = bin(int(hex_bits, 16))[2:].zfill(len(hex_bits) * 4)
    # Remove the first 3 bits, as it is not part of the fragment offset.
    bits = bits[3:]
    return bits
    
def is_icmp_echo(protocol, type):
    return protocol == "01" and type == "08"

def filter_packets_ping(filename):
    # Open file containing the packets
    file = open(filename, 'r')
    file_lines = file.readlines()

    # Put packets' packet number their data into corresponding lists.
    packet_numbers = []
    packet_data = []
    current_packet_data = ""
    for file_line in file_lines:
        # Obtain packet number if current file line contains it.
        # .strip() to clear any trailing whitespaces(' ', \t, \n)
        if file_line.strip().isdigit():
            packet_numbers.append(int(file_line.strip()))
            # Append all currently processed data into list, and clear out the variable.
            insert_packet_data(packet_data, current_packet_data)
            current_packet_data = ""
        else:
            # Process data to remove unnecessary information and whitespaces.
            processed_line = file_line.strip().replace(' ', '')
            index = processed_line.find(':')
            current_packet_data += processed_line[index+1:]

    # Insert last set of packet data into the packet_data list.
    insert_packet_data(packet_data, current_packet_data)

    for packet_number, data in zip(packet_numbers, packet_data):
        # Retrieve data from specific parts of the packet
        protocol = data[18:20]
        type = data[40:42]
        packet_length = convert_to_dec(data[4:8])
        src_ip = int(data[24:32], 16)
        dest_ip = int(data[32:40], 16)
        # Retrieve fragment offset hex_bits, convert to binary, and remove first 3 bits that
        # aren't part of the offset.
        fragment_offset_bin_bits = extract_fragment_bin_bits(data[12:16])
        fragment_offset_size = int(fragment_offset_bin_bits, 2)
        # if it is an IMCP echo AND (a ping of death OR a smurf attack), then yes -> malicious pack; drop it.
        # otherwise, no -> don't drop it.
        if (is_icmp_echo(protocol, type) 
            and is_ping_of_death(fragment_offset_size, packet_length) 
            or is_smurf_attack(src_ip, dest_ip)):
            print(str(packet_number) + ' ' + "yes")
        else:
            print(str(packet_number) + " no")

def is_egress_packet(src_ip, dest_ip):
    subnet = ipaddress.IPv4Network("142.58.22.0/24")
    is_inside_subnet = ipaddress.IPv4Address(src_ip) in subnet
    is_outside_subnet = ipaddress.IPv4Address(dest_ip) not in subnet
    return is_inside_subnet and is_outside_subnet

def insert_packet_data(packet_data, current_packet_data):
    if current_packet_data != "":
        packet_data.append(current_packet_data)

def filter_packets_egress(filename):
    # Open file containing the packets
    file = open(filename, 'r')
    file_lines = file.readlines()

    # Put packets' packet number their data into corresponding lists.
    packet_numbers = []
    packet_data = []
    current_packet_data = ""
    for file_line in file_lines:
        # Obtain packet number if current file line contains it.
        # .strip() to clear any trailing whitespaces(' ', \t, \n)
        if file_line.strip().isdigit():
            packet_numbers.append(int(file_line.strip()))
            # Append all currently processed data into list, and clear out the variable.
            insert_packet_data(packet_data, current_packet_data)
            current_packet_data = ""
        else:
            # Process data to remove unnecessary information and whitespaces.
            processed_line = file_line.strip().replace(' ', '')
            index = processed_line.find(':')
            current_packet_data += processed_line[index+1:]

    # Insert last set of packet data into the packet_data list.
    insert_packet_data(packet_data, current_packet_data)

    for packet_number, data in zip(packet_numbers, packet_data):
        src_ip = int(data[24:32], 16)
        dest_ip = int(data[32:40], 16)
        if is_egress_packet(src_ip, dest_ip):
            # If it is an egress packet, then it is not malicious -> no (it is not malicious; should not be dropped)
            # If it is NOT an egress packet, then it is  malicious -> yes (it is a malicious packet; should be dropped)
            print(str(packet_number) + ' ' + "no")
        else:
            print(str(packet_number) + " yes")
        

if len(sys.argv) != 3:
    # print("Incorrect usage. Use: \"python3 filter.py <-i or -j or -k> <filename>\"")
    sys.exit(1)

option = sys.argv[1]
filename = sys.argv[2]

match option:
    # Do egress filtering on packets
    case "-i":
        filter_packets_egress(filename)
    case "-j":
        filter_packets_ping(filename)
    case "-k":
        filter_packets_syn(filename)
    case _:
        # print("Incorrect usage. Use: \"python3 filter.py <-i or -j or -k> <filename>\"")
        sys.exit()
