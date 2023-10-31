using Azure.Storage.Blobs;
using Azure.Storage.Queues;


    public interface IStorageProvider
    {
        BlobClient GetBlobContainer();
        QueueClient GetQueue(string queueName);
       // QueueClient GetQueueByType(QueueType type, string prio, string sandbox);
    }

