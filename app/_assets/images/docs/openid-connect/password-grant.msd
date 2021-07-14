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
client->kong: service with\nbasic authentication
deactivate client
kong->kong: load basic\nauthentication\ncredentials
activate keycloak
kong->keycloak: keycloak/token with\nclient credentials and\npassword grant
deactivate kong
keycloak->keycloak: "authenticate client and\nverify password grant"
activate kong
keycloak->kong: return tokens
deactivate keycloak
kong->kong: verify tokens
activate httpbin
kong->httpbin: request with access token
httpbin->kong: response
deactivate httpbin
activate client
kong->client: response
deactivate kong
deactivate client