defmodule KC.Util.SecureRandom do
  @moduledoc """
  Ruby-like SecureRandom module.

  ## Examples

      iex> KC.Util.SecureRandom.base64
      "xhTcitKZI8YiLGzUNLD+HQ=="

      iex> KC.Util.SecureRandom.urlsafe_base64(4)
      "pLSVJw"

  """

  @default_length 16

  @doc """
  Returns random Base64 encoded string.

  ## Examples

      iex> KC.Util.SecureRandom.base64
      "rm/JfqH8Y+Jd7m5SHTHJoA=="

      iex> KC.Util.SecureRandom.base64(8)
      "2yDtUyQ5Xws="

  """
  def base64(n \\ @default_length) when is_integer n do
    randomBytes(n)
    |> :base64.encode_to_string
    |> to_string
  end

  @doc """
  Returns random hex string.

  ## Examples

      iex> KC.Util.SecureRandom.hex
      "c3d3b6cdab81a7382fbbae33407b3272"

      iex> KC.Util.SecureRandom.hex(8)
      "125583e32b698259"

  """
  def hex(n \\ @default_length) when is_integer n do
    bytes = randomBytes(n)

    (for <<num <- bytes>>, do: Integer.to_string(num, 16))
    |> Enum.join
    |> String.downcase
  end

  @doc """
  Returns UUID v4. Not implemented yet.
  """
  def uuid do
    raise NotImplemented
  end

  @doc """
  Returns random number.

  ## Examples

      iex> KC.Util.SecureRandom.randomNumber
      0.11301116455519611

      iex> KC.Util.SecureRandom.randomNumber(42)
      31

      iex> KC.Util.SecureRandom.randomNumber(14..42)
      28

      iex> KC.Util.SecureRandom.randomNumber(14, 42)
      18

  """
  def randomNumber do
    :random.seed({:crypto.rand_uniform(1, 99999), :crypto.rand_uniform(1, 99999), :crypto.rand_uniform(1, 99999)})
    :random.uniform
  end
  def randomNumber(x) when is_integer x do
    :crypto.rand_uniform(1, x)
  end

  def randomNumber(first .. last) do
    :crypto.rand_uniform(first, last)
  end

  def randomNumber(x, y) when is_integer(x) and is_integer(y) do
    :crypto.rand_uniform(x, y)
  end

  @doc """
  Returns random bytes.

  ## Examples

      iex> KC.Util.SecureRandom.randomBytes
      <<202, 104, 227, 197, 25, 7, 132, 73, 92, 186, 242, 13, 170, 115, 135, 7>>

      iex> KC.Util.SecureRandom.randomBytes(8)
      <<231, 123, 252, 174, 156, 112, 15, 29>>

  """
  def randomBytes(n \\ @default_length) when is_integer n do
    :crypto.strong_rand_bytes(n)
  end
end
