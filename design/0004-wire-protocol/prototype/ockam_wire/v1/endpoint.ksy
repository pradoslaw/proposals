
meta:
  id: endpoint
  imports:
    - public_key
    - ../variable_length_encoded_u2le

seq:
  - id: type
    type: u1

  - id: value
    type:
      switch-on: type
      cases:
        0: local_endpoint
        1: channel_endpoint
        2: tcp_endpoint_ipv4
        3: tcp_endpoint_ipv6
        4: udp_endpoint_ipv4
        5: udp_endpoint_ipv6

types:
  local_endpoint:
    seq:
      - id: length
        type: variable_length_encoded_u2le
      - id: data
        size: length.value

  channel_endpoint:
    seq:
      - id: pk
        type: public_key
      - id: endpoint
        type: endpoint

  tcp_endpoint_ipv4:
    seq:
      - id: ip
        type: u4le
      - id: port
        type: u2le

  tcp_endpoint_ipv6:
    seq:
      - id: ip
        size: 16 # variable length encode this?
      - id: port
        type: u2le

  udp_endpoint_ipv4:
    seq:
      - id: ip
        type: u4le
      - id: port
        type: u2le

  udp_endpoint_ipv6:
    seq:
      - id: ip
        size: 16 # variable length encode this?
      - id: port
        type: u2le
