defmodule JWTex do
  @doc """
  Decodes a JWT Token with a given secret
  """
  def decode(parts = [header, second_part, _third_part], secret) do
    header
    |> decode64
    |> Poison.decode!
    |> Dict.fetch!("alg")
    |> String.downcase
    |> case do
      "none" ->
        plaintext(header, second_part)
      "hs" <> keylength when keylength in ~w(256 384 512) ->
        verify_hash(parts, keylength, secret)
      algo -> raise "Unssuported algorithm #{algo}"
    end
  end
  def decode(string, secret) when is_binary(string) do
    String.split(string, ".") |> decode(secret)
  end

  def plaintext(header, second_part) do
    [header, second_part] =
      [header, second_part]
      |> Enum.map(&decode64/1)
      |> Enum.map(&Poison.decode!/1)

    if verify_header(header) do
      {:ok, {header, second_part}}
    else
      {:error, "Header invalid"}
    end
  end

  def verify_hash([header, second_part, third_part], keylength, secret) do
    payload = header <> "." <> second_part
    hash    = :crypto.hmac :"sha#{keylength}", secret, payload


    if encode64(hash) == third_part do
      plaintext(header, second_part)
    else
      {:error, "Invalid signature"}
    end
  end

  defp verify_header({"exp", time}), do: time >= time_now
  defp verify_header({"nbf", time}), do: time <= time_now
  defp verify_header({_, _}), do: true
  defp verify_header(header), do: Enum.all?(header, &verify_header/1)

  defp encode64(string) do
    string
    |> Base.encode64
    |> String.rstrip(?=)
    |> String.replace("+", "-")
    |> String.replace("/", "_")
  end

  defp decode64(string) do
    missing_bytes = (String.length(string) / 4) |> Float.ceil |> round
    valid_string  = String.ljust(string, missing_bytes * 4, ?=)

    valid_string
    |> String.replace("-", "+")
    |> String.replace("_", "/")
    |> Base.decode64!
    |> String.rstrip(?=)
  end

  defp time_now do
    {msec, sec, _} = :os.timestamp
    msec * 1_000_000 + sec
  end
end
