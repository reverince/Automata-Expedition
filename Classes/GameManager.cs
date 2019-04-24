using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;
using Windows.Storage;
using Windows.Storage.Streams;

namespace Automata_Expedition.Classes
{
    class GameManager
    {
        const string SAVE_FILE = "save.txt";

        public static void Save()
        {
            Windows.Storage.ApplicationDataContainer localSettings = Windows.Storage.ApplicationData.Current.LocalSettings;
            byte[] bytesGame = Serialize<Game>(Game.Instance);
            localSettings.Values["Game"] = bytesGame;
            //    Windows.Storage.StorageFolder localFolder =
            //        Windows.Storage.ApplicationData.Current.LocalFolder;
            //    Windows.Storage.StorageFile saveFile =
            //        await localFolder.CreateFileAsync(SAVE_FILE, Windows.Storage.CreationCollisionOption.OpenIfExists);
            //    await Windows.Storage.FileIO.WriteBytesAsync(saveFile, game);
        }

        public static void Load()
        {
            Windows.Storage.ApplicationDataContainer localSettings = Windows.Storage.ApplicationData.Current.LocalSettings;
            byte[] bytesGame = localSettings.Values["Game"] as byte[];
            Game.Instance = Deserialize<Game>(bytesGame);
            //Windows.Storage.StorageFolder storageFolder = Windows.Storage.ApplicationData.Current.LocalFolder;
            //if (await storageFolder.TryGetItemAsync(SAVE_FILE) != null)
            //{
            //    Windows.Storage.StorageFile saveFile =
            //        await storageFolder.GetFileAsync(SAVE_FILE);

            //    IBuffer buffer = await Windows.Storage.FileIO.ReadBufferAsync(saveFile);
            //    byte[] bytes = buffer.ToArray();
            //    Game.Instance = Deserialize<Game>(bytes);
            //}
        }

        private static byte[] Serialize<T>(object obj) where T : class
        {
            if (obj == null)
                return null;
            BinaryFormatter binaryFormatter = new BinaryFormatter();
            using (MemoryStream stream = new MemoryStream())
            {
                var serializer = new DataContractSerializer(typeof(T));
                serializer.WriteObject(stream, obj);
                return stream.ToArray();
            }
        }

        private static T Deserialize<T>(byte[] bytes) where T : class
        {
            if (bytes == null)
                return default;
            using (MemoryStream stream = new MemoryStream(bytes))
            {
                var serializer = new DataContractSerializer(typeof(T));
                return (T)serializer.ReadObject(stream);
            }
        }
    }
}
