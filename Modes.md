## The following options can be set by Environment Variables


## TRACK\_REWARD\_MILES
* When flights are booked/canceled, the booking service will asynchronously call the flight service to get the number of reward miles and then call the customer service to add/subtract to the total.
* Default: true

## SECURE\_USER\_CALLS
* The auth service will create a JWT during login that will later be verified by the booking and customer services.
* Default: true

## SECURE\_SERVICE\_CALLS
* Service to service calls will uses HMAC encryption to verify the authenticity of the call.
* Default: false
