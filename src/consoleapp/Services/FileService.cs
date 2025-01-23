
using Azure.Storage.Blobs.Specialized;
using RandomDataGenerator.FieldOptions;
using RandomDataGenerator.Randomizers;

public class FileService : IFileService
{
    private readonly BlobServiceClient _blobServiceClient;

    public FileService(IConfiguration configuration)
    {
        string storageName = configuration["StorageName"] ??
                                    throw new ArgumentException("The storage name needs to be defined");

        _blobServiceClient = new BlobServiceClient(new Uri($"https://{storageName}.blob.core.windows.net"),
                                                   new DefaultAzureCredential());
    }

    public async Task UploadFileAsync(string containerName, string directoryName, string fileName)
    {

        try
        {
            var randomizerText = RandomizerFactory.GetRandomizer(new FieldOptionsText
            {
                UseNumber = false,
                UseSpecial = false
            });

            string text = randomizerText.Generate();

            var container = _blobServiceClient.GetBlobContainerClient(containerName);

            using (var stream = new MemoryStream())
            using (var writer = new StreamWriter(stream))
            {
                writer.Write(text);
                writer.Flush();
                stream.Position = 0;

                string blobName = $"{directoryName}/{fileName}";
                var blockBlobClient = container.GetBlockBlobClient(blobName);
                await blockBlobClient.UploadAsync(stream);

            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }

    public async Task<string> ReadFileAsync(string containerName, string directoryName, string fileName)
    {
        var container = _blobServiceClient.GetBlobContainerClient(containerName);
        string blobName = $"{directoryName}/{fileName}";

        var blobClient = container.GetBlobClient(blobName);

        var result = await blobClient.DownloadContentAsync();

        return result.Value.Content.ToString();
    }

    public async Task<IEnumerable<string>> ListBlobsAsync(string containerName, string directoryName)
    {
        var container = _blobServiceClient.GetBlobContainerClient(containerName);
        List<string> blobs = new();

        await foreach (BlobItem blobItem in container.GetBlobsAsync(prefix: $"{directoryName}/"))
        {
            blobs.Add(blobItem.Name);
            BlobClient blobClient = container.GetBlobClient(blobItem.Name);

            // Download the blob's content
            //BlobDownloadInfo download = await blobClient.DownloadAsync();
        }

        return blobs;
    }
}