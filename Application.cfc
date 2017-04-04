component {
  this.name= "Shopping";
  this.datasource = "eShoppingBasic";
  this.sessionManagement = true;
  this.sessionTimeout = CreateTimeSpan(0, 2, 0, 0);
  this.applicationTimeout = CreateTimeSpan(0,2,0,0);
  this.rootDir = #server.ColdFusion.RootDir#;

  session.loggedin = "false";


  // for models..
  this.mappings["/project"] = getDirectoryFromPath(getCurrentTemplatePath());


  //functions
  function onSessionStart(){
    session.loggedin = false;
    session.cart = [];
    session.cartDataChanged = false;
    session.User = {};
  }

  public void function onError(required any exception, required string eventname){
      writeDump(exception);
      writeDump(eventname);
      WriteLog(type="Error", file="shoppingbuzz.log", text="[#arguments.exception.type#] #arguments.exception.message#");
  }
  // writeDump(server);
  // writeDump(this);

  // this.clientManagement = true;
  // WriteDump(var = "#session#");
  // this.ormenabled = true;
}
