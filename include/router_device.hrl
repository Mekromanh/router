-record(device, {
                 id :: binary() | undefined,
                 name :: binary() | undefined,
                 dev_eui :: binary() | undefined,
                 app_eui :: binary() | undefined,
                 nwk_s_key :: binary() | undefined,
                 app_s_key :: binary() | undefined,
                 join_nonce=0 :: non_neg_integer(),
                 fcnt=0 :: non_neg_integer(),
                 fcntdown=0 :: non_neg_integer(),
                 offset=0 :: non_neg_integer(),
                 channel_correction=false :: boolean(),
                 queue=[] :: [any()]
                }).

-record(device_v1, {
                    id :: binary() | undefined,
                    name :: binary() | undefined,
                    dev_eui :: binary() | undefined,
                    app_eui :: binary() | undefined,
                    nwk_s_key :: binary() | undefined,
                    app_s_key :: binary() | undefined,
                    join_nonce=0 :: non_neg_integer(),
                    fcnt=0 :: non_neg_integer(),
                    fcntdown=0 :: non_neg_integer(),
                    offset=0 :: non_neg_integer(),
                    channel_correction=false :: boolean(),
                    queue=[] :: [any()],
                    key :: map() | undefined
                   }).
