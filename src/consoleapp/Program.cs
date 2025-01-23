using System.Drawing;
using Console = Colorful.Console;

Console.WriteLine("Initialize bootStrapper", Color.Azure);

var bootStrapper = new Bootstrapper();
var fileService = bootStrapper.FileService;

string filename = $"{Guid.NewGuid()}.txt";

// Console.WriteLine("");
// Console.WriteLine($"Uploading File: {filename}", Color.Azure);

// await fileService.UploadFileAsync("doc", "labs", filename);

// Console.WriteLine("File uploaded successfully", Color.Green);

// try
// {
//     Console.WriteLine("");
//     Console.WriteLine("Write non authorized folder", Color.Yellow);
//     filename = $"{Guid.NewGuid()}.txt";
//     Console.WriteLine("");
//     Console.WriteLine($"Uploading File: {filename}", Color.Yellow);

//     await fileService.UploadFileAsync("doc", "result", filename);

// }
// catch (Exception ex)
// {
//     Console.WriteLine("");
//     Console.WriteLine("Error happened", Color.OrangeRed);
//     Console.WriteLine(ex.Message);

// }

// try
// {
//     Console.WriteLine("");
//     Console.WriteLine("List blobs folder", Color.Azure);
//     //string content = await fileService.ReadFileAsync("doc", "result", "ai.txt");
//     var items = await fileService.ListBlobsAsync("doc", "result");

//     items.ToList().ForEach(i => Console.WriteLine(i));

//     Console.WriteLine("");
//     //Console.WriteLine(content);
// }
// catch (Exception ex)
// {
//     Console.WriteLine("");
//     Console.WriteLine("Error happened", Color.Red);
//     Console.WriteLine(ex.Message);
// }

try
{
    Console.WriteLine("");
    Console.WriteLine("Read file AI", Color.Azure);
    string content = await fileService.ReadFileAsync("doc", "result", "ai.txt");


    Console.WriteLine("");
    Console.WriteLine(content);
}
catch (Exception ex)
{
    Console.WriteLine("");
    Console.WriteLine("Error happened", Color.Red);
    Console.WriteLine(ex.Message);
}
