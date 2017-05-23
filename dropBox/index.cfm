<head>
	<script src="https://unpkg.com/dropbox/dist/Dropbox-sdk.min.js"></script>

	<script>
		var dbx = new Dropbox({ accessToken: 'h2YxfEUsuNcAAAAAAAAAfTZehs8HqL0SYwlawP_JuStfUMrCScTMRATyQaRdCNcU'});
		// var x = dbx.getAuthenticationUrl();
		// dbx.filesListFolder({
		// 	path: ""
		// }).then(function(response){
		// 	$.each(response.entries , function(i, entry) {
		// 		var things = 	'type =' +  entry[".tag"] + '<br>' +
		// 						'name = ' + entry.name + '<br>' +
		// 						'display path = ' + entry.path_display + '<br>';
		//
		// 		$("body").append(things + '<br> <br>');
		// 	});
		// }).catch(function(error) {
		// 	console.log(error);
		// 	$(document).html(error);
		// });
		//

		function uploadFile()
		{
			// get file input box id from form
			var fileInput = document.getElementById('file-upload');
			// get the file from files array
			var file = fileInput.files[0];

			// for displaying results purposee
			var results = document.getElementById('results');
			var resultsJ = $("#results");
			resultsJ.empty();  //empty the results element

			// search for the file before uploading it to server
			dbx.filesSearch({
				path: '',
				query: file.name
			}).then(function(re){
				if( re.matches.length == 0 ){
					dbx.filesUpload({
						path: '/' + file.name,
						contents: file
					}).then(function(response) {
						resultsJ.text('File uploaded!');
						console.log(response);
					}).catch(function(error) {
						console.error(error);
					});
				}
				else {
					resultsJ.text("this file already exists in Dropbox");
				}
			}).catch(function(er){
					resultsJ.append(JSON.stringify(er));
			});
			return false;
		}

		function downloadFile() {
			var name = $("#fileName").val();
			console.log('/' + name);
			dbx.filesDownload({
				path: '/' + name
			}).then(function(re){
				console.log(re);
				var downloadUrl = URL.createObjectURL(re.fileBlob);
				console.log(re.fileBlob);
				console.log(downloadUrl);
				var downloadButton = document.createElement('a');
				downloadButton.setAttribute('href', downloadUrl);
				downloadButton.setAttribute('download', re.name);
				downloadButton.setAttribute('class', 'button');
				downloadButton.innerText = 'Download: ' + re.name;
				document.getElementById('results').appendChild(downloadButton);
			}).catch(function(er){
				console.log(re);
			});
			return false;
		}
	</script>
</head>
<body>
   <form onSubmit="return uploadFile()">
   		<!--- <input type="text" id="access-token" placeholder="Access token" /> --->
 		<input type="file" id="file-upload" required/>
 		<button type="submit">Submit</button>
   </form>
   <form onSubmit="return downloadFile()">
   		<input type="text" id="fileName" placeholder="filename to download" required />
   		<button type="submit">Submit</button>
   </form>

	results here:
	<h2 id="results"></h2>
</body>
