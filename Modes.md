## The following options can be set by Environment Variables


## TRACK\_REWARD\_MILES
* When flights are booked/canceled, the booking service will asynchronously call the flight service to get the number of reward miles and then call the customer service to add/subtract to the total.
* Default: false
    * If true, additional env variables may need to be set on the booking service depending on the service proxy.
    
      amalgam8 example (default):
    
          A8_PROXY=true
    
          A8_CONTROLLER_URL=http://controller:8080
        
      nginx example:
    
          CUSTOMER_SERVICE=nginx1/customer
    
          FLIGHT_SERVICE=nginx1/flight
   
      istio example:
    
          CUSTOMER_SERVICE=customer:9080/customer
    
          FLIGHT_SERVICE=flight:9080/flight
   

## SECURE\_USER\_CALLS
* The auth service will create a JWT during login that will later be verified by the booking and customer services.
* Default: true

## SECURE\_SERVICE\_CALLS
* Service to service calls will uses HMAC encrytpion to verify the authenticity of the call.
* Default: false
