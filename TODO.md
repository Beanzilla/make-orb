Make Orb Todo:

- [x] Make Orb item
- [x] Make Orb crops (Crops also are randomly placed within the world)
- [ ] Make Stick item
- [ ] Make Wood
- [ ] Make Log
- [ ] Make Iron item
- [ ] Make Gold item
- [ ] Make Irold item (A merger between Iron and Gold, behold the Irold)
- [ ] Make Crystal item (actually it's Diamond)
- [ ] Make Circuit item (Used in crafting machines)
- [ ] Make Tank item (Used in crafting machines and storage tanks)
- [ ] CMaker Series (These are the actual machines, below are the categories)
  - [ ] Internal formspec gui for paging and displaying the 3 things queued up for being made (don't forget to show the make orbs in the machines inventory and some way to load and unload machines)
  - [ ] Dirty CMaker (Makes dirt/grass and other dirt like materials, including sand)
  - [ ] Stoney CMaker (Makes stone and other stone like materials, excluding ores)
  - [ ] Lumpy CMaker (Makes coal/iron/gold materials)
  - [ ] Foody CMaker (Makes food like items, this includes direct byproducts from crops, how ever you'll need to make a Seedy CMaker if you need/want seeds)
  - [ ] Seedy CMaker (Makes seeds for crops & tree saplings, See the Foody CMaker for direct byproducts from crops)
  - [ ] Tool CMaker (Makes tools and armor items, this will have an option to choose to allow or not allow swords)
  - [ ] Woody CMaker (Makes logs and wood like materials, excluding saplings)
  - [ ] Admin CMaker (Makes everything from 1 machine, and has no Make Orb cost for anything, just makes away)
- [ ] Storage Tank Series (Each of these will for the most part use previous tanks in their crafting)
  - [ ] Internal make orb transfer system (Storage tanks will make sure machines by the same owner within a range are full at all times)
  - [ ] Dirt-Level Make Store (Stores about the same amount of Make Orbs as a CMaker/machine)
  - [ ] Stone-Level Make Store (Stores 3 times the previous level)
  - [ ] Irold-Level Make Store (Stores 3 times the previous level)
  - [ ] Crystal-Level Make Store (Stores 3 times the previous level)
  - [ ] Admin Make Store (Stores an infinite amount)
- [ ] Auto-Cropper (Automatically collects Make Orbs and transfers them to near by storage tanks, of course by the same owner too)

Approximate Item Costs:

> Costs are in make_orbs:units_produced, as all make times will be a second (1.0 second) one just needs to mass produce Make Orbs to do any number of things

- dirt and sand, 1:2 (1 Make orbs for 2 units)
- stone like materials 1:3
- coal 1:2
- iron 2:1
- gold 3:1
- diamond 5:1
- MCL emerald 5:1
- MCL redstone / MTG Mesecon 3:2
- MCL lapis 2:1
- MTG mese 4:1
- wood tools 1:1 (includes leather armor/wood armor)
- stone tools 2:1 (includes chain armor)
- iron tools 3:1 (includes iron armor)
- gold tools 4:1 (includes armor)
- diamond tools 5:1 (includes armor)
- MCL netherite tools 7:1 (not sure if MCL2 or MCL5 add netherite tools yet but if/when they do let's support it)
- gemstones mod 4:1 (all gemstones will be counted the same)
- gemstones mod tools 4:1 (includes gemstone mod armor)
