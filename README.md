# Add to known_hosts

A wercker step to use ssh-keyscan to add a host to the known_hosts file. This step requires 
`ssh-keyscan` to be installed.

**Important!** Use the `fingerprint` parameter, otherwise a man-in-the-middle attack is possible.

Please note that if you run OpenSSH version equals or greater than 6.8 the fingerprint is reported by default in the `SHA256/base64` format.

[![wercker status](https://app.wercker.com/status/85d1e231bf48bd1b3b7d9a2073a6f75a/m "wercker status")](https://app.wercker.com/project/bykey/85d1e231bf48bd1b3b7d9a2073a6f75a)

## GitHub

The following example adds GitHub's SSH key to the known_hosts file, using the
correct fingerprint (https://help.github.com/articles/what-are-github-s-ssh-key-fingerprints/):

```yaml
- add-to-known_hosts:
    hostname: github.com
    fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
    type: rsa
```

## Bitbucket

The following example adds Bitbucket's SSH key to the known_hosts file, using
the correct fingerprint (https://confluence.atlassian.com/bitbucket/use-the-ssh-protocol-with-bitbucket-cloud-221449711.html):

```yaml
- add-to-known_hosts:
    hostname: bitbucket.org
    fingerprint: 97:8c:1b:f2:6f:14:6b:5c:3b:ec:aa:46:46:74:7c:40
    type: rsa
```
## Dependencies

- `mktemp`
- `ssh-keyscan`
- `ssh-keygen`

## What's new

- improved error message when `/etc/ssh` does not exist (and not adding it locally)
- improved error message when `ssh-keyscan` can't be found

## Options

* `hostname` (required) The hostname to scan for a public ssh key.
* `fingerprint` (optional) Only add the public key to `known_hosts` if it matches this fingerprint.
* `type` (optional) Scan for these key types (default: `rsa,dsa,ecdsa`).
* `port` (optional) Probe the ssh server on the following port.
* `local` (optional) Set to `true` to add the host to `$HOME/.ssh/known_hosts` file instead of `/etc/ssh/ssh_known_hosts` (default: `false`).
* `use-md5` (optional) Set to `true` to use `MD5/hex` format for the key
fingerprint. Please note that if you are using OpenSSH version equal or
greater than 6.8 the fingerprint are reported in `SHA256/base64` format by
default, that means that if you have your key fingerprint specified in
`MD5/hex` format you have either to change your wercker.yml and specify the
`SHA256` format of your key fingerprint or set the `use-md5` parameter to
`true` (default: `false`).

## Example

Probe the host `ssh.example.com` for it's public key and see if the fingerprint matches `ce:83:e9:7d:02:a4:e3:63:3f:8a:07:cc:d5:d9:bb:cd`, using OpenSSH version < 6.8

``` yaml
deploy:
  steps:
    - add-to-known_hosts:
        hostname: ssh.example.com
        fingerprint: ce:83:e9:7d:02:a4:e3:63:3f:8a:07:cc:d5:d9:bb:cd
```

Probe the host `ssh.example.com` for it's public key and see if the fingerprint matches `ce:83:e9:7d:02:a4:e3:63:3f:8a:07:cc:d5:d9:bb:cd`, using OpenSSH version >= 6.8

``` yaml
deploy:
  steps:
    - add-to-known_hosts:
        hostname: ssh.example.com
        use-md5: "true"
        fingerprint: ce:83:e9:7d:02:a4:e3:63:3f:8a:07:cc:d5:d9:bb:cd
```

Define key fingerprint for github

```yaml
deploy:
  steps:
    - add-to-known_hosts:
        hostname: github.com
        fingerprint: nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8
```


Define key fingerprint for bitbucket

```yaml
deploy:
  steps:
    - add-to-known_hosts:
        hostname: bitbucket.org
        fingerprint: zzXQOXSRBEiUtuE8AikJYKwbHaxvSc0ojez9YXaGp1A
```
## FAQ

__Step fails with the message: "... Cause: ssh-client software probably not installed."__

It looks like there's no ssh client software installed. This is probably resolved by adding an install-packages step that installs an openssh-client (works on ubuntu/debian based
containers):

```
build:
  steps:
    - install-packages:
        packages: openssh-client
    - add-to-known_hosts:
        ...
```

## Getting a fingerprint

...

## License

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

## Changelog

### 2.0.4
- Add the `use-md5` option to force the use of the `-E` flag in the ssh-keygen command.

### 2.0.3
- bug fix: Add the `-E` flag to the ssh-keygen command to report the fingerprint in the `MD5/hex` format.

### 2.0.2

- Add example section for GithHub and Bitbucket's SSH key's

### 2.0.1

- bug fix: incorrect use of `>`: known_hosts file was not updated

### 2.0.0

- improved error message when `/etc/ssh` does not exist (and not adding it locally)
- improved error message when `ssh-keyscan` can't be found

### 1.4.0

- Add support to specify a key type

### 1.3.1

- Fix issue if server returns multiple keys and fingerprint was used

### 1.3.0

- Add fingerprints to global file

### 1.2.0

- Implement filter by fingerprint
- Implement port

### 1.1.0

- Initial release
