# cliff.kak: managing clients in Kakoune
`cliff.kak` provides some useful commands for managing clients in Kakoune.
It does not come with any interface directly.
Instead, it is intended for plugin authors and custom scripts.

## Installation
To install manually, do
```
git clone https://github.com/Guest0x0/cliff.kak.git
```
then in your kakrc, do
```
source /path/to/cliff.kak/rc/cliff.kak
```
You can also install via [plug.kak](https://gitlab.com/andreyorst/plug.kak):
```
plug "guest0x0/cliff.kak"
```

## Usage
`cliff.kak` maintains two option values:

- `cliff_buffer_of_clients`: should only has value in global scope.
Holds a map from client name to its current buffer.
- `cliff_clients_of_buffer`: should only has value in buffer scope.
Holds a list of clients displaying current buffer.

These two values are maintained automatically and **SHOULD NOT**
be modified by users.

To query the buffer of a client from `cliff_buffer_of_clients`,
`cliff.kak` provides a utility command `cliff-query-client`.
`cliff-query-client scope option client`
will query for the buffer `client` is currently displaying,
and store it in option value `option` in scope `scope`.

Users can also make use of two user hooks provided by `cliff.kak`:

- `CliffBufClientsChange`:
in buffer scope, triggered when the list of clients
displaying current buffer changes.
- `CliffClientSetBuf,client,bufname`:
in global scope, triggered when a client starts displaying another buffer.
In the hook parameter, `client` is the name of the client
and `bufname` is the name of its new buffer.

Finally, `cliff.kak` provides four utilities for
creating temporary clients and buffers that are "bound"
to a parent client/buffer:

- `cliff-bind-client-to-client child parent`:
bind client `child` to client `parent`.
Close `child` automatically when `parent` closes.

- `cliff-bind-client-to-buffer ...`: similarly
- `cliff-bind-buffer-to-client ...`: similarly
- `cliff-bind-buffer-to-buffer ...`: similarly

## License
0-BSD
