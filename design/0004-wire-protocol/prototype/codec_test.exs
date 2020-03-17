Code.compile_file("codec.exs", __DIR__)

defmodule Test do

  def test_encode do
    <<1, 0>> = Ockam.Wire.encode_message(%Ockam.Message.Ping{})
    <<1, 1>> = Ockam.Wire.encode_message(%Ockam.Message.Pong{})
  end

  def test_decode do
    {%Ockam.Message.Ping{}, <<>>} = Ockam.Wire.decode_message(<<1, 0>>)
    {%Ockam.Message.Pong{}, <<>>} = Ockam.Wire.decode_message(<<1, 1>>)
    {%Ockam.Message.Payload{}, <<>>} = Ockam.Wire.decode_message(<<1, 2, 2, 100, 100>>)
    {%Ockam.Message.Payload.AuthenticatedEncrypted{}, <<>>} =
      Ockam.Wire.decode_message(<<1, 3, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>)
    {%Ockam.Message.KeyAgreement.T1.M1{}, <<>>} =
      Ockam.Wire.decode_message(<<1, 4, 33, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>)
    {%Ockam.Message.KeyAgreement.T1.M1{}, <<>>} =
      Ockam.Wire.decode_message(<<1, 5, 33, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>)
    {%Ockam.Message.KeyAgreement.T1.M1{}, <<>>} =
      Ockam.Wire.decode_message(<<1, 6, 33, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>)
  end

end

Test.test_decode
Test.test_encode
