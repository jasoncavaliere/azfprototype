using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace FunctionApp.Functions;

public class QueueProcessor
{
    private readonly ILogger<QueueProcessor> _logger;

    public QueueProcessor(ILogger<QueueProcessor> logger) => _logger = logger;

    [Function("QueueProcessor")]
    public void Run(
        [ServiceBusTrigger("%ServiceBusQueueName%", Connection = "ServiceBusConnection")]
        string message)
    {
        _logger.LogInformation("Received message: {Message}", message);
    }
}