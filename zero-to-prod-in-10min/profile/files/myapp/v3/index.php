<?php
header('X-Source: ' . gethostname());
header('X-Version: 3.0');
header('Content-Type: text/html');
header('Cache-Control: must-revalidate');
header('Cache-Control: no-cache');
?>
<?php
  $cols = $_GET['cols'];
  if (empty($cols)) {
    $cols = 1;
  }
  $rows = $_GET['rows'];
  if (empty($rows)) {
    $rows = 1;
  }
  $failures = $_GET['failures'];
  $failure_sec = $_GET['failure_sec'];
  if (empty($failure_sec)) {
    $failure_sec = 2;
  }
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
      font-size: 18pt;
      font-weight: bold;
      color: white;
      float: right;
      opacity: 0.25;
      text-align: right;
    }
    #content {
      margin: 16pt;
    }
    TABLE {
      width: 100%;
    }
    TR {
      padding: 4pt;
    }
    IFRAME {
      border: 1px solid gray;
      width: 100%;
<?php if ($_GET['debug']) { ?>
      height: 300px;
<?php } else { ?>
      height: 150px;
<?php } ?>
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
        var fail_sec = document.all.failure_sec.value;
        var failures = document.all.failures.checked;
        var debug = document.all.debug.checked;

        var params = {
          rows: rows != '1' ? rows : null,
          cols: cols != '1' ? cols : null,
          failures: failures ? 1 : null,
          failure_sec: failures ? fail_sec : null,
          refresh: document.all.refresh.checked ? 1 : null,
          debug: document.all.debug.checked ? 1 : null
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

      function scheduleFrameReload() {
        setTimeout('reloadFrames()', 5000);
      }

      function reloadFrames() {
        loadFrames();
        scheduleFrameReload(); // again
      }

      function loadFrames() {
        var frames = document.getElementsByTagName('IFRAME');
        for (i = 0; i < frames.length; i++) {
          loadFrame(frames[i]);
        }
      }
      function loadFrame(frame) {
        var debug = document.all.debug.checked;
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
          if (xhr.readyState == XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
              frame.contentWindow.document.open();
              frame.contentWindow.document.write(xhr.responseText);
              frame.contentWindow.document.close();
            } else {
<?php if ($failures) { ?>
              frame.contentWindow.document.open();
              frame.contentWindow.document.write("<font size='18pt'>&#x2620;</font>");
              frame.contentWindow.document.close();
              setTimeout(function() { loadFrame(frame); }, <?= $failure_sec ?> * 1000);
<?php } else { /* immediate reload */ ?>
              loadFrame(frame);
<?php } ?>
            }
          }
        }
        xhr.open('GET', 'frame.php' + (debug ? '?debug=1' : ''), true);
        xhr.send(null);
      }

      function pageLoaded() {
        loadFrames();
<?php if ($_GET['refresh']) { ?>
        scheduleFrameReload();
<?php } ?>
      }
    </script>
  </head>
  <body onload='pageLoaded()'>
    <div id='banner'>
      <img id='gcp' src='google-cloud-platform-logo.png'>
      <span id='amp'>+</span>
      <img id='puppet' src='puppet-logo.png'>
      <div id='slogan'>
        From nothing to production in 10 minutes!<br/>
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
      <div id='divider'></div>
      <input type='checkbox' id='failures' name='failures'
          onclick='updateLoad()'
          <?= $_GET['failures'] ? 'checked' : '' ?>>
      show failures:
      <select id='failure_sec' name='failure_sec' onchange='updateLoad()'
          <?= ! $failures ? 'disabled' : '' ?>>
<?php foreach ([0.1, 0.5, 1, 2] as $v) { ?>
        <option <?= $failure_sec == $v ? 'selected' : ''?> value='<?= $v ?>'><?= $v ?> s</option>
<?php } ?>
      </select>
      <div id='divider'></div>
      <input type='checkbox' id='debug' name='debug'
          onclick='updateLoad()'
          <?= $_GET['debug'] ? 'checked' : '' ?>>
      debug
    </div>
    <div id='content'>
      <table>
<?php for ($j = 0; $j < $rows; $j++) { ?>
        <tr>
<?php   for ($i = 0; $i < $cols; $i++) { ?>
          <td>
            <iframe></iframe>
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
