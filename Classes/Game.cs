using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Xaml;

namespace Automata_Expedition.Classes
{
    [Serializable]
    class Game
    {
        private static Game instance;
        public static Game Instance
        {
            get
            {
                if (instance == null)
                    instance = new Game();
                return instance;
            }
            set
            {
                instance = value;
            }
        }
        private Game() { }

        public Player Player
        {
            get
            {
                return Player.Instance;
            }
            set
            {

            }
        }
        public ElementSoundPlayerState ElementSoundPlayerState { get; set; }
        public ElementSpatialAudioMode ElementSpatialAudioMode { get; set; }

    }
}
