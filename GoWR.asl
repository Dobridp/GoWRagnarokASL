state("GoWR")
{
  int IGT : 0x39C890C; //IGT in seconds
  int MainMenu : 0x5D9E584; //1 on menu, 0 out of menu
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
