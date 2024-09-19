state("GoWR")
{
  int IGT : 0x39C790C;
  int MainMenu : 0x5D9D584;
}

startup
{
  settings.Add("Main Game", true);
  settings.SetToolTip("Main Game", "Autosplitter Work in Progress");
  settings.Add("Valhalla", false);
  settings.SetToolTip("Valhalla", "Autosplitter Work in Progress");
}

init
{
  vars.igtAux = 0;
}

update
{
  if (current.IGT > old.IGT)
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
  if (settings["Main Game"] && current.MainMenu == 0 && old.MainMenu == 1)
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