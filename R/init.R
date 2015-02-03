# class constructor:
rga.open <- function(instance = "ga",
                     client.id = "583811151505-bljlfanod0uuhpjrg17tvm9rsqomb017.apps.googleusercontent.com",
                     client.secret = "FPnFtNQIYVMheqcSJLeERlX ",
                     where, envir = .GlobalEnv) {

    if (exists(instance, where = envir)) {
        get(instance, envir = envir, mode = "S4")$prepare()
    } else {
        if (missing("where")) {
            # where is not set
            token <- .rga.getToken(client.id, client.secret)
            assign(instance, rga$new(client.id, client.secret, where = "", token), envir = envir)
        } else {
            if (file.exists(where)) {
                # file exists
                assign(instance, readRDS(where), envir = envir)
                get(instance, envir = envir, mode = "S4")$prepare()
            } else {
                # create file
                token <- .rga.getToken(client.id, client.secret)
                assign(instance, rga$new(client.id, client.secret, where, token), envir = envir)
                saveRDS(get(instance, envir = envir), file = where)
            }
        }
    }
}
