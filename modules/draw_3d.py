#source http://rdkit.blogspot.com/2016/07/a-recent-post-on-in-pipeline-talked.html
from rdkit import Chem
import py3Dmol

def drawit(m,dimensions=(900,400),p=None,confId=-1):
    mb = Chem.MolToMolBlock(m,confId=confId)
    if p is None:
        p = py3Dmol.view(width=dimensions[0],height=dimensions[1])
    p.removeAllModels()
    p.addModel(mb,'sdf')
    p.setStyle({'stick':{}})
    p.setBackgroundColor('0xeeeeee')
    p.zoomTo()
    return p.show()