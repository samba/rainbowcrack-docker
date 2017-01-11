# RainbowCrack in Docker

Crack passwords in a container, whee! Say hello to RainbowCrack.

This container installs RainbowCrack from their web download package, which
offers the following algorithms:

- `lm` (LAN Manager)
- `ntlm`
- `md5`
- `sha1`
- `sha256`

## Usage

The container uses `rcrack` as its entrypoint, so arguments are directly associated
to its interface. To provide rainbow tables, they must be mounted into the container
at `/opt/rainbowcrack/tables`; by default, it will load all files matching the pattern
`*.rt*`

The appropriate arguments to `rcrack` are roughly:

- `-h ${password_hash}` Crack an individual password hash
- `-l ${hashlist_file}` Crack a batch of password hashes (one per line)
- `-f ${pwdump_file}` Crack a batch of LANMAN hashes via `pwdump`
- `-n ${pwdump_file}` Crack a batch of NTLM hashes via `pwdump`


To crack an individual hash:

```shell
docker run -v "`pwd`/tables:/opt/rainbowcrack/tables" \
     -it sbriesemeister/rainbowcrack:latest -h PASSWORD_HASH
```

To crack a batch of hashes, the files must be made available in a docker volume.

```shell
# example: populate the file
echo -n "mypassword" | md5sum | cut -c 1-32 > ./hashlist.txt
docker run -v "`pwd`:/tmp/hash"  -v "`pwd`/tables:/opt/rainbowcrack/tables" \
    -it sbriesemeister/rainbowcrack:latest -l /tmp/hash/hashlist.txt
```

## Testing

Please refer to the `test.sh` script in this repository.

1. Download [the smallest rainbow table I could find][1],
2. Extract them (using lzma, in the `xz` package in Homebrew on OSX)
3. Execute the test script:

```shell
sh test.sh test /path/to/rainbowtables/
```

Note that the path noted above must contain `*.rt` files after decompression.

This test script builds the Docker image, and then executes the container as
noted above.

Some sensible tables (for testing) can be found at:
- http://rainbowtables.shmoo.com/
- http://project-rainbowcrack.com/table.htm


[1]: http://rainbowtables.shmoo.com/3534B723F090BD98C60BECEA24E8827415C2EDF9.torrent
