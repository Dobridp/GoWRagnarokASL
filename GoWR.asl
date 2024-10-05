state("GoWR")
{
  int IGT : 0x393570C; //IGT in seconds
  int MainMenu : 0x5D0B384; //1 on menu, 0 out of menu
  int Load: 0x5D0B380; //0 when not loading, 257 when loading, 256 when in cutscene loading
}

startup
{
  settings.Add("Main Game", true);
  settings.SetToolTip("Main Game", "Autosplitter Work in Progress");
  settings.Add("Valhalla", false);
  settings.SetToolTip("Valhalla", "Autosplitter Work in Progress");
}

update
{
  if (current.IGT > old.IGT && (current.IGT - old.IGT) < 2)
  {
    vars.igtAux += current.IGT - old.IGT;
  }
}

onStart
{
  vars.igtAux = 0;
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
  if (settings["Valhalla"])
  {
    return TimeSpan.FromSeconds(current.IGT);
  }
  else
  {
    return TimeSpan.FromSeconds(vars.igtAux);
  }
}
