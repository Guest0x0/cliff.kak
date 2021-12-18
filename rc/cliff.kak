
declare-option -docstring %{
    the list of clients and their buffer
} str-to-str-map cliff_buffer_of_clients

declare-option -docstring %{
    (in buffer scope) the list of clients displaying the buffer
} str-list cliff_clients_of_buffer


define-command -docstring %{
    `cliff-query-client scope opt client`
    query for the buffer `client` is displaying
    and stores the result of the client in
    `opt` in `scope`.

    Note that in some hooks on startup,
    the result may be empty.
} -params 3 cliff-query-client %{
    set-option %arg{1} %arg{2} %sh{
        for kv in $kak_opt_cliff_buffer_of_clients; do
            client=${kv%%=*}
            buffer=${kv##*=}
            if [ "$client" = "$3" ]; then
               echo "$buffer"
               break
            fi
        done
    }
}




# For internal use
declare-option -hidden str cliff_internal_query_result

hook -group cliff-global global WinDisplay .* %{
    cliff-query-client global cliff_internal_query_result %val{client}

    try %{
        set-option -remove "buffer=%opt{cliff_internal_query_result}" \
            cliff_clients_of_buffer %val{client}

        evaluate-commands -buffer %opt{cliff_internal_query_result} %{
            trigger-user-hook CliffBufClientsChange
        }
    }

    set-option -add "buffer=%val{bufname}" \
        cliff_clients_of_buffer %val{client}

    trigger-user-hook CliffBufClientsChange

    set-option -add global cliff_buffer_of_clients \
        "%val{client}=%val{bufname}"

    trigger-user-hook "CliffClientSetBuf,%val{client},%val{bufname}"
}

hook -group cliff-global global ClientClose .* %{
    set-option -remove global cliff_buffer_of_clients "%val{hook_param}="
}


define-command -docstring %{
    `cliff-bind-client-to-client child parent`
    binds `child` to `parent`.
    When `parent` is closed, `child` will be closes automatically.
} -params 2 cliff-bind-client-to-client %{
    evaluate-commands %sh{
        printf "hook -once global ClientClose %s %%{ " "$2"
        printf "evaluate-commands -client %s quit }\n" "$1"
    }
}

define-command -docstring %{
    `cliff-bind-client-to-buffer client buffer`
    binds `client` to `buffer`,
    when `buffer` is closed, `client` will be closed automatically.
} -params 2 cliff-bind-client-to-buffer %{
    evaluate-commands %sh{
        printf "hook -once global BufClose %s %%{ " "$2"
        printf "evaluate-commands -client %s quit }\n" "$1"
    }
}

define-command -docstring %{
    `cliff-bind-buffer-to-client buffer client`
    binds `buffer` to `client`,
    when `client` is closed, `buffer` will be closed automatically.
} -params 2 cliff-bind-buffer-to-client %{
    evaluate-commands %sh{
        printf "hook -once global ClientClose %s %%{ " "$2"
        printf "delete-buffer %s }\n" "$1"
    }
}

define-command -docstring %{
    `cliff-bind-buffer-to-buffer child parent`
    binds `child` to `parent`,
    when `parent` is closed, `child` will be closed automatically.
} -params 2 cliff-bind-buffer-to-buffer %{
    evaluate-commands %sh{
        printf "hook -once global BufClose %s %%{ " "$2"
        printf "delete-buffer %s }\n" "$1"
    }
}
