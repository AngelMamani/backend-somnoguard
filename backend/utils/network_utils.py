import socket


def ObtenerIpRecomendada():
    try:
        Socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        Socket.connect(("8.8.8.8", 80))
        Ip = Socket.getsockname()[0]
        Socket.close()
        return Ip
    except OSError:
        return None


def ObtenerIpsLocales():
    Ips = set()
    IpRecomendada = ObtenerIpRecomendada()

    if IpRecomendada:
        Ips.add(IpRecomendada)

    try:
        NombreHost = socket.gethostname()
        for Ip in socket.gethostbyname_ex(NombreHost)[2]:
            if _EsIpUtil(Ip):
                Ips.add(Ip)
    except OSError:
        pass

    Ordenadas = sorted(Ips, key=lambda Ip: (0 if Ip == IpRecomendada else 1, _PrioridadIp(Ip)))
    return IpRecomendada, Ordenadas


def _EsIpUtil(Ip):
    if Ip.startswith("127."):
        return False
    if Ip.startswith("169.254."):
        return False
    return True


def _PrioridadIp(Ip):
    if Ip.startswith("192.168."):
        return 0
    if Ip.startswith("10."):
        return 1
    if Ip.startswith("172."):
        return 2
    return 9


def ImprimirUrlsBackend(Puerto=5000):
    IpRecomendada, Ips = ObtenerIpsLocales()

    print("\n" + "=" * 50)
    print("  BACKEND SOMNOGUARD - URLs para la app movil")
    print("=" * 50)
    print(f"  PC (local):     http://localhost:{Puerto}")
    print(f"  Prueba web:     http://localhost:{Puerto}/probar")

    if Ips:
        print("\n  Celular (misma WiFi):")
        for Ip in Ips:
            Marca = "  >>> USA ESTA" if Ip == IpRecomendada else "     alternativa"
            print(f"    {Marca}  http://{Ip}:{Puerto}")
    else:
        print("\n  Ejecuta en PowerShell: ipconfig")
        print("  Busca 'Adaptador de LAN inalambrica Wi-Fi' -> IPv4")

    print("\n  La IP cambia cada vez que cambias de WiFi.")
    print("=" * 50 + "\n")
