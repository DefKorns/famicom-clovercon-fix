---
Name: Famicom Clovercon Fix
Creator: DefKorns
Category: System
Version: 1.1.0
---
Fixes unresponsive controllers and a frozen home menu when the Famicom Mini or
Shonen Jump firmware runs on NES or SNES Classic hardware.

The gamepad driver is loaded with the controller detect lines of the NES/SNES
board instead of the hardwired setup the Famicom firmware expects. Every
other console and firmware is left untouched.
