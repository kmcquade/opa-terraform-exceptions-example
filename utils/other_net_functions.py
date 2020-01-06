import ipaddress

from netaddr import *

def getFirstIp(ipAddress, subnet):
    ipBin = IPNetwork(ipAddress).ip.bits().split('.')
    subBin = IPNetwork(subnet).ip.bits().split('.')
    zipped = zip(ipBin, subBin)
    netIdList = []
    for octets in zipped:
        netIdList.append(''.join(str(b) for b in (map((lambda x: int(x[0])*int(x[1])), zip(list(octets[0]), list(octets[1]))))))
    firstIp = ''
    firstIp = '.'.join(str(int(oct, 2)) for oct in netIdList)
    return firstIp


def getLastIp(ipAddress, subnet):
    ipBin = IPNetwork(ipAddress).ip.bits().split('.')
    subBin = IPNetwork(subnet).ip.bits().split('.')
    #print ipBin
    #print subBin
    revsubBin = []
    for octets in subBin:
        revB = ''.join('1' if(b == '0') else '0' for b in octets)
    revsubBin.append(revB)
    zipped = zip(ipBin, revsubBin)
    netIdList = []
    # print(zipped)
    for octets in zipped:
        # print(octets)
        netIdList.append(''.join(str(b) for b in (map((lambda x: 0 if(int(x[0]) == 0 and int(x[1]) == 0) else 1), zip(list(octets[0]), list(octets[1]))))))
    # print(netIdList)
    lastIp = ''
    lastIp = '.'.join(str(int(oct, 2)) for oct in netIdList)
    for oct in netIdList:
        lastIpTest = '.'.join(str(int(oct, 2)))
    print(lastIpTest)
    return lastIp


def getRangeOfIps(firstIp, lastIp):
    start = int(IPAddress(firstIp))
    end = int(IPAddress(lastIp))
    ipList = []
    for ip in range(start, end+1):
        ipList.append(str(IPAddress(ip)))
    return ipList


def manipulateIP(ipAddress, subnet):
    firstIp = getFirstIp(ipAddress, subnet)
    lastIp = getLastIp(ipAddress, subnet)
    ipList = getRangeOfIps(firstIp, lastIp)
    # print(ipList)

if __name__ == '__main__':
    # stuff()
    manipulateIP('61.120.150.128', '255.255.255.0')
