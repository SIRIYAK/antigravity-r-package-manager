#' Speak Text Using System TTS
#'
#' A simple wrapper to convert text to audio using the system's built-in
#' text-to-speech engine.
#'
#' @param text Character string to speak.
#' @param wait Logical; if TRUE, wait for speaking to finish before returning.
#' @export
#'
#' @examples
#' \dontrun{
#' speak("Hello, I am an R package!")
#' }
speak <- function(text, wait = TRUE) {
    if (!is.character(text) || length(text) != 1) {
        stop("Input 'text' must be a single character string.")
    }

    os <- Sys.info()[["sysname"]]

    if (os == "Windows") {
        # Using PowerShell for Windows TTS
        ps_cmd <- sprintf(
            "Add-Type -AssemblyName System.Speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.Speak('%s')",
            gsub("'", "''", text)
        )
        system2("powershell", args = c("-Command", shQuote(ps_cmd)), wait = wait)
    } else if (os == "Darwin") {
        # Mac 'say' command
        system2("say", args = shQuote(text), wait = wait)
    } else if (os == "Linux") {
        # Check for espeak or festival
        if (system("which espeak", ignore.stdout = TRUE) == 0) {
            system2("espeak", args = shQuote(text), wait = wait)
        } else if (system("which festival", ignore.stdout = TRUE) == 0) {
            cmd <- sprintf("echo %s | festival --tts", shQuote(text))
            system(cmd, wait = wait)
        } else {
            warning("No TTS engine found (espeak or festival). Please install one.")
        }
    } else {
        stop("Operating system not supported for TTS.")
    }

    invisible(NULL)
}
