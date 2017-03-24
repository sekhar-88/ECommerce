<!--- <cfdump var="#cgi#"> --->
<head>
    <link rel="stylesheet" href="assets/css/footer.css">
</head>

<body>
    <footer class="footer-basic-centered">
        <cfif session.loggedin>
        <cfif session.User.Role EQ 'admin'>
            <p><a class="admin-panel-notice" href="section_admin.cfm">Go To Admin Panel</a></p>
        </cfif>
        </cfif>

        <p class="footer-company-motto">Expect the unexpected.</p>
        <p class="footer-links">
            <a href="index.cfm">Home</a>
            &#8226;
            <a href="#">Blog</a>
            &#8226;
            <a href="#">License</a>
            &#8226;
            <a href="#">About</a>
            &#8226;
            <a href="#">Faq</a>
            &#8226;
            <a href="#">Contact</a>
        </p>

        <p class="footer-company-name">ShoppingBUZZ &copy; 2017</p>

    </footer>
</body>
