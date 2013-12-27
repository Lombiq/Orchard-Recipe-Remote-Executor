using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Orchard.Environment.Extensions.Models;
using Orchard.Security.Permissions;

namespace Lombiq.Hosting.RecipeRemoteExecutor
{
    public class Permissions : IPermissionProvider
    {
        public const string AccessApiName = "Lombiq.Hosting.RecipeRemoteExecutor.AccessApi";
        public static readonly Permission AccessApi = new Permission { Category = "Hosting", Description = "Access the Recipe Remote Executor API endpoints", Name = AccessApiName };

        public virtual Feature Feature { get; set; }


        public IEnumerable<Permission> GetPermissions()
        {
            return new[]
            {
                AccessApi
            };
        }

        public IEnumerable<PermissionStereotype> GetDefaultStereotypes()
        {
            return Enumerable.Empty<PermissionStereotype>();
        }
    }
}