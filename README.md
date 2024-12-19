<!------------------- HEADER SECTION -------------------------->
<header>
 <h1 align="center"><strong> d｡◕‿↼｡bづ </strong><br/>P4wnBunny</h1>
  <!-- BADGET BUTTONS -->
<p align="center">
  <img src="https://img.shields.io/badge/Status-Development-lightgray.svg?style=flat" />
  <img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat" />
 </p>
</header>
<p></p> <!-- BLANK PARAGRAPH TO FIX HTML HEADER IN GITHUB PAGES TEMPLATE -->
<!------------------- END OF HEADER SECTION -------------------->

<!-- INTRODUCTION -->

## 💬 Introduction  

**P4wnBunny** pretends to be an off-brand port of DuckyScript to make available launch duckyscript payloads on P4wnP1 A.L.O.A.

Its a bash script who you can import on your payloads or in environment in order to make duckyscript work.

By now this is a POC. The payloads im testing are working with minimal modifications, but i need do more work around to emulate the BashBunny workflow.

NOTE: I do not have a phisical BashBunny, so all i do its thinking about get the same things with HIDScript+Bash

<!-- TABLE OF CONTENTS -->

<details><summary>📑 Table of Contents(click to expand)</summary><p>

- [Introduction](#-introduction)
- [Features](#-features)
- [Installation](#-installation)
- [Contribute](#-contribute)
- [Team](#-team)
- [License](#-license)
---

</p></details><br/>

<!-- END TABLE OF CONTENTS -->

> If you want to **improve** this project, please, **read** the [`Contributors section`](#-contribute).



## 🏅 Features

<!-- FEATURES ACHIEVED -->
I would love to have a great list of features and make one section for it, but it will not be like that. You'll be glad of the introduction ones.

<table align="center">
<tr width="900px" style="display:table-style;">
<td width="400px" align="left" style="display:cell-style;">

**Achieved**
- [X] Basic duckyscript commands
- [X] Basic bashbunny commands
- [X] Basic extensions

</td>
<td width="400px" align="left" style="display:cell-style;float:left;">

**To-Do**
- [ ] Agile Exfill/Infill to UMS
- [ ] Port all extensions
- [ ] Test & port all payloads
- [ ] Installer script
- [ ] BashBunny workflow

</td>
</tr>
</table>

<!-- INSTALLATION  SECTION -->

## 🏭 Installation
1. Download/Fork/Copy/Get this repository.
1. Edit the p4wnbunny vars in p4wnbunny.sh
    1. **_configfile_path** = path to config.txt
    1. **_extensions_path** = path to extensions folder
    1. **_bunny_image** = name of the image.bin to launch in ATTACKMODE STORAGE
1. Import p4wnbunny.sh at start of your payload.txt
1. Run it with "bash payload.txt"

Alternatively you can add "BASH_ENV=/path_to/p4wnbunny.sh" on your /etc/environment file in order to integrate with all system bash. In that way you dont need to import nothing on payloads, but may make fail other bash scripts if use the same function or var names.

#### Requirements  
* P4wnP1 A.L.O.A.: https://github.com/RoganDawes/P4wnP1_aloa
<!-- CONTRIBUTE -->

## 💎 Contribute
Feel free to send us a message for anything. We'd love to ear about improve!.

Please, have a look at the [Contributor Covenant][contributor covenant].

<!-- TEAM -->

## 🏀 Team  
Only me.

<!-- LICENSE -->
## 🎓 License  
<sub> © 2024 Hackstur </sub>  

This project is released under the terms of the [MIT][license file] license.

<!------------ RELATIVE LINKS ----------->

[license file]: LICENSE  
[contributor covenant]: https://www.contributor-covenant.org/version/1/4/code-of-conduct.htm  
