#//# --------------------------------------------------------------------------------------
#//# Created using Sequence Diagram for Mac
#//# https://www.macsequencediagram.com
#//# https://itunes.apple.com/gb/app/sequence-diagram/id1195426709?mt=12
#//# --------------------------------------------------------------------------------------
participant "User 👴🏻" as user
participant "Browser 🧭" as browser
participant "Kong 🐵" as kong
participant "Keycloak 🔑" as keycloak
participant "httpbin 🌐" as httpbin
activate user
activate browser
user->browser: service with\nquery arguments
deactivate user
activate kong
browser->kong: service with\nquery arguments
kong->browser: redirect to keycloak\nwith client parameters
deactivate kong
activate keycloak
browser->keycloak: keycloak/auth with\nclient parameters
deactivate browser
keycloak->keycloak: "verify client parameters"
activate browser
keycloak->browser: login page
deactivate keycloak
activate user
browser->user: login page
user->browser: "login with user\ncredentials"
deactivate user
activate keycloak
browser->keycloak: "keycloak/auth with\nuser credentials"
deactivate browser
keycloak->keycloak: verify user credentials
activate browser
keycloak->browser: "redirect to service with\nauthorization code"
deactivate keycloak
activate kong
browser->kong: "service with\nauthorization code
deactivate browser
kong->kong: verify authorization\ncode flow
activate keycloak
kong->keycloak: "keycloak/token\nwith client credentials\nand authorization code"
deactivate kong
keycloak->keycloak: "authenticate client and\nverify authorization code"
activate kong
keycloak->kong: return tokens
deactivate keycloak
kong->kong: verify tokens
activate browser
kong->browser: "redirect to service\nwith query arguments\nand session cookie"
browser->kong: service with\nquery arguments\nand session cookie"
deactivate browser
kong->kong: verify session cookie
activate httpbin
kong->httpbin: request with access token\nand query arguments
httpbin->kong: response
deactivate httpbin
activate browser
kong->browser: response
deactivate kong
activate user
browser->user: response
deactivate browser
deactivate user