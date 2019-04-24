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
        private static Player instance;
        public static Player Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new Player();
                    instance.Name = "플레이어";
                }
                return instance;
            }
        }
        private Player() { }

        public string Name { get; set; }
        public Dictionary<string, Puppet> Puppets { get; }

        public void AddPuppet(Puppet puppet)
        {
            Puppets.Add(puppet.Name, puppet);
        }
        public Puppet RemovePuppet(string name)
        {
            return Puppets[name];
        }
    }
}
