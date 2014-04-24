# Add to known_hosts

A wercker step to use ssh-keyscan to add a host to the known_hosts file.

**Important!** Use the `fingerprint` parameter, otherwise a man-in-the-middle attack is possible.

[![wercker status](https://app.wercker.com/status/85d1e231bf48bd1b3b7d9a2073a6f75a/m "wercker status")](https://app.wercker.com/project/bykey/85d1e231bf48bd1b3b7d9a2073a6f75a)

# What's new

- Add support to specify a key type

# Options

* `hostname` (required) The hostname to scan for a public ssh key.
* `fingerprint` (optional) Only add the public key to `known_hosts` if it matches this fingerprint.
* `type` (optional) Scan for these key types (default: `rsa,dsa,ecdsa`).
* `port` (optional) Probe the ssh server on the following port.
* `local` (optional) Set to true to add the host to the local `known_hosts` file (default: `false`).

# Example

Probe the host `ssh.example.com` for it's public key and see if the fingerprint matches `ce:83:e9:7d:02:a4:e3:63:3f:8a:07:cc:d5:d9:bb:cd`

``` yaml
deploy:
  steps:
    - add-to-known_hosts:
        hostname: ssh.example.com
        fingerprint: ce:83:e9:7d:02:a4:e3:63:3f:8a:07:cc:d5:d9:bb:cd
```

# Getting a fingerprint

...

# License

The MIT License (MIT)

Copyright (c) 2013 wercker

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Changelog

## 1.4.0

- Add support to specify a key type

## 1.3.1

- Fix issue if server returns multiple keys and fingerprint was used

## 1.3.0

- Add fingerprints to global file

## 1.2.0

- Implement filter by fingerprint
- Implement port

## 1.1.0

- Initial release
