
meta:
  id: route
  imports:
    - endpoint

seq:
  - id: count_endpoints
    type: u1
  - id: endpoints
    type: endpoint
    repeat: count_endpoints
