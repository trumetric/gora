.rga.getToken <- function(client.id, client.secret) {
    if (interactive()) {
        redirect.uri <- "https%3A%2F%2Ftrumetric.me%2Fdashboard%2Fauthgo"
        url <- paste("https://accounts.google.com/o/oauth2/auth?",
                     "scope=email%20profile%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fanalytics%20https%3A%2F%2Fadwords.google.com%2Fapi%2Fadwords%2F&",
                     "state=%2Fprofile&", "redirect_uri=", redirect.uri, "&",
                     "response_type=code&",
                     "client_id=", client.id, "&",
                     "approval_prompt=force&",
                     "access_type=offline", sep = "", collapse = "")

        browseURL(url)
        # in case of server
        cat(paste("Browse URL:", url, "\n"))
        code <- readline("Please enter code here: ")
    } else {
        code <- "dummy"
    }
    .rga.authenticate(client.id = client.id, client.secret = client.secret,
                      code = code, redirect.uri = redirect.uri)
}

.rga.authenticate <- function(client.id, client.secret, code, redirect.uri) {
    opts <- list(verbose = FALSE)
    raw.response <- POST("https://accounts.google.com/o/oauth2/token",
                         body = list(
                             code = code,
                             client_id = client.id,
                             client_secret = client.secret,
                             redirect_uri = redirect.uri,
                             grant_type = "authorization_code"))

    token.data <- jsonlite::fromJSON(content(raw.response, "text"))

    now <- as.numeric(Sys.time())
    token <- c(token.data, timestamp = c(first = now, refresh = now))

    return(token)
}
