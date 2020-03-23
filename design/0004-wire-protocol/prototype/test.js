const OckamWire = require("./OckamWire");
const KaitaiStream = require('kaitai-struct/KaitaiStream');

const ping                         = new Uint8Array([1,255,0])
const ping_with_send_to_header     = new Uint8Array([1, 0,0,1,1, 1,0,1,1 ,255, 0])


const pong                         = new Uint8Array([1,255,1])
const payload                      = new Uint8Array([1,255,2,2,100,100])
const ping_in_paylod               = new Uint8Array([1,255,2,2,1,255,0])
const payload_aead_aes_gcm         = new Uint8Array([1,255,3,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])

const key_agreement_t1_m1          = new Uint8Array([1,255,4,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
const key_agreement_t1_m2          = new Uint8Array([1,255,5,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
const key_agreement_t1_m3          = new Uint8Array([1,255,6,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])

const message = new OckamWire(new KaitaiStream(ping_with_send_to_header))
console.log(message.withoutVersion.headers.length)
