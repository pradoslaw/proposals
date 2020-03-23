meta:
  id: header
  imports:
    - endpoint

seq:
  - id: type
    type: u1

  - id: value
    type:
      switch-on: type
      cases:
        # 255: reserved to signal end of headers
        0: send_to
        1: reply_to

types:
  send_to:
    seq:
      - id: endpoint
        type: endpoint

  reply_to:
    seq:
      - id: endpoint
        type: endpoint
