# With the official Powershell image
FROM mcr.microsoft.com/powershell

# Add Microsoft Graph
RUN pwsh -c "Install-Module Microsoft.Graph -Scope CurrentUser"
RUN pwsh -c "Install-Module Microsoft.Graph.Beta"

# Run this on mount/run
CMD ["pwsh"]

