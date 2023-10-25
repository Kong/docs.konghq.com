#//# --------------------------------------------------------------------------------------
#//# Created using Sequence Diagram for Mac
#//# https://www.macsequencediagram.com
#//# https://itunes.apple.com/gb/app/sequence-diagram/id1195426709?mt=12
#//# --------------------------------------------------------------------------------------
participant "Client 📱" as client
participant "Kong 🐵" as kong
participant "Keycloak 🔑" as keycloak
participant "httpbin 🌐" as httpbin
activate client
activate kong
client->kong: service with\naccess token
deactivate client
kong->kong: load access token
activate keycloak
kong->keycloak: keycloak/userinfo\nwith client credentials\nand access token
deactivate kong
keycloak->keycloak: "authenticate client and\nverify token"
activate kong
keycloak->kong: return user info \nresponse
deactivate keycloak
kong->kong: verify response\nstatus code (200)
activate httpbin
kong->httpbin: request with access token
httpbin->kong: response
deactivate httpbin
activate client
kong->client: response
deactivate kong
deactivate client