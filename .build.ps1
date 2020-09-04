#Requires -Module @{ ModuleName = 'Invoke-Build'; ModuleVersion = '5.6.1' }
#Requires -Version 7.0.0

[CmdletBinding(PositionalBinding)]
param (
    # Clean the rust project.
    [Parameter()]
    [switch]
    $Clean,

    # If set, lint failures will stop the build. Always true in CI.
    [Parameter()]
    [switch]
    $FailOnLint
)

# If we're in a CI environment, we force these settings
if ($env:CI) {
    # Always fail on bad linting in CI
    $FailOnLint = $true
}

task Clean -If $Clean {
    cargo clean
}

task Lint {
    if ($FailOnLint) {
        exec {
            cargo clippy -- --deny warnings
            cargo fmt -- --check
        }
    } else {
        exec {
            cargo clippy
            cargo fmt
        }
    }
}

task Test {
    if ($env:CI) {
        # Since we're in CI we should run all tests for a complete picture of any failures
        exec { cargo test --no-fail-fast --color auto }
    } else {
        exec { cargo test --color auto }
    }
}

task Build {
    exec { cargo build --release --color auto }
}

# task UploadArtifacts {
#     https://github.com/actions/upload-artifact
#     TBD were things will be stored, maybe GitHub?
# }

task . Clean, Lint, Test, Build
