public interface IFileService
{
    Task UploadFileAsync(string containerName, string directoryName, string fileName);

    Task<string> ReadFileAsync(string containerName, string directoryName, string fileName);

    Task<IEnumerable<string>> ListBlobsAsync(string containerName, string directoryName);
}