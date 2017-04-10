<!DOCTYPE html>
<html>
<head>
  <title>Register</title>
  <cfinclude template = "assets/libraries/libraries.cfm">
      <link rel="stylesheet" href="assets/css/register.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/zxcvbn/4.2.0/zxcvbn.js"></script>
  <script src="assets/js/register.js"></script>

 </head>

  <body>
    <cfinclude template = "commons/header.cfm">


    <h1 class="signup-header" align="center">Register With Us</h1>
      <div id="signup-content">
        <form action="" method="post" id="signup_form"  autocomplete="off">

          <div class="form-group">
            <label for="" class="required" >First Name:</label>
            <input id="ufirstname" minlength="2" type="text" class="form-control" name="FirstName" required/>
          </div>

          <div class="form-group">
            <label for="">Last Name:</label>
            <input id="ulastname" type="text"  class="form-control" name="LastName" />
          </div>

          <div class="form-group">
            <label for="" class="required" >Email:</label>
            <input id="uemail" type="email"  class="form-control" name="Email" required/>
          </div>

          <label for="">Phone Number:</label>
          <div class="input-group">
            <span class="input-group-addon">+91</span>
            <input id="uphoneno"  class="form-control" type="number" name="PhoneNo" maxlength="13" />
          </div>

          <div class="form-group">
            <label for="" class="required" >Password:</label>
            <input type="password" id="pswd" name="Password" class="form-control" pattern="/^(?=.*?[a-zA-Z])(?=.*?[0-9])[a-zA-Z0-9_!@##$%]{8,12}$/" autocomplete="new-password" required>
            <meter max="4" id="password-strength-meter"></meter>
            <p id="password-strength-text"></p>
            <!--- <input type="password" name="Password" required/> --->
          </div>

          <div class="form-group clearfix center" id="form-buttons">
            <label for=""></label>
            <button type="submit"  id="submit-button" name="signup" class="btn btn-primary" > Sign UP </button>

            <label for=""></label>
            <input type="reset" name="Clear" class="btn btn-default" value="Clear" />
          </div>

        </form>
      </div>





<!--- Server side check for signup --->
<!--- move into cfc  IMPLEMENT USING CFC--->

<cfinclude template = "commons/footer.cfm">
</body>
</html>
