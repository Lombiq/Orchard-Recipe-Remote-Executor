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

if (!(Test-Path($FilePath)))
{
    Write-Host ("`n*****`nCOMPOSITE RECIPE FILE NOT FOUND!`n*****`n")
    exit 1
}

$compositeRecipe = New-Object XML

try
{
    $compositeRecipe.Load($FilePath)

    $recipeTemplateStart = @"
    <?xml version="1.0"?><Orchard>
"@
    $recipeTemplateEnd = "</Orchard>"

    $recipes = @()
    foreach ($tenant in $compositeRecipe.Orchard.ChildNodes)
    {
        $recipes += ,@{ TenantName = $tenant.Name; RecipeText = $recipeTemplateStart + $tenant.InnerXml + $recipeTemplateEnd }
    }
}
catch
{
    Write-Host ("`n*****`nERROR WHILE PROCESSING THE COMPOSITE RECIPE!`n*****`n")
	exit 1
}

& "$PSScriptRoot\RecipeRemoteExecutorClient.ps1" -HostName $HostName -UserName $UserName -Password $Password -CompositeRecipeData $recipes

exit $LASTEXITCODE