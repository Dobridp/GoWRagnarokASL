state("GoWR")
{
  int IGT : 0x39B3B0C; //IGT in seconds
  float IGTms : 0x605DB04; //ms of the IGT -> 0.0 to 1.0, when on 1.0, IGT goes up by 1 and resets back to 0.0 -> currently broken
  int MainMenu : 0x5D89EFC; //1 on menu, 0 out of menu
  int Load: 0x5D89EF8; //0 when not loading, 257 when loading, 256 when in cutscene loading
  uint Objective: 0x25DE880; //Objective number, changes number base off the objective 0 when in mainmenu and loading
  uint MainObjective: 0x25D6C98; //Should only be main path objective as it doesnt go to 0 when loading but it might not get all the objectives
  string100 SFD: 0x256A8E1; //Save file Description so same as in 2018 but for this game
  
}

startup
{
  settings.Add("Main Game", true);
  settings.SetToolTip("Main Game", "Autosplitter Work in Progress");
  settings.Add("Valhalla", false);
  settings.SetToolTip("Valhalla", "Autosplitter Work in Progress");
  settings.Add("Log", false);
  settings.SetToolTip("Log", "Log the objective numbers");
  vars.igtAux = 0.0;
  Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
  vars.Helper.StartFileLogger("ObjectiveNumbers.log");

  vars.ObjectiveNames = new List<string>{
    "Head Home", // start of Surviving Fimbulwinter
    "Track Atreus",
    "Return Home With Atreus",
    "Return Home To Atreus",
    "Follow Atreus Into The Forest",
    "Return Home",
    "Follow Sindri To Gate",
    "Enter The House",
    "Talk To Sindri",
    "Follow Sindri",
    "Meet At Fast Travel",
    "Travel To Svartalfheim", 
    "Journey To Nid", // start of The Quest For Tyr
    "Explore Nid",
    "Boat To Durlins",
    "Continue Through Port",
    "Reach Front Of Train",
    "Fix Broken Train",
    "Ride Train To Mines",
    "Search Mines For Tyr",
    "Pursue Tyr",
    "Exit Mines With Tyr",
    "Return To Sindris",
    "Confer With Mimir", 
    "Travel To Midgard", // start of Old Friends
    "Speak With Jorm",
    "Find Way Out",
    "Speak With Freya",
    "Return To Sindris",
    "Travel To Alf",
    "Return To RBR", 
    "Reach The Triptych", // start of Groas Secret
    "Descend The Light Well",
    "Fight To Gate",
    "Return To Sindris",
    "Eat Dinner",
    "Approach Phantom Atreus",
    "Follow The Wolf",
    "Explore Jotunheim With Agrboda", // start of The Lost Stantuary
    "Follow Agrboda To The Shrine",
    "Observe Agrbodas Daily Life",
    "Head To The Final Stop",
    "Head Back To Jalla",
    "Clear The Creepers From The Sinkhole",
    "Climb Back Up To The Surface",
    "Head Home Through The Marshes",
    "Free The Wolf From Grylas Clutches",
    "Return To Agrbodas Camp",
    "Explore The Treehouse",
    "Return To Sindris House",
    "Follow Freya To Vanaheim", // start of The Reckoning
    "Find The Source Blocking Freyas Realm Travel",
    "Speak With Freyr",
    "Continue To The Village",
    "Get Across The Bay",
    "Cross Broken Bridge",
    "Find Freyas Old House",
    "Return To Freyrs Camp",
    "Retrieve Mimir",
    "Return To The Realm Travel Gate",
    "Check On Atreus",
    "Find Shelter", // start of The Runaway
    "Light A Fire For Charuli",
    "Follow Odins Raven",
    "Climb The Wall",
    "Go Meet Odin",
    "Observe Odin On His Workday",
    "Investigate Wardrobe",
    "Go To Odins Study",
    "Walk With Odin",
    "Search For The Mask Fragment With Thor", // start of Into The Fire
    "Investigate The Surtr Triptych",
    "Resume The Search For The Mask Fragment",
    "Go Back To Your Quarters",
    "Travel To Midgard", // start of The Word Of Fate
    "Get The Wolves",
    "Open The Gate",
    "Follow Wolves To Norns",
    "Keep Tracking Norns",
    "Norns Final Spot",
    "Well Of Urd",
    "Back To Frozen Lake",
    "Return To RBR",
    "Ask The Dwarves",
    "Continue Talking To Dwarves",
    "Travel To Svart",
    "Reach The Forge", // start of Forging Destiny
    "Follow Brok To Forge",
    "Destroy The Hive",
    "Ride The Gondola",
    "Repair The Switch",
    "Forge The Weapon",
    "Find A Path",
    "Return To Sindris House",
    "Talk To Sindri",
    "Retire For The Night",
    "Go To Library", // start of Unleashing Hel
    "Find The Mask Piece",
    "Explain Yourself",
    "Return To Your Quarters",
    "Return Home",
    "Repel The Helwalkers", // start of Reunion
    "Approach Ratatoskr",
    "Find Garm",
    "Pursue Garm",
    "Leave Helheim",
    "Run From Garm",
    "Keep Pursuing Garm",
    "Return To Mystic Gateway",
    "Head Back Home",
    "Travel To Vanaheim",
    "Reach Freyrs Camp", // start of Creatures Of Prophecy
    "Walk With Hildisin",
    "Find Skoll And Hati",
    "Find The Moon",
    "Pursue The Moon Thief",
    "Return To Skoll And Hati",
    "Return To Freyrs Camp",
    "Goto Freyrs Prison",
    "Regroup With The Resistance",
    "Escape From The Prison",
    "Reveal Gjallarhorn",
    "Seek Out Huginn", // start of Unlocking The Mask
    "Speak With The AllFather",
    "Find Thor",
    "Bar Brawl Gap Objective",
    "Locate The Mask Fragment",
    "Return To The Treehouse",
    "Consider Tyrs Plan",
    "Leave",
    "Hunt With Atreus", // start of Hunting For Solace
    "Find Sindri",
    "Return Home And Prepare For War",
    "Enter The House",
    "Go To Muspelheim", // start of The Summoning
    "Reach Surtrs Forge",
    "Speak To Surtr",
    "Follow Surtr",
    "Approach The Spark",
    "Return To The Realm Travel Gate",
    "Get Some Rest", // start of The Realms At War
    "Blow The Horn",
    "Fight Your Way To The War Machines",
    "Protect The Refugees",
    "Find Odin",
    "Find Father", // start of Beyond Ragnarok
    "Follow Agrboda",
    "Set Things Right",
  };
  vars.Counter = 0;
}

update
{
  if (current.IGT > old.IGT && (current.IGT - old.IGT) < 2)
  {
    vars.igtAux += current.IGT - old.IGT;
  }
  
  if(settings["Log"] && (current.MainObjective != old.MainObjective) || 
  (current.Objective != old.Objective && current.Objective != 0 && old.Objective != 0 && current.Load == 0))
  {
    string objectivename = vars.ObjectiveNames[(int)vars.Counter];
    vars.Counter++;
    vars.Log("New Objective(main): " + current.MainObjective + "-" + objectivename);
    vars.Log("Settings format: " + current.MainObjective + "," + old.MainObjective + "-" + objectivename);
    vars.Log("---------------------------------");
    vars.Log("New Objective(notmain): " + current.Objective + "-" + objectivename);
    vars.Log("Settings format: " + current.Objective + "," + old.Objective + "-" + objectivename);
    vars.Log("---------------------------------");
  }
}

onStart
{
  vars.igtAux = 0.0;
}

start
{
  if (settings["Main Game"] && current.MainMenu == 0 && old.MainMenu == 1 && current.Load == 0)
  {
    return true;
  }
  if (settings["Valhalla"] && current.MainMenu == 0 && current.IGT == 0 && old.IGT > 0)
  {
    return true;
  }
}

isLoading
{
  return true;
}

gameTime
{
  return TimeSpan.FromSeconds(vars.igtAux);
}
