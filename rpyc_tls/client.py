import rpyc

def test_server():
    c = rpyc.ssl_connect(
        "gecco.colorifix.com",
        port=18861,
        keyfile="/path_to_certs/certs/client.key",
        certfile="/path_to_certs/certs/certs/client.crt",
        ssl_version=2
    )
    ret = c.root.test("54")
    print(ret["arg"])

if __name__ == "__main__":
    test_server()