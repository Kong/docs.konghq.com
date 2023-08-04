#//# --------------------------------------------------------------------------------------
#//# Created using Sequence Diagram for Mac
#//# https://www.macsequencediagram.com
#//# https://itunes.apple.com/gb/app/sequence-diagram/id1195426709?mt=12
#//# --------------------------------------------------------------------------------------
participant "Client 📱" as client
participant "Kong 🐵" as kong
participant "httpbin 🌐" as httpbin
activate client
activate kong
client->kong: service with\naccess token
deactivate client
kong->kong: load access token
kong->kong: verify kong\noauth token
activate httpbin
kong->httpbin: request with\naccess token
httpbin->kong: response
deactivate httpbin
activate client
kong->client: response
deactivate kong
deactivate client