component {
  this.name= "Shopping";
  this.datasource = "eShoppingBasic";
  this.sessionManagement = true;
  this.sessionTimeout = CreateTimeSpan(0, 2, 0, 0);
  this.applicationTimeout = CreateTimeSpan(0,2,0,0);
  session.loggedin = "false";

  // for models..
  this.mappings["/project"] = getDirectoryFromPath(getCurrentTemplatePath());


  //functions
  function onSessionStart(){
    session.loggedin = false;
    session.cart = [];
    session.cartDataChanged = false;
  }

  function onError(){

  }


  // this.clientManagement = true;
  // WriteDump(var = "#session#");
  // this.ormenabled = true;
}
