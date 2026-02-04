# Git aliases/functions
function s { git status }

function am {
    param([Parameter(Mandatory=$true)][string]$message)
    git commit -am "$message"
}

function p { git push }

function m {
    param([Parameter(Mandatory=$true)][string]$message)
    git commit -m "$message"
}

function a { git add . }
