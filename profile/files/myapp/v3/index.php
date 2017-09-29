<?php
header('X-Source: ' . gethostname());
header('Content-Type: text/html');
?>
<html>
  <head>
    <link href="https://fonts.googleapis.com/css?family=Roboto"
        rel="stylesheet">
    <style>
    BODY {
      margin: 0;
      font-family: Roboto;
      font-size: 16pt;
    }
    #banner {
      background-color: gray;
      padding: 6pt;
    }
    #banner IMG {
      height: 48px;
      vertical-align: middle;
    }
    #banner #slogan {
      font-size: 24pt;
      font-weight: bold;
      color: white;
      float: right;
      margin: 6pt;
      opacity: 0.25;
    }
    #content {
      margin: 16pt;
    }
    TABLE {
      width: 100%;
    }
    TD {
      padding: 4pt;
    }
    IFRAME {
      border: 1px solid gray;
      width: 100%;
    }
    #amp {
      font-weight: bold;
      color: white;
      font-size: 36pt;
      margin-left: 16pt;
      margin-right: 16pt;
      vertical-align: middle;
    }
    #cpanel {
      border: 1px solid gray;
      background-color: lightgray;
      margin: 16pt;
      margin-left: 20pt;
      margin-right: 20pt;
      font-size: 10pt;
    }
    #cpanel DIV {
      display: inline-block;
      margin: 0;
      padding: 4pt;
    }
    #cpanel #title {
      color: white;
      background-color: gray;
      padding-right: 4pt;
      padding-left: 4pt;
      margin-right: 8pt;
    }
    #cpanel #divider {
      border-left: 1px solid gray;
      width: 1px;
      margin-left: 4pt;
    }
    INPUT {
      margin: 0;
    }
    #version {
      color: gray;
      position: absolute;
      bottom: 0;
      right: 0;
      margin: 16pt;
      margin-left: 20pt;
      margin-right: 20pt;
      font-size: 10pt;
    }
    </style>
    <script>
      function getParameterByName(name, url) {
          if (!url) url = window.location.href;
          name = name.replace(/[\[\]]/g, "\\$&");
          var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
              results = regex.exec(url);
          if (!results) return null;
          if (!results[2]) return '';
          return decodeURIComponent(results[2].replace(/\+/g, " "));
      }

      function updateLoad() {
        var rows = document.all.rows.value;
        var cols = document.all.cols.value;

        var params = {
          rows: rows != '1' ? rows : null,
          cols: cols != '1' ? cols : null,
          refresh: document.all.refresh.checked ? 1 : null
        }

        var new_location = document.location.origin
            + document.location.pathname;

        var query = '';
        for (var p in params) {
          if (params[p] != null) {
            if (query.length) {
              query += '&';
            }
            query += p + '=' + params[p];
          }
        }

        if (query.length) {
          new_location += '?' + query;
        }

        document.location = new_location;
      }
    </script>
  </head>
<?php 
  $cols = $_GET['cols'];
  if (empty($cols)) {
    $cols = 1;
  }
  $rows = $_GET['rows'];
  if (empty($rows)) {
    $rows = 1;
  }
?>
  <body>
    <div id='banner'>
      <img id='gcp' src='google-cloud-platform-logo.png'>
      <span id='amp'>+</span>
      <img id='puppet' src='puppet-logo.png'>
      <div id='slogan'>
        From nothing to production in 10 minutes!
        Make it scalable in 30 minutes!
      </div>
    </div>
    <div id='cpanel'>
      <div id='title'>
        Load Control Panel
      </div>
      <select id='rows' name='rows' onchange='updateLoad()'>
<?php foreach ([1, 3, 5, 10] as $v) { ?>
        <option <?= $rows == $v ? 'selected' : ''?>><?= $v ?></option>
<?php } ?>
      </select>
      rows
      <div id='divider'></div>
      <select id='cols' name='cols' onchange='updateLoad()'>
<?php foreach ([1, 3, 5, 10] as $v) { ?>
        <option <?= $cols == $v ? 'selected' : ''?>><?= $v ?></option>
<?php } ?>
      </select>
      columns
      <div id='divider'></div>
      <input type='checkbox' id='refresh' name='refresh'
          onclick='updateLoad()'
          <?= $_GET['refresh'] ? 'checked' : '' ?>>
      automatically refresh
    </div>
    <div id='content'>
      <table>
<?php for ($j = 0; $j < $rows; $j++) { ?>
        <tr>
<?php   for ($i = 0; $i < $cols; $i++) { ?>
          <td>
            <iframe src='frame.php?refresh=<?= $_GET['refresh'] ?>'></iframe>
          </td>
<?php   } ?>
        </tr>
<?php } ?>
      </table>
    </div>
    <div id='version'>
      Version 3.0
    </div>
  </body>
</html>
