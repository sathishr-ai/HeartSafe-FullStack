const fs = require('fs');
let text = fs.readFileSync('CChd.prediction.html', 'utf8');
if (!text.includes('premium-ui.css')) {
    text = text.replace('</head>', '    <link rel="stylesheet" href="premium-ui.css">\n</head>');
    fs.writeFileSync('CChd.prediction.html', text);
    console.log('Injected premium-ui.css');
} else {
    console.log('Already injected');
}
