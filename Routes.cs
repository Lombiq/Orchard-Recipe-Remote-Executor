using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using Orchard.Mvc.Routes;

namespace Lombiq.Hosting.RecipeRemoteExecutor
{
    public class Routes : IRouteProvider
    {
        public void GetRoutes(ICollection<RouteDescriptor> routes)
        {
            foreach (var routeDescriptor in GetRoutes()) routes.Add(routeDescriptor);
        }

        public IEnumerable<RouteDescriptor> GetRoutes()
        {
            return new[]
			{
				new HttpRouteDescriptor
                {
                    RouteTemplate = "api/Lombiq.Hosting.RecipeRemoteExecutor/{controller}/{action}/{id}",
                    Defaults = new { Area = "Lombiq.Hosting.RecipeRemoteExecutor", Id = RouteParameter.Optional}
                }
			};
        }
    }
}