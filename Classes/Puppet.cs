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
        private string name;
        private int level, exp;
        private int chp, hp;
        private int atk, amr, agl;

        public Puppet(string _name, int _hp, int _atk, int _amr, int _agl)
        {
            name = _name;
            level = 1;
            exp = 0;
            chp = hp = _hp;
            atk = _atk;
            amr = _amr;
            agl = _agl;
        }

        public override string ToString()
        {
            return $"[{level}] {name}";
        }
        
        public bool isAlive()
        {
            return chp > 0;
        }
    }
}
