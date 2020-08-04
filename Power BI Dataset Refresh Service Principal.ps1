# Power BI Dataset Refresh
# Parameters
$TenantId  = "" 
$AppId     = ""  # Service PRincipal ID
$Secret    = ""  # Secret from Service Principal
$GroupId   = ""  # Workspace ID
$DatasetId = ""

# Connect the Service Principal
$password = ConvertTo-SecureString $Secret -AsPlainText -Force
$Creds = New-Object PSCredential $AppId, $password
Connect-PowerBIServiceAccount -ServicePrincipal -Credential $Creds -Tenant $TenantId

$headers = Get-PowerBIAccessToken

# Refresh the dataset
$uri = "https://api.powerbi.com/v1.0/myorg/groups/$GroupId/datasets/$DatasetId/refreshes"
Invoke-RestMethod -Uri $uri –Headers $headers –Method POST –Verbose

Disconnect-PowerBIServiceAccount


# Check the refresh history
$uri = "https://api.powerbi.com/v1.0/myorg/groups/$GroupId/datasets/$DatasetId/refreshes?$top=2"
Invoke-RestMethod -Uri $uri –Headers $headers –Method GET –Verbose | ConvertTo-Json | ConvertFrom-Json | Select -ExpandProperty value | Select id, refreshType, startTime, endTime, status
