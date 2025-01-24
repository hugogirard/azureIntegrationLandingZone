using System;
using System.Threading.Tasks;
using Azure.Messaging.ServiceBus;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace Contoso
{
    public class QueueTrigger
    {
        private readonly ILogger<QueueTrigger> _logger;

        public QueueTrigger(ILogger<QueueTrigger> logger)
        {
            _logger = logger;
        }

        [Function(nameof(QueueTrigger))]
        public async Task Run(
            [ServiceBusTrigger("test", Connection = "srvbushg_SERVICEBUS")]
            ServiceBusReceivedMessage message,
            ServiceBusMessageActions messageActions)
        {
            _logger.LogInformation("Message ID: {id}", message.MessageId);
            _logger.LogInformation("Message Body: {body}", message.Body);
            _logger.LogInformation("Message Content-Type: {contentType}", message.ContentType);

            // Complete the message
            await messageActions.AbandonMessageAsync(message);
            //await messageActions.CompleteMessageAsync(message);
        }
    }
}
