defmodule JWTexTest do
  use ExUnit.Case

  test "#decode with sha 256" do
    token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." <>
      "eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9." <>
      "TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ"

    {:ok, [first_part, second_part]} = JWTex.decode token, "secret"

    assert first_part["alg"] == "HS256"
    assert first_part["typ"] == "JWT"

    assert second_part["sub"] == "1234567890"
    assert second_part["name"] == "John Doe"
    assert second_part["admin"] == true
  end

  test "decode crypt" do
    token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImV4cCI6MTQzMDMzMDI2MH0." <>
      "eyJhbGciOiJKb3PDqSBWYWxpbSJ9." <>
      "XyXnzIjSw9ghBF7HNa1BAQb1G-O8MXOjG1b-wF-4lbHfo4wdhNAy5uB4SE3xvj6dbth1QpFhwCIABQyg3kNUow"

    assert JWTex.decode(token, "secret") == {:error, "Header invalid"}
  end
end
