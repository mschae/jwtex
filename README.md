Jwtex
=====

A library to en- and decode JWT tokens.

Supports the following alogrithms:

- plaintext
- HS256
- HS384
- HS512

Will add more in the future.

Supports the following properties:

- exp
- nbf

## Usage

```elixir
    JWTex.decode "to.ke.n", "secret
```
