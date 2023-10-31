using Microsoft.AspNetCore.Mvc;
using System.Text;
using System.Collections.Generic;
using AutoMapper;
using Microsoft.ApplicationInsights;
using Azure.Storage.Blobs.Specialized;

namespace apidefinition.Controllers;

[ApiController]
[Route("v1")]
public class CustomerHandlerController : ControllerBase
{
    private IMapper _mapper;
    private readonly ILogger<CustomerHandlerController> _logger;
    private IStorageProvider _storageProvider;
    private TelemetryClient _telemetryClient;

    public CustomerHandlerController(ILogger<CustomerHandlerController> logger,IMapper mapper,IStorageProvider SaResolver,TelemetryClient telemetryClient)
    {
        _mapper = mapper;
        _storageProvider = SaResolver;
        _telemetryClient = telemetryClient;
        _logger = logger;
    }

    [Route("customerinformationsingle", Name = "01. CustomerInformationSingle")]
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task <IActionResult> CreateCustomerInformationSingle([FromBody] CustomerInformation customermodel)
    {
                var queueCustomerOrder = _storageProvider.GetQueue("customerinformationsinglequeue");
                var tasks = new List<Task>();
                var payload = _mapper.Map<CanonicalCustomerInformation>(customermodel);
                payload.MessageType = "customerinformation";

                var json = await submitAsTempBlob(payload.SerializeJson());

                tasks.Add(queueCustomerOrder.SendMessageAsync(json));

           

           

            if (tasks.Any(t => t.IsFaulted))
            {
                _telemetryClient.TrackException(tasks.First(t => t.IsFaulted).Exception, new Dictionary<string, string> { { "WriteToInboundQueue", "1" } });
            }


        return new OkResult();
    }

    [Route("customerinformationbatch", Name = "02. CustomerInformationBatch")]
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task <IActionResult> CreateCustomerInformationBatch([FromBody] List<CustomerInformation> customermodel)
    {
        var queueCustomerOrder = _storageProvider.GetQueue("customerinformationbatchqueue");
        var tasks = new List<Task>();

            foreach (var customer in customermodel)
            {
                var payload = _mapper.Map<CanonicalCustomerInformation>(customer);
                payload.MessageType = "customerinformation";
                var json = await determineSubmissionType(payload.SerializeJson());

                tasks.Add(queueCustomerOrder.SendMessageAsync(json));

            }

            await Task.WhenAll(tasks);

            if (tasks.Any(t => t.IsFaulted))
            {
                _telemetryClient.TrackException(tasks.First(t => t.IsFaulted).Exception, new Dictionary<string, string> { { "WriteToInboundQueue", "1" } });
            }


        return new OkResult();
    }

    private async Task<string> determineSubmissionType(string json)
    {
        // For large messages, put the content on blob storage and 
        // replace message with reference id.
        if (json.Length > 40000)
        {
            var guid = Guid.NewGuid().ToString();
            var container = _storageProvider.GetBlobContainer();  
            using (MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(json)))
            {
                await container.UploadAsync(ms);
            }          

            json = $"reference:{guid}";
        }
        return json;
    }

        private async Task<string> submitAsTempBlob(string json)
    {
        // For large messages, put the content on blob storage and 
        // replace message with reference id.
        if (json.Length > 40000)
        {
            var guid = Guid.NewGuid().ToString();
            var container = _storageProvider.GetBlobContainer();  
            using (MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(json)))
            {
                await container.UploadAsync(ms);
            }          

            json = $"reference:{guid}";
        }
        return json;
    }

}
