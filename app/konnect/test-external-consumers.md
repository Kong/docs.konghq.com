curl -X POST \
   https://us.api.konghq.com/v0/realms \
   -H "Content-Type: application/json" \
   -H "Authorization: Bearer kpat_fq3y8H8euZg7lnGgEXIK8vebZAvufF53fCiOTQOos29AQNWbl" \
   -d '{
         "name": "prod",
         "allowed_control_planes": ["dianas-cp"],
         "TTL": {1,-5} 
       }'