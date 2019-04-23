using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Automata_Expedition.Classes
{
    [Serializable]
    class Player
    {
        private string name;

        public Player(string _name)
        {
            this.name = _name;
        }

        public string Name { get; set; }
    }
}
