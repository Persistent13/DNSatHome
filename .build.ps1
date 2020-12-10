#Requires -Module @{ ModuleName = 'InvokeBuild'; ModuleVersion = '5.6.1' }
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
    $FailOnLint,

    # Flag of platforms to target
    [Parameter()]
    [ValidateSet('Windows64','Linux64')]
    [string[]]
    $Platform = @('Windows64','Linux64')
)

# If we're in a CI environment, we force these settings
if ($env:CI) {
    # Always fail on bad linting in CI
    $FailOnLint = $true
}

$targets = @()
switch ($Platform) {
    'Windows64' { $targets += 'x86_64-pc-windows-msvc' }
    'Linux64'   { $targets += 'x86_64-unknown-linux-gnu' }
}

task Clean -If $Clean {
    cargo clean
}

task Lint {
    if ($FailOnLint) {
        exec {
            cargo clippy -- --deny warnings --color auto
            cargo fmt -- --check
        }
    } else {
        exec {
            cargo clippy --color auto
            cargo fmt
        }
    }
}

task Test {
    if ($env:CI) {
        # Since we're in CI we should run all tests for a complete picture of any failures
        exec { cargo test --workspace --no-fail-fast --color auto }
    } else {
        exec { cargo test --workspace --color auto }
    }
}

task Build {
    foreach ($target in $targets) {
        exec { cargo build --release --target $target --color auto }
    }
}

# task UploadArtifacts {
#     https://github.com/actions/upload-artifact
#     TBD were things will be stored, maybe GitHub?
# }

task . Clean, Lint, Test, Build
