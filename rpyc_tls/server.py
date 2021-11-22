import rpyc
from rpyc.utils.server import ThreadedServer
from rpyc.utils.authenticators import SSLAuthenticator

class DictionaryService(rpyc.Service):
    def exposed_test(self, a):
        return {"arg": a}

if __name__ == "__main__":
    authenticator = SSLAuthenticator(
        keyfile="/certs/gecco.key",
        certfile="/certs/gecco.crt"
    )

    server = ThreadedServer(
        DictionaryService,
        port=18862,
        protocol_config={"allow_public_attrs": True},
        authenticator=authenticator
    )
    server.start()