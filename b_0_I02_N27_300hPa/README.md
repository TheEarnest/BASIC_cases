# Universal Synchronizer for Dynamic Models (USM)

<!--
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.2596953.svg)](https://doi.org/10.5281/zenodo.2596953) 
-->
[![APGLv3](https://en.wikipedia.org/wiki/GNU_Affero_General_Public_License#/media/File:AGPLv3_Logo.svg)](LICENSE)
[![PGLv3](https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/GPL_v3_Blue_Badge.svg/100px-GPL_v3_Blue_Badge.svg.png)](LICENSE)
[![Lines of Code](https://tokei.rs/b1/github/XAMPPRocky/tokei?category=code)](https://github.com/XAMPPRocky/tokei)
<!-- 
[![Commit Activity](https://img.shields.io/github/commit-activity/m/TheEarnest/Universal-Synchronizer)](https://github.com/TheEarnest/Universal-Synchronizer/graphs/contributors)
-->
A generic system which allows online data ingestion for any dynamic model.

## Concepts 


### Flowchart
[![Flowchart](docs/figures/Universal_Synchronizer_FlowChart.png)](docs/Universal_Synchronizer_FlowChart.png)



## Module

* All modules are well-defined to achieve Plug and Play (PnP) in dynamic modelling. 

[![modules](docs/figures/Universal_Synchronizer_modules.png)](docs/Universal_Synchronizer_idea.png)



## Potential applications

* Interactive Ensemble

* Supermodeling 

* Dynamic ensemble assimilation 

* Dynamic down-scaling or up-scaling 

* Note: 
  - Please download released version instead of current 'master' branch. Current master branch is normally on the stage of working in progress and may not 100% bug free.
  - The key feature of this package is snapshot data ingestion which alows dynamic models generically exchanging state information.   


* This is a generic package to update states of general circulation models (GCMs) on the fly through each GCM's nudging module and a simple pause/resume approach. Potential applications includes but not limits to
  - Updating Model states with model data corrected by data assimilation scheme.
  - Interactively connecting multiple Models.


## Release Notes

* [Logs](/docs/Release_Logs.md) 

    The Universal Synchronizer Copyright (C) 2020 Mao-Lin Shen
    Contact info: earnestshen@gmail.com; maolin.shen@uib.no

