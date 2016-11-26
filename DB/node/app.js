// モジュール読み込み
var client = require('cheerio-httpcli');

client.fetch('http://cocktailcocktail1.blog.fc2.com/', function(err, $, res) {
  $('.plugin-freearea > li > a').each(function() {
    var link = $(this).attr('href');
    var baseTitle = $(this).text();
    client.fetch(link, function(err, $, res) {
      $('.entry-body > a').each(function() {
        var link = $(this).attr('href');
        var result = link.match(/entry-(.+?).html/);
        if (result != null && parseInt(result[1], 10) > 17) {

          client.fetch(link, function(err, $, res) {
            var title = $('title').text();
            var result = title.match(/^カクテルレシピのデータベース｜(.+)/);
            if (result != null) {
              var cocktail = result[1];
              $('.entry-body').each(function() {
                var html = $(this).html();
                var result = html.match(/<\/a><br><br>(.+)<br><br>/);
                if (result != null) {
                  var materials = result[1].split("<br>")
                  var data = [];
                  // data.push(cocktail);
                  process.stdout.write(baseTitle);
                  process.stdout.write(',');
                  process.stdout.write(cocktail);
                  for (var i = 0; i < materials.length; i++) {
                    var material = materials[i];
                    var m = material.split("　");
                    if (m.length == 2) {
                      // data.push(material);
                      process.stdout.write(',');
                      process.stdout.write(material);
                    }
                  }
                  process.stdout.write('\n');
                  // console.log(data);
                }
              });
            }
          });

        }
      });
    });

  });
});

var downloadCsv = (function() {

    var tableToCsvString = function(table) {
        var str = '\uFEFF';
        for (var i = 0, imax = table.length - 1; i <= imax; ++i) {
            var row = table[i];
            for (var j = 0, jmax = row.length - 1; j <= jmax; ++j) {
                str += '"' + row[j].replace('"', '""') + '"';
                if (j !== jmax) {
                    str += ',';
                }
            }
            str += '\n';
        }
        return str;
    };

    var createDataUriFromString = function(str) {
        return 'data:text/csv,' + encodeURIComponent(str);
    }

    var downloadDataUri = function(uri, filename) {
        var link = document.createElement('a');
        link.download = filename;
        link.href = uri;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    };

    return function(table, filename) {
        if (!filename) {
            filename = 'output.csv';
        }
        var uri = createDataUriFromString(tableToCsvString(table));
        downloadDataUri(uri, filename);
    };

})();
