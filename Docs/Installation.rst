
**Installation requirements**
-----------------------------
**System requirements**
~~~~~~~~~~~~~~~~~~~~~~~~
Microsoft Windows: 64-bit operating system, Windows 7 or later

Apple macOS: OS X 10.9 (Mavericks) or later

3 gigabytes RAM

Display resolution minimum 1440 pixels wide and minimum 650 pixels high.

**Technical information**

QuickNII consists of two co-located executable components implemented in
two programming languages for historical reasons. The GUI component is
implemented in MXML+ActionScript (runs on Adobe Integrated Runtime,
which is bundled as "captive runtime", requiring no installation). A
slicer service running in the background is implemented in Java (and has
a bundled JRE requiring no installation). The two components communicate
via standard output and local TCP connections (using the loopback
interface).

**Download:**

Link: https://www.nitrc.org/projects/quicknii/ 

Unzipp the QuickNII folder at your desired location.

**Conditions of use**
~~~~~~~~~~~~~~~~~~~~~~

**Licence:** 

Creative Commons Attribution-NonCommercial-ShareAlike 4.0
International for the main component. Source code: MIT License.


**Citation of the tool:**

-RRID on SciCrunch: (QuickNII, RRID:SCR_016854)

-Puchades MA, Csucs G, Ledergerber D, Leergaard TB, Bjaalie JG (2019)
  Spatial registration of serial microscopic brain images to
  three-dimensional reference atlases with the QuickNII tool. PLOS ONE
  14(5): e0216796. https://doi.org/10.1371/journal.pone.0216796
   
**Cite funding**
 
QuickNII is developed at the Neural Systems Laboratory, Institute of
Basic Medical Sciences,University of Oslo (Norway), with funding from the European Union’s
Horizon 2020 Framework Programme for Research and Innovation under the
Framework Partnership Agreement No. 650003 (HBP FPA).

**Citation of the atlases embedded in the tool:**

QuickNII can be used with the following reference atlases:

+--------------------------------------------------+
|Allen Mouse Brain Atlas version 3 2015            |
|                                                  |
|Allen Mouse Brain Atlas version 3 2017            |
|                                                  |
|Waxholm Space Atlas of the Sprague Dawley rat v2  |
|                                                  |
|Waxholm Space Atlas of the Sprague Dawley rat v3  |
|                                                  |
|Waxholm Space Atlas of the Sprague Dawley rat v4  |
+--------------------------------------------------+     
How to cite:

* Allen Mouse Brain Atlas (@ 2004 Allen Institute for Brain Science. Allen Mouse Brain Atlas. Available from:  
http://download.alleninstitute.org/informatics-archive/current-release/mouse_ccf/annotation/).                     

* Waxholm Space atlas of the Sprague Dawley rat brain       
version 1.01,2,3 and 4 (RRID: SCR_017124; Papp et al.,NeuroImage 97, 374-386, 2014;
Papp et al., NeuroImage 105, 561–562, 2015; Kjonigsen et al., NeuroImage 108, 441-449, 2015;
Osen et al., NeuroImage 199, 38-56, 2019; Kleven et al., in preparation)                         

For reuse of the Waxholm Space atlas of the Sprague Dawley rat brain,see citation policy at  
https://www.nitrc.org/citation/?group_id=1081

**Release notes**
~~~~~~~~~~~~~~~~~~
*Version 2.2 (2019-05-28) This release includes several new reference atlases: ABAMouse-v3-2017 and WHSRat-v3 both with Mac and Windows.
Linux support was added in July 2020. 

*Version 2.2preview (2019-04-02) Series descriptor builder recognizes multiple numbering variants in filenames (numbers at fixed character position from either end of names, and sequence indicator \_s prefixanywhere) 
Coordinate transformation to/from Allen CCFv3 added to Mouse package.

*Version 2.1 (2018-12-05) First stable version



