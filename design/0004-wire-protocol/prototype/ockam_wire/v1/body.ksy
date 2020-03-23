meta:
  id: body
  imports:
    - ping
    - pong
    - payload
    - payload_aead_aes_gcm
    - key_agreement_t1_m1
    - key_agreement_t1_m2
    - key_agreement_t1_m3

seq:
  - id: type
    type: u1

  - id: body
    type:
      switch-on: type
      cases:
         0: ping
         1: pong

         2: payload
         3: payload_aead_aes_gcm

         4: key_agreement_t1_m1
         5: key_agreement_t1_m2
         6: key_agreement_t1_m3
