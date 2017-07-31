# Add to known_hosts

A wercker step to use ssh-keyscan to add a host to the known_hosts file. This step requires 
`ssh-keyscan` to be installed.

**Important!** Use the `fingerprint` parameter, otherwise a man-in-the-middle attack is possible.

[![wercker status](https://app.wercker.com/status/85d1e231bf48bd1b3b7d9a2073a6f75a/m "wercker status")](https://app.wercker.com/project/bykey/85d1e231bf48bd1b3b7d9a2073a6f75a)

The fingerprint has to be in MD5/hex format, starting from the OpenSSH version 6.8 the fingerprints are reported by default in SHA256/Base64, to get the MD5/hex version we use the new FingerprintHash flag of the ssk-keygen command, that flag is supported by the OpneSSH 6.8 version.

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

## Example

Probe the host `ssh.example.com` for it's public key and see if the fingerprint matches `ce:83:e9:7d:02:a4:e3:63:3f:8a:07:cc:d5:d9:bb:cd`

``` yaml
deploy:
  steps:
    - add-to-known_hosts:
        hostname: ssh.example.com
        fingerprint: ce:83:e9:7d:02:a4:e3:63:3f:8a:07:cc:d5:d9:bb:cd
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

__Step fails with the message: "...unknown option -- E"__

It looks like the OpenSSH version is older than OpenSSH 6.8 so the new FingerprintHash flag (-E) is not supported, to fix the issue you can update the version of OpenSSH or downgrade the version of the step, to do that in your wercker.yml write you can specify the version you want to use, for example:

```
- add-to-known_hosts@2.0.1:
     hostname: <HOSTNAME>
     fingerprint: <FINGERPRINT>

```

__Step fails with the message "...Skipped adding a key to known_hosts, it did not match the fingerprint (SHA256:...)"__

It looks like that the fingerprint is reported in the format SHA256/base64, to fix the issue if the OpenSSH version is equal or greater than 6.8 you can try to use the 2.0.3 version of the step which converts the format from SHA256/base64 to MD5/hex.
If you have the same error, then please verify that you put the correct fingerprint in your wercker.yml file.

If it is not possible to upgrade the version of OpenSSH you can specify in your wercker.yml the fingerprint in the SHA256/base64 format.

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

### 2.0.3
- bug fix: Add the '-E' flag to the ssh-keygen command to report the fingerprint in the MD5/hex format.

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
