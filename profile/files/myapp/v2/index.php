<?php
header('X-Source: ' . gethostname());
header('Content-Type: text/html');
?>
<html>
  <head>
    <style>
    BODY {
      margin: 0;
      font-family: Roboto;
      font-size: 16pt;
    }
    #banner {
      background-color: gray;
      padding: 8pt;
    }
    #banner IMG {
      height: 48px;
    }
    #content {
      margin: 16pt;
    }
    CODE {
      border: 1px solid green;
      border-radius: 4pt;
      color: green;
      padding: 4pt;
      padding-right: 8pt;
      padding-left: 8pt;
      margin-left: 8pt;
      margin-right: 8pt;
    }
    </style>
  </head>
  <body>
    <div id='banner'>
      <img id='gcp' src='google-cloud-platform-logo.png'>
      <img id='puppet' src='puppetconf-logo.png'>
    </div>
    <div id='content'>
      <p>Hello from <code><?= gethostname() ?></code> !</p>
      <p>It's <code><?= date('r') ?></code> around here</p>
    </div>
  </body>
</html>
