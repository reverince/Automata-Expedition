using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;

namespace Automata_Expedition.Classes
{
    class Game
    {
        private static Game instance;
        private Game() { }
        public static Game Instance
        {
            get
            {
                if (instance == null)
                    instance = new Game();
                return instance;
            }
        }

        const string SAVE_FILE = "save.txt";
        private BinaryFormatter formatter = null;
        private Player player;

        public void Save()
        {
            FileStream writerFileStream = new FileStream(SAVE_FILE, FileMode.Create, FileAccess.Write);
            this.formatter.Serialize(writerFileStream, this.player);
            writerFileStream.Close();
        }

        public void Load()
        {
            if (File.Exists(SAVE_FILE))
            {
                FileStream readerFileStream = new FileStream(SAVE_FILE, FileMode.Open, FileAccess.Read);
                this.player = (Player)this.formatter.Deserialize(readerFileStream);
                readerFileStream.Close();
            }
        }

    }
}
