"""
Generate the netmask commands for identifying IP Address ranges OUTSIDE OF salesforce IPs.
"""

from netaddr import IPNetwork, IPAddress

CIDR_LIST = [
    "10.0.0.0/8",
    "192.168.0.0/16",
    "172.16.0.0/12",
    "61.120.150.128/28",
    "62.17.146.128/26",
    "85.222.134.0/24",
    "142.176.79.168/29",
    "202.95.77.64/27",
    "204.14.236.0/24",
    "204.14.239.0/24",
    "221.133.209.128/27"
]

def get_new_ip_network(cidr):
    ip_network = IPNetwork(cidr)
    return ip_network


def get_first_address_in_network(cidr):
    ip_network = IPNetwork(cidr)
    return IPAddress(ip_network.first)


def get_last_address_in_network(cidr):
    ip_network = IPNetwork(cidr)
    return IPAddress(ip_network.last)


def get_first_address_in_network_minus_one(cidr):
    ip_network = IPNetwork(cidr)
    return IPAddress(ip_network.first).__sub__(1)


def get_last_address_in_network_plus_one(cidr):
    ip_network = IPNetwork(cidr)
    return IPAddress(ip_network.last).__add__(1)


def combine_cidrs():
    print(f"netmask -c 0.0.0.0:{get_first_address_in_network_minus_one(CIDR_LIST[0])}")
    i = 0
    how_long = len(CIDR_LIST) + 1
    while i < how_long:
        # print(i)
        if i is len(CIDR_LIST) -1:
            print(f"netmask -c {get_last_address_in_network_plus_one(CIDR_LIST[i])}:255.255.255.255")
            i += 2
        else:
            print(f"netmask -c {get_last_address_in_network_plus_one(CIDR_LIST[i])}:{get_first_address_in_network_minus_one(CIDR_LIST[i + 1])}")
            i += 1


if __name__ == '__main__':
    combine_cidrs()
