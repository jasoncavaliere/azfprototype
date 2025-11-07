using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .ConfigureLogging(lb => lb.AddFilter("Microsoft", LogLevel.Information))
    .Build();

await host.RunAsync();