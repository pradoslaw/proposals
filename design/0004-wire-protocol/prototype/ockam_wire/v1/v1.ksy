
meta:
  id: v1
  title: Ockam Wire V1
  imports:
    - header
    - body

seq:
  - id: size
    type: u2
  - id: count_headers
    type: u1
  - id: headers
    type: header
    repeat: count_headers
    repeat-until: _.type == 255

  - id: body
    type: body
