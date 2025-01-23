public class Bootstrapper
{
    private IConfiguration Configuration { get; }

    public IFileService FileService { get; }

    private BlobServiceClient _blobServiceClient;

    public Bootstrapper()
    {
        var builder = new ConfigurationBuilder()
                            .AddUserSecrets<Program>();

        Configuration = builder.Build();

        FileService = new FileService(Configuration);
    }

}