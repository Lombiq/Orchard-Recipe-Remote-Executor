using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lombiq.Hosting.RecipeRemoteExecutor.Models
{
    public interface IRecipe
    {
        /// <summary>
        /// The name of the tenant the recipe should be executed for.
        /// </summary>
        string TenantName { get; }

        /// <summary>
        /// Textual content of the recipe.
        /// </summary>
        string RecipeText { get; }
    }
}
