using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Lombiq.Hosting.RecipeRemoteExecutor.Models.Api;
using Lombiq.Hosting.RecipeRemoteExecutor.Services;
using Orchard.Environment.Configuration;
using Orchard.ImportExport.Services;
using Orchard.Localization;
using Piedone.HelpfulLibraries.Authentication;
using Orchard.Exceptions;

namespace Lombiq.Hosting.RecipeRemoteExecutor.Controllers
{
    [RequireBasicAuthorization(Permissions.AccessApiName)]
    public class RecipesController : ApiController
    {
        private readonly ShellSettings _shellSettings;
        private readonly IRecipeExecutor _recipeExecutor;

        public Localizer T { get; set; }


        public RecipesController(
            ShellSettings shellSettings,
            IRecipeExecutor recipeExecutor)
        {
            _shellSettings = shellSettings;
            _recipeExecutor = recipeExecutor;

            T = NullLocalizer.Instance;
        }


        // /api/Lombiq.Hosting.RecipeRemoteExecutor/Recipes/Single
        [HttpPost]
        public IHttpActionResult Single(Recipe recipe)
        {
            return Batch(new[] { recipe });
        }

        // /api/Lombiq.Hosting.RecipeRemoteExecutor/Recipes/Batch
        [HttpPost]
        public IHttpActionResult Batch(IEnumerable<Recipe> recipes)
        {
            if (!recipes.Any()) return StatusCode(HttpStatusCode.NotModified);

            if (_shellSettings.Name != ShellSettings.DefaultName && recipes.Any(recipe => recipe.TenantName != _shellSettings.Name))
            {
                return BadRequest(T("You can't execute recipes for other tenants on other than the Default tenant.").Text);
            }

            try
            {
                foreach (var recipe in recipes)
                {
                    _recipeExecutor.ExecuteRecipe(recipe);
                }
            }
            catch (Exception ex)
            {
                if (ex.IsFatal()) throw;

                return InternalServerError(ex);
            }

            return Ok();
        }
    }
}
