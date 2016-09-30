defmodule OptionCalc.OAuth do
    @moduledoc """
    Copyright (c) 2014, Aleksei Magusev <lexmag@me.com>

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted, provided that the above
    copyright notice and this permission notice appear in all copies.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
    """
    def sign(verb, url, config_key) when is_atom(config_key) do
        sign(verb, url, [], config_key)
    end 

  def sign(verb, url, params, config_key) when is_atom(config_key) do
    args = Application.get_env(:option_calc, config_key)
    sign(verb, url, params, args)
  end 
  def sign(verb, url, params, args) do
    creds = Enum.reduce(args, %{}, fn({key, val}, acc) -> Map.put(acc, key, val) end)
    params = protocol_params(params, creds)
    signature = signature(verb, url, params, creds)

    {oauth_params, req_params} = 
    [{"oauth_signature", signature} | params]
    |>Enum.partition(fn {key, _v} -> String.starts_with?(key, "oauth_") end)

    [{"Authorization", "OAuth " <> compose_header(oauth_params)} | req_params]
  end

  def protocol_params(params, creds) do
    [{"oauth_consumer_key",     creds.consumer_key},
     {"oauth_nonce",            nonce()},
     {"oauth_signature_method", "HMAC-SHA1"},
     {"oauth_timestamp",        timestamp()},
     {"oauth_version",          "1.0"}
     | cons_token(params, creds.token)]
  end

  def signature(verb, url, params, creds) do
    :crypto.hmac(:sha, compose_key(creds), base_string(verb, url, params))
    |> Base.encode64
  end

  defp compose_header([_ | _] = params) do
    Stream.map(params, &percent_encode/1)
    |> Enum.map_join(", ", &compose_header/1)
  end

  defp compose_header({key, value}) do
    key <> "=\"" <> value <> "\""
  end

  defp compose_key(creds) do
    [creds.consumer_secret, creds.token_secret]
    |> Enum.map_join("&", &percent_encode/1)
  end

  defp base_string(verb, url, params) do
    {uri, query_params} = parse_url(url)
    [verb, uri, params ++ query_params]
    |> Stream.map(&normalize/1)
    |> Enum.map_join("&", &percent_encode/1)
  end

  defp normalize(verb) when is_atom(verb),
    do: normalize(Atom.to_string(verb))

  defp normalize(verb) when is_binary(verb),
    do: String.upcase(verb)

  defp normalize(%URI{host: host} = uri),
    do: %{uri | host: String.downcase(host)}

  defp normalize([_ | _] = params) do
    Enum.map(params, &percent_encode/1)
    |> Enum.sort
    |> Enum.map_join("&", &normalize_pair/1)
  end

  defp normalize_pair({key, value}) do
    key <> "=" <> value
  end

  defp parse_url(url) do
    uri = URI.parse(url)
    {%{uri | query: nil}, parse_query_params(uri.query)}
  end

  def parse_query_params(nil), do: []

  def parse_query_params(params) do
    URI.query_decoder(params)
    |> Enum.into([])
  end

  defp nonce() do
    :crypto.strong_rand_bytes(24)
    |> Base.encode64
  end

  defp timestamp() do
    {mgsec, sec, _mcs} = :os.timestamp

    mgsec * 1_000_000 + sec
  end

  defp cons_token(params, nil), do: params
  defp cons_token(params, value),
    do: [{"oauth_token", value} | params]

  defp percent_encode({key, value}) do
    {percent_encode(key), percent_encode(value)}
  end

  defp percent_encode(term) do
    to_string(term)
    |> URI.encode(&URI.char_unreserved?/1)
  end

end

