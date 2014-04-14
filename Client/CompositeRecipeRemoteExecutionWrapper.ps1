param
(
    [Parameter(Mandatory = $true, HelpMessage = "The URL where the recipes will be posted. The URL pattern is https://mywebsite.com/api/Lombiq.Hosting.RecipeRemoteExecutor/Recipes/Batch, but you only need to define mywebsite.com.")]
    [string] $HostName = $(throw "You need to specify the host where the recipes will be executed."),

    [Parameter(Mandatory = $true, HelpMessage = "The name of the user to authenticate. Make sure that the user is in a role that is permitted to run recipes remotely.")]
    [string] $UserName = $(throw "You need to specify the username."),

    [Parameter(Mandatory = $true, HelpMessage = "The password of the user.")]
    [string] $Password = $(throw "You need to specify the password."),

    [Parameter(Mandatory = $true, HelpMessage = "The file containing the composite recipe that will be processed. This XML document is very similar to a regular Orchard recipe, but it contains a new second-level node for each tenant.")]
    [array] $FilePath = $(throw "You need to specify the path to the composite recipe file.")
)

Add-Type -Language CSharp @"
public class Recipe
{
    public string TenantName;
    public string RecipeText;
}
"@;

if (!(Test-Path($FilePath)))
{
    Write-Host ("`n*****`nCOMPOSITE RECIPE FILE AT $FilePath NOT FOUND!`n*****`n")
    exit 1
}

$compositeRecipe = New-Object XML
$recipes = @()
$tenantNames = @()

try
{
    $compositeRecipe.Load($FilePath)

    $recipeTemplateStart = @"
<?xml version="1.0"?><Orchard>
"@
    $recipeTemplateEnd = "</Orchard>"

    foreach ($tenant in $compositeRecipe.Orchard.ChildNodes)
    {
        if(!([string]::IsNullOrWhiteSpace($tenant.InnerXml)))
        {
            $currentRecipe = New-Object Recipe
            $currentRecipe.TenantName = $tenant.Name
            $currentRecipe.RecipeText = $recipeTemplateStart.Trim() + $tenant.InnerXml + $recipeTemplateEnd

            $recipes += $currentRecipe
            $tenantNames += $tenant.Name            
        }
    }
}
catch [Exception]
{
    Write-Host ("`n*****`nERROR WHILE PROCESSING THE COMPOSITE RECIPE:`n")
    Write-Host ($_.Exception.Message)
    Write-Host ("*****`n")
	exit 1
}

if ($recipes.Count -gt 0)
{
    $tenantNames = [string]::Join(", ", $tenantNames)
    Write-Host ("`n*****`nNOTIFICATION: EXECUTING RECIPE ON THE FOLLOWING TENANT(S): $tenantNames.`n*****`n")
    & "$PSScriptRoot\RecipeRemoteExecutorClient.ps1" -HostName $HostName -UserName $UserName -Password $Password -CompositeRecipeData $recipes
    exit $LASTEXITCODE
}
else
{
    Write-Host ("`n*****`nNOTIFICATION: THERE ARE NO RECIPES TO BE EXECUTED.`n*****`n")
    exit 0
}