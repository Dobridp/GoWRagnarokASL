state("GoWR")
{
  int IGT : 0x39C001C; //IGT in seconds
  float IGTms : 0x606A004; //ms of the IGT -> 0.0 to 1.0, when on 1.0, IGT goes up by 1 and resets back to 0.0
  int MainMenu : 0x5D963FC; //1 on menu, 0 out of menu
  int Load: 0x5D963F8; //0 when not loading, 257 when loading, 256 when in cut-scene loading
  uint Obj: 0x25EABE0; //Objective number, changes number base off the objective 0 when in MainMenu and loading
  //uint AltObj: 0x25E2FF8; //Alt objective number, changes number base off the objective does not go to 0 at all
  string100 SFD: 0x256EC00; //Save file Description so same as in 2018 but for this game
  int SkapSlag: 0x5EB62C8, 0x4C8, 0x128, 0xFD8; // current amount of skap slag in your inventory, -1 in main menu
  int WarriorsKilled: 0x03729450, 0x80, 0x8, 0x148, 0xD88, 0xA78; // current amount of Berserker's killed, -1 in main menu and valhalla
}

startup
{
  //asl help stuff
  Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
  var culture = System.Globalization.CultureInfo.CurrentCulture.Name;
  vars.Log(culture);

  switch (culture)
  {
    case "pt-BR": // work in progress
      vars.Helper.Settings.CreateFromXml("Components/GodOfWarRagnarok.Settings." + culture + ".xml");
      break;
    default:
      vars.Helper.Settings.CreateFromXml("Components/GodOfWarRagnarok.Settings.en-US.xml");
      break;
  }

  vars.igtAux = 0.0;
  vars.igtAux2 = 0.0;
  vars.completedSplits = new List<string>{};
}

update
{
  if (current.IGT > old.IGT && (current.IGT - old.IGT) < 2)
  {
    vars.igtAux += current.IGT - old.IGT;
    vars.igtAux2 = 0.0; //Fixing the IGTms out of sync
  }

  if (current.IGTms > old.IGTms)
  {
    vars.igtAux2 += current.IGTms - old.IGTms;
  }
}

onStart
{
  vars.igtAux = 0.0;
  vars.igtAux2 = 0.0;
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

split
{
  // splits for main game and valhalla
  if ((settings["Main Game"] || settings["Valhalla"]) && old.Obj != current.Obj) // Split on Obj address changing
  {
    string objTransition = old.Obj + "," + current.Obj;
    print("Obj Transition: " + objTransition);
    if (settings.ContainsKey(objTransition) && settings[objTransition])
        {
          vars.completedSplits.Add(objTransition);
          return true;
        }
  }
  //splits for Berserker%
  if(settings["Berserker's"] && current.WarriorsKilled > old.WarriorsKilled)
  {
    return true;
  }
  
}

onReset
{
  vars.completedSplits.Clear();
}

isLoading
{
  return true;
}

gameTime
{
  return TimeSpan.FromSeconds(vars.igtAux + vars.igtAux2);
}
