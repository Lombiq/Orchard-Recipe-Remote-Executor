using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Lombiq.Hosting.RecipeRemoteExecutor.Models.Api
{
    public class Recipe : IRecipe
    {
        public string TenantName { get; set; }
        public string RecipeText { get; set; }
    }
}