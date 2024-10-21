
# Clear VS Code Appdata Roaming Cache , CachedData, CachedExtensions, CachedExtensionVSIXs (if this folder exists) and Code Cache
# This is useful if you are having issues with VS Code and you want to clear the cache
function Clear-VSCodeCache() {
    # Get the VS Code Appdata Roaming folder
    $vscode_appdata_roaming_folder = Join-Path $env:APPDATA "Code"

    # Check if the VS Code Appdata Roaming folder exists
    if (Test-Path $vscode_appdata_roaming_folder) {
        # Get the VS Code Appdata Roaming Cache folder
        $vscode_appdata_roaming_cache_folder = Join-Path $vscode_appdata_roaming_folder "Cache"

        # Check if the VS Code Appdata Roaming Cache folder exists
        if (Test-Path $vscode_appdata_roaming_cache_folder) {
            # Remove the VS Code Appdata Roaming Cache folder
            Remove-Item $vscode_appdata_roaming_cache_folder -Recurse -Force
        }

        # Get the VS Code Appdata Roaming CachedData folder
        $vscode_appdata_roaming_cacheddata_folder = Join-Path $vscode_appdata_roaming_folder "CachedData"

        # Check if the VS Code Appdata Roaming CachedData folder exists
        if (Test-Path $vscode_appdata_roaming_cacheddata_folder) {
            # Remove the VS Code Appdata Roaming CachedData folder
            Remove-Item $vscode_appdata_roaming_cacheddata_folder -Recurse -Force
        }

        # Get the VS Code Appdata Roaming CachedExtensions folder
        $vscode_appdata_roaming_cachedextensions_folder = Join-Path $vscode_appdata_roaming_folder "CachedExtensions"

        # Check if the VS Code Appdata Roaming CachedExtensions folder exists
        if (Test-Path $vscode_appdata_roaming_cachedextensions_folder) {
            # Remove the VS Code Appdata Roaming CachedExtensions folder
            Remove-Item $vscode_appdata_roaming_cachedextensions_folder -Recurse -Force
        }

        # Get the VS Code Appdata Roaming CachedExtensionVSIXs folder
        $vscode_appdata_roaming_cachedextensionvsixs_folder = Join-Path $vscode_appdata_roaming_folder "CachedExtensionVSIXs"

        # Check if the VS Code Appdata Roaming CachedExtensionVSIXs folder exists
        if (Test-Path $vscode_appdata_roaming_cachedextensionvsixs_folder) {
            # Remove the VS Code Appdata Roaming
            Remove-Item $vscode_appdata_roaming_cachedextensionvsixs_folder -Recurse -Force
        }
        
        # Get the VS Code Appdata Roaming Code Cache folder
        $vscode_appdata_roaming_code_cache_folder = Join-Path $vscode_appdata_roaming_folder "Code Cache"
         
        # Check if the VS Code Appdata Roaming Code Cache folder exists
        if (Test-Path $vscode_appdata_roaming_code_cache_folder) {
            # Remove the VS Code Appdata Roaming Code Cache folder
            Remove-Item $vscode_appdata_roaming_code_cache_folder -Recurse -Force
        }
    }
}
