
meta:
  id: v1
  title: Ockam Wire V1
  imports:
    - header
    - body

seq:
  - id: headers
    type: header
    repeat: until
    repeat-until: _.type == 255

  - id: body
    type: body
