using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Lombiq.Hosting.RecipeRemoteExecutor.Models;
using Orchard;
using Orchard.Environment;
using Orchard.Environment.Configuration;
using Orchard.Environment.Features;
using Orchard.ImportExport.Services;
using Autofac;

namespace Lombiq.Hosting.RecipeRemoteExecutor.Services
{
    public interface IRecipeExecutor : IDependency
    {
        void ExecuteRecipe(IRecipe recipe);
    }


    public class RecipeExecutor : IRecipeExecutor
    {
        private readonly ShellSettings _shellSettings;
        private readonly IOrchardHost _orchardHost;
        private readonly Work<IImportExportService> _importExportServiceWork;


        public RecipeExecutor(
            ShellSettings shellSettings,
            IOrchardHost orchardHost,
            Work<IImportExportService> importExportServiceWork)
        {
            _shellSettings = shellSettings;
            _orchardHost = orchardHost;
            _importExportServiceWork = importExportServiceWork;
        }


        public void ExecuteRecipe(IRecipe recipe)
        {
            if (_shellSettings.Name == recipe.TenantName)
            {
                _importExportServiceWork.Value.Import(recipe.RecipeText);
            }
            else
            {
                var shellContext = _orchardHost.GetShellContext(new ShellSettings { Name = recipe.TenantName });

                if (shellContext == null || shellContext.Settings.State != TenantState.Running)
                {
                    throw new InvalidOperationException("There is no tenant running with the name \"" + recipe.TenantName + "\".");
                }

                var shellSettings = shellContext.Settings;
                IWorkContextScope environment;
                using (environment = shellContext.LifetimeScope.Resolve<IWorkContextAccessor>().CreateWorkContextScope())
                {
                    IImportExportService importExportService;
                    if (!environment.TryResolve<IImportExportService>(out importExportService))
                    {
                        IFeatureManager featureManager;
                        if (!environment.TryResolve<IFeatureManager>(out featureManager))
                        {
                            throw new InvalidOperationException("The tenant \"" + recipe.TenantName + "\" is not running properly.");
                        }

                        featureManager.EnableFeatures(new[] { "Orchard.ImportExport" }, true);

                        // Reloading the shell. This is costly but unfortunately necessary, just creating a new work context isn't enough.
                        environment.Dispose();
                        environment = _orchardHost.CreateStandaloneEnvironment(shellSettings);

                        importExportService = environment.Resolve<IImportExportService>();
                    }

                    importExportService.Import(recipe.RecipeText);
                }
            }
        }
    }
}