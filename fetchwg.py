import sys
import unofficialkeepsolidvpn as ks

def genwg(email, password, countrycode, devicename, sessid):
    return ks.fetchwg(email, password, countrycode, devicename, sessid)     # dictionary

def export(wg, sessid):
    with open('/etc/wireguard/wg0.conf', 'w') as fp:
        fp.write(wg)
        pass
    with open('/etc/wireguard/sessid.txt', 'w') as fp:
        fp.write(sessid)
        pass
    print("Written wg to \'/etc/wireguard/wg0.conf\' and sessid to \'/etc/wireguard/sessid.txt\'")

if __name__ == '__main__' :
    res = genwg(str(sys.argv[1]), str(sys.argv[2]), str(sys.argv[3]), str(sys.argv[4]), str(sys.argv[5]))   # ['wg']['sessid']
    export(res['wg'], res['sessid'])
