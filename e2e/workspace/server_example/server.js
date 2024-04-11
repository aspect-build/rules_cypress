const express = require("express");
const app = express();
const port = Number(process.argv[2]);

if (isNaN(port)) {
  throw new Error("port must be passed as first arg");
}

app.get("/", (req, res) => {
  res.send(`
<html>
    <body>
        <div id="hello">world</div>
    </body>
</html>  
`);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
