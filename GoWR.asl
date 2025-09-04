state("GoWR")
{
  int IGT : 0x39C001C; //IGT in seconds
  float IGTms : 0x606A074; //ms of the IGT -> 0.0 to 1.0, when on 1.0, IGT goes up by 1 and resets back to 0.0
  int MainMenu : 0x5D9643C; //1 on menu, 0 out of menu
  int Load: 0x5D96438; //0 when not loading, 257 when loading, 256 when in cutscene loading
  uint Obj: 0x25EABE0; //Objective number, changes number base off the objective 0 when in MainMenu and loading
}

startup
{
  Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
  vars.Helper.Settings.CreateFromXml("Components/GodOfWarRagnarok.Settings.en-US.xml", false); // for now only english

  /*
  keeping these in case this for some reason the xml doesnt want to work for whatever reason
  settings.Add("Main Game", true);
  settings.SetToolTip("Main Game", "Autosplitter Work in Progress");
  settings.Add("Valhalla", false);
  settings.SetToolTip("Valhalla", "Autosplitter Work in Progress");
  */
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

