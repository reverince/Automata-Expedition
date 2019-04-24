using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Automata_Expedition.Classes
{
    [Serializable]
    class Puppet
    {
        public string Name { get; set; }
        public int Level { get; }
        public int Exp { get; }
        public int Chp { get; }
        public int Hp { get; }
        public int Atk, Amr, Agl;

        public Puppet(string _name, int _hp, int _atk, int _amr, int _agl)
        {
            Name = _name;
            Level = 1;
            Exp = 0;
            Chp = Hp = _hp;
            Atk = _atk;
            Amr = _amr;
            Agl = _agl;
        }

        public override string ToString()
        {
            return $"[{Level}] {Name}";
        }
        
        public bool isAlive()
        {
            return Chp > 0;
        }
    }

    public class Expedition
    {
        
    }
}
